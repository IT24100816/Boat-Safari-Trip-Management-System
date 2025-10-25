<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Boat Driver Dashboard</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <style>
    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .fade-in-up {
      animation: fadeInUp 0.6s ease-out forwards;
    }
    .booking-card {
      transition: all 0.3s ease;
    }
    .booking-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    }
  </style>
</head>
<body class="bg-gray-100 text-gray-800 min-h-screen flex flex-col">
<!-- Navbar -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg">
  <div class="max-w-7xl mx-auto px-6">
    <div class="flex items-center justify-between h-24">
      <div class="flex items-center space-x-3 flex-shrink-0">
        <div class="text-3xl font-extrabold tracking-wide">
          <span class="text-blue-400">BlueWave</span> Safaris - Boat Driver
        </div>
      </div>
      <div class="hidden lg:flex items-center space-x-8 font-semibold text-lg">
        <a href="/boat-driver/dashboard" class="hover:text-blue-400 transition">Dashboard</a>
        <a href="/boat-driver/boats" class="hover:text-blue-400 transition">Boats</a>
        <a href="/boat-driver/profile" class="hover:text-blue-400 transition">Profile</a>
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
    <a href="/boat-driver/dashboard" class="block hover:text-blue-400 transition">Dashboard</a>
    <a href="/boat-driver/boats" class="block hover:text-blue-400 transition">Boats</a>
    <a href="/boat-driver/profile" class="block hover:text-blue-400 transition">Profile</a>
    <a href="/logout" class="block hover:text-blue-400 transition"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
  </div>
</nav>

<!-- Header -->
<header class="pt-28">
  <div class="max-w-7xl mx-auto px-6 text-center">
    <h1 class="text-4xl font-bold text-gray-800">Welcome, <c:out value="${sessionScope.username}"/></h1>
    <p class="mt-2 text-gray-600">Boat Driver Dashboard</p>
  </div>
</header>

