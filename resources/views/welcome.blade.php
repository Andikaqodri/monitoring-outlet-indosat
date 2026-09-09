<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IOH - Internal API Services</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .indosat-red { background-color: #ED1D24; }
        .indosat-yellow { background-color: #FFC20E; }
    </style>
</head>
<body class="bg-slate-950 text-slate-100 min-h-screen">

    <!-- Header -->
    <header class="bg-slate-900 border-b border-slate-800 sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 py-3 flex items-center justify-between">
            <div class="flex items-center space-x-3">
                <div class="w-9 h-9 rounded-lg indosat-red flex items-center justify-center font-black text-lg text-white shadow-md">
                    IOH
                </div>
                <div>
                    <h1 class="text-base font-bold text-white leading-tight">API Gateway & Developer Console</h1>
                    <p class="text-[11px] text-slate-400">Monitoring Outlet & CCIB System &bull; Environment: Local</p>
                </div>
            </div>
            <div class="flex items-center space-x-2">
                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
                    <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 mr-1.5 animate-pulse"></span>
                    API Service Online
                </span>
            </div>
        </div>
    </header>

    <main class="max-w-7xl mx-auto px-4 py-6">

        <!-- Top Metrics Bar -->
        <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 mb-6">
            <div class="bg-slate-900 p-3.5 rounded-xl border border-slate-800">
                <p class="text-[11px] text-slate-400">Endpoints Status</p>
                <p class="text-lg font-bold text-white">32 Active Routes</p>
            </div>
            <div class="bg-slate-900 p-3.5 rounded-xl border border-slate-800">
                <p class="text-[11px] text-slate-400">Database Schema</p>
                <p class="text-lg font-bold text-emerald-400">11 Relational Tables</p>
            </div>
            <div class="bg-slate-900 p-3.5 rounded-xl border border-slate-800">
                <p class="text-[11px] text-slate-400">Database Engine</p>
                <p class="text-lg font-bold text-blue-400">PostgreSQL Driver</p>
            </div>
            <div class="bg-slate-900 p-3.5 rounded-xl border border-slate-800">
                <p class="text-[11px] text-slate-400">Authentication</p>
                <p class="text-lg font-bold text-amber-400">Sanctum Token</p>
            </div>
        </div>

        <!-- Testing Console Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
            
            <!-- Left: Request Controls -->
            <div class="lg:col-span-5 space-y-4">
                
                <!-- Authentication Panel -->
                <div class="bg-slate-900 border border-slate-800 rounded-xl p-4">
                    <div class="flex items-center justify-between mb-3">
                        <h2 class="text-xs font-bold text-slate-200 uppercase tracking-wider flex items-center">
                            <i class="fas fa-shield-alt text-amber-400 mr-1.5"></i> Authentication Session
                        </h2>
                        <span id="authStatus" class="text-[10px] px-2 py-0.5 rounded bg-slate-800 text-slate-400">No Session</span>
                    </div>
                    
                    <div class="grid grid-cols-2 gap-2 mb-3">
                        <button onclick="loginAs('admin@indosat.com')" class="p-2 bg-slate-800 hover:bg-slate-700/80 rounded-lg text-left border border-slate-700/60 transition">
                            <div class="text-xs font-semibold text-white">Admin Pusat</div>
                            <div class="text-[10px] text-slate-400">admin@indosat.com</div>
                        </button>
                        <button onclick="loginAs('cse.surabaya@indosat.com')" class="p-2 bg-slate-800 hover:bg-slate-700/80 rounded-lg text-left border border-slate-700/60 transition">
                            <div class="text-xs font-semibold text-white">CSE Area</div>
                            <div class="text-[10px] text-slate-400">cse.surabaya@indosat.com</div>
                        </button>
                        <button onclick="loginAs('owner.kayoon@mitra.com')" class="p-2 bg-slate-800 hover:bg-slate-700/80 rounded-lg text-left border border-slate-700/60 transition">
                            <div class="text-xs font-semibold text-white">Owner Gerai</div>
                            <div class="text-[10px] text-slate-400">owner.kayoon@mitra.com</div>
                        </button>
                        <button onclick="loginAs('sales.kayoon@mitra.com')" class="p-2 bg-slate-800 hover:bg-slate-700/80 rounded-lg text-left border border-slate-700/60 transition">
                            <div class="text-xs font-semibold text-white">Sales Kasir</div>
                            <div class="text-[10px] text-slate-400">sales.kayoon@mitra.com</div>
                        </button>
                    </div>

                    <div class="text-[10px] bg-slate-950 p-2 rounded border border-slate-800 font-mono text-slate-400 truncate" id="tokenBox">
                        Bearer: <span class="text-slate-600">Select user role above to authenticate</span>
                    </div>
                </div>

                <!-- API Endpoint Controls -->
                <div class="bg-slate-900 border border-slate-800 rounded-xl p-4">
                    <h2 class="text-xs font-bold text-slate-200 uppercase tracking-wider mb-3 flex items-center">
                        <i class="fas fa-network-wired text-blue-400 mr-1.5"></i> Endpoint Test Suite
                    </h2>
                    
                    <div class="space-y-1.5">
                        <button onclick="testApi('/api/v1/cards', 'GET')" class="w-full text-left px-3 py-2 rounded-lg bg-slate-950 hover:bg-slate-800 border border-slate-800/80 text-xs transition flex items-center justify-between">
                            <span><strong class="text-emerald-400 font-mono mr-2">GET</strong> /api/v1/cards</span>
                            <span class="text-slate-400 text-[10px]">Cards Catalogue</span>
                        </button>

                        <button onclick="testApi('/api/v1/dashboard/overview', 'GET', true)" class="w-full text-left px-3 py-2 rounded-lg bg-slate-950 hover:bg-slate-800 border border-slate-800/80 text-xs transition flex items-center justify-between">
                            <span><strong class="text-emerald-400 font-mono mr-2">GET</strong> /api/v1/dashboard/overview</span>
                            <span class="text-slate-400 text-[10px]">KPI Overview</span>
                        </button>

                        <button onclick="testApi('/api/v1/outlets', 'GET', true)" class="w-full text-left px-3 py-2 rounded-lg bg-slate-950 hover:bg-slate-800 border border-slate-800/80 text-xs transition flex items-center justify-between">
                            <span><strong class="text-emerald-400 font-mono mr-2">GET</strong> /api/v1/outlets</span>
                            <span class="text-slate-400 text-[10px]">Authorized Outlets</span>
                        </button>

                        <button onclick="testApi('/api/v1/outlets/1/stocks', 'GET', true)" class="w-full text-left px-3 py-2 rounded-lg bg-slate-950 hover:bg-slate-800 border border-slate-800/80 text-xs transition flex items-center justify-between">
                            <span><strong class="text-emerald-400 font-mono mr-2">GET</strong> /api/v1/outlets/1/stocks</span>
                            <span class="text-slate-400 text-[10px]">Outlet Stock Balance</span>
                        </button>

                        <button onclick="simulateSale()" class="w-full text-left px-3 py-2 rounded-lg bg-slate-950 hover:bg-slate-800 border border-slate-800/80 text-xs transition flex items-center justify-between">
                            <span><strong class="text-amber-400 font-mono mr-2">POST</strong> /api/v1/transactions</span>
                            <span class="text-slate-400 text-[10px]">Sales Transaction</span>
                        </button>

                        <button onclick="simulateReplacement()" class="w-full text-left px-3 py-2 rounded-lg bg-slate-950 hover:bg-slate-800 border border-slate-800/80 text-xs transition flex items-center justify-between">
                            <span><strong class="text-amber-400 font-mono mr-2">POST</strong> /api/v1/card-replacements</span>
                            <span class="text-slate-400 text-[10px]">Card Replacement</span>
                        </button>

                        <button onclick="simulateOtp()" class="w-full text-left px-3 py-2 rounded-lg bg-slate-950 hover:bg-slate-800 border border-slate-800/80 text-xs transition flex items-center justify-between">
                            <span><strong class="text-amber-400 font-mono mr-2">POST</strong> /api/v1/otp/send</span>
                            <span class="text-slate-400 text-[10px]">OTP Dispatch</span>
                        </button>
                    </div>
                </div>

            </div>

            <!-- Right: Response Console -->
            <div class="lg:col-span-7">
                <div class="bg-slate-900 border border-slate-800 rounded-xl p-4 h-full flex flex-col">
                    <div class="flex items-center justify-between pb-2.5 border-b border-slate-800 mb-3">
                        <div>
                            <h2 class="text-xs font-bold text-slate-200 uppercase tracking-wider flex items-center">
                                <i class="fas fa-terminal text-emerald-400 mr-1.5"></i> HTTP Response Payload
                            </h2>
                            <p class="text-[11px] text-slate-400 font-mono" id="currentEndpoint">Endpoint: Ready</p>
                        </div>
                        <span id="responseStatus" class="text-xs font-mono font-semibold px-2 py-0.5 rounded bg-slate-800 text-slate-400">
                            HTTP 200
                        </span>
                    </div>

                    <pre id="jsonOutput" class="flex-1 bg-slate-950 p-3.5 rounded-lg text-xs font-mono text-emerald-400 overflow-auto border border-slate-900 min-h-[350px] max-h-[520px] leading-relaxed">
// Select an action on the left panel to execute an API request and inspect the JSON response.
                    </pre>
                </div>
            </div>

        </div>

    </main>

    <script>
        let currentToken = '';

        async function loginAs(email) {
            const btnBox = document.getElementById('tokenBox');
            btnBox.innerHTML = '<span class="text-amber-400">Authenticating...</span>';

            try {
                const res = await fetch('/api/v1/auth/login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                    body: JSON.stringify({ identifier: email, password: 'password' })
                });

                const data = await res.json();
                renderJson('/api/v1/auth/login', res.status, data);

                if (data.status === 'success') {
                    currentToken = data.data.token;
                    document.getElementById('authStatus').className = 'text-[10px] px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-400 border border-emerald-500/30 font-semibold';
                    document.getElementById('authStatus').innerText = data.data.user.name;
                    btnBox.innerHTML = '<span class="text-emerald-400 font-bold">Bearer:</span> ' + currentToken.substring(0, 30) + '...';
                }
            } catch (err) {
                renderJson('/api/v1/auth/login', 500, { error: err.message });
            }
        }

        async function testApi(url, method = 'GET', requireAuth = false) {
            if (requireAuth && !currentToken) {
                await loginAs('admin@indosat.com');
            }

            const headers = { 'Accept': 'application/json' };
            if (currentToken) {
                headers['Authorization'] = 'Bearer ' + currentToken;
            }

            try {
                const res = await fetch(url, { method, headers });
                const data = await res.json();
                renderJson(url, res.status, data);
            } catch (err) {
                renderJson(url, 500, { error: err.message });
            }
        }

        async function simulateSale() {
            if (!currentToken) await loginAs('sales.kayoon@mitra.com');
            
            try {
                const res = await fetch('/api/v1/transactions', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                        'Authorization': 'Bearer ' + currentToken
                    },
                    body: JSON.stringify({
                        outlet_id: 1,
                        card_id: 1,
                        qty: 1,
                        customer_name: 'Customer Direct Sale',
                        customer_phone: '085712348899'
                    })
                });
                const data = await res.json();
                renderJson('/api/v1/transactions (POST)', res.status, data);
            } catch (err) {
                renderJson('/api/v1/transactions', 500, { error: err.message });
            }
        }

        async function simulateReplacement() {
            if (!currentToken) await loginAs('sales.kayoon@mitra.com');
            
            try {
                const res = await fetch('/api/v1/card-replacements', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                        'Authorization': 'Bearer ' + currentToken
                    },
                    body: JSON.stringify({
                        outlet_id: 1,
                        customer_name: 'Ahmad Fauzi',
                        customer_nik: '3578011504950001',
                        customer_phone: '085712348899',
                        old_iccid: '8962010100492812',
                        new_iccid: '8962010100998811',
                        reason: 'Upgrade 5G Indosat',
                        fee: 25000
                    })
                });
                const data = await res.json();
                renderJson('/api/v1/card-replacements (POST)', res.status, data);
            } catch (err) {
                renderJson('/api/v1/card-replacements', 500, { error: err.message });
            }
        }

        async function simulateOtp() {
            try {
                const res = await fetch('/api/v1/otp/send', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
                    body: JSON.stringify({ phone: '085712345678', type: 'REGISTER' })
                });
                const data = await res.json();
                renderJson('/api/v1/otp/send (POST)', res.status, data);
            } catch (err) {
                renderJson('/api/v1/otp/send', 500, { error: err.message });
            }
        }

        function renderJson(endpoint, status, data) {
            document.getElementById('currentEndpoint').innerText = 'Endpoint: ' + endpoint;
            const statusEl = document.getElementById('responseStatus');
            statusEl.innerText = 'HTTP ' + status;
            statusEl.className = status >= 200 && status < 300 
                ? 'text-xs font-mono font-semibold px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-400 border border-emerald-500/30'
                : 'text-xs font-mono font-semibold px-2 py-0.5 rounded bg-red-500/20 text-red-400 border border-red-500/30';

            document.getElementById('jsonOutput').innerText = JSON.stringify(data, null, 2);
        }
    </script>
</body>
</html>