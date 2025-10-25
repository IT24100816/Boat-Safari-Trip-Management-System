<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Tourist Profile - BlueWave Safaris</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <style>
    body {
      background: linear-gradient(to bottom right, #ebf8ff, #ffffff);
      font-family: 'Poppins', sans-serif;
    }
    .card {
      transition: all 0.3s ease;
    }
    .card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
    }
    .focus-ring:focus {
      outline: 2px solid #3b82f6;
      outline-offset: 2px;
    }
    .error {
      color: #ef4444;
      font-size: 0.875rem;
      margin-top: 0.25rem;
      display: none;
    }
  </style>
  <script>
    function validateForm() {
      const email = document.getElementById('email').value;
      const age = document.getElementById('age').value;
      const emailError = document.getElementById('emailError');
      const ageError = document.getElementById('ageError');

      // Reset error messages
      emailError.style.display = 'none';
      ageError.style.display = 'none';

      // Email validation: Must contain @ and end with .com, .org, .net, etc.
      const emailRegex = /^[^\s@]+@[^\s@]+\.(com|org|net|edu|gov|in)$/i;
      if (!emailRegex.test(email)) {
        emailError.style.display = 'block';
        return false;
      }

      // Age validation: Must be non-negative
      if (age < 0) {
        ageError.style.display = 'block';
        return false;
      }

      return true;
    }

    function validateDelete() {
      const confirmPassword = document.getElementById('confirmPassword').value;
      const passwordError = document.getElementById('passwordError');
      passwordError.style.display = confirmPassword === '' ? 'block' : 'none';
      return confirmPassword !== '';
    }
  </script>
</head>

<body class="text-gray-800">

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

