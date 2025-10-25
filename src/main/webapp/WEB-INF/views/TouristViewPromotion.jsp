<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Tourist View Promotions</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body class="bg-gray-100 text-gray-800 min-h-screen flex flex-col">

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
        <span class="text-white font-medium">👋 Welcome, <c:out value="${sessionScope.username}"/></span>
        <a href="/logout" class="text-xl hover:text-blue-400 transition" aria-label="Logout">
          <i class="fas fa-sign-out-alt"></i>
        </a>
      </div>
    </div>
  </div>
</nav>

<!-- Main Content -->
<section class="max-w-7xl mx-auto px-6 py-12 flex-1 mt-28">
  <c:if test="${not empty success}">
    <div class="bg-green-100 text-green-700 text-center py-3 px-4 rounded-lg mb-6">
      <i class="fas fa-check-circle"></i> ${success}
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="bg-red-100 text-red-700 text-center py-3 px-4 rounded-lg mb-6">
      <i class="fas fa-exclamation-circle"></i> ${error}
    </div>
  </c:if>

  <h1 class="text-5xl font-extrabold text-gray-800 mb-8">🎉 Tourist Promotions</h1>

  <c:choose>
    <c:when test="${not empty promotions}">
      <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-8">
        <c:forEach var="promotion" items="${promotions}">
          <div class="bg-white rounded-2xl shadow-lg hover:shadow-2xl transition overflow-hidden flex flex-col">
            <!-- Image -->
            <c:if test="${not empty promotion.imageUrl}">
              <img src="${promotion.imageUrl}" alt="Promotion Image" class="w-full h-48 object-cover"/>
            </c:if>

            <!-- Content -->
            <div class="p-6 flex flex-col flex-grow">
              <h2 class="text-2xl font-bold text-gray-800 mb-2">
                <i class="fas fa-ship text-blue-400"></i> ${promotion.tripName}
              </h2>
              <p class="text-gray-600 mb-1"><i class="fas fa-users text-blue-400"></i> Min Passengers: ${promotion.passengers}</p>
              <p class="text-gray-600 mb-1"><i class="fas fa-clock text-blue-400"></i> Min Hours: ${promotion.hours}</p>
              <p class="text-gray-600 mb-1"><i class="fas fa-tag text-blue-400"></i> Discount: ${promotion.discountPercentage}%</p>

              <!-- Button -->
              <div class="mt-auto pt-4">
                <a href="/tourist/feedback?promotionId=${promotion.id}"
                   class="w-full block text-center bg-blue-500 text-white px-6 py-3 rounded-full font-semibold hover:bg-blue-600 transition">
                  <i class="fas fa-comment"></i> Give Feedback
                </a>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:when>
    <c:otherwise>
      <div class="text-center py-20 text-gray-500">
        <i class="fas fa-inbox text-6xl mb-4 animate-bounce"></i>
        <p class="text-lg">No promotions available at the moment.</p>
      </div>
    </c:otherwise>
  </c:choose>
</section>

<!-- Footer -->
<footer class="bg-black text-white py-8 mt-auto">
  <div class="max-w-7xl mx-auto px-6 grid md:grid-cols-3 gap-8 text-center md:text-left">
    <!-- About -->
    <div>
      <h3 class="text-lg font-semibold mb-2">About BlueWave Safaris</h3>
      <p class="text-gray-400 text-sm">We bring you the most exciting boat safari promotions with unbeatable offers to make your journey unforgettable.</p>
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
        <a href="#" class="hover:text-blue-400"><i class="fab fa-facebook-f"></i></a>
        <a href="#" class="hover:text-blue-400"><i class="fab fa-instagram"></i></a>
        <a href="#" class="hover:text-blue-400"><i class="fab fa-twitter"></i></a>
        <a href="#" class="hover:text-blue-400"><i class="fab fa-youtube"></i></a>
      </div>
    </div>
  </div>

  <div class="mt-6 text-center text-gray-500 text-sm">
    © 2025 BlueWave Safaris — Tourist Promotions
  </div>
</footer>

</body>
</html>