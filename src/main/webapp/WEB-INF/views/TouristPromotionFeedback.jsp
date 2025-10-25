<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Feedback - BlueWave Safaris</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

  <style>
    body {
      background: linear-gradient(to bottom right, #e0f7ff, #ffffff);
      background-attachment: fixed;
    }
    .star-rating .star {
      cursor: pointer;
      font-size: 1.7rem;
      color: #cbd5e1;
      transition: color 0.25s ease, transform 0.2s ease;
      display:inline-block;
      line-height:1;
    }
    .star-rating .star.active,
    .star-rating .star.hover {
      color: #facc15;
      transform: scale(1.2);
    }
    .wave-bg {
      background: url('https://www.transparenttextures.com/patterns/wavecut.png');
      animation: float 6s ease-in-out infinite alternate;
    }
    @keyframes float { 0% {background-position:0 0;} 100% {background-position:0 20px;} }
    .fade-in { opacity: 0; transform: translateY(20px); animation: fadeInUp 0.7s forwards; }
    @keyframes fadeInUp { 100% { opacity: 1; transform: translateY(0); } }
    .feedback-card { background: linear-gradient(135deg,#f0f9ff,#e0f2fe); transition: transform 0.3s,box-shadow 0.3s; }
    .feedback-card:hover { transform: translateY(-6px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
    .floating-icon { position: absolute; opacity: 0.1; animation: floatUpDown 6s ease-in-out infinite alternate; }
    @keyframes floatUpDown { from {transform: translateY(0);} to {transform: translateY(15px);} }
    .modal { display: none; }
    .modal.active { display: flex; }
  </style>
</head>

<body class="text-gray-800 flex flex-col min-h-screen font-sans">

<!-- Navbar (left unchanged) -->
<nav class="bg-black text-white fixed top-0 w-full z-50 shadow-lg">
  <div class="max-w-7xl mx-auto px-6">
    <div class="flex items-center justify-between h-20">
      <div class="flex items-center space-x-3 flex-shrink-0">
        <i class="fas fa-ship text-3xl text-blue-400 animate-bounce"></i>
        <a href="/" class="text-2xl font-extrabold tracking-wide whitespace-nowrap">
          <span class="text-blue-400">BlueWave</span> Safaris
        </a>
      </div>
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
<section class="relative max-w-7xl mx-auto px-6 py-20 mt-24 flex-1 wave-bg overflow-hidden">

  <!-- Floating icons (decorations) -->
  <i class="fas fa-water floating-icon text-blue-400 text-6xl" style="top:4rem; left:5rem;"></i>
  <i class="fas fa-fish floating-icon text-blue-300 text-5xl" style="bottom:2.5rem; right:8rem;"></i>
  <i class="fas fa-anchor floating-icon text-blue-500 text-4xl" style="top:10rem; right:3rem;"></i>

  <h1 class="text-5xl font-bold text-center text-blue-800 mb-10 fade-in drop-shadow-lg">
    Feedback for <span class="text-blue-500">${promotion.tripName}</span>
  </h1>

  <!-- Add Feedback Form -->
  <div class="bg-white bg-opacity-90 rounded-2xl shadow-2xl p-8 mb-12 backdrop-blur-sm fade-in">
    <h2 class="text-3xl font-semibold text-gray-800 mb-6 flex items-center gap-3">
      <i class="fas fa-comment-dots text-blue-500"></i> Add Your Feedback
    </h2>
    <form id="addFeedbackForm" action="/tourist/feedback/add" method="post" class="space-y-6">
      <input type="hidden" name="promotionId" value="${promotion.id}" />
      <div>
        <label for="feedback" class="block text-sm font-medium text-gray-600 mb-1">Your Feedback</label>
        <textarea id="feedback" name="feedback" rows="4"
                  class="w-full p-4 border border-gray-200 rounded-xl focus:outline-none focus:ring-4 focus:ring-blue-300 transition"
                  required></textarea>
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-600 mb-1">Rating</label>
        <div class="star-rating flex space-x-1 mb-1" id="addStars">
          <span class="star" data-value="1"><i class="fas fa-star"></i></span>
          <span class="star" data-value="2"><i class="fas fa-star"></i></span>
          <span class="star" data-value="3"><i class="fas fa-star"></i></span>
          <span class="star" data-value="4"><i class="fas fa-star"></i></span>
          <span class="star" data-value="5"><i class="fas fa-star"></i></span>
        </div>
        <input type="hidden" id="rating" name="rating" value="0" />
      </div>
      <button type="submit"
              class="bg-blue-600 hover:bg-blue-700 text-white px-8 py-3 rounded-xl shadow-lg transition transform hover:-translate-y-1">
        <i class="fas fa-paper-plane mr-2"></i> Submit Feedback
      </button>
    </form>
  </div>

  <!-- Feedback List -->
  <div class="bg-white bg-opacity-90 rounded-2xl shadow-2xl p-8 backdrop-blur-sm fade-in">
    <h2 class="text-3xl font-semibold text-gray-800 mb-8 flex items-center gap-3">
      <i class="fas fa-comments text-blue-500"></i> What Others Say
    </h2>

    <c:choose>
      <c:when test="${not empty feedbacks}">
        <div class="grid gap-6">
          <c:forEach var="feedback" items="${feedbacks}">
            <div class="feedback-card p-6 rounded-2xl border border-blue-100 flex justify-between items-start relative overflow-hidden fade-in">
              <div>
                <p class="text-gray-900 font-bold text-lg">${feedback.tourist.firstName} ${feedback.tourist.lastName}</p>
                <div class="flex items-center mt-1">
                  <c:forEach begin="1" end="${feedback.rating}">
                    <i class="fas fa-star text-yellow-400"></i>
                  </c:forEach>
                  <c:forEach begin="${feedback.rating + 1}" end="5">
                    <i class="fas fa-star text-gray-300"></i>
                  </c:forEach>
                  <span class="ml-2 text-sm text-gray-500">(${feedback.rating}/5)</span>
                </div>
                <p class="text-gray-700 mt-3 italic">“${feedback.feedback}”</p>
                <p class="text-sm text-gray-400 mt-2">Posted on ${feedback.createdAt}</p>
              </div>

              <c:if test="${sessionScope.user.id == feedback.tourist.id}">
                <div class="space-x-3">
                  <!-- note: data-modal attribute used; JS handles data-modal and data-modal-toggle too -->
                  <button type="button" data-modal="editModal${feedback.id}"
                          class="open-modal text-blue-600 hover:text-blue-800 font-medium transition">Edit</button>
                  <a href="/tourist/feedback/delete/${feedback.id}?promotionId=${promotion.id}"
                     class="text-red-500 hover:text-red-700 font-medium transition"
                     onclick="return confirm('Are you sure you want to delete this feedback?')">Delete</a>
                </div>
              </c:if>
            </div>

            <!-- Edit Modal -->
            <div id="editModal${feedback.id}" class="modal fixed inset-0 justify-center items-center bg-black bg-opacity-50 z-50">
              <div class="bg-white rounded-2xl p-8 shadow-2xl w-full max-w-md mx-4">
                <h3 class="text-2xl font-semibold text-gray-800 mb-4">Edit Feedback</h3>
                <form action="/tourist/feedback/update/${feedback.id}" method="post"
                      class="space-y-4 edit-feedback-form" data-feedback-id="${feedback.id}">
                  <input type="hidden" name="promotionId" value="${promotion.id}" />
                  <textarea name="feedback" rows="4" class="w-full p-3 border border-gray-200 rounded-lg focus:ring-2 focus:ring-blue-500"
                            required>${feedback.feedback}</textarea>

                  <div class="star-rating flex space-x-1" id="editStars${feedback.id}">
                    <span class="star" data-value="1"><i class="fas fa-star"></i></span>
                    <span class="star" data-value="2"><i class="fas fa-star"></i></span>
                    <span class="star" data-value="3"><i class="fas fa-star"></i></span>
                    <span class="star" data-value="4"><i class="fas fa-star"></i></span>
                    <span class="star" data-value="5"><i class="fas fa-star"></i></span>
                  </div>
                  <input type="hidden" id="editRating${feedback.id}" name="rating" value="${feedback.rating}" />

                  <div class="flex justify-end space-x-4 mt-4">
                    <button type="button" class="close-modal bg-gray-300 text-gray-800 px-4 py-2 rounded-lg hover:bg-gray-400">Cancel</button>
                    <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700">Save</button>
                  </div>
                </form>
              </div>
            </div>

          </c:forEach>
        </div>
      </c:when>

      <c:otherwise>
        <p class="text-center text-gray-500 py-8 text-lg italic">No feedbacks yet — be the first to share your experience!</p>
      </c:otherwise>
    </c:choose>
  </div>
</section>

<!-- Footer (left unchanged) -->
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
    © 2025 BlueWave Safaris — Tourist Promotions
  </div>
</footer>

<!-- Scripts: star ratings + modal open/close (robust) -->
<script>
  // Initialize clickable star rating widget for a container and hidden input.
  function initStarRating(containerId, inputId, initialValue = 0) {
    const container = document.getElementById(containerId);
    if (!container) return;
    const stars = Array.from(container.querySelectorAll(".star"));
    const input = document.getElementById(inputId);
    if (!input) return;

    // hover behavior
    stars.forEach((star, idx) => {
      star.addEventListener("mouseover", () => {
        stars.forEach((s, i) => s.classList.toggle("hover", i <= idx));
      });
      star.addEventListener("mouseout", () => {
        stars.forEach(s => s.classList.remove("hover"));
      });
      star.addEventListener("click", () => {
        const rating = idx + 1;
        input.value = rating;
        stars.forEach((s, i) => s.classList.toggle("active", i < rating));
      });
    });

    // set initial
    stars.forEach((s, i) => s.classList.toggle("active", i < Number(initialValue)));
  }

  document.addEventListener("DOMContentLoaded", function () {
    // Add-feedback stars
    initStarRating("addStars", "rating", 0);

    // Initialize edit stars for each feedback item (if present)
    document.querySelectorAll(".edit-feedback-form").forEach(form => {
      const fid = form.dataset.feedbackId;
      const input = form.querySelector(`#editRating${fid}`);
      const initial = input ? input.value : 0;
      initStarRating(`editStars${fid}`, `editRating${fid}`, initial);
    });

    // Use event delegation: open modals for elements with data-modal or data-modal-toggle or class open-modal
    document.addEventListener("click", function (e) {
      // open modal
      const openBtn = e.target.closest("[data-modal], [data-modal-toggle], .open-modal");
      if (openBtn) {
        e.preventDefault();
        const modalId = openBtn.dataset.modal || openBtn.dataset.modalToggle;
        if (!modalId) return;
        const modal = document.getElementById(modalId);
        if (modal) {
          modal.classList.add("active");
          // ensure edit stars inside modal are initialized (in case not done earlier)
          const editForm = modal.querySelector(".edit-feedback-form");
          if (editForm) {
            const fid = editForm.dataset.feedbackId;
            const input = editForm.querySelector(`#editRating${fid}`);
            const initial = input ? input.value : 0;
            initStarRating(`editStars${fid}`, `editRating${fid}`, initial);
          }
        }
        return;
      }

      // close modal via elements with .close-modal or [data-close]
      const closeBtn = e.target.closest(".close-modal, [data-close]");
      if (closeBtn) {
        e.preventDefault();
        const modal = closeBtn.closest(".modal");
        if (modal) modal.classList.remove("active");
        return;
      }
    });

    // click on modal backdrop closes modal
    document.querySelectorAll(".modal").forEach(modal => {
      modal.addEventListener("click", (ev) => {
        if (ev.target === modal) modal.classList.remove("active");
      });
    });

    // esc key closes active modal
    document.addEventListener("keydown", (ev) => {
      if (ev.key === "Escape") {
        document.querySelectorAll(".modal.active").forEach(m => m.classList.remove("active"));
      }
    });

    // Form validation: ensure rating chosen on add and edit forms
    const validateForm = (form) => {
      const ratingInput = form.querySelector('input[name="rating"]');
      const text = form.querySelector('textarea[name="feedback"]');
      if (!ratingInput || Number(ratingInput.value) < 1) {
        alert("Please select a rating (1-5 stars).");
        return false;
      }
      if (!text || !text.value.trim()) {
        alert("Please enter your feedback.");
        return false;
      }
      return true;
    };

    // attach validation to add form
    const addForm = document.getElementById("addFeedbackForm");
    if (addForm) {
      addForm.addEventListener("submit", function (ev) {
        if (!validateForm(this)) ev.preventDefault();
      });
    }

    // attach validation for each edit form
    document.querySelectorAll(".edit-feedback-form").forEach(form => {
      form.addEventListener("submit", function (ev) {
        if (!validateForm(this)) ev.preventDefault();
      });
    });
  });
</script>

</body>
</html>
