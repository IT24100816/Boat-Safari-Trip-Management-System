<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Manage Feedbacks - BlueWave Safaris</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

  <style>
    body {
      background: linear-gradient(to bottom right, #f0f9ff, #e0f2fe);
      background-attachment: fixed;
    }
    .wave-bg {
      background: url('https://www.transparenttextures.com/patterns/wavecut.png');
      animation: float 6s ease-in-out infinite alternate;
    }
    @keyframes float { 0% {background-position:0 0;} 100% {background-position:0 20px;} }
    .fade-in { opacity: 0; transform: translateY(20px); animation: fadeInUp 0.7s forwards; }
    @keyframes fadeInUp { 100% { opacity: 1; transform: translateY(0); } }
    .feedback-card {
      background: linear-gradient(135deg, #ffffff, #f8fafc);
      transition: transform 0.3s, box-shadow 0.3s;
      border-left: 4px solid #3b82f6;
    }
    .feedback-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 10px 25px rgba(0,0,0,0.1);
    }
    .floating-icon {
      position: absolute;
      opacity: 0.1;
      animation: floatUpDown 6s ease-in-out infinite alternate;
    }
    @keyframes floatUpDown { from {transform: translateY(0);} to {transform: translateY(15px);} }
  </style>
</head>

<body class="text-gray-800 flex flex-col min-h-screen font-sans">

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
<section class="relative max-w-7xl mx-auto px-6 py-20 mt-24 flex-1 wave-bg overflow-hidden">

  <!-- Floating icons (decorations) -->
  <i class="fas fa-water floating-icon text-blue-400 text-6xl" style="top:4rem; left:5rem;"></i>
  <i class="fas fa-comments floating-icon text-blue-300 text-5xl" style="bottom:2.5rem; right:8rem;"></i>
  <i class="fas fa-star floating-icon text-yellow-400 text-4xl" style="top:10rem; right:3rem;"></i>

  <div class="flex justify-between items-center mb-10 fade-in">
    <h1 class="text-4xl font-bold text-blue-800 drop-shadow-lg">
      <i class="fas fa-comment-dots text-blue-500 mr-3"></i>Customer Feedbacks
    </h1>
    <a href="/marketing-coordinator/dashboard"
       class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-xl shadow-lg transition transform hover:-translate-y-1">
      <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
    </a>
  </div>

  <!-- Success/Error Messages -->
  <c:if test="${not empty success}">
    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-lg mb-6 fade-in">
      <i class="fas fa-check-circle mr-2"></i> ${success}
    </div>
  </c:if>

  <c:if test="${not empty error}">
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-6 fade-in">
      <i class="fas fa-exclamation-circle mr-2"></i> ${error}
    </div>
  </c:if>

  <!-- Feedback List -->
  <div class="bg-white bg-opacity-90 rounded-2xl shadow-2xl p-8 backdrop-blur-sm fade-in">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-2xl font-semibold text-gray-800 flex items-center gap-3">
        <i class="fas fa-list text-blue-500"></i> All Customer Feedbacks
        <span class="bg-blue-100 text-blue-800 text-sm font-medium px-3 py-1 rounded-full">
          ${feedbacks.size()} feedbacks
        </span>
      </h2>
    </div>

    <c:choose>
      <c:when test="${not empty feedbacks}">
        <div class="grid gap-6">
          <c:forEach var="feedback" items="${feedbacks}" varStatus="status">
            <div class="feedback-card p-6 rounded-xl border border-gray-200 relative overflow-hidden fade-in"
                 style="animation-delay: ${status.index * 0.1}s">

              <!-- Feedback Header -->
              <div class="flex justify-between items-start mb-4">
                <div>
                  <h3 class="text-xl font-bold text-gray-900 flex items-center gap-2">
                    <i class="fas fa-user text-blue-500"></i>
                      ${feedback.tourist.firstName} ${feedback.tourist.lastName}
                    <span class="text-sm font-normal text-gray-500 ml-2">
                      (${feedback.tourist.email})
                    </span>
                  </h3>
                  <p class="text-gray-600 text-sm mt-1">
                    <i class="fas fa-tag text-blue-400 mr-1"></i>
                    Promotion: <span class="font-semibold">${feedback.promotion.tripName}</span>
                  </p>
                </div>
                <div class="text-right">
                  <div class="flex items-center justify-end mb-2">
                    <c:forEach begin="1" end="${feedback.rating}">
                      <i class="fas fa-star text-yellow-400 text-sm"></i>
                    </c:forEach>
                    <c:forEach begin="${feedback.rating + 1}" end="5">
                      <i class="fas fa-star text-gray-300 text-sm"></i>
                    </c:forEach>
                    <span class="ml-2 text-sm text-gray-500 font-medium">(${feedback.rating}/5)</span>
                  </div>
                  <p class="text-xs text-gray-400">
                    <i class="far fa-clock mr-1"></i>
                      ${feedback.createdAt}
                  </p>
                </div>
              </div>

              <!-- Feedback Content -->
              <div class="mb-4">
                <p class="text-gray-700 text-lg leading-relaxed italic">
                  " ${feedback.feedback} "
                </p>
              </div>

              <!-- Action Buttons -->
              <div class="flex justify-end pt-4 border-t border-gray-100">
                <form action="/delete-feedback" method="post" class="inline">
                  <input type="hidden" name="feedbackId" value="${feedback.id}" />
                  <button type="submit"
                          class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition transform hover:scale-105 flex items-center gap-2"
                          onclick="return confirm('Are you sure you want to delete this feedback? This action cannot be undone.')">
                    <i class="fas fa-trash"></i> Delete Feedback
                  </button>
                </form>
              </div>

              <!-- Decorative corner -->
              <div class="absolute top-0 right-0 w-16 h-16 bg-blue-500 opacity-5 rounded-bl-full"></div>
            </div>
          </c:forEach>
        </div>
      </c:when>

      <c:otherwise>
        <div class="text-center py-12 fade-in">
          <i class="fas fa-comments text-gray-300 text-6xl mb-4"></i>
          <h3 class="text-2xl font-semibold text-gray-500 mb-2">No Feedbacks Yet</h3>
          <p class="text-gray-400 text-lg">Customer feedbacks will appear here once tourists start reviewing promotions.</p>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</section>

<!-- Footer -->
<footer class="bg-black text-white py-8 mt-auto">
  <div class="max-w-7xl mx-auto px-6 grid md:grid-cols-3 gap-8 text-center md:text-left">
    <div>
      <h3 class="text-lg font-semibold mb-2">About BlueWave Safaris</h3>
      <p class="text-gray-400 text-sm">We bring you the most exciting boat safari promotions with unbeatable offers.</p>
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
    © 2025 BlueWave Safaris — Marketing Coordinator Dashboard
  </div>
</footer>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    // Add smooth animations for page load
    const fadeElements = document.querySelectorAll('.fade-in');
    fadeElements.forEach((el, index) => {
      el.style.animationDelay = (index * 0.1) + 's';
    });
  });
</script>

</body>
</html>