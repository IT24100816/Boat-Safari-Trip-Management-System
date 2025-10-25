<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Marketing Coordinator Dashboard</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

  <style>
    /* Smooth fade-in animation */
    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }

    .fade-up {
      animation: fadeInUp 0.8s ease-out;
    }
    .fade {
      animation: fadeIn 1s ease-in;
    }

    .card {
      background-color: #ffffff;
      border-radius: 0.5rem;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .card:hover {
      transform: translateY(-8px) scale(1.02);
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    }

    /* Floating hover effect for icons */
    .card i {
      transition: transform 0.3s ease;
    }
    .card:hover i {
      transform: rotate(10deg) scale(1.2);
    }
  </style>
</head>
<body class="bg-gray-100 text-gray-800 min-h-screen flex flex-col fade">

<!-- Navbar -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg fade">
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

<!-- Main Content -->
<section class="max-w-7xl mx-auto px-6 py-12 flex-1 mt-28 fade-up">
  <h1 class="text-4xl font-bold text-gray-800 mb-6">Marketing Coordinator Dashboard</h1>

  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <!-- Campaign Management Card -->
    <div class="card p-6 fade-up" style="animation-delay: 0.1s;">
      <h2 class="text-xl font-semibold text-gray-700 mb-4"><i class="fas fa-bullhorn text-blue-500 mr-2"></i>Campaign Management</h2>
      <p class="text-gray-600">Create and manage marketing campaigns to promote boat safaris.</p>
      <a href="/marketing-trips" class="mt-4 inline-block text-blue-500 hover:underline">Go to Campaigns</a>
    </div>

    <!-- Promotion Analytics Card -->
    <div class="card p-6 fade-up" style="animation-delay: 0.2s;">
      <h2 class="text-xl font-semibold text-gray-700 mb-4"><i class="fas fa-chart-line text-green-500 mr-2"></i>Promotion Analytics</h2>
      <p class="text-gray-600">View analytics and performance of current promotions.</p>
      <a href="/analytics" class="mt-4 inline-block text-blue-500 hover:underline">View Analytics</a>
    </div>

    <!-- Customer Feedback Card -->
    <div class="card p-6 fade-up" style="animation-delay: 0.3s;">
      <h2 class="text-xl font-semibold text-gray-700 mb-4"><i class="fas fa-comments text-purple-500 mr-2"></i>Customer Feedback</h2>
      <p class="text-gray-600">Review and respond to customer feedback.</p>
      <a href="/marketing-feedbacks" class="mt-4 inline-block text-blue-500 hover:underline">Check Feedback</a>
    </div>

    <!-- View Promotions Card -->
    <div class="card p-6 fade-up" style="animation-delay: 0.4s;">
      <h2 class="text-xl font-semibold text-gray-700 mb-4"><i class="fas fa-eye text-blue-500 mr-2"></i>View Promotions</h2>
      <p class="text-gray-600">Check and manage existing promotions.</p>
      <a href="/view-promotions" class="mt-4 inline-block text-blue-500 hover:underline">View Promotions</a>
    </div>

    <!-- Profile Management Card -->
    <div class="card p-6 fade-up" style="animation-delay: 0.5s;">
      <h2 class="text-xl font-semibold text-gray-700 mb-4"><i class="fas fa-user-cog text-indigo-500 mr-2"></i>Profile Management</h2>
      <p class="text-gray-600">Manage your personal information and account settings.</p>
      <a href="/marketing-coordinator/profile" class="mt-4 inline-block text-blue-500 hover:underline">Manage Profile</a>
    </div>
  </div>
</section>

<!-- Footer -->
<footer class="bg-black text-white py-8 fade">
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
  // Mobile menu functionality
  const menuBtn = document.getElementById('menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');
  if (menuBtn && mobileMenu) {
    menuBtn.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));
  }

  // Delay-based card animation
  document.querySelectorAll('.fade-up').forEach((el, index) => {
    el.style.animationDelay = `${index * 0.15}s`;
  });
</script>
</body>
</html>
