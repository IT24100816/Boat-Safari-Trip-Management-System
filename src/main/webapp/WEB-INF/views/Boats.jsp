<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Boat Management</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <style>
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .fade-in { animation: fadeIn 0.6s ease-out forwards; }
    .boat-card { transition: all 0.3s ease; }
    .boat-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1); }
  </style>
</head>
<body class="bg-gray-100 text-gray-800 min-h-screen flex flex-col">
<!-- Navbar -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg">
  <div class="max-w-7xl mx-auto px-6">
    <div class="flex items-center justify-between h-24">
      <div class="flex items-center space-x-3 flex-shrink-0">
        <div class="text-3xl font-extrabold tracking-wide">
          <span class="text-blue-400">BlueWave</span> Safaris - Boat Driver
        </div>
      </div>
      <div class="hidden lg:flex items-center space-x-8 font-semibold text-lg">
        <a href="/boat-driver/dashboard" class="hover:text-blue-400 transition">Dashboard</a>
        <a href="/boat-driver/boats" class="hover:text-blue-400 transition">Boats</a>
        <a href="/boat-driver/profile" class="hover:text-blue-400 transition">Profile</a>
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
    <a href="/boat-driver/dashboard" class="block hover:text-blue-400 transition">Dashboard</a>
    <a href="/boat-driver/boats" class="block hover:text-blue-400 transition">Boats</a>
    <a href="/boat-driver/profile" class="block hover:text-blue-400 transition">Profile</a>
    <a href="/logout" class="block hover:text-blue-400 transition"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
  </div>
</nav>

<!-- Header -->
<header class="pt-28">
  <div class="max-w-7xl mx-auto px-6 text-center">
    <h1 class="text-4xl font-bold text-gray-800">Boat Management</h1>
    <p class="mt-2 text-gray-600">Manage your fleet of boats</p>
  </div>
</header>

