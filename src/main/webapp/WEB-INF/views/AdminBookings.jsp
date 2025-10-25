<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Admin Bookings</title>
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
  </style>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen">

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
        <a href="/admin/bookings" class="underline-grow text-blue-400">Bookings</a>
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

<!-- Main Content -->
<main class="flex-grow pt-28 pb-16 px-6">
  <div class="max-w-7xl mx-auto">
    <h1 class="text-4xl font-bold text-blue-800 mb-8 flex items-center gap-3">
      <i class="fa-solid fa-calendar-check text-blue-600"></i> Manage Bookings
    </h1>

    <c:if test="${not empty errorMessage}">
      <div class="bg-red-100 border border-red-400 text-red-700 p-4 rounded mb-4">${errorMessage}</div>
    </c:if>
    <c:if test="${not empty successMessage}">
      <div class="bg-green-100 border border-green-400 text-green-700 p-4 rounded mb-4">${successMessage}</div>
    </c:if>

    <div class="bg-white shadow-lg rounded-2xl overflow-hidden">
      <div class="overflow-x-auto">
        <table class="min-w-full text-sm text-left text-gray-800">
          <thead class="bg-blue-600 text-white text-sm uppercase">
          <tr>
            <th class="px-4 py-3">ID</th>
            <th class="px-4 py-3">Trip ID</th>
            <th class="px-4 py-3">Trip Name</th>
            <th class="px-4 py-3">User ID</th>
            <th class="px-4 py-3">Username</th>
            <th class="px-4 py-3">NIC</th>
            <th class="px-4 py-3">Booking Date</th>
            <th class="px-4 py-3">Hours</th>
            <th class="px-4 py-3">Passengers</th>
            <th class="px-4 py-3">Total Amount</th>
            <th class="px-4 py-3">Payment Slip</th>
            <th class="px-4 py-3">Status</th>
            <th class="px-4 py-3">Driver ID</th>
            <th class="px-4 py-3">Driver Name</th>
            <th class="px-4 py-3">Boat ID</th>
            <th class="px-4 py-3">Created At</th>
            <th class="px-4 py-3 text-center">Actions</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="booking" items="${bookings}">
            <tr class="border-b hover:bg-blue-50 transition">
              <td class="px-4 py-3">${booking.id}</td>
              <td class="px-4 py-3">${booking.tripId}</td>
              <td class="px-4 py-3">${booking.tripName}</td>
              <td class="px-4 py-3">${booking.userId}</td>
              <td class="px-4 py-3">${booking.username}</td>
              <td class="px-4 py-3">${booking.nic}</td>
              <td class="px-4 py-3">${booking.bookingDate}</td>
              <td class="px-4 py-3">${booking.hours}</td>
              <td class="px-4 py-3">${booking.passengers}</td>
              <td class="px-4 py-3 font-semibold text-blue-700">${booking.totalAmount}</td>
              <td class="px-4 py-3">
                <c:if test="${not empty booking.paymentSlipUrl}">
                  <a href="${booking.paymentSlipUrl}" target="_blank" class="text-blue-600 hover:underline">View Slip</a>
                </c:if>
                <c:if test="${empty booking.paymentSlipUrl}">
                  <span class="text-gray-400 italic">No Slip</span>
                </c:if>
              </td>
              <td class="px-4 py-3">${booking.bookingStatus}</td>
              <td class="px-4 py-3">${booking.boatDriverId}</td>
              <td class="px-4 py-3">${booking.boatDriverName}</td>
              <td class="px-4 py-3">${booking.boatId}</td>
              <td class="px-4 py-3">${booking.createdAt}</td>
              <td class="px-4 py-3 text-center">
                <div class="flex justify-center space-x-3">
                  <form action="/admin/approveBooking" method="post" class="inline">
                    <input type="hidden" name="bookingId" value="${booking.id}">
                    <button type="submit" class="text-green-600 hover:text-green-800"><i class="fas fa-check-circle text-lg"></i></button>
                  </form>
                  <form action="/admin/rejectBooking" method="post" class="inline">
                    <input type="hidden" name="bookingId" value="${booking.id}">
                    <button type="submit" class="text-red-600 hover:text-red-800"><i class="fas fa-times-circle text-lg"></i></button>
                  </form>
                </div>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</main>

<!-- Footer -->
<footer class="bg-black text-white mt-auto">
  <div class="max-w-7xl mx-auto px-6 py-8 text-center">
    <p class="text-gray-300 text-sm">© 2025 BlueWave Safaris — All Rights Reserved</p>
    <p class="text-gray-400 text-xs mt-1">Designed by BlueWave Admin Team</p>
  </div>
</footer>

<script>
  const menuBtn = document.getElementById('menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');
  if (menuBtn) menuBtn.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));
</script>
</body>
</html>
