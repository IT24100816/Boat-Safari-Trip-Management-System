<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Add Feedback</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <style>
    .star-rating input[type="radio"] {
      display: none;
    }
    .star-rating label {
      font-size: 2rem;
      color: #ccc;
      cursor: pointer;
    }
    .star-rating input[type="radio"]:checked ~ label,
    .star-rating label:hover,
    .star-rating label:hover ~ label {
      color: #ffd700;
    }
  </style>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col font-sans">

<!-- Navbar -->
<nav class="bg-black text-white p-4 shadow-md">
  <div class="container mx-auto flex justify-between items-center">
    <h1 class="text-2xl font-bold flex items-center gap-2">
      <i class="fa-solid fa-water"></i> BlueWave Safaris
    </h1>
    <a href="/logout" class="flex items-center gap-2 bg-white/10 px-3 py-2 rounded-lg hover:bg-white/20 transition">
      <i class="fas fa-sign-out-alt"></i> Logout
    </a>
  </div>
</nav>

<!-- Main Content -->
<div class="container mx-auto p-6 flex-1">
  <h2 class="text-3xl font-bold text-gray-800 mb-8">Add Feedback for <c:out value="${trip.name}"/></h2>

  <c:if test="${not empty success}">
    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4" role="alert">
      <p><c:out value="${success}"/></p>
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4" role="alert">
      <p><c:out value="${error}"/></p>
    </div>
  </c:if>

  <form action="/tour-guide/save-feedback" method="post" enctype="multipart/form-data" class="bg-white p-6 rounded-lg shadow-lg">
    <input type="hidden" name="tripId" value="${trip.id}">

    <!-- Default Fields -->
    <div class="mb-6">
      <label class="block text-lg font-semibold text-gray-700 mb-2">Trip Name</label>
      <input type="text" value="${trip.name}" class="w-full p-3 border border-gray-300 rounded bg-gray-100" readonly>
    </div>
    <div class="mb-6">
      <label class="block text-lg font-semibold text-gray-700 mb-2">Trip ID</label>
      <input type="text" value="${trip.id}" class="w-full p-3 border border-gray-300 rounded bg-gray-100" readonly>
    </div>
    <div class="mb-6">
      <label class="block text-lg font-semibold text-gray-700 mb-2">Tour Guide ID</label>
      <input type="text" value="${tourGuide.id}" class="w-full p-3 border border-gray-300 rounded bg-gray-100" readonly>
    </div>
    <div class="mb-6">
      <label class="block text-lg font-semibold text-gray-700 mb-2">Tour Guide Name</label>
      <input type="text" value="${tourGuide.firstName} ${tourGuide.lastName}" class="w-full p-3 border border-gray-300 rounded bg-gray-100" readonly>
    </div>

    <!-- Date -->
    <div class="mb-6">
      <label for="date" class="block text-lg font-semibold text-gray-700 mb-2">Date</label>
      <input type="date" id="date" name="date" class="w-full p-3 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-400" required>
    </div>

    <!-- Rating -->
    <div class="mb-6">
      <label class="block text-lg font-semibold text-gray-700 mb-2">Rating (1-5 Stars)</label>
      <div class="star-rating">
        <input type="radio" id="star5" name="rating" value="5" required><label for="star5" title="5 stars"><i class="fas fa-star"></i></label>
        <input type="radio" id="star4" name="rating" value="4"><label for="star4" title="4 stars"><i class="fas fa-star"></i></label>
        <input type="radio" id="star3" name="rating" value="3"><label for="star3" title="3 stars"><i class="fas fa-star"></i></label>
        <input type="radio" id="star2" name="rating" value="2"><label for="star2" title="2 stars"><i class="fas fa-star"></i></label>
        <input type="radio" id="star1" name="rating" value="1"><label for="star1" title="1 star"><i class="fas fa-star"></i></label>
      </div>
    </div>

    <!-- Tourist Name -->
    <div class="mb-6">
      <label for="touristName" class="block text-lg font-semibold text-gray-700 mb-2">Select Tourist</label>
      <select id="touristName" name="touristName" class="w-full p-3 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-400" required>
        <option value="">Select a Tourist</option>
        <c:forEach var="tourist" items="${tourists}">
          <option value="${tourist.firstName} ${tourist.lastName}">${tourist.firstName} ${tourist.lastName}</option>
        </c:forEach>
      </select>
    </div>

    <!-- Paragraph 1 -->
    <div class="mb-6">
      <label for="paragraph1" class="block text-lg font-semibold text-gray-700 mb-2">Paragraph 1</label>
      <textarea id="paragraph1" name="paragraph1" rows="4" class="w-full p-3 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-400" placeholder="Enter the first paragraph of feedback..." required></textarea>
    </div>

    <!-- Image Upload -->
    <div class="mb-6">
      <label class="block text-lg font-semibold text-gray-700 mb-2">Upload Images (Add more fields as needed)</label>
      <div id="imageInputs">
        <input type="file" name="images" class="w-full p-3 border border-gray-300 rounded mb-2 focus:outline-none focus:ring-2 focus:ring-blue-400" accept="image/*" multiple>
      </div>
      <button type="button" id="addImage" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 transition">Add More Images</button>
    </div>

    <!-- Paragraph 2 -->
    <div class="mb-6">
      <label for="paragraph2" class="block text-lg font-semibold text-gray-700 mb-2">Paragraph 2</label>
      <textarea id="paragraph2" name="paragraph2" rows="4" class="w-full p-3 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-400" placeholder="Enter the second paragraph of feedback..." required></textarea>
    </div>

    <!-- Image Upload -->
    <div class="mb-6">
      <label class="block text-lg font-semibold text-gray-700 mb-2">Upload More Images (Add more fields as needed)</label>
      <div id="imageInputs2">
        <input type="file" name="images" class="w-full p-3 border border-gray-300 rounded mb-2 focus:outline-none focus:ring-2 focus:ring-blue-400" accept="image/*" multiple>
      </div>
      <button type="button" id="addImage2" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 transition">Add More Images</button>
    </div>

    <button type="submit" class="bg-blue-500 text-white px-6 py-3 rounded-lg hover:bg-blue-600 transition transform hover:scale-105">
      <i class="fas fa-save"></i> Save Feedback
    </button>
  </form>
</div>

<!-- Footer -->
<footer class="bg-black text-white p-4 text-center mt-auto shadow-inner">
  <p>© 2025 BlueWave Safaris - All rights reserved.</p>
</footer>

<script>
  document.getElementById('addImage').addEventListener('click', function() {
    let div = document.getElementById('imageInputs');
    let newInput = document.createElement('input');
    newInput.type = 'file';
    newInput.name = 'images';
    newInput.className = 'w-full p-3 border border-gray-300 rounded mb-2 focus:outline-none focus:ring-2 focus:ring-blue-400';
    newInput.accept = 'image/*';
    newInput.multiple = true;
    div.appendChild(newInput);
  });

  document.getElementById('addImage2').addEventListener('click', function() {
    let div = document.getElementById('imageInputs2');
    let newInput = document.createElement('input');
    newInput.type = 'file';
    newInput.name = 'images';
    newInput.className = 'w-full p-3 border border-gray-300 rounded mb-2 focus:outline-none focus:ring-2 focus:ring-blue-400';
    newInput.accept = 'image/*';
    newInput.multiple = true;
    div.appendChild(newInput);
  });
</script>