<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Admin Trip Management</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

  <style>
    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .fade-in-up {
      animation: fadeInUp 0.6s ease-out forwards;
    }
    .underline-grow {
      position: relative;
      display: inline-block;
    }
    .underline-grow::after {
      content: "";
      position: absolute;
      bottom: -4px;
      left: 0;
      width: 0;
      height: 2px;
      background-color: #3b82f6;
      transition: width 0.3s ease;
    }
    .underline-grow:hover::after {
      width: 100%;
    }
  </style>
</head>
<body class="bg-gray-100 text-gray-800 min-h-screen flex flex-col">

<!-- Navbar -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg">
  <div class="max-w-7xl mx-auto px-6">
    <div class="flex items-center justify-between h-24">
      <div class="text-3xl font-extrabold tracking-wide whitespace-nowrap">
        <span class="text-blue-400">BlueWave</span> Safaris - Admin
      </div>
      <div class="hidden lg:flex items-center space-x-8 font-semibold text-lg">
        <a href="/admin/dashboard" class="underline-grow">Dashboard</a>
        <a href="/admin/trips" class="underline-grow text-blue-400">Manage Trips</a>
        <a href="/admin/users" class="underline-grow">Users</a>
        <a href="/admin/boats" class="underline-grow">Boats</a>
        <a href="/admin/bookings" class="underline-grow">Bookings</a>
        <a href="/admin/promotions" class="underline-grow">Promotions</a>
        <a href="/admin/profile" class="underline-grow">Profile</a>
        <a href="/logout" class="text-3xl hover:text-blue-400 transition"><i class="fas fa-sign-out-alt"></i></a>
      </div>
      <button id="menu-btn" class="lg:hidden text-white text-3xl focus:outline-none">
        <i class="fas fa-bars"></i>
      </button>
    </div>
  </div>
  <div id="mobile-menu" class="hidden lg:hidden bg-black px-6 py-4 space-y-4 text-lg">
    <a href="/admin/dashboard" class="block hover:text-blue-400">Dashboard</a>
    <a href="/admin/trips" class="block hover:text-blue-400">Manage Trips</a>
    <a href="/admin/users" class="block hover:text-blue-400">Users</a>
    <a href="/admin/boats" class="block hover:text-blue-400">Boats</a>
    <a href="/admin/bookings" class="block hover:text-blue-400">Bookings</a>
    <a href="/admin/promotions" class="block hover:text-blue-400">Promotions</a>
    <a href="/admin/profile" class="block hover:text-blue-400">Profile</a>
    <a href="/logout" class="block hover:text-blue-400"><i class="fas fa-sign-out-alt mr-2"></i>Logout</a>
  </div>
</nav>

<!-- ✅ Header -->
<header class="pt-28">
  <div class="max-w-7xl mx-auto px-6 text-center">
    <h1 class="text-4xl font-bold text-gray-800">Manage Trips</h1>
    <p class="mt-2 text-gray-600">View, edit, and manage all boat safari packages</p>
  </div>
</header>

<!-- ✅ Trip Management Section -->
<section class="max-w-7xl mx-auto px-6 py-12 flex-1">
  <c:if test="${not empty success}">
    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6 text-center shadow fade-in-up">
      <span>${success}</span>
      <c:if test="${not empty param.lastEditedId}">
        <a href="/admin/edit-trip?id=${param.lastEditedId}" class="ml-4 text-blue-600 hover:underline">Back to Edit</a>
      </c:if>
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6 text-center shadow fade-in-up">
      <span>${error}</span>
    </div>
  </c:if>

  <div class="grid gap-10 sm:grid-cols-2 lg:grid-cols-3">
    <c:forEach var="trip" items="${trips}">
      <!-- Trip Card -->
      <div class="bg-white/90 backdrop-blur-lg p-6 rounded-2xl shadow-lg hover:shadow-2xl transform hover:-translate-y-2 transition duration-300 fade-in-up flex flex-col justify-between">

        <div>
          <!-- Image -->
          <c:if test="${not empty trip.pictureUrl}">
            <img src="${trip.pictureUrl}" alt="${trip.name} Image"
                 class="w-full h-40 object-cover rounded-xl mb-4"/>
          </c:if>

          <!-- Trip Info -->
          <h3 class="text-2xl font-semibold text-gray-800 flex items-center space-x-2">
            <i class="fas fa-umbrella-beach text-blue-500"></i>
            <span>${trip.name}</span>
          </h3>
          <p class="text-gray-500 mt-1">${trip.description}</p>

          <div class="mt-4 grid grid-cols-2 gap-3 text-sm text-gray-600">
            <p><i class="fas fa-tags text-blue-400"></i> ${trip.type}</p>
            <p><i class="fas fa-clock text-blue-400"></i> ${trip.time}</p>
            <p><i class="fas fa-hourglass-half text-blue-400"></i> ${trip.duration} hrs</p>
            <p><i class="fas fa-users text-blue-400"></i> ${trip.capacity} people</p>
            <p><i class="fas fa-dollar-sign text-blue-400"></i> $${trip.price}/hr</p>
            <p><i class="fas fa-map-marker-alt text-blue-400"></i> ${trip.locationName}</p>
          </div>

          <!-- Google Maps Link -->
          <p class="mt-3 text-sm">
            <i class="fas fa-map text-blue-400"></i>
            <a href="${trip.googleMapsLink}" target="_blank" class="text-blue-600 hover:underline">View on Google Maps</a>
          </p>
        </div>

        <!-- Actions -->
        <div class="mt-6 flex justify-center gap-4">
          <a href="/admin/edit-trip?id=${trip.id}"
             class="flex items-center justify-center gap-2 bg-blue-500 hover:bg-blue-600 text-white px-5 py-2.5 rounded-lg text-sm font-semibold transition w-32 text-center">
            <i class="fas fa-edit"></i> Edit
          </a>
          <a href="/admin/delete-trip?id=${trip.id}"
             onclick="return confirm('Are you sure you want to delete this trip?')"
             class="flex items-center justify-center gap-2 bg-red-500 hover:bg-red-600 text-white px-5 py-2.5 rounded-lg text-sm font-semibold transition w-32 text-center">
            <i class="fas fa-trash"></i> Delete
          </a>
        </div>
      </div>
    </c:forEach>
  </div>
</section>

<!-- ✅ Footer -->
<footer class="bg-black text-white py-6 mt-auto">
  <div class="max-w-7xl mx-auto px-6 text-center">
    <p class="text-gray-400">© 2025 BlueWave Safaris — Admin Trip Management</p>
  </div>
</footer>

<script>
  // Mobile menu toggle
  document.getElementById("menu-btn").addEventListener("click", function () {
    const menu = document.getElementById("mobile-menu");
    menu.classList.toggle("hidden");
  });
</script>

</body>
</html>
