<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Marketing Coordinator Profile - BlueWave Safaris</title>
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

    function validatePasswordChange() {
      const newPassword = document.getElementById('newPassword').value;
      const confirmPassword = document.getElementById('confirmPassword').value;
      const passwordError = document.getElementById('passwordError');

      passwordError.style.display = 'none';

      if (newPassword !== confirmPassword) {
        passwordError.style.display = 'block';
        return false;
      }

      return true;
    }

    function validateDelete() {
      const confirmPassword = document.getElementById('deletePassword').value;
      const passwordError = document.getElementById('deletePasswordError');
      passwordError.style.display = confirmPassword === '' ? 'block' : 'none';
      return confirmPassword !== '';
    }

    function togglePasswordForm() {
      const passwordForm = document.getElementById('passwordForm');
      passwordForm.classList.toggle('hidden');
    }

    function toggleDeleteForm() {
      const deleteForm = document.getElementById('deleteForm');
      deleteForm.classList.toggle('hidden');
    }
  </script>
</head>

<body class="text-gray-800">

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

<!-- Profile Section -->
<main class="pt-28 pb-16 px-6">
  <div class="max-w-7xl mx-auto">
    <!-- Success/Error Messages -->
    <c:if test="${not empty success}">
      <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-6 fade-in-up">
          ${success}
      </div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-6 fade-in-up">
          ${error}
      </div>
    </c:if>

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

          <h3 class="text-2xl font-bold text-gray-800 mt-4">${marketingCoordinator.firstName} ${marketingCoordinator.lastName}</h3>
          <p class="text-gray-500 text-sm mt-1">${marketingCoordinator.email}</p>
          <span class="mt-2 px-3 py-1 bg-blue-100 text-blue-600 rounded-full text-xs font-medium shadow-sm uppercase tracking-wide">
            ${marketingCoordinator.role != null ? marketingCoordinator.role : "Marketing Coordinator"}
          </span>

          <hr class="my-6 w-2/3 border-gray-300">

          <div class="space-y-3 text-sm text-left w-full px-3">
            <p class="flex items-center">
              <i class="fas fa-id-card text-blue-500 mr-3"></i>
              <span><strong>NIC:</strong> ${marketingCoordinator.nic}</span>
            </p>
            <p class="flex items-center">
              <i class="fas fa-birthday-cake text-blue-500 mr-3"></i>
              <span><strong>Age:</strong> ${marketingCoordinator.age}</span>
            </p>
            <p class="flex items-center">
              <i class="fas fa-phone text-blue-500 mr-3"></i>
              <span><strong>Phone:</strong> ${marketingCoordinator.phone}</span>
            </p>
          </div>

          <div class="mt-8 flex flex-col space-y-3 w-full px-4">
            <button onclick="togglePasswordForm()"
                    class="w-full bg-gradient-to-r from-green-500 to-green-600 text-white px-4 py-2 rounded-lg font-semibold hover:from-green-600 hover:to-green-700 shadow-md hover:shadow-lg transition-all duration-300">
              <i class="fas fa-key mr-2"></i>Change Password
            </button>
            <a href="#edit"
               class="w-full inline-flex items-center justify-center bg-gradient-to-r from-blue-500 to-blue-600 text-white px-4 py-2 rounded-lg font-semibold hover:from-blue-600 hover:to-blue-700 shadow-md hover:shadow-lg transition-all duration-300">
              <i class="fas fa-user-edit mr-2"></i>Edit Profile
            </a>
          </div>
        </div>
      </div>

      <!-- Right Column: Edit Form and Password Change -->
      <div class="lg:col-span-2 space-y-8">
        <!-- Edit Profile Form -->
        <div id="edit" class="bg-white rounded-2xl shadow-xl p-8 card">
          <h3 class="text-2xl font-semibold text-gray-800 mb-6 flex items-center">
            <i class="fas fa-user-pen text-blue-500 mr-2"></i> Edit Profile Details
          </h3>

          <form action="/marketing-coordinator/profile/edit" method="post" onsubmit="return validateForm()" class="space-y-6">
            <input type="hidden" name="id" value="${marketingCoordinator.id}" />

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label for="firstName" class="block text-sm font-medium text-gray-600 mb-1">First Name</label>
                <input type="text" id="firstName" name="firstName" value="${marketingCoordinator.firstName}"
                       class="w-full p-3 border border-gray-200 rounded focus-ring" required />
              </div>
              <div>
                <label for="lastName" class="block text-sm font-medium text-gray-600 mb-1">Last Name</label>
                <input type="text" id="lastName" name="lastName" value="${marketingCoordinator.lastName}"
                       class="w-full p-3 border border-gray-200 rounded focus-ring" required />
              </div>
              <div>
                <label for="email" class="block text-sm font-medium text-gray-600 mb-1">Email</label>
                <input type="email" id="email" name="email" value="${marketingCoordinator.email}"
                       class="w-full p-3 border border-gray-200 rounded focus-ring" required pattern="[^\s@]+@[^\s@]+\.(com|org|net|edu|gov|in)" />
                <div id="emailError" class="error">Please enter a valid email (e.g., user@domain.com).</div>
              </div>
              <div>
                <label for="nic" class="block text-sm font-medium text-gray-600 mb-1">NIC</label>
                <input type="text" id="nic" name="nic" value="${marketingCoordinator.nic}"
                       class="w-full p-3 border border-gray-200 rounded focus-ring" required />
              </div>
              <div>
                <label for="age" class="block text-sm font-medium text-gray-600 mb-1">Age</label>
                <input type="number" id="age" name="age" value="${marketingCoordinator.age}"
                       class="w-full p-3 border border-gray-200 rounded focus-ring" required min="0" />
                <div id="ageError" class="error">Age cannot be negative.</div>
              </div>
              <div>
                <label for="phone" class="block text-sm font-medium text-gray-600 mb-1">Phone</label>
                <input type="text" id="phone" name="phone" value="${marketingCoordinator.phone}"
                       class="w-full p-3 border border-gray-200 rounded focus-ring" />
              </div>
            </div>

            <button type="submit" class="bg-blue-500 text-white px-6 py-3 rounded font-semibold hover:bg-blue-600 transition">
              Save Changes
            </button>
          </form>
        </div>

        <!-- Change Password Form -->
        <div id="passwordForm" class="bg-white rounded-2xl shadow-xl p-8 card hidden">
          <h3 class="text-2xl font-semibold text-gray-800 mb-6 flex items-center">
            <i class="fas fa-key text-green-500 mr-2"></i> Change Password
          </h3>

          <form action="/marketing-coordinator/profile/change-password" method="post" onsubmit="return validatePasswordChange()" class="space-y-6">
            <input type="hidden" name="id" value="${marketingCoordinator.id}" />

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label for="currentPassword" class="block text-sm font-medium text-gray-600 mb-1">Current Password</label>
                <input type="password" id="currentPassword" name="currentPassword"
                       class="w-full p-3 border border-gray-200 rounded focus-ring" required />
              </div>
              <div>
                <label for="newPassword" class="block text-sm font-medium text-gray-600 mb-1">New Password</label>
                <input type="password" id="newPassword" name="newPassword"
                       class="w-full p-3 border border-gray-200 rounded focus-ring" required />
              </div>
              <div>
                <label for="confirmPassword" class="block text-sm font-medium text-gray-600 mb-1">Confirm New Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword"
                       class="w-full p-3 border border-gray-200 rounded focus-ring" required />
                <div id="passwordError" class="error">New passwords do not match.</div>
              </div>
            </div>

            <div class="flex space-x-4">
              <button type="submit" class="bg-green-500 text-white px-6 py-3 rounded font-semibold hover:bg-green-600 transition">
                Update Password
              </button>
              <button type="button" onclick="togglePasswordForm()" class="bg-gray-500 text-white px-6 py-3 rounded font-semibold hover:bg-gray-600 transition">
                Cancel
              </button>
            </div>
          </form>
        </div>

        <!-- Delete Account Section -->
        <div class="bg-white rounded-2xl shadow-xl p-8 card border border-red-200">
          <h3 class="text-2xl font-semibold text-gray-800 mb-6 flex items-center">
            <i class="fas fa-exclamation-triangle text-red-500 mr-2"></i> Delete Account
          </h3>
          <p class="text-gray-600 mb-4">Once you delete your account, there is no going back. Please be certain.</p>

          <button onclick="toggleDeleteForm()" class="bg-red-500 text-white px-6 py-3 rounded font-semibold hover:bg-red-600 transition">
            Delete Profile
          </button>

          <form id="deleteForm" action="/marketing-coordinator/profile/delete" method="post" onsubmit="return validateDelete()" class="mt-6 space-y-4 hidden">
            <input type="hidden" name="id" value="${marketingCoordinator.id}" />
            <div>
              <label for="deletePassword" class="block text-sm font-medium text-gray-600 mb-1">Enter Password to Confirm Deletion</label>
              <input type="password" id="deletePassword" name="password"
                     class="w-full p-3 border border-gray-200 rounded focus-ring" required />
              <div id="deletePasswordError" class="error">Please enter your password to confirm deletion.</div>
            </div>
            <div class="flex space-x-4">
              <button type="submit" class="bg-red-500 text-white px-6 py-3 rounded font-semibold hover:bg-red-600 transition">
                Confirm Delete
              </button>
              <button type="button" onclick="toggleDeleteForm()" class="bg-gray-500 text-white px-6 py-3 rounded font-semibold hover:bg-gray-600 transition">
                Cancel
              </button>
            </div>
          </form>
        </div>
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

<script>
  // Mobile menu functionality
  const menuBtn = document.getElementById('menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');
  if (menuBtn && mobileMenu) {
    menuBtn.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));
  }
</script>

</body>
</html>