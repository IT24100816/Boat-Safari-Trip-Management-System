<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Available Bookings</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <style>
    /* Fade Animation */
    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(30px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .fade-in-up {
      animation: fadeInUp 0.8s ease-out forwards;
    }

    /* Bounce Animation for Buttons */
    @keyframes bounce {
      0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
      40% { transform: translateY(-10px); }
      60% { transform: translateY(-5px); }
    }
    .bounce-on-hover:hover {
      animation: bounce 0.8s ease-in-out;
    }

    /* Enhanced Card Hover Effect */
    .booking-card {
      background-color: #ffffff;
      border-radius: 0.5rem;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
      margin-bottom: 2rem; /* Clear margin between cards */
    }
    .booking-card:hover {
      transform: translateY(-6px);
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
    }

    /* Edit Form Styling */
    .edit-form {
      display: none;
      background-color: #f9f9f9;
      padding: 1rem;
      border-radius: 0.375rem;
      margin-top: 0.5rem;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      transition: opacity 0.3s ease;
    }
    .edit-form.active {
      display: block;
      opacity: 1;
    }

    /* Action Buttons */
    .action-buttons button {
      min-width: 3rem;
      padding: 0.25rem 0.5rem;
      transition: background-color 0.3s ease, transform 0.2s ease;
    }
    .action-buttons button:hover {
      transform: scale(1.05);
    }

    /* Read-Only Input */
    .read-only {
      background-color: #e0e0e0;
      cursor: not-allowed;
    }

    /* Custom Focus Ring */
    .input-field:focus {
      border-color: #4dd0e1;
      box-shadow: 0 0 5px rgba(77, 208, 225, 0.5);
      outline: none;
    }
  </style>
</head>
<body class="bg-white text-gray-800 min-h-screen flex flex-col font-sans">
<!-- Navbar with Icon -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg">
  <div class="max-w-7xl mx-auto px-6">
    <div class="flex items-center justify-between h-24">
      <div class="flex items-center space-x-4 flex-shrink-0">
        <i class="fas fa-anchor text-3xl text-blue-300"></i>
        <div class="text-3xl font-extrabold tracking-wide">
          <span class="text-blue-400">BlueWave</span> Safaris - Available Bookings
        </div>
      </div>
      <div class="hidden lg:flex items-center space-x-8 font-semibold text-lg">
        <a href="/booking-manager/dashboard" class="hover:text-blue-400 transition flex items-center">
          <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
        </a>
        <a href="/available-bookings" class="hover:text-blue-400 transition flex items-center">
          <i class="fas fa-calendar-check mr-2"></i> Available Bookings
        </a>
        <a href="/booking-manager/profile" class="hover:text-blue-400 transition flex items-center">
          <i class="fas fa-user mr-2"></i> Profile
        </a>
        <a href="/logout" class="text-3xl hover:text-blue-400 transition" aria-label="Logout">
          <i class="fas fa-sign-out-alt"></i>
        </a>
      </div>
      <div class="lg:hidden flex items-center">
        <button id="menu-btn" class="text-white text-3xl focus:outline-none" aria-label="Open menu">
          <i class="fas fa-bars"></i>
        </button>
      </div>
    </div>
  </div>
  <div id="mobile-menu" class="hidden lg:hidden bg-black px-6 py-4 space-y-4 text-lg">
    <a href="/booking-manager/dashboard" class="block hover:text-blue-400 transition flex items-center">
      <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
    </a>
    <a href="/available-bookings" class="block hover:text-blue-400 transition flex items-center">
      <i class="fas fa-calendar-check mr-2"></i> Available Bookings
    </a>
    <a href="/booking-manager/profile" class="block hover:text-blue-400 transition flex items-center">
      <i class="fas fa-user mr-2"></i> Profile
    </a>
    <a href="/logout" class="block hover:text-blue-400 transition flex items-center">
      <i class="fas fa-sign-out-alt mr-2"></i> Logout
    </a>
  </div>
</nav>

<!-- Header with Animation -->
<header class="pt-28">
  <div class="max-w-7xl mx-auto px-6 text-center">
    <h1 class="text-5xl font-bold text-gray-900 bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-blue-300 animate-pulse">
      Welcome, <c:out value="${sessionScope.username}"/>
    </h1>
    <p class="mt-4 text-xl text-gray-700">Manage Your Available Bookings</p>
  </div>
</header>

<!-- Success/Error Messages with Icons -->
<c:if test="${not empty successMessage}">
  <div class="max-w-7xl mx-auto px-6 mt-4">
    <div class="bg-green-100 border border-green-400 text-green-700 px-6 py-4 rounded-lg relative fade-in-up flex items-center">
      <i class="fas fa-check-circle text-2xl mr-3"></i>
      <strong class="font-bold">Success!</strong>
      <span class="ml-2">${successMessage}</span>
    </div>
  </div>
</c:if>
<c:if test="${not empty errorMessage}">
  <div class="max-w-7xl mx-auto px-6 mt-4">
    <div class="bg-red-100 border border-red-400 text-red-700 px-6 py-4 rounded-lg relative fade-in-up flex items-center">
      <i class="fas fa-exclamation-triangle text-2xl mr-3"></i>
      <strong class="font-bold">Error!</strong>
      <span class="ml-2">${errorMessage}</span>
    </div>
  </div>
</c:if>

<!-- Main Content with Card Design -->
<section class="max-w-7xl mx-auto px-6 py-12 flex-1">
  <div class="bg-white rounded-lg shadow-xl p-6 fade-in-up">
    <h2 class="text-3xl font-bold text-gray-800 mb-6 flex items-center">
      <i class="fas fa-book text-blue-500 mr-3 animate-spin-slow"></i> Available Bookings
    </h2>
    <c:choose>
      <c:when test="${not empty assignedBookings}">
        <div class="space-y-8"> <!-- Increased space-y for clearer margins -->
          <c:forEach var="assignment" items="${assignedBookings}" varStatus="loop">
            <div class="booking-card p-6">
              <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
                <div class="flex items-center"><i class="fas fa-key text-blue-500 mr-2"></i><strong class="text-gray-700">ID:</strong> <span class="text-gray-900">${assignment.id}</span></div>
                <div class="flex items-center"><i class="fas fa-clipboard-list text-blue-500 mr-2"></i><strong class="text-gray-700">Booking ID:</strong> <span class="text-gray-900">${assignment.booking != null ? assignment.booking.id : 'N/A'}</span></div>
                <div class="flex items-center"><i class="fas fa-user-tie text-blue-500 mr-2"></i><strong class="text-gray-700">Tourist Name:</strong> <span class="text-gray-900">${not empty assignment.touristName ? assignment.touristName : 'N/A'}</span></div>
                <div class="flex items-center"><i class="fas fa-id-card text-blue-500 mr-2"></i><strong class="text-gray-700">Tourist NIC:</strong> <span class="text-gray-900">${not empty assignment.touristNic ? assignment.touristNic : 'N/A'}</span></div>
                <div class="flex items-center"><i class="fas fa-users text-blue-500 mr-2"></i><strong class="text-gray-700">Passengers:</strong> <span class="text-gray-900">${not empty assignment.passengers ? assignment.passengers : 'N/A'}</span></div>
                <div class="flex items-center"><i class="fas fa-clock text-blue-500 mr-2"></i><strong class="text-gray-700">Hours:</strong> <span class="text-gray-900">${not empty assignment.hours ? assignment.hours : 'N/A'}</span></div>
                <div class="flex items-center"><i class="fas fa-dollar-sign text-blue-500 mr-2"></i><strong class="text-gray-700">Total Amount:</strong> <span class="text-gray-900"><fmt:formatNumber value="${not empty assignment.totalAmount ? assignment.totalAmount : 0}" type="currency" currencySymbol="$" /></span></div>
                <div class="flex items-center"><i class="fas fa-calendar-day text-blue-500 mr-2"></i><strong class="text-gray-700">Booking Date:</strong> <span class="text-gray-900">${not empty assignment.bookingDate ? assignment.bookingDate : 'N/A'}</span></div>
                <div class="flex items-center"><i class="fas fa-ship text-blue-500 mr-2"></i><strong class="text-gray-700">Boat Name:</strong> <span class="text-gray-900">${not empty assignment.boatName ? assignment.boatName : 'N/A'}</span></div>
                <div class="flex items-center"><i class="fas fa-user-captain text-blue-500 mr-2"></i><strong class="text-gray-700">Driver Name:</strong> <span class="text-gray-900">${not empty assignment.driverName ? assignment.driverName : 'N/A'}</span></div>
                <div class="flex items-center"><i class="fas fa-map-marker-alt text-blue-500 mr-2"></i><strong class="text-gray-700">Trip ID:</strong> <span class="text-gray-900">${not empty assignment.tripId ? assignment.tripId : 'N/A'}</span></div>
                <div class="flex items-center"><i class="fas fa-map-marked-alt text-blue-500 mr-2"></i><strong class="text-gray-700">Trip Name:</strong> <span class="text-gray-900">${not empty assignment.tripName ? assignment.tripName : 'N/A'}</span></div>
                <div class="flex items-center"><i class="fas fa-info-circle text-blue-500 mr-2"></i><strong class="text-gray-700">Status:</strong> <span class="text-gray-900">${not empty assignment.status ? assignment.status : 'N/A'}</span></div>
                <div class="flex items-center"><i class="fas fa-calendar-check text-blue-500 mr-2"></i><strong class="text-gray-700">Assigned Date:</strong> <span class="text-gray-900">${not empty assignment.assignedDate ? assignment.assignedDate : 'N/A'}</span></div>
              </div>
              <div class="action-buttons flex space-x-3 mt-4">
                <c:if test="${assignment.status == 'Assigned'}">
                  <button onclick="toggleEditForm(${assignment.id})" class="bg-blue-500 hover:bg-blue-600 text-white font-medium py-2 px-4 rounded-lg flex items-center space-x-2 bounce-on-hover">
                    <i class="fas fa-edit"></i><span>Edit</span>
                  </button>
                  <button onclick="confirmDelete(${assignment.id})" class="bg-red-500 hover:bg-red-600 text-white font-medium py-2 px-4 rounded-lg flex items-center space-x-2 bounce-on-hover">
                    <i class="fas fa-trash"></i><span>Delete</span>
                  </button>
                  <button onclick="confirmBooking(${assignment.id})" class="bg-green-500 hover:bg-green-600 text-white font-medium py-2 px-4 rounded-lg flex items-center space-x-2 bounce-on-hover">
                    <i class="fas fa-check"></i><span>Confirm</span>
                  </button>
                </c:if>
                <c:if test="${assignment.status == 'Completed'}">
                  <button onclick="confirmDelete(${assignment.id})" class="bg-red-500 hover:bg-red-600 text-white font-medium py-2 px-4 rounded-lg flex items-center space-x-2 bounce-on-hover">
                    <i class="fas fa-trash"></i><span>Delete</span>
                  </button>
                </c:if>
              </div>
              <div id="edit-form-${assignment.id}" class="edit-form mt-4">
                <form action="/booking-manager/update-booking" method="post" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                  <input type="hidden" name="id" value="${assignment.id}">
                  <input type="hidden" name="touristName" value="${assignment.touristName}">
                  <input type="hidden" name="tripId" value="${assignment.tripId}">
                  <input type="hidden" name="tripName" value="${assignment.tripName}">
                  <input type="hidden" name="status" value="${assignment.status}">
                  <div class="mb-4">
                    <label class="block text-gray-700 text-sm font-medium mb-2 flex items-center">
                      <i class="fas fa-id-card text-blue-500 mr-2"></i> Tourist NIC
                    </label>
                    <input type="text" name="touristNic" value="${assignment.touristNic}" class="w-full p-3 border border-gray-300 rounded-lg input-field focus:outline-none">
                  </div>
                  <div class="mb-4">
                    <label class="block text-gray-700 text-sm font-medium mb-2 flex items-center">
                      <i class="fas fa-users text-blue-500 mr-2"></i> Passengers
                    </label>
                    <input type="number" name="passengers" value="${assignment.passengers}" class="w-full p-3 border border-gray-300 rounded-lg input-field focus:outline-none">
                  </div>
                  <div class="mb-4">
                    <label class="block text-gray-700 text-sm font-medium mb-2 flex items-center">
                      <i class="fas fa-clock text-blue-500 mr-2"></i> Hours
                    </label>
                    <input type="number" step="0.5" name="hours" value="${assignment.hours}" class="w-full p-3 border border-gray-300 rounded-lg input-field focus:outline-none">
                  </div>
                  <div class="mb-4">
                    <label class="block text-gray-700 text-sm font-medium mb-2 flex items-center">
                      <i class="fas fa-dollar-sign text-blue-500 mr-2"></i> Total Amount
                    </label>
                    <input type="number" step="0.01" name="totalAmount" value="${assignment.totalAmount}" class="w-full p-3 border border-gray-300 rounded-lg input-field focus:outline-none">
                  </div>
                  <div class="mb-4">
                    <label class="block text-gray-700 text-sm font-medium mb-2 flex items-center">
                      <i class="fas fa-calendar-day text-blue-500 mr-2"></i> Booking Date
                    </label>
                    <input type="date" name="bookingDate" value="${assignment.bookingDate}" class="w-full p-3 border border-gray-300 rounded-lg input-field focus:outline-none">
                  </div>
                  <div class="mb-4">
                    <label class="block text-gray-700 text-sm font-medium mb-2 flex items-center">
                      <i class="fas fa-calendar-check text-blue-500 mr-2"></i> Assigned Date
                    </label>
                    <input type="date" name="assignedDate" value="${assignment.assignedDate}" class="w-full p-3 border border-gray-300 rounded-lg input-field focus:outline-none">
                  </div>
                  <div class="mb-4 col-span-full flex justify-end space-x-4">
                    <button type="submit" class="bg-green-500 hover:bg-green-600 text-white font-medium py-2 px-5 rounded-lg flex items-center space-x-2 bounce-on-hover">
                      <i class="fas fa-save"></i><span>Update</span>
                    </button>
                    <button type="button" onclick="toggleEditForm(${assignment.id})" class="bg-gray-500 hover:bg-gray-600 text-white font-medium py-2 px-5 rounded-lg flex items-center space-x-2 bounce-on-hover">
                      <i class="fas fa-times"></i><span>Cancel</span>
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </c:forEach>
        </div>
        <p class="mt-6 text-gray-600 text-sm">Total assignments: ${assignedBookings != null ? assignedBookings.size() : 0}</p>
      </c:when>
      <c:otherwise>
        <div class="text-center py-12 text-gray-500 fade-in-up">
          <i class="fas fa-inbox text-5xl mb-4 animate-pulse"></i>
          <p class="text-lg">No available bookings at the moment.</p>
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
  const menuBtn = document.getElementById('menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');
  if (menuBtn && mobileMenu) {
    menuBtn.addEventListener('click', () => {
      mobileMenu.classList.toggle('hidden');
      menuBtn.classList.toggle('text-blue-300');
    });
  }

  document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.fade-in-up').forEach((el, index) => {
      el.style.opacity = 0;
      el.style.animationDelay = `${index * 0.3}s`;
      setTimeout(() => el.classList.add('fade-in-up'), 200);
    });
  });

  function toggleEditForm(id) {
    const form = document.getElementById('edit-form-' + id);
    if (form) {
      form.classList.toggle('active');
    }
  }

  function confirmDelete(id) {
    if (confirm('Are you sure you want to delete this booking assignment?')) {
      const form = document.createElement('form');
      form.method = 'post';
      form.action = '/booking-manager/delete-booking';
      const csrfInput = document.createElement('input');
      csrfInput.type = 'hidden';
      csrfInput.name = '${_csrf.parameterName}';
      csrfInput.value = '${_csrf.token}';
      form.appendChild(csrfInput);
      const idInput = document.createElement('input');
      idInput.type = 'hidden';
      idInput.name = 'id';
      idInput.value = id;
      form.appendChild(idInput);
      document.body.appendChild(form);
      form.submit();
    }
  }

  function confirmBooking(id) {
    if (confirm('Are you sure you want to confirm this booking? This will mark it as completed and save it to confirmed bookings.')) {
      const form = document.createElement('form');
      form.method = 'post';
      form.action = '/booking-manager/confirm-booking';
      const csrfInput = document.createElement('input');
      csrfInput.type = 'hidden';
      csrfInput.name = '${_csrf.parameterName}';
      csrfInput.value = '${_csrf.token}';
      form.appendChild(csrfInput);
      const idInput = document.createElement('input');
      idInput.type = 'hidden';
      idInput.name = 'id';
      idInput.value = id;
      form.appendChild(idInput);
      document.body.appendChild(form);
      form.submit();
    }
  }
</script>
<style>
  /* Slow Spin Animation for Icon */
  @keyframes spin-slow {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
  }
  .animate-spin-slow {
    animation: spin-slow 4s linear infinite;
  }

  /* Pulse Animation for Empty State */
  @keyframes pulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.05); }
  }
  .animate-pulse {
    animation: pulse 2s infinite;
  }
</style>
</body>
</html>