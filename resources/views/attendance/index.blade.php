<x-app-layout>
    <x-slot name="header">
        {{ __('Scan Absensi Member') }}
    </x-slot>

    <style>
        .kiosk-video-stage {
            position: relative;
            width: 100%;
            aspect-ratio: 4 / 3;
            background: #0f130e;
            border-radius: 0.75rem;
            overflow: hidden;
            border: 2px solid #273024;
        }
        .kiosk-video-stage video,
        .kiosk-video-stage img.kiosk-stream-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        .kiosk-video-stage video {
            transform: scaleX(-1);
        }
        .kiosk-guide-frame {
            position: absolute;
            inset: 12% 20%;
            border: 2px dashed rgba(224, 255, 0, 0.45);
            border-radius: 50% 50% 45% 45%;
            pointer-events: none;
            box-shadow: 0 0 0 9999px rgba(10, 14, 9, 0.35);
            transition: border-color 0.3s;
        }
        .kiosk-guide-frame.scanning {
            border-color: #e0ff00;
            box-shadow: 0 0 20px rgba(224, 255, 0, 0.4), 0 0 0 9999px rgba(10, 14, 9, 0.45);
        }
        .scan-laser-line {
            position: absolute;
            left: 15%;
            right: 15%;
            height: 3px;
            background: linear-gradient(90deg, transparent, #e0ff00, transparent);
            box-shadow: 0 0 10px #e0ff00;
            top: 20%;
            animation: scanLaser 2s infinite ease-in-out;
            pointer-events: none;
        }
        @keyframes scanLaser {
            0% { top: 15%; opacity: 0.2; }
            50% { top: 80%; opacity: 1; }
            100% { top: 15%; opacity: 0.2; }
        }
        .kiosk-result-card {
            animation: popIn 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        @keyframes popIn {
            0% { transform: scale(0.92); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }
        /* Fullscreen kiosk styling */
        #fullscreenKiosk:fullscreen {
            background: radial-gradient(circle at 50% 30%, #1c2619 0%, #0d120a 60%, #050704 100%);
            display: flex;
            flex-direction: column;
            padding: 2rem;
            color: white;
            overflow-y: auto;
        }
    </style>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6" x-data="attendanceScanner()">
        <!-- Scan / Kiosk Box -->
        <div class="lg:col-span-1">
            <div class="bg-card rounded-xl border border-gray-800 p-6 shadow-lg relative overflow-hidden">
                <!-- Mode Switcher Tabs -->
                <div class="flex items-center justify-between mb-4 border-b border-gray-800 pb-3">
                    <div class="flex space-x-2">
                        <button type="button" @click="setMode('id')"
                            :class="activeMode === 'id' ? 'bg-neon text-darker font-bold shadow-[0_0_12px_rgba(224,255,0,0.25)]' : 'bg-dark text-gray-400 hover:text-white border border-gray-700'"
                            class="px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center transition">
                            <i class="ph ph-barcode text-base mr-1.5"></i>
                            ID / Barcode
                        </button>
                        <button type="button" @click="setMode('face')"
                            :class="activeMode === 'face' ? 'bg-neon text-darker font-bold shadow-[0_0_12px_rgba(224,255,0,0.25)]' : 'bg-dark text-gray-400 hover:text-white border border-gray-700'"
                            class="px-3 py-1.5 rounded-lg text-xs font-semibold flex items-center transition relative">
                            <i class="ph ph-scan-face text-base mr-1.5"></i>
                            Kiosk Wajah
                            @if($apiReady)
                                <span class="w-2 h-2 rounded-full bg-green-400 ml-1.5 inline-block animate-pulse"></span>
                            @endif
                        </button>
                    </div>

                    <button type="button" @click="openFullscreen()" title="Buka Mode Kiosk Layar Penuh"
                        class="p-1.5 rounded-lg bg-dark border border-gray-700 text-gray-400 hover:text-neon hover:border-neon transition">
                        <i class="ph ph-arrows-out text-lg"></i>
                    </button>
                </div>

                {{-- Alert Messages dari Form Biasa --}}
                @if(session('success'))
                    <div class="mb-4 p-4 rounded-lg bg-green-500/10 border border-green-500/50 text-green-400 text-sm flex items-start">
                        <i class="ph ph-check-circle text-xl mr-2 mt-0.5"></i>
                        <span>{{ session('success') }}</span>
                    </div>
                @endif
                
                @if(session('error'))
                    <div class="mb-4 p-4 rounded-lg bg-red-500/10 border border-red-500/50 text-red-400 text-sm flex items-start">
                        <i class="ph ph-warning-circle text-xl mr-2 mt-0.5"></i>
                        <span>{{ session('error') }}</span>
                    </div>
                @endif
                
                @if(session('warning'))
                    <div class="mb-4 p-4 rounded-lg bg-yellow-500/10 border border-yellow-500/50 text-yellow-400 text-sm flex items-start">
                        <i class="ph ph-info text-xl mr-2 mt-0.5"></i>
                        <span>{{ session('warning') }}</span>
                    </div>
                @endif

                @if(session('scanned_member'))
                    @php $sm = session('scanned_member'); @endphp
                    <div class="mb-5 p-4 rounded-xl bg-gradient-to-r from-darker to-gray-900 border {{ $sm['days_left'] > 7 ? 'border-neon/50 shadow-[0_0_15px_rgba(224,255,0,0.15)]' : ($sm['days_left'] >= 0 ? 'border-amber-500/50 shadow-[0_0_15px_rgba(245,158,11,0.15)]' : 'border-red-500/50 shadow-[0_0_15px_rgba(239,68,68,0.15)]') }} relative z-10">
                        <div class="flex items-center space-x-4">
                            <div class="shrink-0">
                                @if($sm['photo_path'])
                                    <img src="{{ $sm['photo_path'] }}" alt="{{ $sm['name'] }}" class="w-16 h-16 rounded-full object-cover border-2 {{ $sm['days_left'] > 7 ? 'border-neon' : ($sm['days_left'] >= 0 ? 'border-amber-400' : 'border-red-400') }}">
                                @else
                                    <div class="w-16 h-16 rounded-full bg-dark flex items-center justify-center text-2xl text-gray-400 border-2 {{ $sm['days_left'] > 7 ? 'border-neon' : ($sm['days_left'] >= 0 ? 'border-amber-400' : 'border-red-400') }}">
                                        <i class="ph ph-user"></i>
                                    </div>
                                @endif
                            </div>
                            <div class="flex-1 min-w-0">
                                <div class="flex items-center space-x-2">
                                    <h4 class="text-lg font-bold text-white truncate">{{ $sm['name'] }}</h4>
                                    <span class="px-2 py-0.5 text-[10px] uppercase font-semibold rounded bg-gray-800 text-gray-300 border border-gray-700">{{ $sm['member_type'] ?? 'Member' }}</span>
                                </div>
                                <p class="text-xs text-gray-400 font-mono">{{ $sm['member_id'] }}</p>

                                <div class="mt-2 flex flex-wrap items-center gap-2">
                                    @if($sm['days_left'] > 7)
                                        <span class="px-2.5 py-1 text-xs font-mono font-bold rounded-lg bg-green-500/20 text-green-400 border border-green-500/40 flex items-center">
                                            <i class="ph ph-hourglass-high mr-1.5 text-sm"></i> Sisa {{ $sm['days_left'] }} Hari
                                        </span>
                                    @elseif($sm['days_left'] >= 0)
                                        <span class="px-2.5 py-1 text-xs font-mono font-bold rounded-lg bg-amber-500/20 text-amber-400 border border-amber-500/40 flex items-center animate-pulse">
                                            <i class="ph ph-warning-circle mr-1.5 text-sm"></i> {{ $sm['days_left'] == 0 ? 'Hari Ini Terakhir!' : 'Sisa ' . $sm['days_left'] . ' Hari' }}
                                        </span>
                                    @else
                                        <span class="px-2.5 py-1 text-xs font-mono font-bold rounded-lg bg-red-500/20 text-red-400 border border-red-500/40 flex items-center">
                                            <i class="ph ph-x-circle mr-1.5 text-sm"></i> Expired
                                        </span>
                                    @endif

                                    <span class="text-xs text-gray-400">
                                        <i class="ph ph-calendar text-gray-500"></i> Berakhir: <strong class="text-gray-200">{{ $sm['expiry_date'] }}</strong>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                @endif

                <!-- MODE 1: Scan ID / Barcode Form -->
                <div x-show="activeMode === 'id'" x-transition:enter="transition ease-out duration-200">
                    <form method="POST" action="{{ route('attendance.store') }}" class="space-y-4">
                        @csrf
                        <div>
                            <label class="block text-sm font-medium text-gray-400 mb-2">Arahkan Scanner, ketik VIP ID, atau Nama Member</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="ph ph-scan text-neon text-xl"></i>
                                </div>
                                <input type="text" name="identifier" id="identifier" required autofocus autocomplete="off"
                                    class="block w-full pl-10 pr-3 py-3 border border-neon rounded-lg bg-dark text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-neon focus:border-neon transition-colors text-lg font-mono shadow-[0_0_15px_rgba(224,255,0,0.1)]" 
                                    placeholder="VIP-... atau Nama Member">
                            </div>
                        </div>
                        
                        <button type="submit" class="w-full bg-neon hover:bg-[#c4e600] text-darker font-bold py-3 px-4 rounded-lg transition-colors flex items-center justify-center space-x-2">
                            <i class="ph ph-check-square-offset text-xl"></i>
                            <span>Proses Absensi ID</span>
                        </button>
                    </form>
                    
                    <p class="text-xs text-gray-500 mt-4 text-center">
                        Pastikan cursor berada di dalam kotak input saat melakukan scan QR Code / Barcode.
                    </p>
                </div>

                <!-- MODE 2: Kiosk Wajah AI (Biometrik) -->
                <div x-show="activeMode === 'face'" x-transition:enter="transition ease-out duration-200" style="display: none;">
                    @if(! $apiReady)
                        <div class="p-4 rounded-lg bg-yellow-500/10 border border-yellow-500/30 text-yellow-400 text-xs text-center mb-3">
                            <i class="ph ph-warning text-2xl block mb-1"></i>
                            <strong>Layanan Biometrik Belum Aktif</strong>
                            <p class="text-gray-400 mt-1">Jalankan perintah <code>php artisan face-api:serve</code> di terminal untuk mengaktifkan scan wajah.</p>
                        </div>
                    @endif

                    <!-- Pilihan Sumber Kamera -->
                    <div class="flex items-center justify-between mb-3 bg-dark/60 p-1.5 rounded-lg border border-gray-800 text-xs">
                        <span class="text-gray-400 font-medium pl-1 flex items-center">
                            <i class="ph ph-camera mr-1 text-neon"></i> Sumber Kamera:
                        </span>
                        <div class="flex space-x-1">
                            <button type="button" @click="setCameraSource('webcam')"
                                :class="cameraSource === 'webcam' ? 'bg-neon text-darker font-bold shadow-sm' : 'text-gray-400 hover:text-white'"
                                class="px-2.5 py-1 rounded-md transition flex items-center text-xs">
                                <i class="ph ph-video-camera mr-1 text-sm"></i> Webcam
                            </button>
                            <button type="button" @click="setCameraSource('esp32cam')"
                                :class="cameraSource === 'esp32cam' ? 'bg-neon text-darker font-bold shadow-sm' : 'text-gray-400 hover:text-white'"
                                class="px-2.5 py-1 rounded-md transition flex items-center text-xs">
                                <i class="ph ph-broadcast mr-1 text-sm"></i> ESP32-CAM
                            </button>
                        </div>
                    </div>

                    <!-- Kotak Konfigurasi ESP32-CAM -->
                    <div x-show="cameraSource === 'esp32cam'" x-transition class="mb-3 p-3 rounded-lg bg-dark/80 border border-gray-700 space-y-2 text-xs">
                        <div class="flex items-center justify-between">
                            <span class="text-gray-300 font-semibold flex items-center">
                                <i class="ph ph-wifi-high mr-1 text-neon"></i> Alamat IP / URL ESP32-CAM
                            </span>
                            <span class="text-[10px] font-mono px-1.5 py-0.5 rounded"
                                :class="esp32Connected ? 'bg-green-500/20 text-green-400 border border-green-500/30' : 'bg-gray-800 text-gray-400 border border-gray-700'"
                                x-text="esp32Connected ? 'Stream Aktif' : 'Belum Terhubung'"></span>
                        </div>
                        <div class="flex gap-2">
                            <div class="relative flex-1">
                                <input type="text" x-model="esp32Ip" @input.debounce.500ms="updateEsp32Url()" 
                                    placeholder="Contoh: 192.168.1.100 atau http://..."
                                    class="w-full px-2.5 py-1.5 bg-black/60 border border-gray-700 rounded text-white font-mono text-xs focus:border-neon focus:ring-1 focus:ring-neon">
                            </div>
                            <button type="button" @click="testEsp32Connection()" :disabled="esp32Testing || !esp32Ip"
                                class="px-3 py-1.5 bg-neon hover:bg-[#c4e600] disabled:opacity-50 text-darker font-bold rounded flex items-center space-x-1 shrink-0">
                                <i class="ph ph-arrows-clockwise text-sm" :class="esp32Testing ? 'animate-spin' : ''"></i>
                                <span x-text="esp32Testing ? 'Cek...' : 'Uji'"></span>
                            </button>
                        </div>
                        <div class="flex items-center justify-between text-[11px] text-gray-400 pt-0.5">
                            <span class="truncate pr-2" :class="esp32Error ? 'text-red-400' : (esp32Connected ? 'text-green-400' : 'text-gray-400')" x-text="esp32Status || 'Ketik IP ESP32-CAM (misal: 192.168.1.50)'"></span>
                            <button type="button" @click="refreshEsp32Stream()" class="text-neon hover:underline shrink-0 text-[11px] flex items-center">
                                <i class="ph ph-arrow-clockwise mr-0.5"></i> Reload
                            </button>
                        </div>
                    </div>

                    <!-- Stage Kamera Kiosk -->
                    <div class="kiosk-video-stage mb-3">
                        <!-- Webcam Video -->
                        <video id="kioskVideo" x-show="cameraSource === 'webcam'" autoplay muted playsinline></video>

                        <!-- ESP32-CAM Stream Image -->
                        <div x-show="cameraSource === 'esp32cam'" class="w-full h-full relative flex items-center justify-center bg-black">
                            <img id="kioskEsp32Image" :src="esp32StreamSrc"
                                x-show="esp32StreamSrc && !esp32Error"
                                x-on:load="onEsp32ImageLoad()"
                                x-on:error="onEsp32ImageError()"
                                class="kiosk-stream-img" alt="ESP32-CAM Stream">
                            <div x-show="!esp32StreamSrc || esp32Error" class="p-4 text-center text-gray-400">
                                <i class="ph ph-broadcast text-3xl text-neon mb-1.5 block"></i>
                                <p class="text-xs font-semibold text-white">ESP32-CAM Siap Digunakan</p>
                                <p class="text-[11px] text-gray-500 mt-1 max-w-[220px] mx-auto" x-text="esp32Ip ? 'Gagal menampilkan stream dari ' + esp32Ip + '. Periksa koneksi IP/Wi-Fi.' : 'Masukkan IP ESP32-CAM pada kotak di atas.'"></p>
                            </div>
                        </div>

                        <div class="kiosk-guide-frame" :class="scanning ? 'scanning' : ''"></div>
                        <div class="scan-laser-line" x-show="scanning" style="display: none;"></div>

                        <!-- Badge Status -->
                        <div class="absolute top-2.5 left-2.5 flex items-center space-x-1.5 bg-black/70 border border-gray-700/60 rounded-md px-2 py-1 text-[11px] text-gray-300 font-mono">
                            <template x-if="cameraSource === 'webcam'">
                                <span class="flex items-center space-x-1.5">
                                    <span class="w-2 h-2 rounded-full" :class="cameraReady ? 'bg-green-400' : 'bg-red-400'"></span>
                                    <span x-text="cameraReady ? 'Webcam Siap' : 'Menyiapkan Webcam...'"></span>
                                </span>
                            </template>
                            <template x-if="cameraSource === 'esp32cam'">
                                <span class="flex items-center space-x-1.5">
                                    <span class="w-2 h-2 rounded-full" :class="esp32Connected ? 'bg-green-400' : (esp32Ip ? 'bg-amber-400' : 'bg-red-400')"></span>
                                    <span x-text="esp32Connected ? 'ESP32-CAM Aktif' : (esp32Ip ? 'Menghubungkan...' : 'IP Belum Diisi')"></span>
                                </span>
                            </template>
                        </div>

                        <!-- Indicator Scanning -->
                        <div class="absolute bottom-2.5 right-2.5 flex items-center space-x-1.5 bg-black/75 rounded-md px-2.5 py-1 text-xs text-neon font-bold" x-show="scanning" style="display: none;">
                            <i class="ph ph-spinner animate-spin text-sm"></i>
                            <span>Memproses Wajah...</span>
                        </div>
                    </div>

                    <!-- Kiosk Action Controls -->
                    <div class="space-y-2">
                        <button type="button" @click="triggerFaceCheckin()" :disabled="scanning || (cameraSource === 'webcam' ? !cameraReady : !esp32Ip)"
                            class="w-full bg-neon hover:bg-[#c4e600] disabled:opacity-50 text-darker font-bold py-3 px-4 rounded-lg transition-colors flex items-center justify-center space-x-2 shadow-[0_0_15px_rgba(224,255,0,0.15)]">
                            <i class="ph ph-scan text-xl"></i>
                            <span x-text="scanning ? 'Sedang Memverifikasi...' : 'Mulai Check-in Wajah'"></span>
                        </button>

                        <button type="button" @click="connectBuzzer()" :disabled="buzzerConnecting || buzzerConnected"
                            class="w-full bg-dark hover:bg-gray-800 disabled:opacity-50 text-gray-200 font-semibold py-2.5 px-4 rounded-lg border border-gray-700 transition-colors flex items-center justify-center space-x-2">
                            <i class="ph ph-speaker-high text-lg"></i>
                            <span x-text="buzzerConnecting ? 'Menyambungkan ESP32...' : (buzzerConnected ? 'ESP32 Terhubung' : 'Sambungkan Buzzer ESP32')"></span>
                        </button>
                        <p class="text-xs text-gray-400 text-center" role="status" x-text="buzzerStatus"></p>

                        <div class="flex items-center justify-between text-xs text-gray-400 pt-1">
                            <label class="flex items-center space-x-2 cursor-pointer select-none">
                                <input type="checkbox" x-model="autoScan" class="rounded bg-dark border-gray-700 text-neon focus:ring-neon">
                                <span>Auto Scan Berkelanjutan</span>
                            </label>

                            <button type="button" @click="openFullscreen()" class="text-neon hover:underline flex items-center">
                                <i class="ph ph-arrows-out mr-1"></i> Mode Layar Penuh
                            </button>
                        </div>
                    </div>

                    <!-- Kiosk Result Feedback (Modal/Card Popup) -->
                    <template x-if="kioskResult">
                        <div class="kiosk-result-card mt-4 p-4 rounded-xl border relative overflow-hidden"
                            :class="kioskResult.decision === 'ALLOW' ? 'bg-green-500/10 border-green-500 text-green-300 shadow-[0_0_20px_rgba(34,197,94,0.2)]' : 'bg-red-500/10 border-red-500 text-red-300 shadow-[0_0_20px_rgba(239,68,68,0.2)]'">
                            <div class="flex items-start space-x-3">
                                <div class="shrink-0 text-3xl mt-0.5">
                                    <i :class="kioskResult.decision === 'ALLOW' ? 'ph ph-check-circle text-green-400' : 'ph ph-x-circle text-red-400'"></i>
                                </div>
                                <div class="flex-1 min-w-0">
                                    <span class="text-[10px] font-mono uppercase tracking-wider font-bold block"
                                        :class="kioskResult.decision === 'ALLOW' ? 'text-green-400' : 'text-red-400'"
                                        x-text="kioskResult.decision === 'ALLOW' ? 'VERIFIKASI BERHASIL' : 'AKSES DITOLAK'"></span>
                                    <h4 class="text-base font-bold text-white mt-0.5" x-text="kioskResult.title"></h4>
                                    
                                    <template x-if="kioskResult.member">
                                        <div class="mt-2 p-2.5 rounded-lg bg-black/40 border border-gray-800">
                                            <p class="text-sm font-bold text-white" x-text="kioskResult.member.name"></p>
                                            <p class="text-xs text-gray-400 font-mono" x-text="kioskResult.member.member_id"></p>
                                            <template x-if="kioskResult.member.days_left !== undefined">
                                                <p class="text-xs font-semibold mt-1"
                                                    :class="kioskResult.member.days_left > 7 ? 'text-green-400' : (kioskResult.member.days_left >= 0 ? 'text-amber-400' : 'text-red-400')">
                                                    Sisa Masa Aktif: <span x-text="kioskResult.member.days_left"></span> Hari
                                                </p>
                                            </template>
                                        </div>
                                    </template>

                                    <p class="text-xs mt-2" x-text="kioskResult.message"></p>
                                </div>
                            </div>
                        </div>
                    </template>
                </div>
            </div>
            
            <!-- Attendance Stats -->
            <div class="mt-6 grid grid-cols-2 gap-4">
                <div class="bg-card rounded-xl border border-gray-800 p-4 shadow-lg text-center">
                    <p class="text-xs text-gray-400 mb-1">Total Hadir <br>(Tanggal Terpilih)</p>
                    <p class="text-2xl font-bold text-neon" id="statTotalSelected" x-text="totalSelectedDate">{{ $totalSelectedDate }}</p>
                </div>
                <div class="bg-card rounded-xl border border-gray-800 p-4 shadow-lg text-center">
                    <p class="text-xs text-gray-400 mb-1">Rata-rata <br>Harian (Total)</p>
                    <p class="text-2xl font-bold text-white">{{ $averageDaily }}</p>
                </div>
                <div class="bg-card rounded-xl border border-gray-800 p-4 shadow-lg text-center">
                    <p class="text-xs text-gray-400 mb-1">Rata-rata <br>Mingguan (Total)</p>
                    <p class="text-2xl font-bold text-white">{{ $averageWeekly }}</p>
                </div>
                <div class="bg-card rounded-xl border border-gray-800 p-4 shadow-lg text-center">
                    <p class="text-xs text-gray-400 mb-1">Rata-rata <br>Bulanan (Total)</p>
                    <p class="text-2xl font-bold text-white">{{ $averageMonthly }}</p>
                </div>
            </div>
        </div>

        <!-- Today's Attendance Table -->
        <div class="lg:col-span-2">
            <div class="bg-card rounded-xl border border-gray-800 shadow-lg overflow-hidden flex flex-col h-full">
                <div class="p-6 border-b border-gray-800 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                    <div class="flex items-center space-x-2">
                        <i class="ph ph-clock-counter-clockwise text-neon text-xl"></i>
                        <h3 class="text-white font-medium">Log Kehadiran Member</h3>
                    </div>
                    
                    <form method="GET" action="{{ route('attendance.index') }}" class="flex items-center gap-2">
                        <label for="date" class="text-sm text-gray-400">Tanggal:</label>
                        <input type="date" name="date" id="date" value="{{ $selectedDate }}" onchange="this.form.submit()" class="border-gray-700 rounded bg-dark text-white text-sm focus:ring-neon focus:border-neon px-3 py-1.5">
                    </form>
                </div>
                
                <div class="overflow-x-auto flex-1">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-dark/50 border-b border-gray-800 text-xs uppercase tracking-wider text-gray-400">
                                <th class="px-6 py-4 font-medium">Waktu</th>
                                <th class="px-6 py-4 font-medium">Member</th>
                                <th class="px-6 py-4 font-medium">Sisa Masa Aktif</th>
                                <th class="px-6 py-4 font-medium">Petugas / Metode</th>
                            </tr>
                        </thead>
                        <tbody id="attendanceTableBody" class="divide-y divide-gray-800 text-sm">
                            @forelse ($attendances as $att)
                                @php
                                    $today = \Carbon\Carbon::today();
                                    $expiry = \Carbon\Carbon::parse($att->member->expiry_date)->startOfDay();
                                    $daysLeft = (int) $today->diffInDays($expiry, false);
                                @endphp
                                <tr class="hover:bg-dark/50 transition-colors">
                                    <td class="px-6 py-4">
                                        <span class="font-mono text-neon font-bold">{{ \Carbon\Carbon::parse($att->attendance_time)->format('H:i') }}</span>
                                    </td>
                                    <td class="px-6 py-4">
                                        <p class="font-medium text-white">{{ $att->member->name }}</p>
                                        <p class="text-xs text-gray-500 font-mono">{{ $att->member->member_id }}</p>
                                    </td>
                                    <td class="px-6 py-4">
                                        @if($daysLeft > 7)
                                            <span class="px-2.5 py-1 text-xs rounded-md bg-green-500/10 text-green-400 border border-green-500/30 font-mono font-medium inline-flex items-center">
                                                <i class="ph ph-hourglass-high mr-1 text-sm"></i> {{ $daysLeft }} Hari Lagi
                                            </span>
                                        @elseif($daysLeft >= 0)
                                            <span class="px-2.5 py-1 text-xs rounded-md bg-amber-500/10 text-amber-400 border border-amber-500/30 font-mono font-medium inline-flex items-center">
                                                <i class="ph ph-warning-circle mr-1 text-sm"></i> {{ $daysLeft == 0 ? 'Hari Ini Terakhir' : $daysLeft . ' Hari Lagi' }}
                                            </span>
                                        @else
                                            <span class="px-2.5 py-1 text-xs rounded-md bg-red-500/10 text-red-400 border border-red-500/30 font-mono font-medium inline-flex items-center">
                                                <i class="ph ph-x-circle mr-1 text-sm"></i> Expired
                                            </span>
                                        @endif
                                    </td>
                                    <td class="px-6 py-4 text-gray-400 text-xs">
                                        <i class="ph ph-user-circle mr-1"></i> {{ $att->user->name ?? 'Kiosk Biometrik' }}
                                    </td>
                                </tr>
                            @empty
                                <tr id="emptyAttendanceRow">
                                    <td colspan="4" class="px-6 py-12 text-center text-gray-500">
                                        <i class="ph ph-clock text-4xl mb-2 block text-gray-600"></i>
                                        Belum ada member yang absen hari ini.
                                    </td>
                                </tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Fullscreen Kiosk Overlay Modal -->
        <div id="fullscreenKiosk" x-show="isFullscreen" style="display: none;"
            class="fixed inset-0 z-50 bg-[#0d120a] flex flex-col p-6 sm:p-10 justify-between">
            <header class="flex items-center justify-between border-b border-gray-800 pb-4">
                <div class="flex items-center space-x-3">
                    <img src="{{ asset('asset/logo_gym.jpg') }}" alt="Logo" class="w-10 h-10 rounded-full border border-neon">
                    <div>
                        <span class="text-xl font-black text-white tracking-wider">BISA<span class="text-neon">GYM</span></span>
                        <p class="text-xs text-gray-400 font-mono">KIOSK CHECK-IN MANDIRI</p>
                    </div>
                </div>

                <div class="flex items-center space-x-6">
                    <div class="text-right">
                        <span id="fullscreenClock" class="text-2xl font-mono font-bold text-neon"></span>
                        <p class="text-xs text-gray-400">Pintu Masuk Utama</p>
                    </div>
                    <button type="button" @click="closeFullscreen()" class="p-2 rounded-lg bg-dark border border-gray-700 text-gray-400 hover:text-white">
                        <i class="ph ph-x text-2xl"></i>
                    </button>
                </div>
            </header>

            <main class="flex-1 flex flex-col lg:flex-row items-center justify-center gap-10 py-6 max-w-5xl mx-auto w-full">
                <!-- Video / Stream Stage -->
                <div class="w-full max-w-md">
                    <!-- Switcher in Fullscreen -->
                    <div class="flex items-center justify-between mb-3 bg-dark/80 p-1.5 rounded-lg border border-gray-700 text-xs">
                        <span class="text-gray-400 font-medium pl-1 flex items-center">
                            <i class="ph ph-camera mr-1 text-neon"></i> Sumber Kamera:
                        </span>
                        <div class="flex space-x-1">
                            <button type="button" @click="setCameraSource('webcam')"
                                :class="cameraSource === 'webcam' ? 'bg-neon text-darker font-bold shadow-sm' : 'text-gray-400 hover:text-white'"
                                class="px-2.5 py-1 rounded-md transition flex items-center text-xs">
                                <i class="ph ph-video-camera mr-1"></i> Webcam
                            </button>
                            <button type="button" @click="setCameraSource('esp32cam')"
                                :class="cameraSource === 'esp32cam' ? 'bg-neon text-darker font-bold shadow-sm' : 'text-gray-400 hover:text-white'"
                                class="px-2.5 py-1 rounded-md transition flex items-center text-xs">
                                <i class="ph ph-broadcast mr-1"></i> ESP32-CAM
                            </button>
                        </div>
                    </div>

                    <div class="kiosk-video-stage shadow-[0_0_40px_rgba(0,0,0,0.8)]" style="aspect-ratio: 1/1;">
                        <video id="fullscreenVideo" x-show="cameraSource === 'webcam'" autoplay muted playsinline></video>

                        <div x-show="cameraSource === 'esp32cam'" class="w-full h-full relative flex items-center justify-center bg-black">
                            <img id="fullscreenEsp32Image" :src="esp32StreamSrc"
                                x-show="esp32StreamSrc && !esp32Error"
                                x-on:load="onEsp32ImageLoad()"
                                x-on:error="onEsp32ImageError()"
                                class="kiosk-stream-img" alt="ESP32-CAM Stream">
                            <div x-show="!esp32StreamSrc || esp32Error" class="p-6 text-center text-gray-400">
                                <i class="ph ph-broadcast text-4xl text-neon mb-2 block"></i>
                                <p class="text-sm font-semibold text-white">ESP32-CAM Belum Terhubung</p>
                                <p class="text-xs text-gray-500 mt-1" x-text="esp32Ip ? 'Gagal memuat stream dari ' + esp32Ip : 'Ketik IP ESP32-CAM pada halaman utama'"></p>
                            </div>
                        </div>

                        <div class="kiosk-guide-frame" :class="scanning ? 'scanning' : ''"></div>
                        <div class="scan-laser-line" x-show="scanning"></div>
                    </div>
                    
                    <button type="button" @click="triggerFaceCheckin()" :disabled="scanning"
                        class="w-full mt-4 bg-neon hover:bg-[#c4e600] text-darker font-black text-lg py-4 rounded-xl transition shadow-[0_0_25px_rgba(224,255,0,0.3)] flex items-center justify-center space-x-2">
                        <i class="ph ph-scan text-2xl"></i>
                        <span x-text="scanning ? 'MEMPROSES WAJAH...' : 'MULAI CHECK-IN SEKARANG'"></span>
                    </button>
                    <button type="button" @click="connectBuzzer()" :disabled="buzzerConnecting || buzzerConnected"
                        class="w-full mt-2 bg-dark hover:bg-gray-800 disabled:opacity-50 text-gray-200 font-semibold py-3 px-4 rounded-xl border border-gray-700 transition-colors flex items-center justify-center space-x-2">
                        <i class="ph ph-speaker-high text-lg"></i>
                        <span x-text="buzzerConnecting ? 'Menyambungkan ESP32...' : (buzzerConnected ? 'ESP32 Terhubung' : 'Sambungkan Buzzer ESP32')"></span>
                    </button>
                    <p class="text-xs text-gray-400 text-center mt-2" role="status" x-text="buzzerStatus"></p>
                </div>

                <!-- Info / Feedback Side -->
                <div class="flex-1 max-w-md w-full">
                    <template x-if="!kioskResult">
                        <div class="text-center lg:text-left space-y-4">
                            <span class="text-neon text-xs font-mono font-bold uppercase tracking-widest">PANDUAN AKSES</span>
                            <h2 class="text-3xl font-extrabold text-white">Silakan Berdiri & Hadap Kamera</h2>
                            <p class="text-gray-400 text-sm leading-relaxed">
                                Posisikan wajah Anda tepat di dalam bingkai oval hijau. Pastikan pencahayaan cukup dan hanya satu orang di depan kamera.
                            </p>
                            <div class="pt-4 border-t border-gray-800 flex gap-4 text-xs text-gray-400 font-mono">
                                <div><i class="ph ph-check text-neon mr-1"></i> 1. Lepas Helm/Masker</div>
                                <div><i class="ph ph-check text-neon mr-1"></i> 2. Lihat Lurus</div>
                                <div><i class="ph ph-check text-neon mr-1"></i> 3. Tunggu Bunyi Beep</div>
                            </div>
                        </div>
                    </template>

                    <template x-if="kioskResult">
                        <div class="p-6 rounded-2xl border text-center space-y-4 kiosk-result-card"
                            :class="kioskResult.decision === 'ALLOW' ? 'bg-green-500/10 border-green-500 shadow-[0_0_40px_rgba(34,197,94,0.25)]' : 'bg-red-500/10 border-red-500 shadow-[0_0_40px_rgba(239,68,68,0.25)]'">
                            <div class="w-20 h-20 mx-auto rounded-full flex items-center justify-center text-5xl"
                                :class="kioskResult.decision === 'ALLOW' ? 'bg-green-500/20 text-green-400' : 'bg-red-500/20 text-red-400'">
                                <i :class="kioskResult.decision === 'ALLOW' ? 'ph ph-check-circle' : 'ph ph-x-circle'"></i>
                            </div>

                            <div>
                                <span class="text-xs font-mono uppercase tracking-widest font-bold"
                                    :class="kioskResult.decision === 'ALLOW' ? 'text-green-400' : 'text-red-400'"
                                    x-text="kioskResult.decision === 'ALLOW' ? 'AKSES DIIZINKAN' : 'AKSES BELUM DAPAT DIBERIKAN'"></span>
                                <h3 class="text-2xl font-black text-white mt-1" x-text="kioskResult.title"></h3>
                            </div>

                            <template x-if="kioskResult.member">
                                <div class="bg-black/50 p-4 rounded-xl border border-gray-800">
                                    <p class="text-xl font-extrabold text-white" x-text="kioskResult.member.name"></p>
                                    <p class="text-sm text-neon font-mono mt-0.5" x-text="kioskResult.member.member_id"></p>
                                    <template x-if="kioskResult.member.days_left !== undefined">
                                        <p class="text-sm font-bold mt-2"
                                            :class="kioskResult.member.days_left > 7 ? 'text-green-400' : (kioskResult.member.days_left >= 0 ? 'text-amber-400' : 'text-red-400')">
                                            Sisa Keanggotaan: <span x-text="kioskResult.member.days_left"></span> Hari
                                        </p>
                                    </template>
                                </div>
                            </template>

                            <p class="text-sm text-gray-300" x-text="kioskResult.message"></p>
                        </div>
                    </template>
                </div>
            </main>

            <footer class="border-t border-gray-800 pt-4 text-center text-xs text-gray-500">
                Butuh bantuan? Silakan hubungi resepsionis / kasir di sebelah kanan pintu masuk.
            </footer>
        </div>
    </div>

    @push('scripts')
    <script>
        function attendanceScanner() {
            return {
                activeMode: 'id',
                cameraSource: localStorage.getItem('bisagym_camera_source') || 'webcam', // 'webcam' | 'esp32cam'
                cameraReady: false,
                scanning: false,
                autoScan: false,
                autoScanTimer: null,
                stream: null,
                kioskResult: null,
                resultTimeout: null,
                totalSelectedDate: {{ $totalSelectedDate }},
                isFullscreen: false,
                serialPort: null,
                serialWriter: null,
                buzzerConnecting: false,
                buzzerConnected: false,
                buzzerStatus: 'Buzzer belum tersambung.',

                // ESP32-CAM State
                esp32Ip: localStorage.getItem('bisagym_esp32_ip') || '',
                esp32Connected: false,
                esp32Testing: false,
                esp32Status: '',
                esp32StreamSrc: '',
                esp32Error: false,
                esp32UseProxy: false,
                esp32PollTimer: null,
                esp32IsCloud: false,

                init() {
                    // Clock for fullscreen
                    setInterval(() => {
                        const now = new Date();
                        const timeStr = now.toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
                        const el = document.getElementById('fullscreenClock');
                        if (el) el.textContent = timeStr;
                    }, 1000);

                    // Restore ESP32 stream if configured
                    if (this.esp32Ip.trim()) {
                        this.updateEsp32Url();
                    }
                },

                normalizeHost(ipOrUrl) {
                    if (!ipOrUrl) return '';
                    let val = ipOrUrl.trim();
                    if (!/^https?:\/\//i.test(val)) {
                        // Jika mengandung domain (huruf di hostname), default ke https
                        // Jika IP numerik murni, default ke http
                        const isIpAddress = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(:\d+)?$/.test(val.split('/')[0]);
                        val = (isIpAddress ? 'http://' : 'https://') + val;
                    }
                    return val.replace(/\/+$/, '');
                },

                getEsp32StreamUrl() {
                    if (!this.esp32Ip.trim()) return '';
                    const base = this.normalizeHost(this.esp32Ip);
                    if (base.includes('/stream') || base.includes('.mjpg')) {
                        return base;
                    }
                    try {
                        const u = new URL(base);
                        // Jika menggunakan HTTPS tunnel (ngrok, cloudflare, localtunnel) atau domain, jangan tambahkan port :81
                        if (u.protocol === 'https:' || /[a-z]/i.test(u.hostname.replace(/\./g, ''))) {
                            return `${base}/stream`;
                        }
                        // Default ESP32-CAM IP lokal (port 81 untuk stream MJPEG standar)
                        if (!u.port || u.port === '80') {
                            return `${u.protocol}//${u.hostname}:81/stream`;
                        }
                        return `${base}/stream`;
                    } catch (e) {
                        return `${base}/stream`;
                    }
                },

                getEsp32ProxyStreamUrl() {
                    if (!this.esp32Ip.trim()) return '';
                    const streamUrl = this.getEsp32StreamUrl();
                    return `{{ route("attendance.esp32-stream") }}?url=${encodeURIComponent(streamUrl)}`;
                },

                getEsp32CaptureUrl() {
                    if (!this.esp32Ip.trim()) return '';
                    const base = this.normalizeHost(this.esp32Ip);
                    if (base.includes('/capture') || base.endsWith('.jpg')) {
                        return base;
                    }
                    return `${base}/capture`;
                },

                updateEsp32Url() {
                    localStorage.setItem('bisagym_esp32_ip', this.esp32Ip);
                    if (this.esp32Ip.trim()) {
                        this.refreshEsp32Stream();
                    } else {
                        this.esp32StreamSrc = '';
                        this.esp32Connected = false;
                        this.esp32Status = '';
                        this.esp32Error = false;
                    }
                },

                refreshEsp32Stream() {
                    if (!this.esp32Ip.trim()) return;
                    this.esp32UseProxy = false;
                    this.esp32Error = false;

                    // Stop polling sebelumnya jika ada
                    if (this.esp32PollTimer) {
                        clearInterval(this.esp32PollTimer);
                        this.esp32PollTimer = null;
                    }

                    const base = this.normalizeHost(this.esp32Ip);
                    this.esp32IsCloud = /^https:/i.test(base);

                    if (this.esp32IsCloud) {
                        // CLOUD MODE: Polling /capture setiap 500ms (Railway tidak support MJPEG long-lived)
                        this.esp32Status = 'Menghubungkan ke ESP32-CAM Cloud...';
                        const captureUrl = this.getEsp32CaptureUrl();
                        const self = this;
                        let loadOk = false;

                        function pollFrame() {
                            const img = new Image();
                            img.onload = function() {
                                self.esp32StreamSrc = img.src;
                                if (!loadOk) {
                                    loadOk = true;
                                    self.esp32Connected = true;
                                    self.esp32Error = false;
                                    self.esp32Status = 'ESP32-CAM Cloud aktif (polling mode).';
                                }
                            };
                            img.onerror = function() {
                                if (!loadOk) {
                                    self.esp32Status = 'Menunggu frame dari ESP32-CAM...';
                                }
                            };
                            img.src = captureUrl + (captureUrl.includes('?') ? '&' : '?') + '_t=' + Date.now();
                        }

                        pollFrame();
                        this.esp32PollTimer = setInterval(pollFrame, 600);
                    } else {
                        // LOCAL MODE: MJPEG stream langsung (IP lokal / jaringan sama)
                        const url = this.getEsp32StreamUrl();
                        const sep = url.includes('?') ? '&' : '?';
                        this.esp32StreamSrc = url + sep + '_t=' + Date.now();
                        this.esp32Status = 'Menghubungkan ke stream ESP32-CAM lokal...';
                    }
                },

                onEsp32ImageLoad() {
                    this.esp32Connected = true;
                    this.esp32Error = false;
                    if (!this.esp32IsCloud) {
                        this.esp32Status = this.esp32UseProxy ? 'Stream ESP32-CAM aktif (via proxy).' : 'Stream ESP32-CAM aktif.';
                    }
                },

                onEsp32ImageError() {
                    // Cloud mode pakai polling, jangan fallback ke proxy
                    if (this.esp32IsCloud) return;

                    // Jika belum coba proxy, coba lewat proxy Laravel
                    if (!this.esp32UseProxy && this.esp32Ip.trim()) {
                        this.esp32UseProxy = true;
                        const proxyUrl = this.getEsp32ProxyStreamUrl();
                        const sep = proxyUrl.includes('?') ? '&' : '?';
                        this.esp32StreamSrc = proxyUrl + (proxyUrl.includes('_t=') ? '' : sep + '_t=' + Date.now());
                        this.esp32Status = 'Mencoba koneksi via proxy server...';
                        return;
                    }
                    this.esp32Connected = false;
                    this.esp32Error = true;
                    this.esp32Status = 'Gagal memuat stream dari ' + this.esp32Ip + '. Periksa IP / Wi-Fi.';
                },

                async testEsp32Connection() {
                    if (!this.esp32Ip.trim()) return;
                    this.esp32Testing = true;
                    this.esp32Status = 'Menguji koneksi ke ESP32-CAM...';
                    try {
                        const res = await fetch('{{ route("attendance.test-esp32") }}', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
                                'Accept': 'application/json'
                            },
                            body: JSON.stringify({ esp32_url: this.getEsp32CaptureUrl() })
                        });
                        const data = await res.json();
                        if (data.success) {
                            this.esp32Connected = true;
                            this.esp32Error = false;
                            this.esp32Status = data.message;
                            this.refreshEsp32Stream();
                        } else {
                            this.esp32Connected = false;
                            this.esp32Error = true;
                            this.esp32Status = data.message || 'Gagal tersambung ke ESP32-CAM.';
                        }
                    } catch (err) {
                        this.esp32Connected = false;
                        this.esp32Error = true;
                        this.esp32Status = 'Koneksi gagal: ' + err.message;
                    } finally {
                        this.esp32Testing = false;
                    }
                },

                setCameraSource(source) {
                    this.cameraSource = source;
                    localStorage.setItem('bisagym_camera_source', source);
                    // Hentikan polling jika pindah dari ESP32
                    if (source === 'webcam' && this.esp32PollTimer) {
                        clearInterval(this.esp32PollTimer);
                        this.esp32PollTimer = null;
                    }
                    if (this.activeMode === 'face') {
                        if (source === 'webcam') {
                            this.$nextTick(() => this.startCamera(this.isFullscreen ? 'fullscreenVideo' : 'kioskVideo'));
                        } else {
                            this.stopCamera();
                            this.refreshEsp32Stream();
                        }
                    }
                },

                setMode(mode) {
                    this.activeMode = mode;
                    if (mode === 'face') {
                        if (this.cameraSource === 'webcam') {
                            this.$nextTick(() => this.startCamera(this.isFullscreen ? 'fullscreenVideo' : 'kioskVideo'));
                        } else {
                            this.refreshEsp32Stream();
                        }
                    } else {
                        this.stopCamera();
                        this.$nextTick(() => {
                            const input = document.getElementById('identifier');
                            if (input) input.focus();
                        });
                    }
                },

                async startCamera(videoElementId) {
                    if (this.stream) return;
                    try {
                        this.stream = await navigator.mediaDevices.getUserMedia({
                            video: {
                                width: { ideal: 640 },
                                height: { ideal: 480 },
                                facingMode: 'user'
                            },
                            audio: false
                        });

                        const video = document.getElementById(videoElementId);
                        if (video) {
                            video.srcObject = this.stream;
                            video.onloadedmetadata = () => {
                                video.play();
                                this.cameraReady = true;
                            };
                        }
                    } catch (err) {
                        console.error('Kamera gagal dibuka:', err);
                        this.cameraReady = false;
                        alert('Tidak dapat mengakses kamera. Pastikan izin kamera browser sudah diberikan.');
                    }
                },

                async connectBuzzer() {
                    if (!('serial' in navigator)) {
                        this.buzzerStatus = 'Web Serial tidak tersedia. Gunakan Chrome/Edge di localhost atau HTTPS.';
                        return;
                    }

                    this.buzzerConnecting = true;
                    try {
                        this.serialPort = await navigator.serial.requestPort();
                        await this.serialPort.open({ baudRate: 115200 });
                        if (!this.serialPort.writable) {
                            throw new Error('Port serial ESP32 tidak dapat ditulis.');
                        }

                        this.serialWriter = this.serialPort.writable.getWriter();
                        this.buzzerConnected = true;
                        this.buzzerStatus = 'ESP32 terhubung. Alarm aktif untuk wajah tak dikenal.';
                        await this.sendBuzzerCommand('OFF');
                    } catch (error) {
                        console.error('Koneksi buzzer ESP32 gagal:', error);
                        this.buzzerConnected = false;
                        this.buzzerStatus = `Koneksi buzzer gagal: ${error.message || 'Periksa port dan kabel USB.'}`;
                        if (this.serialWriter) {
                            this.serialWriter.releaseLock();
                            this.serialWriter = null;
                        }
                        if (this.serialPort) {
                            try {
                                await this.serialPort.close();
                            } catch (closeError) {
                                console.error('Port serial tidak dapat ditutup:', closeError);
                            }
                        }
                        this.serialPort = null;
                    } finally {
                        this.buzzerConnecting = false;
                    }
                },

                async sendBuzzerCommand(command) {
                    if (!this.serialWriter) {
                        if (command === 'UNKNOWN') {
                            this.buzzerStatus = 'Wajah tak dikenal terdeteksi, tetapi ESP32 belum tersambung.';
                        }
                        return;
                    }

                    try {
                        await this.serialWriter.write(new TextEncoder().encode(`${command}\n`));
                    } catch (error) {
                        console.error('Pengiriman perintah buzzer gagal:', error);
                        this.buzzerConnected = false;
                        this.buzzerStatus = 'Koneksi ESP32 terputus. Sambungkan kembali buzzer.';
                        this.serialWriter.releaseLock();
                        this.serialWriter = null;
                        if (this.serialPort) {
                            try {
                                await this.serialPort.close();
                            } catch (closeError) {
                                console.error('Port serial terputus dan tidak dapat ditutup:', closeError);
                            }
                            this.serialPort = null;
                        }
                    }
                },

                stopCamera() {
                    if (this.autoScanTimer) clearInterval(this.autoScanTimer);
                    if (this.stream) {
                        this.stream.getTracks().forEach(track => track.stop());
                        this.stream = null;
                    }
                    this.cameraReady = false;
                },

                async triggerFaceCheckin() {
                    if (this.scanning) return;

                    if (this.cameraSource === 'webcam') {
                        const video = this.isFullscreen ? document.getElementById('fullscreenVideo') : document.getElementById('kioskVideo');
                        if (!video || !this.cameraReady) {
                            alert('Kamera webcam belum siap.');
                            return;
                        }

                        this.scanning = true;

                        // Capture frame via canvas
                        const canvas = document.createElement('canvas');
                        canvas.width = video.videoWidth || 640;
                        canvas.height = video.videoHeight || 480;
                        const ctx = canvas.getContext('2d');
                        ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

                        canvas.toBlob(async (blob) => {
                            if (!blob) {
                                this.scanning = false;
                                return;
                            }

                            const formData = new FormData();
                            formData.append('frame', blob, 'checkin.jpg');
                            await this.sendCheckinRequest(formData);
                        }, 'image/jpeg', 0.88);

                    } else {
                        // ESP32-CAM Source
                        if (!this.esp32Ip.trim()) {
                            alert('Silakan masukkan alamat IP ESP32-CAM terlebih dahulu.');
                            return;
                        }

                        this.scanning = true;
                        const formData = new FormData();
                        formData.append('esp32_url', this.getEsp32CaptureUrl());
                        await this.sendCheckinRequest(formData);
                    }
                },

                async sendCheckinRequest(formData) {
                    try {
                        const res = await fetch('{{ route("attendance.face-checkin") }}', {
                            method: 'POST',
                            headers: {
                                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
                                'Accept': 'application/json'
                            },
                            body: formData
                        });

                        const data = await res.json();
                        this.handleCheckinResult(data);
                    } catch (err) {
                        console.error('Checkin error:', err);
                        this.handleCheckinResult({
                            decision: 'DENY',
                            title: 'Kesalahan Jaringan',
                            message: 'Tidak dapat menghubungi server atau kamera. Coba lagi beberapa saat.'
                        });
                    } finally {
                        this.scanning = false;
                    }
                },

                async handleCheckinResult(data) {
                    this.kioskResult = data;
                    clearTimeout(this.resultTimeout);

                    await this.sendBuzzerCommand(data.code === 'IDENTITY_NOT_FOUND' ? 'UNKNOWN' : 'OFF');

                    // Kirim sinyal feedback ke ESP32 Kiosk (LED, Buzzer, LCD) lewat Wi-Fi lokal
                    if (this.esp32Ip && this.esp32Ip.trim()) {
                        const isSuccess = data.decision === 'ALLOW';
                        const statusParam = isSuccess ? 'berhasil' : 'gagal';
                        const memberName = data.member?.name || '';
                        let base = this.esp32Ip.trim().replace(/\/+$/, '');
                        if (!/^https?:\/\//i.test(base)) base = 'http://' + base;
                        fetch(`${base}/absen?status=${statusParam}&name=${encodeURIComponent(memberName)}`, { mode: 'no-cors' })
                            .catch(() => {});
                    }

                    // Sound effect
                    this.playAudioFeedback(data.decision === 'ALLOW');

                    // If ALLOW: prepend to table dynamically!
                    if (data.decision === 'ALLOW' && data.member) {
                        this.totalSelectedDate++;
                        this.prependAttendanceRow(data.member);
                    }

                    // Auto dismiss result after 4 seconds
                    this.resultTimeout = setTimeout(() => {
                        this.kioskResult = null;
                        if (this.autoScan && this.activeMode === 'face') {
                            this.triggerFaceCheckin();
                        }
                    }, 4000);
                },

                prependAttendanceRow(member) {
                    const tbody = document.getElementById('attendanceTableBody');
                    const emptyRow = document.getElementById('emptyAttendanceRow');
                    if (emptyRow) emptyRow.remove();

                    if (!tbody) return;

                    const daysLeft = member.days_left;
                    let badgeHtml = '';
                    if (daysLeft > 7) {
                        badgeHtml = `<span class="px-2.5 py-1 text-xs rounded-md bg-green-500/10 text-green-400 border border-green-500/30 font-mono font-medium inline-flex items-center"><i class="ph ph-hourglass-high mr-1 text-sm"></i> ${daysLeft} Hari Lagi</span>`;
                    } else if (daysLeft >= 0) {
                        badgeHtml = `<span class="px-2.5 py-1 text-xs rounded-md bg-amber-500/10 text-amber-400 border border-amber-500/30 font-mono font-medium inline-flex items-center"><i class="ph ph-warning-circle mr-1 text-sm"></i> Sisa ${daysLeft} Hari</span>`;
                    } else {
                        badgeHtml = `<span class="px-2.5 py-1 text-xs rounded-md bg-red-500/10 text-red-400 border border-red-500/30 font-mono font-medium inline-flex items-center"><i class="ph ph-x-circle mr-1 text-sm"></i> Expired</span>`;
                    }

                    const methodText = this.cameraSource === 'esp32cam' ? 'ESP32-CAM AI' : 'Webcam AI';

                    const tr = document.createElement('tr');
                    tr.className = 'hover:bg-dark/50 transition-colors bg-green-500/5 animate-pulse';
                    tr.innerHTML = `
                        <td class="px-6 py-4"><span class="font-mono text-neon font-bold">${member.attendance_time || 'Baru Saja'}</span></td>
                        <td class="px-6 py-4"><p class="font-medium text-white">${member.name}</p><p class="text-xs text-gray-500 font-mono">${member.member_id}</p></td>
                        <td class="px-6 py-4">${badgeHtml}</td>
                        <td class="px-6 py-4 text-gray-400 text-xs"><i class="ph ph-scan-face text-neon mr-1"></i> ${methodText}</td>
                    `;
                    tbody.prepend(tr);
                },

                playAudioFeedback(isSuccess) {
                    try {
                        const AudioContext = window.AudioContext || window.webkitAudioContext;
                        if (!AudioContext) return;
                        const ctx = new AudioContext();
                        const osc = ctx.createOscillator();
                        const gain = ctx.createGain();
                        osc.connect(gain);
                        gain.connect(ctx.destination);

                        if (isSuccess) {
                            // Pleasant major 3rd beep
                            osc.frequency.setValueAtTime(587.33, ctx.currentTime); // D5
                            osc.frequency.setValueAtTime(880.00, ctx.currentTime + 0.12); // A5
                            gain.gain.setValueAtTime(0.2, ctx.currentTime);
                            gain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.35);
                            osc.start();
                            osc.stop(ctx.currentTime + 0.35);
                        } else {
                            // Low buzz
                            osc.type = 'sawtooth';
                            osc.frequency.setValueAtTime(160, ctx.currentTime);
                            gain.gain.setValueAtTime(0.2, ctx.currentTime);
                            gain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + 0.3);
                            osc.start();
                            osc.stop(ctx.currentTime + 0.3);
                        }
                    } catch (e) {
                        // ignore audio context restrictions
                    }
                },

                openFullscreen() {
                    const el = document.getElementById('fullscreenKiosk');
                    if (el) {
                        this.isFullscreen = true;
                        this.setMode('face');
                        this.$nextTick(() => {
                            if (el.requestFullscreen) {
                                el.requestFullscreen().catch(() => {});
                            }
                            if (this.cameraSource === 'webcam') {
                                this.startCamera('fullscreenVideo');
                            } else {
                                this.refreshEsp32Stream();
                            }
                        });
                    }
                },

                closeFullscreen() {
                    this.isFullscreen = false;
                    if (document.fullscreenElement && document.exitFullscreen) {
                        document.exitFullscreen().catch(() => {});
                    }
                    this.setMode('face');
                    this.$nextTick(() => {
                        if (this.cameraSource === 'webcam') {
                            this.startCamera('kioskVideo');
                        } else {
                            this.refreshEsp32Stream();
                        }
                    });
                }
            };
        }

        document.addEventListener('alpine:init', () => {
            const input = document.getElementById('identifier');
            if (input) {
                input.addEventListener('input', function() {
                    if (this.value.startsWith('VIP-') && this.value.length >= 24) {
                        this.form.submit();
                    }
                });
            }
        });
    </script>
    @endpush
</x-app-layout>
