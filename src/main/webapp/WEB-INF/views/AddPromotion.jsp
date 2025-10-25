<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Add Promotion</title>

  <!-- Tailwind -->
  <script src="https://cdn.tailwindcss.com"></script>

  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

  <style>
    /* subtle animations */
    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(18px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .fade-in { animation: fadeInUp 0.6s cubic-bezier(.22,.9,.38,1) both; }

    /* hero underline */
    .hero-underline { width: 72px; height: 6px; background: linear-gradient(90deg,#60a5fa,#38bdf8); border-radius:999px; margin-top:12px; }

    /* image preview */
    .preview-wrap { display:flex; gap:1rem; align-items:center; }
    .preview-thumb { width:140px; height:100px; object-fit:cover; border-radius:10px; box-shadow:0 8px 20px rgba(2,6,23,0.12); }

    /* input drop area */
    .drop-area { border: 2px dashed rgba(14,165,233,0.12); background: linear-gradient(180deg, rgba(14,165,233,0.02), transparent); padding:12px; border-radius:12px; cursor:pointer; }
    .drop-area.hover { border-color: rgba(59,130,246,0.6); background: rgba(59,130,246,0.02); }

    /* nice card */
    .card-glass { background: linear-gradient(180deg, rgba(255,255,255,0.92), rgba(255,255,255,0.86)); box-shadow: 0 12px 34px rgba(2,6,23,0.12); border-radius:18px; }

    /* small focus ring */
    .focus-ring:focus { outline: 3px solid rgba(59,130,246,0.12); outline-offset: 2px; }

    /* subtle tooltip */
    .hint { font-size:0.9rem; color:#6b7280; }
  </style>
</head>
<body class="bg-gradient-to-b from-slate-50 to-white min-h-screen text-gray-800">

<!-- Navbar -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg">
  <div class="max-w-7xl mx-auto px-6">
    <div class="flex items-center justify-between h-24">
      <div class="flex items-center space-x-3 flex-shrink-0">
        <div class="text-3xl font-extrabold tracking-wide">
          <span class="text-blue-400">BlueWave</span> Safaris - Marketing Coordinator
        </div>
      </div>
      <div class="hidden lg:flex items-center space-x-8 font-semibold text-lg">
        <a href="/marketing-coordinator/dashboard" class="hover:text-blue-400 transition">Dashboard</a>
        <a href="/marketing-trips" class="hover:text-blue-400 transition">Campaigns</a>
        <a href="/marketing-coordinator/profile" class="hover:text-blue-400 transition">Profile</a>
        <a href="/logout" class="text-3xl hover:text-blue-400 transition" aria-label="Logout"><i class="fas fa-sign-out-alt"></i></a>
      </div>
      <div class="lg:hidden flex items-center">
        <button id="menu-btn" class="text-white text-3xl focus:outline-none" aria-label="Open menu">
          <i class="fas fa-bars"></i>
        </button>
      </div>
    </div>
  </div>
  <div id="mobile-menu" class="hidden lg:hidden bg-black px-6 py-4 space-y-4 text-lg">
    <a href="/marketing-coordinator/dashboard" class="block hover:text-blue-400 transition">Dashboard</a>
    <a href="/marketing-trips" class="block hover:text-blue-400 transition">Campaigns</a>
    <a href="/marketing-coordinator/profile" class="block hover:text-blue-400 transition">Profile</a>
    <a href="/logout" class="block hover:text-blue-400 transition"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
  </div>
</nav>

<!-- HERO -->
<header class="pt-28 pb-8">
  <div class="max-w-5xl mx-auto px-6">
    <div class="card-glass overflow-hidden p-8 flex flex-col md:flex-row items-start gap-8">
      <div class="flex-1">
        <h1 class="text-3xl md:text-4xl font-extrabold text-slate-900">Create Promotion for</h1>
        <h2 class="text-2xl md:text-3xl font-extrabold text-blue-600 mt-2">${trip.name}</h2>
        <p class="mt-4 text-gray-600">Boost bookings with limited-time offers — set minimums, discount percent and upload a promotional image. Your promotion will include an additional discount based on trip type.</p>
        <p class="mt-2 text-gray-600"><strong>Trip Type:</strong> ${trip.type} (Additional Discount: ${trip.type == 'morning' ? '5%' : trip.type == 'evening' ? '7.5%' : trip.type == 'private' ? '10%' : '0%'})</p>

        <div class="mt-6 flex gap-3">
          <a href="/marketing/promotions" class="inline-flex items-center gap-2 bg-gradient-to-r from-blue-500 to-blue-400 text-white px-4 py-2 rounded-full shadow hover:scale-[1.02] transition">
            <i class="fas fa-tags"></i> View Promotions
          </a>
          <a href="/trips/view?tripId=${trip.id}" class="inline-flex items-center gap-2 bg-white/10 text-slate-900 px-4 py-2 rounded-full border border-white/10 hover:bg-white/5 transition">
            <i class="fas fa-eye"></i> Preview Trip
          </a>
        </div>

        <div class="hero-underline"></div>
      </div>

      <div class="w-full md:w-80 flex-shrink-0">
        <div class="rounded-xl overflow-hidden bg-gradient-to-tr from-blue-50 to-white p-4 shadow-inner">
          <div class="flex items-center gap-3">
            <div>
              <div class="text-xs uppercase text-slate-500">Price / hour</div>
              <div class="text-xl font-bold text-slate-800 mt-1">$${trip.price}</div>
            </div>
            <div class="ml-auto text-center">
              <div class="text-xs text-slate-500">Capacity</div>
              <div class="text-lg font-semibold text-slate-800">${trip.capacity}</div>
            </div>
          </div>

          <div class="mt-4">
            <div class="w-full h-40 rounded-lg overflow-hidden bg-white/50 flex items-center justify-center">
              <c:choose>
                <c:when test="${not empty trip.pictureUrl}">
                  <img src="${trip.pictureUrl}" alt="${trip.name}" class="w-full h-full object-cover"/>
                </c:when>
                <c:otherwise>
                  <div class="text-center text-slate-300">
                    <i class="fas fa-ship text-3xl"></i>
                    <div class="mt-2">No image</div>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</header>

<!-- FORM -->
<section class="max-w-5xl mx-auto px-6 pb-12">
  <form action="/submit-promotion" method="post" enctype="multipart/form-data" class="card-glass p-8 rounded-2xl shadow-xl grid grid-cols-1 md:grid-cols-3 gap-6 fade-in">
    <!-- hidden values -->
    <input type="hidden" name="tripId" value="${trip.id}" />
    <input type="hidden" name="tripName" value="${trip.name}" />

    <!-- Left column: Trip & Promotion inputs -->
    <div class="md:col-span-2 space-y-6">
      <!-- Promotion details card -->
      <div class="p-5 bg-white rounded-lg shadow-sm">
        <h3 class="text-lg font-semibold text-slate-800 mb-3">Promotion Details</h3>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <label class="block text-sm text-slate-600 mb-2">Minimum Passengers</label>
            <input type="number" name="passengers" min="1" max="${trip.capacity}" required
                   class="w-full p-3 rounded-lg border border-gray-200 focus:ring-2 focus:ring-blue-400 focus:outline-none" />
            <p class="hint mt-2">Set the min passengers to qualify.</p>
          </div>

          <div>
            <label class="block text-sm text-slate-600 mb-2">Minimum Hours</label>
            <input type="number" name="hours" min="1" required
                   class="w-full p-3 rounded-lg border border-gray-200 focus:ring-2 focus:ring-blue-400 focus:outline-none" />
            <p class="hint mt-2">Minimum booking duration (hours).</p>
          </div>

          <div>
            <label class="block text-sm text-slate-600 mb-2">Discount (%)</label>
            <div class="relative">
              <input type="number" name="discountPercentage" min="0" max="100" step="0.1" required
                     class="w-full p-3 rounded-lg border border-gray-200 focus:ring-2 focus:ring-blue-400 focus:outline-none" />
              <div class="absolute right-3 top-3 text-slate-500">%</div>
            </div>
            <p class="hint mt-2">Enter base percentage off (0-100). Total discount will include trip type discount.</p>
          </div>
        </div>

        <div class="mt-6 p-4 rounded-lg border border-dashed border-gray-100 drop-area" id="dropArea">
          <label class="block text-sm text-slate-600 mb-2">Promotion Image</label>
          <div class="flex items-center justify-between gap-4">
            <div class="flex items-center gap-4">
              <div id="previewContainer" class="preview-wrap">
                <c:choose>
                  <c:when test="${not empty trip.pictureUrl}">
                    <img id="thumbPreview" src="${trip.pictureUrl}" alt="preview" class="preview-thumb"/>
                  </c:when>
                  <c:otherwise>
                    <img id="thumbPreview" src="/uploads/default-promo.png" alt="preview" class="preview-thumb"/>
                  </c:otherwise>
                </c:choose>
                <div>
                  <div class="text-slate-700 font-semibold">Promotion image (recommended 1200×800)</div>
                  <div class="text-sm hint">Drag & drop or click to upload new image.</div>
                </div>
              </div>
            </div>

            <div class="flex flex-col items-end gap-3">
              <input id="promotionImage" name="promotionImage" type="file" accept="image/*" required class="hidden" />
              <button type="button" id="chooseBtn" class="px-4 py-2 rounded-lg border border-gray-200 bg-white hover:shadow-sm transition">
                <i class="fas fa-upload mr-2"></i> Choose File
              </button>

              <button type="button" id="removeBtn" class="px-4 py-2 rounded-lg bg-red-50 text-red-600 border border-red-100 hover:bg-red-100 transition">
                Remove
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Notes & Preview -->
      <div class="p-5 bg-white rounded-lg shadow-sm">
        <h3 class="text-lg font-semibold text-slate-800 mb-3">Preview & Notes</h3>
        <p class="text-slate-600 mb-4">This promotion will be displayed to visitors on promotional sections. Keep images crisp and discounts attractive but sustainable for your business.</p>

        <div class="flex flex-wrap gap-3">
          <div class="px-3 py-2 bg-blue-50 text-blue-700 rounded-full text-sm"><i class="fas fa-info-circle mr-2"></i> Image recommended 1200×800</div>
          <div class="px-3 py-2 bg-emerald-50 text-emerald-700 rounded-full text-sm"><i class="fas fa-check mr-2"></i> Visible on featured and promo pages</div>
        </div>
      </div>
    </div>

    <!-- Right column: Submit + Trip snapshot -->
    <aside class="space-y-6">
      <div class="p-5 bg-white rounded-lg shadow-sm text-center">
        <div class="text-sm text-slate-500">Trip Snapshot</div>
        <div class="text-xl font-bold text-slate-800 mt-2">${trip.name}</div>
        <div class="mt-3 text-slate-600">$${trip.price} / hour • Capacity ${trip.capacity}</div>
        <a href="/trips/view?tripId=${trip.id}" class="mt-4 inline-flex items-center gap-2 w-full justify-center bg-gradient-to-r from-blue-500 to-blue-400 text-white px-4 py-2 rounded-lg hover:from-blue-600 hover:to-blue-500 transition">
          <i class="fas fa-eye"></i> Preview Trip
        </a>
      </div>

      <div class="p-5 bg-white rounded-lg shadow-sm">
        <div class="space-y-3">
          <button type="submit" class="w-full inline-flex items-center justify-center gap-2 bg-gradient-to-r from-blue-500 to-blue-400 text-white px-4 py-3 rounded-lg font-semibold hover:from-blue-600 hover:to-blue-500 transition">
            <i class="fas fa-plus"></i> Add Promotion
          </button>

          <a href="/marketing" class="w-full inline-flex items-center justify-center gap-2 border border-gray-200 px-4 py-3 rounded-lg text-slate-700 hover:shadow-sm transition">
            <i class="fas fa-times text-red-500"></i> Cancel
          </a>
        </div>
      </div>

      <div class="p-4 text-sm text-slate-600 bg-white rounded-lg shadow-sm">
        <div class="font-medium">Quick tip</div>
        <div class="mt-2">Use moderate base discounts (10-30%) and leverage trip type discounts to maximize appeal.</div>
      </div>
    </aside>
  </form>
</section>

<!-- FOOTER -->
<footer class="bg-black text-white py-8 mt-auto">
  <div class="max-w-7xl mx-auto px-6 text-center">
    <p class="text-gray-400">© 2025 BlueWave Safaris — Add Promotion</p>
  </div>
</footer>

<!-- SCRIPTS -->
<script>
  // Mobile menu toggle (simple)
  const menuBtn = document.getElementById('menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');
  if (menuBtn) {
    menuBtn.addEventListener('click', () => {
      if (mobileMenu) mobileMenu.classList.toggle('hidden');
    });
  }

  // File chooser + preview
  const chooseBtn = document.getElementById('chooseBtn');
  const fileInput = document.getElementById('promotionImage');
  const thumb = document.getElementById('thumbPreview');
  const removeBtn = document.getElementById('removeBtn');
  const dropArea = document.getElementById('dropArea');

  if (chooseBtn && fileInput) {
    chooseBtn.addEventListener('click', () => fileInput.click());
  }

  fileInput.addEventListener('change', (e) => {
    const f = e.target.files[0];
    if (!f) return;
    const reader = new FileReader();
    reader.onload = function(evt) {
      thumb.src = evt.target.result;
    };
    reader.readAsDataURL(f);
  });

  // Remove preview
  removeBtn.addEventListener('click', () => {
    fileInput.value = '';
    // fallback to original trip picture or default
    thumb.src = "${not empty trip.pictureUrl ? trip.pictureUrl : '/uploads/default-promo.png'}";
  });

  // Drag & drop visual feedback
  ['dragenter','dragover'].forEach(evt =>
          dropArea.addEventListener(evt, (e) => { e.preventDefault(); dropArea.classList.add('hover'); })
  );
  ['dragleave','drop'].forEach(evt =>
          dropArea.addEventListener(evt, (e) => { e.preventDefault(); dropArea.classList.remove('hover'); })
  );
  // drop to select file
  dropArea.addEventListener('drop', (e) => {
    e.preventDefault();
    const files = e.dataTransfer.files;
    if (files && files.length) {
      fileInput.files = files;
      const changeEvent = new Event('change');
      fileInput.dispatchEvent(changeEvent);
    }
  });
</script>
</body>
</html>