<!-- Main Content -->
<section class="max-w-7xl mx-auto px-6 py-12 flex-1">
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

  <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
    <!-- Pending Bookings Section -->
    <div class="bg-white rounded-lg shadow-xl p-6 fade-in-up">
      <h2 class="text-2xl font-bold text-gray-800 mb-6 flex items-center">
        <i class="fas fa-clock text-yellow-500 mr-2"></i> Pending Bookings
        <span class="ml-2 bg-yellow-100 text-yellow-800 text-sm font-medium px-2.5 py-0.5 rounded">
          ${pendingBookings.size()}
        </span>
      </h2>

      <c:choose>
        <c:when test="${not empty pendingBookings}">
          <div class="space-y-4">
            <c:forEach var="booking" items="${pendingBookings}">
              <div class="booking-card bg-gray-50 p-4 rounded-lg border border-gray-200">
                <div class="flex justify-between items-start mb-2">
                  <h3 class="font-semibold text-lg">${booking.tripName}</h3>
                  <span class="bg-yellow-100 text-yellow-800 text-xs font-medium px-2.5 py-0.5 rounded">Pending</span>
                </div>

                <div class="grid grid-cols-2 gap-2 text-sm text-gray-600 mb-3">
                  <div><i class="fas fa-calendar-alt mr-2"></i> ${booking.bookingDate}</div>
                  <div><i class="fas fa-clock mr-2"></i> ${booking.hours} hours</div>
                  <div><i class="fas fa-users mr-2"></i> ${booking.passengers} passengers</div>
                  <div><i class="fas fa-dollar-sign mr-2"></i> ${booking.totalAmount}</div>
                </div>

                <div class="text-sm mb-3">
                  <strong>Customer:</strong> ${booking.username} (NIC: ${booking.nic})
                </div>

                <form action="/boat-driver/assign-booking" method="post" class="mt-2">
                  <input type="hidden" name="bookingId" value="${booking.id}">
                  <button type="submit" class="w-full bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded-lg text-sm font-medium transition">
                    <i class="fas fa-check-circle mr-2"></i> Assign to Me
                  </button>
                </form>
              </div>
            </c:forEach>
          </div>
        </c:when>
        <c:otherwise>
          <div class="text-center py-8 text-gray-500">
            <i class="fas fa-inbox text-4xl mb-3"></i>
            <p>No pending bookings at the moment.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- My Assigned Bookings Section -->
    <div class="bg-white rounded-lg shadow-xl p-6 fade-in-up">
      <h2 class="text-2xl font-bold text-gray-800 mb-6 flex items-center">
        <i class="fas fa-list-check text-green-500 mr-2"></i> My Assigned Bookings
        <span class="ml-2 bg-green-100 text-green-800 text-sm font-medium px-2.5 py-0.5 rounded">
          ${myAssignedBookings.size()}
        </span>
      </h2>

      <c:choose>
        <c:when test="${not empty myAssignedBookings}">
          <div class="space-y-4">
            <c:forEach var="booking" items="${myAssignedBookings}">
              <div class="booking-card bg-green-50 p-4 rounded-lg border border-green-200">
                <div class="flex justify-between items-start mb-2">
                  <h3 class="font-semibold text-lg">${booking.tripName}</h3>
                  <span class="bg-green-100 text-green-800 text-xs font-medium px-2.5 py-0.5 rounded">Assigned</span>
                </div>

                <div class="grid grid-cols-2 gap-2 text-sm text-gray-600 mb-3">
                  <div><i class="fas fa-calendar-alt mr-2"></i> ${booking.bookingDate}</div>
                  <div><i class="fas fa-clock mr-2"></i> ${booking.hours} hours</div>
                  <div><i class="fas fa-users mr-2"></i> ${booking.passengers} passengers</div>
                  <div><i class="fas fa-dollar-sign mr-2"></i> ${booking.totalAmount}</div>
                </div>

                <div class="text-sm">
                  <strong>Customer:</strong> ${booking.username} (NIC: ${booking.nic})
                </div>

                <div class="mt-3 flex space-x-2">
                  <form action="/boat-driver/assign-update" method="post">
                    <input type="hidden" name="bookingId" value="${booking.id}">
                    <select name="bookingStatus" class="w-full px-2 py-1 border border-gray-300 rounded text-sm mb-2">
                      <option value="Assigned" ${booking.bookingStatus == 'Assigned' ? 'selected' : ''}>Assigned</option>
                      <option value="Completed" ${booking.bookingStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                    </select>
                    <button type="submit" class="w-full bg-blue-500 hover:bg-blue-600 text-white py-2 px-3 rounded text-sm font-medium">
                      <i class="fas fa-edit mr-1"></i> Update
                    </button>
                  </form>
                  <form action="/boat-driver/assign-leave" method="post" onsubmit="return confirm('Are you sure you want to leave this assignment?')">
                    <input type="hidden" name="bookingId" value="${booking.id}">
                    <button type="submit" class="w-full bg-yellow-500 hover:bg-yellow-600 text-white py-2 px-3 rounded text-sm font-medium">
                      <i class="fas fa-sign-out-alt mr-1"></i> Leave
                    </button>
                  </form>
                </div>
              </div>
            </c:forEach>
          </div>
        </c:when>
        <c:otherwise>
          <div class="text-center py-8 text-gray-500">
            <i class="fas fa-inbox text-4xl mb-3"></i>
            <p>You don't have any assigned bookings yet.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <!-- Profile Section -->
<%--  <div class="bg-white rounded-lg shadow-xl p-6 mt-8 fade-in-up">--%>
<%--    <h2 class="text-2xl font-bold text-gray-800 mb-6"><i class="fas fa-user text-blue-500 mr-2"></i> Your Profile</h2>--%>
<%--    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">--%>
<%--      <div class="space-y-2">--%>
<%--        <p><strong>Name:</strong> <c:out value="${sessionScope.user.firstName} ${sessionScope.user.lastName}"/></p>--%>
<%--        <p><strong>Email:</strong> <c:out value="${sessionScope.user.email}"/></p>--%>
<%--        <p><strong>NIC:</strong> <c:out value="${sessionScope.user.nic}"/></p>--%>
<%--      </div>--%>
<%--      <div class="space-y-2">--%>
<%--        <p><strong>Age:</strong> <c:out value="${sessionScope.user.age}"/></p>--%>
<%--        <p><strong>Phone:</strong> <c:out value="${sessionScope.user.phone}"/></p>--%>
<%--        <p><strong>License Number:</strong> <c:out value="${sessionScope.user.licenseNumber}"/></p>--%>
<%--      </div>--%>
<%--    </div>--%>
<%--    <p class="mt-4"><strong>Role:</strong> <span class="bg-blue-100 text-blue-800 text-sm font-medium px-2.5 py-0.5 rounded">Boat Driver</span></p>--%>
<%--  </div>--%>
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
    menuBtn.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));
  }

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