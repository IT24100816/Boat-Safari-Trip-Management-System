<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.boatsafari.model.User" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Update Booking</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <style>
    .error { color: red; font-size: 0.875rem; }
    .success-message {
      display: none;
      color: #10B981;
      font-size: 1.25rem;
      font-weight: 600;
      text-align: center;
      padding: 1rem;
      border-radius: 0.5rem;
      background-color: #D1FAE5;
      margin-bottom: 1rem;
    }
  </style>
</head>
<body class="bg-gray-100 text-gray-800 min-h-screen flex flex-col">

<!-- Navbar -->
<nav class="bg-black text-white fixed top-0 w-full z-50 shadow-lg">
  <div class="max-w-7xl mx-auto px-6">
    <div class="flex items-center justify-between h-20">
      <div class="flex items-center space-x-3 flex-shrink-0">
        <i class="fas fa-ship text-3xl text-blue-400"></i>
        <a href="/booking-history" class="text-2xl font-extrabold tracking-wide whitespace-nowrap">
          <span class="text-blue-400">BlueWave</span> Safaris
        </a>
      </div>
      <div class="flex items-center space-x-6">
        <c:if test="${not empty user}">
          <span class="text-white font-medium">👋 Welcome, <span class="text-blue-400">${user.firstName} ${user.lastName}</span></span>
        </c:if>
        <a href="/logout" class="text-xl hover:text-blue-400 transition" aria-label="Logout">
          <i class="fas fa-sign-out-alt"></i>
        </a>
      </div>
    </div>
  </div>
</nav>

