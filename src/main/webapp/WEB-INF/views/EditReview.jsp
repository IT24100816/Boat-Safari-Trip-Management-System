<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Edit Feedbacks</title>
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
    .modal {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.8);
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }
    .modal-content {
      max-width: 90%;
      max-height: 90%;
    }
    .modal-content img {
      max-width: 100%;
      max-height: 100%;
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
  <h2 class="text-3xl font-bold text-gray-800 mb-8">Edit Feedbacks for <c:out value="${trip.name}"/></h2>

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

  <c:if test="${not empty reviews}">
    <c:forEach var="review" items="${reviews}">
      <div class="bg-white p-6 rounded-lg shadow-lg mb-6">
        <form action="/tour-guide/update-feedback" method="post" enctype="multipart/form-data" class="space-y-6">
          <input type="hidden" name="reviewId" value="${review.id}">

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

          <!-- Paragraph 1 -->
          <div class="mb-6">
            <label for="paragraph1" class="block text-lg font-semibold text-gray-700 mb-2">Paragraph 1</label>
            <textarea id="paragraph1" name="paragraph1" rows="4" class="w-full p-3 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-400" required>${review.paragraph1}</textarea>
          </div>

          <!-- Image Upload 1 -->
          <div class="mb-6">
            <label class="block text-lg font-semibold text-gray-700 mb-2">Current Images</label>
            <c:if test="${not empty review.imageUrls}">
              <div class="flex flex-wrap gap-2">
                <c:forTokens var="imageUrl" items="${review.imageUrls}" delims=",">
                  <img src="${imageUrl}" alt="Review Image" class="w-24 h-24 object-cover rounded cursor-pointer" onclick="openModal('${imageUrl}')">
                </c:forTokens>
              </div>
            </c:if>
            <label class="block text-lg font-semibold text-gray-700 mb-2 mt-4">Upload New Images (Optional)</label>
            <div id="imageInputs_${review.id}">
              <input type="file" name="images" class="w-full p-3 border border-gray-300 rounded mb-2 focus:outline-none focus:ring-2 focus:ring-blue-400" accept="image/*" multiple>
            </div>
            <button type="button" id="addImage_${review.id}" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 transition">Add More Images</button>
          </div>

          <!-- Paragraph 2 -->
          <div class="mb-6">
            <label for="paragraph2" class="block text-lg font-semibold text-gray-700 mb-2">Paragraph 2</label>
            <textarea id="paragraph2" name="paragraph2" rows="4" class="w-full p-3 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-400" required>${review.paragraph2}</textarea>
          </div>

          <!-- Image Upload 2 -->
          <div class="mb-6">
            <label class="block text-lg font-semibold text-gray-700 mb-2">Upload More Images (Optional)</label>
            <div id="imageInputs2_${review.id}">
              <input type="file" name="images" class="w-full p-3 border border-gray-300 rounded mb-2 focus:outline-none focus:ring-2 focus:ring-blue-400" accept="image/*" multiple>
            </div>
            <button type="button" id="addImage2_${review.id}" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 transition">Add More Images</button>
          </div>

          <!-- Date -->
          <div class="mb-6">
            <label for="date" class="block text-lg font-semibold text-gray-700 mb-2">Date</label>
            <input type="date" id="date" name="date" value="${review.date}" class="w-full p-3 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-400" required>
          </div>

          <!-- Rating -->
          <div class="mb-6">
            <label class="block text-lg font-semibold text-gray-700 mb-2">Rating (1-5 Stars)</label>
            <div class="star-rating">
              <input type="radio" id="star5_${review.id}" name="rating" value="5" ${review.rating == 5 ? 'checked' : ''} required><label for="star5_${review.id}" title="5 stars"><i class="fas fa-star"></i></label>
              <input type="radio" id="star4_${review.id}" name="rating" value="4" ${review.rating == 4 ? 'checked' : ''}><label for="star4_${review.id}" title="4 stars"><i class="fas fa-star"></i></label>
              <input type="radio" id="star3_${review.id}" name="rating" value="3" ${review.rating == 3 ? 'checked' : ''}><label for="star3_${review.id}" title="3 stars"><i class="fas fa-star"></i></label>
              <input type="radio" id="star2_${review.id}" name="rating" value="2" ${review.rating == 2 ? 'checked' : ''}><label for="star2_${review.id}" title="2 stars"><i class="fas fa-star"></i></label>
              <input type="radio" id="star1_${review.id}" name="rating" value="1" ${review.rating == 1 ? 'checked' : ''}><label for="star1_${review.id}" title="1 star"><i class="fas fa-star"></i></label>
            </div>
          </div>

          <!-- Tourist Name -->
          <div class="mb-6">
            <label for="touristName" class="block text-lg font-semibold text-gray-700 mb-2">Tourist Name</label>
            <select id="touristName" name="touristName" class="w-full p-3 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-400">
              <option value="${review.touristName}" selected>${review.touristName}</option>
              <c:forEach var="tourist" items="${tourists}">
                <option value="${tourist.firstName} ${tourist.lastName}">${tourist.firstName} ${tourist.lastName}</option>
              </c:forEach>
            </select>
          </div>

          <div class="flex gap-4">
            <button type="submit" class="bg-blue-500 text-white px-6 py-3 rounded-lg hover:bg-blue-600 transition transform hover:scale-105">
              <i class="fas fa-save"></i> Update Feedback
            </button>
            <a href="/tour-guide/delete-feedback?reviewId=${review.id}" class="bg-red-500 text-white px-6 py-3 rounded-lg hover:bg-red-600 transition transform hover:scale-105 flex items-center">
              <i class="fas fa-trash"></i> Delete
            </a>
          </div>
        </form>
      </div>
    </c:forEach>
  </c:if>
  <c:if test="${empty reviews}">
    <p class="text-center text-gray-500 text-lg">No feedbacks available for this trip.</p>
  </c:if>
</div>

<!-- Modal for Image Enlargement -->
<div id="imageModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">&times;</span>
    <img id="modalImage" src="" alt="Enlarged Image">
  </div>
</div>

<!-- Footer -->
<footer class="bg-black text-white p-4 text-center mt-auto shadow-inner">
  <p>© 2025 BlueWave Safaris - All rights reserved.</p>
</footer>

<script>
  <c:forEach var="review" items="${reviews}">
  document.getElementById('addImage_${review.id}').addEventListener('click', function() {
    let div = document.getElementById('imageInputs_${review.id}');
    let newInput = document.createElement('input');
    newInput.type = 'file';
    newInput.name = 'images';
    newInput.className = 'w-full p-3 border border-gray-300 rounded mb-2 focus:outline-none focus:ring-2 focus:ring-blue-400';
    newInput.accept = 'image/*';
    newInput.multiple = true;
    div.appendChild(newInput);
  });

  document.getElementById('addImage2_${review.id}').addEventListener('click', function() {
    let div = document.getElementById('imageInputs2_${review.id}');
    let newInput = document.createElement('input');
    newInput.type = 'file';
    newInput.name = 'images';
    newInput.className = 'w-full p-3 border border-gray-300 rounded mb-2 focus:outline-none focus:ring-2 focus:ring-blue-400';
    newInput.accept = 'image/*';
    newInput.multiple = true;
    div.appendChild(newInput);
  });
  </c:forEach>

  let modal = document.getElementById('imageModal');
  let modalImage = document.getElementById('modalImage');
  let closeBtn = document.getElementsByClassName('close')[0];

  function openModal(imageUrl) {
    modal.style.display = 'flex';
    modalImage.src = imageUrl;
  }

  function closeModal() {
    modal.style.display = 'none';
  }

  // Close modal when clicking outside
  modal.addEventListener('click', function(e) {
    if (e.target === modal) {
      closeModal();
    }
  });
</script>