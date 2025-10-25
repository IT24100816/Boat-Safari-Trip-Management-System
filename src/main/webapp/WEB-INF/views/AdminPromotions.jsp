<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Admin Promotions</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <style>

    .underline-grow {
      position: relative;
      display: inline-block;
    }
    .underline-grow::after {
      content: "";
      position: absolute;
      width: 0;
      height: 2px;
      display: block;
      margin-top: 4px;
      right: 0;
      background: #3b82f6;
      transition: width 0.3s ease;
    }
    .underline-grow:hover::after {
      width: 100%;
      left: 0;
      background: #3b82f6;
    }

    .promotion-card {
      background: #ffffff;
      border-radius: 10px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      transition: transform 0.3s ease, box-shadow 0.3s ease, opacity 0.5s ease;
      opacity: 0;
      animation: fadeInUp 0.6s forwards;
    }

    .promotion-card:hover {
      transform: translateY(-5px) scale(1.02);
      box-shadow: 0 10px 20px rgba(0,0,0,0.15);
    }

    .remove-btn {
      transition: background-color 0.2s ease, transform 0.2s ease;
    }

    .remove-btn:hover {
      background-color: #dc2626;
      transform: scale(1.05);
    }

    @keyframes fadeInUp {
      0% {
        opacity: 0;
        transform: translateY(20px);
      }
      100% {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .detail-icon {
      color: #3b82f6; /* Blue icons */
      margin-right: 6px;
    }
  </style>
</head>
<body class="bg-gray-50 min-h-screen flex flex-col">

<!-- Navbar -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg">
  <div class="max-w-7xl mx-auto px-6">
    <div class="flex items-center justify-between h-24">
      <div class="text-3xl font-extrabold tracking-wide whitespace-nowrap">
        <span class="text-blue-400">BlueWave</span> Safaris - Admin
      </div>
      <div class="hidden lg:flex items-center space-x-8 font-semibold text-lg">
        <a href="/admin/dashboard" class="underline-grow">Dashboard</a>
        <a href="/admin/trips" class="underline-grow">Manage Trips</a>
        <a href="/admin/users" class="underline-grow">Users</a>
        <a href="/admin/boats" class="underline-grow">Boats</a>
        <a href="/admin/bookings" class="underline-grow">Bookings</a>
        <a href="/admin/promotions" class="underline-grow text-blue-400">Promotions</a>
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

<main class="pt-28 pb-12">
  <div class="max-w-7xl mx-auto px-6">
    <h1 class="text-3xl font-bold mb-6 text-gray-800">Manage Promotions</h1>

    <c:if test="${not empty errorMessage}">
      <div class="bg-red-500 bg-opacity-80 border border-red-700 text-white p-4 rounded-lg mb-6 text-center">
        <i class="fas fa-exclamation-triangle mr-2"></i>${errorMessage}
      </div>
    </c:if>

    <c:if test="${not empty successMessage}">
      <div class="bg-green-500 bg-opacity-80 border border-green-700 text-white p-4 rounded-lg mb-6 text-center">
        <i class="fas fa-check-circle mr-2"></i>${successMessage}
      </div>
    </c:if>

    <c:if test="${not empty promotions}">
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <c:forEach var="promotion" items="${promotions}">
          <div class="promotion-card p-4">
            <img src="${promotion.imageUrl}" alt="${promotion.tripName}" class="w-full h-48 object-cover rounded-lg mb-4">
            <h3 class="text-xl font-semibold text-gray-800 flex items-center gap-2">
              <i class="fas fa-route detail-icon"></i>${promotion.tripName}
            </h3>
            <p class="text-gray-600"><i class="fas fa-hashtag detail-icon"></i>Trip ID: ${promotion.tripId}</p>
            <p class="text-gray-600"><i class="fas fa-users detail-icon"></i>Passengers: ${promotion.passengers}</p>
            <p class="text-gray-600"><i class="fas fa-clock detail-icon"></i>Hours: ${promotion.hours}</p>
            <p class="text-gray-600"><i class="fas fa-percent detail-icon"></i>Discount: ${promotion.discountPercentage}%</p>
            <p class="text-gray-600"><i class="fas fa-calendar-alt detail-icon"></i>Created At: ${promotion.createdAt}</p>
            <form action="/admin/promotions/remove/${promotion.id}" method="post" style="display:inline;">
              <button type="submit" class="remove-btn bg-red-500 text-white px-4 py-2 rounded-lg mt-4 w-full flex items-center justify-center gap-2">
                <i class="fas fa-trash-alt"></i> Remove
              </button>
            </form>
          </div>
        </c:forEach>
      </div>
    </c:if>

    <c:if test="${empty promotions}">
      <p class="text-gray-800 text-center">No promotions available.</p>
    </c:if>
  </div>
</main>

<!-- Footer -->
<footer class="bg-black text-white pt-12 mt-auto">
  <div class="max-w-7xl mx-auto px-6 text-center">
    <p class="text-gray-300 mb-4">© 2025 BlueWave Safaris — Admin Dashboard</p>
  </div>
</footer>

<script>
  const menuBtn = document.getElementById('menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');
  if (menuBtn) {
    menuBtn.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));
  }

  // Animate cards on scroll (fade in)
  const cards = document.querySelectorAll('.promotion-card');
  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if(entry.isIntersecting) {
        entry.target.style.opacity = 1;
      }
    });
  }, { threshold: 0.2 });

  cards.forEach(card => observer.observe(card));
</script>
</body>
</html>