<!-- Booking Section -->
<section class="max-w-5xl mx-auto px-6 py-16 flex-grow mt-24">
  <div class="text-center mb-12">
    <h1 class="text-5xl font-extrabold text-gray-800 mb-4">📝 Update Your Booking</h1>
    <p class="text-lg text-gray-600">Modify your booking details with <span class="text-blue-500 font-semibold">BlueWave Safaris</span>.</p>
  </div>

  <c:if test="${not empty error}">
    <p class="error mb-4">${error}</p>
  </c:if>
  <c:if test="${not empty success}">
    <div id="successMessage" class="success-message" style="display: block;">
        ${success}
    </div>
  </c:if>

  <c:if test="${not empty booking}">
    <form action="/update-booking" method="post" enctype="multipart/form-data" class="bg-white p-8 rounded-2xl shadow-xl space-y-8 transition hover:shadow-2xl">
      <!-- Hidden Fields -->
      <input type="hidden" name="bookingId" value="${booking.id}" />
      <input type="hidden" name="username" value="${booking.username}" />
      <input type="hidden" name="bookingStatus" value="${booking.bookingStatus}" />
      <%
        User user = (User) session.getAttribute("user");
        if (user instanceof com.boatsafari.model.Tourist) {
          com.boatsafari.model.Tourist tourist = (com.boatsafari.model.Tourist) user;
      %>
      <input type="hidden" name="nic" value="<%= tourist.getNic() %>" />
      <%
        }
      %>

      <!-- Section: Booking Info -->
      <h2 class="text-2xl font-bold text-gray-800 border-b pb-2 mb-4"><i class="fas fa-calendar-alt text-blue-400"></i> Booking Details</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label class="block text-sm font-medium text-gray-700">Booking Date</label>
          <input type="date" name="bookingDate" id="bookingDate" required
                 class="mt-1 w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-400"
                 value="${booking.bookingDate != null ? booking.bookingDate.toString() : ''}" />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700">Trip Name</label>
          <select name="tripName" id="tripName" required
                  class="mt-1 w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-400"
                  onchange="calculateTotal()">
            <c:forEach var="trip" items="${trips}">
              <c:set var="promo" value="${tripPromotions[trip.id]}"/>
              <option value="${trip.name}" data-price-per-hour="${trip.price}" data-promotion-percentage="${promo.percentage}" data-min-passengers="${promo.passengers}" data-min-hours="${promo.hours}" ${trip.name == booking.tripName ? 'selected' : ''}>${trip.name}</option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700">Number of Hours</label>
          <input type="number" name="hours" id="hours" min="1" max="${trip.duration}" required
                 class="mt-1 w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-400"
                 onchange="calculateTotal()" value="${booking.hours}" />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700">Number of Passengers</label>
          <input type="number" name="passengers" id="passengers" min="1" max="${trip.capacity}" required
                 class="mt-1 w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-400"
                 value="${booking.passengers}" />
        </div>
      </div>

      <!-- Section: User & Trip Info -->
      <h2 class="text-2xl font-bold text-gray-800 border-b pb-2 mb-4"><i class="fas fa-user text-blue-400"></i> User Information</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <label class="block text-sm font-medium text-gray-700">Username</label>
          <input type="text" value="${booking.username}" readonly
                 class="mt-1 w-full p-3 border border-gray-300 rounded-lg bg-gray-100" />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700">NIC</label>
          <%
            if (user instanceof com.boatsafari.model.Tourist) {
              com.boatsafari.model.Tourist tourist = (com.boatsafari.model.Tourist) user;
          %>
          <input type="text" value="<%= tourist.getNic() %>" readonly
                 class="mt-1 w-full p-3 border border-gray-300 rounded-lg bg-gray-100" />
          <% } %>
        </div>
      </div>

      <!-- Section: Payment -->
      <h2 class="text-2xl font-bold text-gray-800 border-b pb-2 mb-4"><i class="fas fa-credit-card text-blue-400"></i> Payment Information</h2>
      <div class="bg-gradient-to-r from-blue-50 to-blue-100 p-5 rounded-xl border border-blue-200 shadow-inner">
        <h3 class="font-semibold text-gray-800 mb-3 flex items-center gap-2"><i class="fas fa-credit-card text-blue-500"></i> Payment Info</h3>
        <div class="grid md:grid-cols-3 gap-4">
          <div>
            <label class="text-sm text-gray-600">Subtotal</label>
            <input type="text" id="subtotal" readonly class="w-full p-2 bg-white border rounded shadow-sm"/>
          </div>
          <div>
            <label class="text-sm text-gray-600">Discount</label>
            <input type="text" id="discount" readonly class="w-full p-2 bg-white border rounded shadow-sm"/>
          </div>
          <div>
            <label class="text-sm text-gray-600">Total</label>
            <input type="text" id="totalAmount" name="totalAmount" readonly class="w-full p-2 bg-white border rounded font-bold text-blue-600 shadow-sm"/>
          </div>
        </div>
        <div id="promoMessage" class="mt-2 text-sm text-green-600 font-medium" style="display: none;">
          🎉 Promo: <span id="promoPercent"></span>% off (Marketing Coordinator Discount)
        </div>
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700">Upload New Payment Slip</label>
        <input type="file" name="paymentSlip" id="paymentSlip" accept="image/*"
               class="mt-1 w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-400" />
      </div>
      <div class="bg-blue-50 p-6 rounded-lg border border-blue-200">
        <h3 class="text-lg font-semibold text-gray-800 mb-2">💳 Bank Details for Payment</h3>
        <p class="text-gray-700"><strong>Account Holder:</strong> W M S A Jayasena</p>
        <p class="text-gray-700"><strong>Account Number:</strong> 100652805851</p>
        <p class="text-gray-700"><strong>Bank:</strong> Sampath Bank</p>
        <p class="text-gray-700"><strong>Branch:</strong> Colombo Branch</p>
      </div>

      <!-- Submit Button -->
      <div>
        <button type="submit" class="w-full bg-blue-500 text-white px-6 py-3 rounded-full font-semibold hover:bg-blue-600 transition transform hover:scale-105">
          <i class="fas fa-check"></i> Save Changes
        </button>
      </div>
    </form>
  </c:if>
  <c:if test="${empty booking}">
    <p class="error mb-4">Booking data not available.</p>
  </c:if>

  <script>
    function calculateTotal() {
      const tripSelect = document.getElementById('tripName');
      const hoursInput = document.getElementById('hours');
      const passengersInput = document.getElementById('passengers');
      const subtotalInput = document.getElementById('subtotal');
      const discountInput = document.getElementById('discount');
      const totalAmountInput = document.getElementById('totalAmount');
      const promoMessage = document.getElementById('promoMessage');
      const promoPercent = document.getElementById('promoPercent');

      const selectedOption = tripSelect.options[tripSelect.selectedIndex];
      const pricePerHour = parseFloat(selectedOption.getAttribute('data-price-per-hour')) || 0;
      const promotionPercentage = parseFloat(selectedOption.getAttribute('data-promotion-percentage')) || 0;
      const minPassengers = parseInt(selectedOption.getAttribute('data-min-passengers')) || 0;
      const minHours = parseInt(selectedOption.getAttribute('data-min-hours')) || 0;
      const hours = parseInt(hoursInput.value) || 1;
      const passengers = parseInt(passengersInput.value) || 1;

      const subtotal = pricePerHour * hours * passengers;
      let discount = 0;
      if (promotionPercentage > 0 && passengers >= minPassengers && hours >= minHours) {
        discount = (subtotal * promotionPercentage) / 100;
      }
      if (promotionPercentage > 0) {
        promoMessage.style.display = 'block';
        promoPercent.textContent = promotionPercentage;
      } else {
        promoMessage.style.display = 'none';
      }

      subtotalInput.value = subtotal.toFixed(2);
      discountInput.value = discount.toFixed(2);
      totalAmountInput.value = (subtotal - discount).toFixed(2);
    }

    // Initialize total on page load
    window.onload = function() {
      calculateTotal(); // Set initial total based on current trip and hours
    };
  </script>
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

</body>
</html>