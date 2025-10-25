<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Marketing Trips</title>

  <!-- Tailwind -->
  <script src="https://cdn.tailwindcss.com"></script>
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

  <style>
    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .fade-in-up { animation: fadeInUp 0.6s ease-out forwards; }
    .trip-card {
      background: #fff;
      border-radius: 1rem;
      overflow: hidden;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .trip-card:hover {
      transform: translateY(-8px) scale(1.02);
      box-shadow: 0 10px 24px rgba(0, 0, 0, 0.2);
    }
    .trip-img {
      transition: transform 6s ease;
    }
    .trip-card:hover .trip-img {
      transform: scale(1.08);
    }
    .btn {
      transition: all 0.3s ease;
    }
    .btn:hover {
      transform: translateY(-2px) scale(1.03);
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
<section class="max-w-7xl mx-auto px-6 py-12 flex-1 mt-28">
  <h1 class="text-4xl font-bold text-gray-800 mb-10 flex items-center gap-3">
    <i class="fas fa-bullhorn text-blue-500"></i> Marketing Trips
  </h1>

  <c:choose>
    <c:when test="${not empty trips}">
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <c:forEach var="trip" items="${trips}">
          <!-- Card -->
          <div class="trip-card fade-in-up">
            <c:if test="${not empty trip.pictureUrl}">
              <img src="${trip.pictureUrl}" alt="${trip.name}" class="w-full h-40 object-cover trip-img">
            </c:if>
            <div class="p-6 flex flex-col flex-grow">
              <h2 class="text-2xl font-semibold text-gray-800 mb-2">${trip.name}</h2>
              <p class="text-gray-600 mb-1"><i class="fas fa-tag text-blue-400 mr-2"></i>Type: ${trip.type}</p>
              <p class="text-gray-600 mb-1"><i class="fas fa-clock text-blue-400 mr-2"></i>Time: ${trip.time}</p>
              <p class="text-gray-600 mb-1"><i class="fas fa-hourglass-half text-blue-400 mr-2"></i>Duration: ${trip.duration} hours</p>
              <p class="text-gray-600 mb-1"><i class="fas fa-dollar-sign text-blue-400 mr-2"></i>Price: $${trip.price}</p>
              <p class="text-gray-600 mb-1"><i class="fas fa-users text-blue-400 mr-2"></i>Capacity: ${trip.capacity}</p>
              <p class="text-gray-600 mb-1"><i class="fas fa-map-marker-alt text-blue-400 mr-2"></i>Location: ${trip.locationName}</p>
              <p class="text-gray-600 mb-4"><i class="fas fa-align-left text-blue-400 mr-2"></i>${trip.description}</p>

              <c:if test="${not empty trip.googleMapsLink}">
                <a href="${trip.googleMapsLink}" target="_blank" class="inline-block text-blue-500 hover:underline mb-4">
                  <i class="fas fa-map-location-dot mr-2"></i> View on Map
                </a>
              </c:if>

              <!-- Button aligned at bottom -->
              <div class="mt-auto">
                <form action="/add-promotion" method="get" class="w-full">
                  <input type="hidden" name="tripId" value="${trip.id}" />
                  <button type="submit"
                          class="btn w-full bg-gradient-to-r from-blue-500 to-blue-600 text-white px-5 py-2 rounded-lg shadow hover:from-blue-600 hover:to-blue-700 flex items-center justify-center gap-2">
                    <i class="fas fa-plus-circle"></i> Add Promotion
                  </button>
                </form>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:when>

    <c:otherwise>
      <div class="text-center py-16 text-gray-500">
        <i class="fas fa-inbox text-5xl mb-4"></i>
        <p class="text-lg">No trips available.</p>
      </div>
    </c:otherwise>
  </c:choose>
</section>

<!-- Footer -->
<footer class="bg-black text-white py-8 mt-auto">
  <div class="max-w-7xl mx-auto px-6 text-center">
    <p class="text-gray-400">© 2025 BlueWave Safaris — Marketing Trips</p>
  </div>
</footer>

<!-- Animation Init -->
<script>
  document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".fade-in-up").forEach((el, i) => {
      el.style.opacity = 0;
      el.style.animationDelay = `${i * 0.15}s`;
      el.classList.add("fade-in-up");
    });
  });
</script>
</body>
</html>
