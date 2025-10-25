<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Edit Trip</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <style>
    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .fade-in-up {
      animation: fadeInUp 0.6s ease-out forwards;
    }
  </style>
</head>
<body class="bg-gray-100 text-gray-800 min-h-screen flex flex-col">

<!-- Navbar -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg">
  <div class="max-w-7xl mx-auto px-6">
    <div class="flex items-center justify-between h-24">
      <div class="flex items-center space-x-3 flex-shrink-0">
        <div class="text-3xl font-extrabold tracking-wide">
          <span class="text-blue-400">BlueWave</span> Safaris - Admin
        </div>
      </div>
      <div class="hidden lg:flex items-center space-x-8 font-semibold text-lg">
        <a href="/admin/dashboard" class="underline-grow">Dashboard</a>
        <a href="/admin/trips" class="underline-grow">Manage Trips</a>
        <a href="/admin/users" class="underline-grow">Users</a>
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
    <a href="/admin/dashboard" class="block hover:text-blue-400 transition">Dashboard</a>
    <a href="/admin/trips" class="block hover:text-blue-400 transition">Manage Trips</a>
    <a href="/admin/users" class="block hover:text-blue-400 transition">Users</a>
    <a href="/logout" class="block hover:text-blue-400 transition"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
  </div>
</nav>

<!-- Header -->
<header class="pt-28">
  <div class="max-w-7xl mx-auto px-6 text-center">
    <h1 class="text-4xl font-bold text-gray-800">Edit Trip</h1>
    <p class="mt-2 text-gray-600">Update the details of ${trip.name}</p>
  </div>
</header>

<!-- Edit Trip Form -->
<section class="max-w-4xl mx-auto px-6 py-12 flex-1">
  <c:if test="${not empty error}">
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6 text-center shadow fade-in-up">
      <span>${error}</span>
    </div>
  </c:if>
  <c:if test="${not empty success}">
    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6 text-center shadow fade-in-up">
      <span>${success}</span>
    </div>
  </c:if>

  <div class="bg-white rounded-lg shadow-xl p-8 fade-in-up">
    <form action="/admin/update-trip" method="post" enctype="multipart/form-data">
      <input type="hidden" name="id" value="${trip.id}" />
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label for="name" class="block text-sm font-medium text-gray-700">Trip Name</label>
          <input id="name" name="name" type="text" value="${trip.name}" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" />
        </div>
        <div>
          <label for="type" class="block text-sm font-medium text-gray-700">Type</label>
          <select id="type" name="type" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500">
            <option value="Morning" ${trip.type == 'Morning' ? 'selected' : ''}>Morning</option>
            <option value="Evening" ${trip.type == 'Evening' ? 'selected' : ''}>Evening</option>
            <option value="Private" ${trip.type == 'Private' ? 'selected' : ''}>Private</option>
          </select>
        </div>
        <div>
          <label for="time" class="block text-sm font-medium text-gray-700">Time</label>
          <input id="time" name="time" type="time" value="${trip.time}" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" />
        </div>
        <div>
          <label for="duration" class="block text-sm font-medium text-gray-700">Duration (hours)</label>
          <input id="duration" name="duration" type="number" min="1" value="${trip.duration}" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" />
        </div>
        <div>
          <label for="price" class="block text-sm font-medium text-gray-700">Price ($/hour)</label>
          <input id="price" name="price" type="number" min="0" step="0.01" value="${trip.price}" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" />
        </div>
        <div>
          <label for="capacity" class="block text-sm font-medium text-gray-700">Capacity</label>
          <input id="capacity" name="capacity" type="number" min="1" value="${trip.capacity}" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" />
        </div>
      </div>
      <div class="mt-6">
        <label for="locationName" class="block text-sm font-medium text-gray-700">Location</label>
        <input id="locationName" name="locationName" type="text" value="${trip.locationName}" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" />
      </div>
      <div class="mt-6">
        <label for="googleMapsLink" class="block text-sm font-medium text-gray-700">Google Maps Link</label>
        <input id="googleMapsLink" name="googleMapsLink" type="url" value="${trip.googleMapsLink}" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" />
      </div>
      <div class="mt-6">
        <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
        <textarea id="description" name="description" rows="4" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500">${trip.description}</textarea>
      </div>
      <div class="mt-6">
        <label for="tripPicture" class="block text-sm font-medium text-gray-700">Trip Picture</label>
        <input id="tripPicture" name="tripPicture" type="file" accept="image/*" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" />
        <c:if test="${not empty trip.pictureUrl}">
          <img src="${trip.pictureUrl}" alt="${trip.name} Image" class="mt-2 w-32 h-32 object-cover rounded" />
        </c:if>
      </div>
      <div class="mt-6 text-center">
        <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white px-6 py-2 rounded-lg text-sm transition">
          <i class="fas fa-save mr-2"></i> Update Trip
        </button>
        <a href="/admin/trips" class="ml-4 bg-gray-500 hover:bg-gray-600 text-white px-6 py-2 rounded-lg text-sm transition">Cancel</a>
      </div>
    </form>
  </div>
</section>

<!-- Footer -->
<footer class="bg-black text-white py-6 mt-auto">
  <div class="max-w-7xl mx-auto px-6 text-center">
    <p class="text-gray-400">© 2025 BlueWave Safaris — Admin Trip Management</p>
  </div>
</footer>

<script>
  const menuBtn = document.getElementById('menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');
  if (menuBtn && mobileMenu) {
    menuBtn.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));
  }

  document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.fade-in-up').forEach((el, index) => {
      el.style.opacity = 0;
      el.style.animationDelay = `${index * 0.2}s`;
      setTimeout(() => el.classList.add('fade-in-up'), 100);
    });
  });
</script>
</body>
</html>