<!-- Main Content -->
<section class="max-w-7xl mx-auto px-6 py-12 flex-1">
  <!-- Success/Error Messages -->
  <c:if test="${not empty success}">
    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-6 fade-in">
        ${success}
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-6 fade-in">
        ${error}
    </div>
  </c:if>

  <!-- Add Boat Form -->
  <div class="bg-white rounded-lg shadow-xl p-6 mb-8 fade-in">
    <h2 class="text-2xl font-bold text-gray-800 mb-6"><i class="fas fa-plus-circle text-blue-500 mr-2"></i> Add New Boat</h2>
    <form action="/boat-driver/boats/add" method="post" enctype="multipart/form-data" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Boat Name</label>
        <input type="text" name="boatName" required class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500">
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Boat Type</label>
        <select name="boatType" required class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500">
          <option value="">Select Type</option>
          <option value="Speed Boat">Speed Boat</option>
          <option value="Fishing Boat">Fishing Boat</option>
          <option value="Safari Boat">Safari Boat</option>
          <option value="Yacht">Yacht</option>
          <option value="Catamaran">Catamaran</option>
        </select>
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Capacity</label>
        <input type="number" name="capacity" min="1" required class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500">
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Registration Number</label>
        <input type="text" name="registrationNumber" required class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500">
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
        <select name="status" required class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500">
          <option value="Available">Available</option>
          <option value="Maintenance">Maintenance</option>
          <option value="In Use">In Use</option>
        </select>
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Boat Image</label>
        <input type="file" name="boatImage" accept="image/*" required class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500">
      </div>
      <div class="flex items-end">
        <button type="submit" class="w-full bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded-md font-medium transition">
          <i class="fas fa-save mr-2"></i> Add Boat
        </button>
      </div>
    </form>
  </div>

  <!-- Boats List -->
  <div class="bg-white rounded-lg shadow-xl p-6 fade-in">
    <h2 class="text-2xl font-bold text-gray-800 mb-6 flex items-center">
      <i class="fas fa-ship text-blue-500 mr-2"></i> All Boats
      <span class="ml-2 bg-blue-100 text-blue-800 text-sm font-medium px-2.5 py-0.5 rounded">
        ${boats.size()}
      </span>
    </h2>

    <c:choose>
      <c:when test="${not empty boats}">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <c:forEach var="boat" items="${boats}">
            <div class="boat-card bg-gray-50 p-4 rounded-lg border border-gray-200">
              <c:if test="${not empty boat.imageUrl}">
                <img src="${boat.imageUrl}" alt="${boat.boatName} Image" class="w-full h-48 object-cover rounded-t-lg mb-3">
              </c:if>
              <div class="flex justify-between items-start mb-3">
                <h3 class="font-semibold text-lg">${boat.boatName}</h3>
                <span class="text-xs font-medium px-2.5 py-0.5 rounded
                                    ${boat.status == 'Available' ? 'bg-green-100 text-green-800' :
                                      boat.status == 'Maintenance' ? 'bg-yellow-100 text-yellow-800' :
                                      'bg-red-100 text-red-800'}">
                    ${boat.status}
                </span>
              </div>

              <div class="space-y-2 text-sm text-gray-600 mb-4">
                <div><i class="fas fa-tag mr-2"></i> ${boat.boatType}</div>
                <div><i class="fas fa-users mr-2"></i> Capacity: ${boat.capacity} people</div>
                <div><i class="fas fa-id-card mr-2"></i> Reg: ${boat.registrationNumber}</div>
                <c:if test="${not empty boat.driverName}">
                  <div><i class="fas fa-user mr-2"></i> Driver: ${boat.driverName}</div>
                </c:if>
              </div>

              <!-- Edit Form (Initially Hidden) -->
              <div id="edit-form-${boat.id}" class="hidden mt-4 space-y-3">
                <form action="/boat-driver/boats/update" method="post" enctype="multipart/form-data">
                  <input type="hidden" name="boatId" value="${boat.id}">
                  <input type="text" name="boatName" value="${boat.boatName}" required
                         class="w-full px-2 py-1 border border-gray-300 rounded text-sm mb-2">
                  <select name="boatType" required class="w-full px-2 py-1 border border-gray-300 rounded text-sm mb-2">
                    <option value="Speed Boat" ${boat.boatType == 'Speed Boat' ? 'selected' : ''}>Speed Boat</option>
                    <option value="Fishing Boat" ${boat.boatType == 'Fishing Boat' ? 'selected' : ''}>Fishing Boat</option>
                    <option value="Safari Boat" ${boat.boatType == 'Safari Boat' ? 'selected' : ''}>Safari Boat</option>
                    <option value="Yacht" ${boat.boatType == 'Yacht' ? 'selected' : ''}>Yacht</option>
                    <option value="Catamaran" ${boat.boatType == 'Catamaran' ? 'selected' : ''}>Catamaran</option>
                  </select>
                  <input type="number" name="capacity" value="${boat.capacity}" min="1" required
                         class="w-full px-2 py-1 border border-gray-300 rounded text-sm mb-2">
                  <input type="text" name="registrationNumber" value="${boat.registrationNumber}" required
                         class="w-full px-2 py-1 border border-gray-300 rounded text-sm mb-2">
                  <select name="status" required class="w-full px-2 py-1 border border-gray-300 rounded text-sm mb-2">
                    <option value="Available" ${boat.status == 'Available' ? 'selected' : ''}>Available</option>
                    <option value="Maintenance" ${boat.status == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                    <option value="In Use" ${boat.status == 'In Use' ? 'selected' : ''}>In Use</option>
                  </select>
                  <input type="file" name="boatImage" accept="image/*" class="w-full px-2 py-1 border border-gray-300 rounded text-sm mb-2">
                  <div class="flex space-x-2">
                    <button type="submit" class="flex-1 bg-green-500 hover:bg-green-600 text-white py-1 px-2 rounded text-sm"
                      ${boat.driverId != boatDriver.id ? 'disabled' : ''}>
                      Save
                    </button>
                    <button type="button" onclick="hideEditForm(${boat.id})"
                            class="flex-1 bg-gray-500 hover:bg-gray-600 text-white py-1 px-2 rounded text-sm">
                      Cancel
                    </button>
                  </div>
                </form>
              </div>

              <!-- Action Buttons -->
              <div class="flex space-x-2">
                <button onclick="showEditForm(${boat.id})"
                        class="flex-1 bg-blue-500 hover:bg-green-600 text-white py-2 px-3 rounded text-sm font-medium"
                  ${boat.driverId != boatDriver.id ? 'disabled' : ''}>
                  <i class="fas fa-edit mr-1"></i> Edit
                </button>
                <form action="/boat-driver/boats/delete" method="post" class="flex-1">
                  <input type="hidden" name="boatId" value="${boat.id}">
                  <button type="submit"
                          class="w-full bg-red-500 hover:bg-red-600 text-white py-2 px-3 rounded text-sm font-medium"
                          onclick="return confirm('Are you sure you want to delete this boat?')"
                    ${boat.driverId != boatDriver.id ? 'disabled' : ''}>
                    <i class="fas fa-trash mr-1"></i> Delete
                  </button>
                </form>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <div class="text-center py-12 text-gray-500">
          <i class="fas fa-ship text-4xl mb-3"></i>
          <p>No boats found. Add your first boat to get started!</p>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</section>

<!-- Footer -->
<footer class="bg-black text-white py-8">
  <div class="max-w-7xl mx-auto px-6 grid md:grid-cols-3 gap-8 text-center md:text-left">
    <div>
      <h3 class="text-lg font-semibold mb-2">About BlueWave Safaris</h3>
      <p class="text-gray-400 text-sm">We provide the most exciting boat safari adventures to explore marine beauty and wildlife in style.</p>
    </div>

    <div>
      <h3 class="text-lg font-semibold mb-2">Contact & Location</h3>
      <p class="text-gray-400 text-sm"><i class="fas fa-map-marker-alt text-blue-400"></i> Colombo, Sri Lanka</p>
      <p class="text-gray-400 text-sm"><i class="fas fa-phone text-blue-400"></i> +94 77 123 4567</p>
      <p class="text-gray-400 text-sm"><i class="fas fa-envelope text-blue-400"></i> info@bluewavesafaris.com</p>
    </div>

    <div>
      <h3 class="text-lg font-semibold mb-2">Follow Us</h3>
      <div class="flex justify-center md:justify-start space-x-4">
        <a href="#" class="hover:text-blue-400"><i class="fab fa-facebook-f"></i></a>
        <a href="#" class="hover:text-blue-400"><i class="fab fa-instagram"></i></a>
        <a href="#" class="hover:text-blue-400"><i class="fab fa-twitter"></i></a>
        <a href="#" class="hover:text-blue-400"><i class="fab fa-youtube"></i></a>
      </div>
    </div>
  </div>

  <div class="mt-6 text-center text-gray-500 text-sm">
    © 2025 BlueWave Safaris — All Rights Reserved
  </div>
</footer>

<script>
  // Mobile menu toggle
  const menuBtn = document.getElementById('menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');
  if (menuBtn && mobileMenu) {
    menuBtn.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));
  }

  // Edit form functions
  function showEditForm(boatId) {
    document.getElementById('edit-form-' + boatId).classList.remove('hidden');
  }

  function hideEditForm(boatId) {
    document.getElementById('edit-form-' + boatId).classList.add('hidden');
  }

  // Apply animations
  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.fade-in').forEach((el, index) => {
      el.style.opacity = 0;
      el.style.animationDelay = `${index * 0.2}s`;
      setTimeout(() => el.classList.add('fade-in'), 100);
    });
  });
</script>
</body>
</html>