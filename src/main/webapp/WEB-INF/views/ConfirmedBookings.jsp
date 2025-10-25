<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Confirmed Bookings</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <style>
    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .fade-in-up { animation: fadeInUp 0.6s ease-out forwards; }
  </style>
</head>
<body class="bg-gray-100 text-gray-800 min-h-screen flex flex-col">

<!-- Navbar -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg">
  <div class="max-w-7xl mx-auto px-6">
    <div class="flex items-center justify-between h-20">
      <a href="/" class="flex items-center space-x-2">
        <i class="fas fa-ship text-3xl text-blue-400"></i>
        <span class="text-2xl font-extrabold"><span class="text-blue-400">BlueWave</span> Safaris</span>
      </a>
      <div class="flex items-center space-x-6">
        <span class="hidden md:block">👋Welcome, <c:out value="${sessionScope.username}"/></span>
        <a href="/logout" class="text-xl hover:text-blue-400 transition"><i class="fas fa-sign-out-alt"></i></a>
      </div>
    </div>
  </div>
</nav>

<!-- Header -->
<header class="pt-28 text-center">
  <div class="max-w-3xl mx-auto px-6">
    <h1 class="text-4xl font-bold text-gray-800">📑 Your Confirmed Bookings</h1>
    <p class="mt-2 text-gray-600">Manage and review your safari adventures</p>
  </div>
</header>

<!-- Main Content -->
<section class="max-w-7xl mx-auto px-6 py-12 flex-1">
  <c:choose>
    <c:when test="${not empty confirmedBookings}">
      <div class="grid gap-8 md:grid-cols-2 lg:grid-cols-3">
        <c:forEach var="booking" items="${confirmedBookings}">
          <div class="bg-white rounded-xl shadow-lg p-6 fade-in-up transform hover:-translate-y-2 transition duration-300">
            <!-- Boat Image -->
            <c:if test="${not empty booking.imageUrl}">
              <img src="${booking.imageUrl}" alt="Boat" class="w-full h-40 object-cover rounded-lg mb-4"/>
            </c:if>

            <!-- Trip & Tourist -->
            <h2 class="text-xl font-semibold text-gray-800 mb-2 flex items-center">
              <i class="fas fa-ship text-blue-500 mr-2"></i> ${booking.boatName}
            </h2>
            <p class="text-gray-600 flex items-center mb-1">
              <i class="fas fa-user text-blue-400 mr-2"></i> ${booking.touristName} (${booking.touristNic})
            </p>
            <p class="text-gray-600 flex items-center mb-1">
              <i class="fas fa-id-badge text-blue-400 mr-2"></i> Booking ID: ${booking.id}
            </p>
            <p class="text-gray-600 flex items-center mb-1">
              <i class="fas fa-user-tie text-blue-400 mr-2"></i> Driver: ${booking.driverName}
            </p>

            <!-- Booking Details -->
            <div class="mt-4 grid grid-cols-2 gap-4 text-sm">
              <div class="bg-blue-50 p-3 rounded-lg text-center">
                <i class="fas fa-users text-blue-500 mb-1"></i>
                <p class="font-semibold">${booking.passengers}</p>
                <p class="text-gray-500">Passengers</p>
              </div>
              <div class="bg-blue-50 p-3 rounded-lg text-center">
                <i class="fas fa-clock text-blue-500 mb-1"></i>
                <p class="font-semibold">${booking.hours} hrs</p>
                <p class="text-gray-500">Duration</p>
              </div>
              <div class="bg-green-50 p-3 rounded-lg text-center col-span-2">
                <i class="fas fa-dollar-sign text-green-600 mb-1"></i>
                <p class="font-semibold"><fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="$" /></p>
                <p class="text-gray-500">Total Amount</p>
              </div>
            </div>

            <!-- Dates -->
            <div class="mt-4 text-sm text-gray-600 space-y-1">
              <p><i class="fas fa-calendar-day text-blue-400 mr-2"></i>
                Booking Date: <fmt:formatDate value="${booking.bookingDate}" pattern="dd-MM-yyyy" />
              </p>
              <p><i class="fas fa-calendar-check text-green-500 mr-2"></i>
                Completed Date: <fmt:formatDate value="${booking.completedDate}" pattern="dd-MM-yyyy" />
              </p>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:when>

    <c:otherwise>
      <div class="text-center py-16 text-gray-500">
        <i class="fas fa-inbox text-6xl mb-4 text-gray-400"></i>
        <p class="text-lg">No confirmed bookings yet. Start your journey today!</p>
        <a href="/trips" class="mt-6 inline-block bg-blue-500 text-white px-6 py-3 rounded-full font-semibold hover:bg-blue-600 transition">
          Explore Trips
        </a>
      </div>
    </c:otherwise>
  </c:choose>
</section>

<!-- Footer -->
<footer class="bg-black text-white py-8 mt-auto">
  <div class="max-w-7xl mx-auto px-6 grid md:grid-cols-3 gap-8 text-center md:text-left">
    <div>
      <h3 class="text-lg font-semibold mb-2">About BlueWave Safaris</h3>
      <p class="text-gray-400 text-sm">Your trusted partner in thrilling boat safari experiences around Sri Lanka.</p>
    </div>
    <div>
      <h3 class="text-lg font-semibold mb-2">Contact</h3>
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
    © 2025 BlueWave Safaris — Confirmed Bookings
  </div>
</footer>

<script>
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