<!-- Profile Section -->
<main class="pt-28 pb-16 px-6">
  <div class="max-w-7xl mx-auto">
    <!-- Title -->
    <div class="text-center mb-10">
      <h2 class="text-3xl font-extrabold text-gray-800 mb-2">
        <i class="fas fa-user-circle text-blue-500 mr-2"></i> Your Profile
      </h2>
      <p class="text-gray-500">Manage your personal information and account settings.</p>
    </div>

    <!-- Grid Layout -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-10">

      <!-- Left Column: Profile Card -->
      <div class="relative bg-gradient-to-b from-blue-50 to-white rounded-2xl shadow-2xl overflow-hidden transform hover:scale-[1.02] transition-all duration-300 border border-gray-200">
        <div class="absolute top-0 left-0 w-full h-28 bg-gradient-to-r from-blue-500 to-blue-400"></div>

        <div class="relative flex flex-col items-center text-center pt-20 pb-8 px-6">
          <div class="relative">
            <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="Profile Photo"
                 class="w-28 h-28 rounded-full border-4 border-white shadow-lg hover:scale-105 transition-transform duration-300">
            <div class="absolute bottom-0 right-0 bg-green-500 w-5 h-5 rounded-full border-2 border-white"></div>
          </div>

          <h3 class="text-2xl font-bold text-gray-800 mt-4">${tourist.firstName} ${tourist.lastName}</h3>
          <p class="text-gray-500 text-sm mt-1">${tourist.email}</p>
          <span class="mt-2 px-3 py-1 bg-blue-100 text-blue-600 rounded-full text-xs font-medium shadow-sm uppercase tracking-wide">
            ${tourist.role != null ? tourist.role : "Tourist"}
          </span>

          <hr class="my-6 w-2/3 border-gray-300">

          <div class="space-y-3 text-sm text-left w-full px-3">
            <p class="flex items-center">
              <i class="fas fa-id-card text-blue-500 mr-3"></i>
              <span><strong>NIC:</strong> ${tourist.nic}</span>
            </p>
            <p class="flex items-center">
              <i class="fas fa-birthday-cake text-blue-500 mr-3"></i>
              <span><strong>Age:</strong> ${tourist.age}</span>
            </p>
            <p class="flex items-center">
              <i class="fas fa-phone text-blue-500 mr-3"></i>
              <span><strong>Phone:</strong> ${tourist.phone}</span>
            </p>
          </div>

          <div class="mt-8">
            <a href="#edit"
               class="inline-flex items-center bg-gradient-to-r from-blue-500 to-blue-600 text-white px-6 py-2 rounded-lg font-semibold hover:from-blue-600 hover:to-blue-700 shadow-md hover:shadow-lg transition-all duration-300">
              <i class="fas fa-user-edit mr-2"></i>Edit Profile
            </a>
          </div>
        </div>
      </div>

      <!-- Right Column: Edit Form -->
      <div id="edit" class="lg:col-span-2 bg-white rounded-2xl shadow-xl p-8 card">
        <h3 class="text-2xl font-semibold text-gray-800 mb-6 flex items-center">
          <i class="fas fa-user-pen text-blue-500 mr-2"></i> Edit Profile Details
        </h3>

        <form action="/tourist/profile/edit" method="post" onsubmit="return validateForm()" class="space-y-6">
          <input type="hidden" name="id" value="${tourist.id}" />

          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label for="firstName" class="block text-sm font-medium text-gray-600 mb-1">First Name</label>
              <input type="text" id="firstName" name="firstName" value="${tourist.firstName}"
                     class="w-full p-3 border border-gray-200 rounded focus-ring" required />
            </div>
            <div>
              <label for="lastName" class="block text-sm font-medium text-gray-600 mb-1">Last Name</label>
              <input type="text" id="lastName" name="lastName" value="${tourist.lastName}"
                     class="w-full p-3 border border-gray-200 rounded focus-ring" required />
            </div>
            <div>
              <label for="email" class="block text-sm font-medium text-gray-600 mb-1">Email</label>
              <input type="email" id="email" name="email" value="${tourist.email}"
                     class="w-full p-3 border border-gray-200 rounded focus-ring" required pattern="[^\s@]+@[^\s@]+\.(com|org|net|edu|gov|in)" />
              <div id="emailError" class="error">Please enter a valid email (e.g., user@domain.com).</div>
            </div>
            <div>
              <label for="password" class="block text-sm font-medium text-gray-600 mb-1">Password</label>
              <input type="password" id="password" name="password" value="${tourist.password}" readonly
                     class="w-full p-3 border border-gray-200 rounded focus-ring bg-gray-100 cursor-not-allowed" required />
            </div>
            <div>
              <label for="nic" class="block text-sm font-medium text-gray-600 mb-1">NIC</label>
              <input type="text" id="nic" name="nic" value="${tourist.nic}"
                     class="w-full p-3 border border-gray-200 rounded focus-ring" required />
            </div>
            <div>
              <label for="age" class="block text-sm font-medium text-gray-600 mb-1">Age</label>
              <input type="number" id="age" name="age" value="${tourist.age}"
                     class="w-full p-3 border border-gray-200 rounded focus-ring" required min="0" />
              <div id="ageError" class="error">Age cannot be negative.</div>
            </div>
            <div>
              <label for="phone" class="block text-sm font-medium text-gray-600 mb-1">Phone</label>
              <input type="text" id="phone" name="phone" value="${tourist.phone}"
                     class="w-full p-3 border border-gray-200 rounded focus-ring" />
            </div>
          </div>

          <button type="submit" class="bg-blue-500 text-white px-6 py-3 rounded font-semibold hover:bg-blue-600 transition">
            Save Changes
          </button>
        </form>

        <form action="/tourist/profile/delete" method="post" onsubmit="return validateDelete()" class="mt-6 space-y-4">
          <input type="hidden" name="id" value="${tourist.id}" />
          <div>
            <label for="confirmPassword" class="block text-sm font-medium text-gray-600 mb-1">Confirm Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword"
                   class="w-full p-3 border border-gray-200 rounded focus-ring" required />
            <div id="passwordError" class="error">Please enter your password to confirm deletion.</div>
          </div>
          <button type="submit" class="bg-red-500 text-white px-6 py-3 rounded font-semibold hover:bg-red-600 transition">
            Delete Profile
          </button>
        </form>
      </div>
    </div>
  </div>
</main>

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

</body>
</html>