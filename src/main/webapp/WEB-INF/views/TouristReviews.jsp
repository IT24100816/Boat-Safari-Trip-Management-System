<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Tourist Reviews</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <!-- AOS Animation Library -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet">
</head>
<body class="bg-gray-100 text-gray-800 min-h-screen flex flex-col">

<!-- Navbar -->
<nav class="bg-black text-white fixed top-0 w-full z-50 shadow-lg">
  <div class="max-w-7xl mx-auto px-6">
    <div class="flex items-center justify-between h-20">
      <!-- Logo -->
      <div class="flex items-center space-x-3 flex-shrink-0">
        <i class="fas fa-ship text-3xl text-blue-400 animate-bounce"></i>
        <a href="/" class="text-2xl font-extrabold tracking-wide whitespace-nowrap hover:text-blue-400 transition">
          <span class="text-blue-400">BlueWave</span> Safaris
        </a>
      </div>

      <!-- Right side -->
      <div class="flex items-center space-x-6">
                <span class="text-white font-medium">
                  👋 Welcome,
                  <span class="text-blue-400"><c:out value="${sessionScope.user.firstName} ${sessionScope.user.lastName}"/></span>
                </span>
        <a href="/logout" class="text-xl hover:text-blue-400 transition transform hover:scale-110" aria-label="Logout">
          <i class="fas fa-sign-out-alt"></i>
        </a>
      </div>
    </div>
  </div>
</nav>

<!-- Header Section -->
<header class="pt-28">
  <div class="max-w-7xl mx-auto px-6 text-left" data-aos="fade-right" data-aos-duration="1000">
    <h1 class="text-5xl font-extrabold text-gray-800 mb-3">🛳 View Trip Reviews</h1>
    <p class="text-lg text-gray-600">Explore reviews for trips you’re interested in.</p>
  </div>
</header>

<!-- Trips Section -->
<section class="max-w-7xl mx-auto px-6 py-12 flex-grow">
  <c:if test="${empty trips}">
    <p class="text-center text-gray-500 text-lg" data-aos="fade-up">🚫 No trips available at the moment. Please check back later.</p>
  </c:if>

  <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-8 mt-8">
    <c:forEach var="trip" items="${trips}">
      <div class="bg-white rounded-2xl shadow-lg hover:shadow-2xl transform hover:scale-105 transition duration-300 overflow-hidden"
           data-aos="zoom-in" data-aos-duration="900">
        <!-- Trip Image -->
        <c:choose>
          <c:when test="${not empty trip.pictureUrl}">
            <img src="${trip.pictureUrl}" alt="${trip.name} Image" class="w-full h-48 object-cover"/>
          </c:when>
          <c:otherwise>
            <div class="w-full h-48 bg-gray-200 flex items-center justify-center text-gray-500">
              <i class="fas fa-image text-4xl"></i>
            </div>
          </c:otherwise>
        </c:choose>

        <!-- Trip Content -->
        <div class="p-6">
          <h3 class="text-2xl font-bold text-gray-800 mb-2">${trip.name}</h3>
          <p class="text-gray-600 mb-1"><i class="fas fa-water text-blue-400"></i> Type: ${trip.type}</p>
          <p class="text-gray-600 mb-1"><i class="far fa-clock text-blue-400"></i> Time: ${trip.time} | Duration: ${trip.duration} hrs</p>
          <p class="text-gray-600 mb-1"><i class="fas fa-dollar-sign text-blue-400"></i> Price: $${trip.price}/hr</p>
          <p class="text-gray-600 mb-1"><i class="fas fa-users text-blue-400"></i> Capacity: ${trip.capacity}</p>
          <p class="text-gray-600 mb-1"><i class="fas fa-map-marker-alt text-blue-400"></i> ${trip.locationName}</p>

          <!-- Action Button -->
          <div class="mt-5">
            <a href="/view-reviews?tripId=${trip.id}"
               class="w-full block text-center bg-blue-500 text-white px-6 py-3 rounded-full font-semibold hover:bg-blue-600 transition">
              <i class="fas fa-eye"></i> View Reviews
            </a>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</section>

<!-- Footer -->
<footer class="bg-black text-white py-8">
  <div class="max-w-7xl mx-auto px-6 grid md:grid-cols-3 gap-8 text-center md:text-left" data-aos="fade-up" data-aos-duration="1000">
    <!-- About -->
    <div>
      <h3 class="text-lg font-semibold mb-2">About BlueWave Safaris</h3>
      <p class="text-gray-400 text-sm">We provide exciting safari adventures, helping tourists explore marine beauty with experienced guides.</p>
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
        <a href="#" class="hover:text-blue-400 transform hover:scale-125 transition"><i class="fab fa-facebook-f"></i></a>
        <a href="#" class="hover:text-blue-400 transform hover:scale-125 transition"><i class="fab fa-instagram"></i></a>
        <a href="#" class="hover:text-blue-400 transform hover:scale-125 transition"><i class="fab fa-twitter"></i></a>
        <a href="#" class="hover:text-blue-400 transform hover:scale-125 transition"><i class="fab fa-youtube"></i></a>
      </div>
    </div>
  </div>

  <div class="mt-6 text-center text-gray-500 text-sm">
    © 2025 BlueWave Safaris — All Rights Reserved
  </div>
</footer>

<!-- AOS Script -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
<script>
  AOS.init();
</script>