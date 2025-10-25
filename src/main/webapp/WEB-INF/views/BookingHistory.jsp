<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Booking History</title>

  <!-- Tailwind + Font Awesome -->
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

  <style>
    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(20px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .fade-in-up { animation: fadeInUp 0.6s ease-out forwards; }
    /* small utility for status badge width consistency */
    .status-badge { min-width: 96px; display:inline-block; text-align:center; }
  </style>
</head>
<body class="bg-gray-100 text-gray-800 min-h-screen flex flex-col">

<!-- Navbar -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg">
  <div class="max-w-7xl mx-auto px-6">
    <div class="flex items-center justify-between h-24">
      <a href="/" class="flex items-center gap-3">
        <i class="fas fa-water text-2xl text-blue-400"></i>
        <span class="text-2xl font-extrabold tracking-wide"><span class="text-blue-400">BlueWave</span> Safaris</span>
      </a>

      <div class="hidden lg:flex items-center space-x-6 font-medium text-lg">
        <a href="/" class="hover:text-blue-400 transition">Home</a>
        <a href="/trips" class="hover:text-blue-400 transition">Trips</a>
        <a href="/promotions" class="hover:text-blue-400 transition">Promotions</a>
        <a href="/contact" class="hover:text-blue-400 transition">Contact</a>

        <!-- Profile & Logout -->
        <a href="/profile" class="flex items-center gap-2 hover:text-blue-400 transition">
          <i class="fas fa-user-circle text-2xl"></i>
          <span>Profile</span>
        </a>
        <a href="/logout" class="text-2xl hover:text-blue-400 transition" title="Logout"><i class="fas fa-sign-out-alt"></i></a>
      </div>

      <!-- Mobile menu button -->
      <div class="lg:hidden flex items-center">
        <button id="menu-btn" class="text-white text-3xl focus:outline-none" aria-label="Open menu">
          <i class="fas fa-bars"></i>
        </button>
      </div>
    </div>
  </div>

  <!-- Mobile menu -->
  <div id="mobile-menu" class="hidden lg:hidden bg-black px-6 py-4 space-y-4 text-lg">
    <a href="/" class="block hover:text-blue-400 transition">Home</a>
    <a href="/trips" class="block hover:text-blue-400 transition">Trips</a>
    <a href="/promotions" class="block hover:text-blue-400 transition">Promotions</a>
    <a href="/contact" class="block hover:text-blue-400 transition">Contact</a>
    <a href="/profile" class="block hover:text-blue-400 transition">Profile</a>
    <a href="/logout" class="block hover:text-blue-400 transition">Logout</a>
  </div>
</nav>

<!-- Header -->
<header class="pt-28 text-center">
  <div class="max-w-7xl mx-auto px-6">
    <h1 class="text-4xl font-bold text-gray-800">👋Welcome, <c:out value="${sessionScope.username}"/></h1>
    <p class="mt-2 text-gray-600">Your booking history — recent bookings shown first</p>
  </div>
</header>

<!-- Main Content -->
<section class="max-w-7xl mx-auto px-6 py-12 flex-1">
  <div class="mb-6 flex items-center justify-between">
    <div>
      <h2 class="text-2xl font-bold text-gray-800 fade-in-up"><i class="fas fa-history text-green-500 mr-2"></i>Booking History</h2>
      <p class="text-sm text-gray-500 mt-1">Manage your bookings — update pending ones or review completed trips.</p>
    </div>

    <!-- Quick actions -->
    <div class="flex gap-3">
      <a href="/trips" class="inline-flex items-center gap-2 bg-gradient-to-r from-blue-600 to-blue-500 text-white px-4 py-2 rounded-lg shadow hover:scale-[1.02] transition">
        <i class="fas fa-ship"></i> Browse Trips
      </a>
      <a href="/booking" class="inline-flex items-center gap-2 bg-white border border-gray-200 px-4 py-2 rounded-lg shadow hover:shadow-lg transition">
        <i class="fas fa-plus text-blue-600"></i> New Booking
      </a>
    </div>
  </div>

  <c:choose>
    <c:when test="${not empty bookings}">
      <!-- responsive grid of cards -->
      <div class="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
        <c:forEach var="booking" items="${bookings}">
          <!-- compute badge class for status safely -->
          <c:choose>
            <c:when test="${booking.bookingStatus == 'Completed'}">
              <c:set var="badgeClass" value="bg-green-100 text-green-700"/>
            </c:when>
            <c:when test="${booking.bookingStatus == 'Pending'}">
              <c:set var="badgeClass" value="bg-yellow-100 text-yellow-700"/>
            </c:when>
            <c:when test="${booking.bookingStatus == 'Cancelled'}">
              <c:set var="badgeClass" value="bg-red-100 text-red-700"/>
            </c:when>
            <c:otherwise>
              <c:set var="badgeClass" value="bg-gray-100 text-gray-700"/>
            </c:otherwise>
          </c:choose>

          <div class="bg-white rounded-2xl shadow-lg overflow-hidden hover:shadow-2xl transform hover:-translate-y-1 transition">
            <div class="p-6">
              <!-- Title row -->
              <div class="flex items-start justify-between gap-4">
                <div>
                  <h3 class="text-lg font-bold text-gray-800 flex items-center gap-3">
                    <i class="fas fa-ship text-blue-500 text-xl"></i>
                    <span>${booking.tripName}</span>
                  </h3>
                  <p class="text-sm text-gray-500 mt-1">Booking ID: <span class="font-medium text-gray-700">${booking.id}</span></p>
                </div>

                <!-- status -->
                <div>
                  <span class="status-badge px-3 py-1 rounded-full text-xs font-semibold ${badgeClass}">${booking.bookingStatus}</span>
                </div>
              </div>

              <!-- details -->
              <div class="mt-4 text-sm text-gray-600 space-y-2">
                <p><i class="fas fa-user mr-2 text-gray-400"></i> <span class="font-medium text-gray-800">${booking.username}</span> (<span>${booking.nic}</span>)</p>

                <p>
                  <i class="fas fa-calendar-alt mr-2 text-gray-400"></i>
                  <c:choose>
                    <c:when test="${not empty booking.bookingDate}">
                      <fmt:formatDate value="${booking.bookingDate}" pattern="dd MMM yyyy" />
                    </c:when>
                    <c:otherwise>N/A</c:otherwise>
                  </c:choose>
                </p>

                <p><i class="fas fa-users mr-2 text-gray-400"></i> Passengers: <span class="font-medium">${booking.passengers}</span></p>
                <p><i class="fas fa-clock mr-2 text-gray-400"></i> Hours: <span class="font-medium">${booking.hours}</span></p>
                <p><i class="fas fa-dollar-sign mr-2 text-gray-400"></i> <fmt:formatNumber value="${booking.totalAmount}" type="currency" currencySymbol="$" /></p>

                <p><i class="fas fa-id-badge mr-2 text-gray-400"></i> Driver: <span class="font-medium">${booking.boatDriverName}</span></p>

                <c:if test="${not empty booking.paymentSlipUrl}">
                  <p class="mt-2"><a href="${booking.paymentSlipUrl}" target="_blank" class="text-blue-600 hover:underline"><i class="fas fa-receipt mr-1"></i> View Payment Slip</a></p>
                </c:if>
              </div>

              <!-- actions -->
              <div class="mt-5">
                <c:if test="${booking.bookingStatus == 'Pending'}">
                  <div class="flex gap-3">
                    <form action="/update-booking" method="get" class="flex-1">
                      <input type="hidden" name="bookingId" value="${booking.id}"/>
                      <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 text-white px-3 py-2 rounded-lg flex items-center justify-center gap-2 transition">
                        <i class="fas fa-edit"></i> Update
                      </button>
                    </form>

                    <form action="/delete-booking" method="post" class="flex-1" onsubmit="return confirm('Delete this booking?');">
                      <input type="hidden" name="bookingId" value="${booking.id}"/>
                      <button type="submit" class="w-full bg-red-500 hover:bg-red-600 text-white px-3 py-2 rounded-lg flex items-center justify-center gap-2 transition">
                        <i class="fas fa-trash"></i> Delete
                      </button>
                    </form>
                  </div>
                </c:if>

                <c:if test="${booking.bookingStatus != 'Pending'}">
                  <div class="flex gap-3">
                    <a href="/booking-details?bookingId=${booking.id}" class="w-full inline-flex items-center justify-center gap-2 border border-gray-200 px-3 py-2 rounded-lg hover:shadow-sm transition text-sm">
                      <i class="fas fa-eye text-gray-600"></i> View Details
                    </a>
                  </div>
                </c:if>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>

    </c:when>

    <c:otherwise>
      <div class="text-center py-16 text-gray-500 fade-in-up">
        <i class="fas fa-inbox text-5xl mb-4"></i>
        <p class="text-lg">No booking history available.</p>
        <a href="/trips" class="mt-6 inline-flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition">
          <i class="fas fa-ship"></i> Browse Trips
        </a>
      </div>
    </c:otherwise>
  </c:choose>
</section>

<!-- Footer -->
<footer class="bg-black text-white py-6 mt-auto">
  <div class="max-w-7xl mx-auto px-6 text-center">
    <p class="text-gray-400">© 2025 BlueWave Safaris — Booking History</p>
  </div>
</footer>

<script>
  // mobile menu toggle
  const menuBtn = document.getElementById('menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');
  if (menuBtn && mobileMenu) {
    menuBtn.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));
  }

  // small entrance animations
  document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.fade-in-up').forEach((el, index) => {
      el.style.opacity = 0;
      el.style.animationDelay = `${index * 0.12}s`;
      setTimeout(() => el.classList.add('fade-in-up'), 80);
    });
  });
</script>
</body>
</html>
