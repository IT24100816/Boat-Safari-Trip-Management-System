<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Change Password</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <style>
    body {
      background: linear-gradient(135deg, #e0f2fe 0%, #ffffff 100%);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }
    .error {
      color: #ef4444;
      font-size: 0.875rem;
      margin-top: 0.25rem;
      display: none;
    }
    .focus-ring:focus {
      outline: 2px solid #3b82f6;
      outline-offset: 2px;
    }
    .fade-in {
      animation: fadeIn 1s ease-in-out;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
  <script>
    function validateForm() {
      const newPassword = document.getElementById('newPassword').value;
      const confirmPassword = document.getElementById('confirmPassword').value;
      const passwordMismatchError = document.getElementById('passwordMismatchError');

      passwordMismatchError.style.display = 'none';
      if (newPassword !== confirmPassword) {
        passwordMismatchError.style.display = 'block';
        return false;
      }
      return true;
    }
  </script>
</head>
<body>

<!-- Navbar -->
<nav class="bg-black text-white fixed top-0 w-full z-50 shadow-lg">
  <div class="max-w-7xl mx-auto px-6">
    <div class="flex items-center justify-between h-20">
      <!-- Logo -->
      <div class="flex items-center space-x-3 flex-shrink-0">
        <i class="fas fa-ship text-3xl text-blue-400"></i>
        <a href="/" class="text-2xl font-extrabold tracking-wide whitespace-nowrap">
          <span class="text-blue-400">BlueWave</span> Safaris
        </a>
      </div>

      <!-- Right side -->
      <div class="flex items-center space-x-6">
        <c:if test="${not empty user}">
          <span class="text-white font-medium">👋 Welcome,
            <span class="text-blue-400">${user.firstName} ${user.lastName}</span>
          </span>
        </c:if>
        <a href="/logout" class="text-xl hover:text-blue-400 transition" aria-label="Logout">
          <i class="fas fa-sign-out-alt"></i>
        </a>
      </div>
    </div>
  </div>
</nav>

<!-- Main Section -->
<main class="flex-1 flex items-center justify-center mt-28 mb-20 px-4 fade-in">
  <div class="bg-white/80 backdrop-blur-md p-10 rounded-2xl shadow-2xl w-full max-w-lg border border-gray-200">
    <div class="text-center mb-8">
      <i class="fa-solid fa-lock text-4xl text-blue-500 mb-3"></i>
      <h2 class="text-3xl font-extrabold text-gray-800">Change Password</h2>
      <p class="text-gray-500 text-sm mt-1">Keep your account safe by updating your password regularly.</p>
    </div>

    <!-- Alerts -->
    <c:if test="${not empty error}">
      <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4" role="alert">
        <span class="block sm:inline">${error}</span>
      </div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4" role="alert">
        <span class="block sm:inline">${success}</span>
      </div>
    </c:if>

    <!-- Form -->
    <form action="/tourist/change-password" method="post" onsubmit="return validateForm()" class="space-y-6">
      <div>
        <label for="email" class="block text-sm font-medium text-gray-600">Email</label>
        <input type="email" id="email" name="email" value="${tourist.email}"
               class="w-full p-3 border border-gray-300 rounded-lg focus-ring bg-gray-50" required />
      </div>
      <div>
        <label for="nic" class="block text-sm font-medium text-gray-600">NIC</label>
        <input type="text" id="nic" name="nic" value="${tourist.nic}"
               class="w-full p-3 border border-gray-300 rounded-lg focus-ring bg-gray-50" required />
      </div>
      <div>
        <label for="currentPassword" class="block text-sm font-medium text-gray-600">Current Password</label>
        <input type="password" id="currentPassword" name="currentPassword"
               class="w-full p-3 border border-gray-300 rounded-lg focus-ring bg-gray-50" required />
      </div>
      <div>
        <label for="newPassword" class="block text-sm font-medium text-gray-600">New Password</label>
        <input type="password" id="newPassword" name="newPassword"
               class="w-full p-3 border border-gray-300 rounded-lg focus-ring bg-gray-50" required />
      </div>
      <div>
        <label for="confirmPassword" class="block text-sm font-medium text-gray-600">Confirm New Password</label>
        <input type="password" id="confirmPassword" name="confirmPassword"
               class="w-full p-3 border border-gray-300 rounded-lg focus-ring bg-gray-50" required />
        <div id="passwordMismatchError" class="error">New passwords do not match.</div>
      </div>

      <button type="submit"
              class="w-full bg-gradient-to-r from-blue-500 to-blue-600 text-white px-4 py-3 rounded-lg font-semibold hover:from-blue-600 hover:to-blue-700 shadow-md hover:shadow-lg transition duration-300">
        <i class="fa-solid fa-key mr-2"></i> Change Password
      </button>
    </form>

    <div class="mt-6 text-center">
      <a href="/" class="text-blue-500 hover:underline font-medium">
        <i class="fa-solid fa-arrow-left mr-1"></i> Back to Home
      </a>
    </div>
  </div>
</main>

<!-- Footer -->
<footer class="bg-black text-white py-8 mt-auto">
  <div class="max-w-7xl mx-auto px-6 grid md:grid-cols-3 gap-8 text-center md:text-left">
    <!-- About -->
    <div>
      <h3 class="text-lg font-semibold mb-2">About BlueWave Safaris</h3>
      <p class="text-gray-400 text-sm">We provide the most exciting boat safari adventures to explore marine beauty and wildlife in style.</p>
    </div>

    <!-- Contact -->
    <div>
      <h3 class="text-lg font-semibold mb-2">Contact & Location</h3>
      <p class="text-gray-400 text-sm"><i class="fas fa-map-marker-alt text-blue-400"></i> Colombo, Sri Lanka</p>
      <p class="text-gray-400 text-sm"><i class="fas fa-phone text-blue-400"></i> +94 77 123 4567</p>
      <p class="text-gray-400 text-sm"><i class="fas fa-envelope text-blue-400"></i> info@bluewavesafaris.com</p>
    </div>

    <!-- Social -->
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

</body>
</html>
