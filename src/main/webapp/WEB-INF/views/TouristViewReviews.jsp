<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Traveler Stories - BlueWave Safaris</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        @keyframes shimmer {
            0% { background-position: -200px 0; }
            100% { background-position: 200px 0; }
        }

        .animate-fade-in-up {
            animation: fadeInUp 0.6s ease-out forwards;
        }

        .animate-float {
            animation: float 3s ease-in-out infinite;
        }

        .review-card {
            opacity: 0;
            animation: fadeInUp 0.6s ease-out forwards;
        }

        .review-card:nth-child(1) { animation-delay: 0.1s; }
        .review-card:nth-child(2) { animation-delay: 0.2s; }
        .review-card:nth-child(3) { animation-delay: 0.3s; }
        .review-card:nth-child(4) { animation-delay: 0.4s; }
        .review-card:nth-child(5) { animation-delay: 0.5s; }

        .water-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .ocean-waves {
            background: linear-gradient(180deg, #0ea5e9 0%, #3b82f6 50%, #1d4ed8 100%);
            position: relative;
            overflow: hidden;
        }

        .ocean-waves::before {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 100px;
            background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1200 120' preserveAspectRatio='none'%3E%3Cpath d='M321.39,56.44c58-10.79,114.16-30.13,172-41.86,82.39-16.72,168.19-17.73,250.45-.39C823.78,31,906.67,72,985.66,92.83c70.05,18.48,146.53,26.09,214.34,3V0H0V27.35A600.21,600.21,0,0,0,321.39,56.44Z' fill='%23f8fafc'%3E%3C/path%3E%3C/svg%3E");
            background-size: cover;
        }

        .star-rating .star {
            color: #d1d5db;
        }

        .star-rating .star.active {
            color: #fbbf24;
        }

        .image-gallery {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 8px;
        }

        .gallery-image {
            width: 100%;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .gallery-image:hover {
            transform: scale(1.05);
        }

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.9);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .modal-content {
            max-width: 90%;
            max-height: 90%;
            position: relative;
        }

        .modal-content img {
            max-width: 100%;
            max-height: 100%;
            border-radius: 12px;
        }

        .close-modal {
            position: absolute;
            top: -40px;
            right: 0;
            color: white;
            font-size: 30px;
            cursor: pointer;
        }

        .quote-mark {
            font-size: 4rem;
            color: #3b82f6;
            opacity: 0.2;
            line-height: 1;
        }

        .review-content {
            position: relative;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-blue-50 via-white to-cyan-50 min-h-screen flex flex-col">

<!-- Navbar -->
<nav class="bg-black text-white fixed top-0 w-full z-50 shadow-lg">
    <div class="max-w-7xl mx-auto px-6">
        <div class="flex items-center justify-between h-20">
            <div class="flex items-center space-x-3 flex-shrink-0">
                <i class="fas fa-ship text-3xl text-blue-400 animate-float"></i>
                <a href="/tourist/promotions" class="text-2xl font-extrabold tracking-wide whitespace-nowrap">
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

<!-- Hero Section -->
<div class="ocean-waves pt-32 pb-24 text-white relative">
    <div class="max-w-6xl mx-auto px-6 text-center relative z-10">
        <div class="animate-float inline-block mb-6">
            <i class="fas fa-book-open text-6xl text-white opacity-90"></i>
        </div>
        <h1 class="text-5xl font-bold mb-4 animate-fade-in-up">Traveler Stories</h1>
        <p class="text-xl opacity-90 max-w-2xl mx-auto animate-fade-in-up" style="animation-delay: 0.2s;">
            Real experiences from fellow adventurers on <strong class="text-blue-200">${trip.name}</strong>
        </p>
        <div class="mt-6 flex items-center justify-center space-x-4 text-blue-200 animate-fade-in-up" style="animation-delay: 0.4s;">
            <i class="fas fa-user-tie"></i>
            <span>Curated by Tour Guide: ${not empty tourGuide ? tourGuide.firstName : 'Our Team'}</span>
        </div>
    </div>
</div>

<!-- Main Content -->
<main class="max-w-6xl mx-auto px-6 py-12 -mt-16 relative z-10">
    <c:if test="${not empty success}">
        <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-6 rounded-lg mb-8 shadow-lg animate-fade-in-up" role="alert">
            <div class="flex items-center">
                <i class="fas fa-check-circle text-xl mr-3"></i>
                <p class="font-semibold">${success}</p>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-6 rounded-lg mb-8 shadow-lg animate-fade-in-up" role="alert">
            <div class="flex items-center">
                <i class="fas fa-exclamation-circle text-xl mr-3"></i>
                <p class="font-semibold">${error}</p>
            </div>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty reviews}">
            <div class="space-y-8">
                <c:forEach var="review" items="${reviews}">
                    <!-- Review Card -->
                    <div class="review-card bg-white rounded-2xl shadow-xl border border-gray-100 overflow-hidden transform transition-all duration-300 hover:shadow-2xl">
                        <!-- Review Header -->
                        <div class="bg-gradient-to-r from-blue-500 to-cyan-500 text-white p-6">
                            <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between">
                                <div class="flex items-center space-x-4 mb-4 lg:mb-0">
                                    <div class="w-16 h-16 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                                        <i class="fas fa-user text-2xl"></i>
                                    </div>
                                    <div>
                                        <h3 class="text-xl font-bold">Adventurer's Experience</h3>
                                        <div class="flex items-center space-x-2 mt-1">
                                            <div class="star-rating flex space-x-1">
                                                <c:forEach begin="1" end="5">
                                                    <span class="star ${review.rating >= it.index ? 'active' : ''}">
                                                        <i class="fas fa-star"></i>
                                                    </span>
                                                </c:forEach>
                                            </div>
                                            <span class="text-blue-100 text-sm">${review.rating}/5 Stars</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="text-blue-100 text-sm">
                                    <i class="far fa-calendar mr-2"></i>
                                    <fmt:formatDate value="${review.date}" pattern="MMMM d, yyyy" />
                                </div>
                            </div>
                        </div>

                        <!-- Review Content -->
                        <div class="p-8">
                            <!-- First Paragraph -->
                            <div class="review-content mb-8">
                                <div class="quote-mark absolute -top-4 -left-2">"</div>
                                <p class="text-gray-700 text-lg leading-relaxed relative z-10">
                                        ${review.paragraph1}
                                </p>
                            </div>

                            <!-- Image Gallery -->
                            <c:if test="${not empty review.imageUrls}">
                                <div class="mb-8">
                                    <h4 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                                        <i class="fas fa-camera text-blue-500 mr-3"></i>
                                        Memorable Moments
                                    </h4>
                                    <div class="image-gallery">
                                        <c:forTokens var="imageUrl" items="${review.imageUrls}" delims=",">
                                            <img src="${imageUrl}"
                                                 alt="Travel memory"
                                                 class="gallery-image"
                                                 onclick="openModal('${imageUrl}')">
                                        </c:forTokens>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Second Paragraph -->
                            <div class="review-content">
                                <p class="text-gray-700 text-lg leading-relaxed">
                                        ${review.paragraph2}
                                </p>
                            </div>

                            <!-- Review Footer -->
                            <div class="mt-6 pt-6 border-t border-gray-200">
                                <div class="flex items-center justify-between text-sm text-gray-500">
                                    <div class="flex items-center space-x-2">
                                        <i class="fas fa-compass text-blue-500"></i>
                                        <span>${trip.name} Experience</span>
                                    </div>
                                    <div class="flex items-center space-x-2">
                                        <i class="fas fa-user-tie text-green-500"></i>
                                        <span>Documented by Tour Guide</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>

        <c:otherwise>
            <!-- No Reviews State -->
            <div class="text-center py-16 animate-fade-in-up">
                <div class="max-w-md mx-auto">
                    <i class="fas fa-book-open text-6xl text-gray-300 mb-6"></i>
                    <h3 class="text-2xl font-semibold text-gray-500 mb-4">No Stories Yet</h3>
                    <p class="text-gray-400 text-lg mb-6">
                        Be the first to create unforgettable memories on this adventure!
                    </p>
                    <div class="bg-blue-50 border border-blue-200 rounded-xl p-6">
                        <i class="fas fa-info-circle text-blue-500 text-xl mb-2"></i>
                        <p class="text-blue-700 text-sm">
                            Our tour guide will share amazing stories from this journey soon!
                        </p>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Back Button -->
    <div class="text-center mt-12 animate-fade-in-up" style="animation-delay: 0.6s;">
        <a href="/reviews"
           class="inline-flex items-center space-x-3 bg-blue-500 text-white px-8 py-4 rounded-xl font-semibold hover:bg-blue-600 transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl">
            <i class="fas fa-arrow-left"></i>
            <span>Back to All Adventures</span>
        </a>
    </div>
</main>

<!-- Image Modal -->
<div id="imageModal" class="modal">
    <div class="modal-content">
        <span class="close-modal" onclick="closeModal()">&times;</span>
        <img id="modalImage" src="" alt="Enlarged view">
    </div>
</div>

<!-- Footer -->
<footer class="bg-black text-white py-8 mt-20">
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

<script>
    function openModal(imageUrl) {
        const modal = document.getElementById('imageModal');
        const modalImage = document.getElementById('modalImage');
        modalImage.src = imageUrl;
        modal.style.display = "flex";
    }

    function closeModal() {
        const modal = document.getElementById('imageModal');
        modal.style.display = "none";
    }

    // Close modal when clicking outside the image
    document.getElementById('imageModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });

    // Close modal with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeModal();
        }
    });

    // Add loading animation to images
    document.addEventListener('DOMContentLoaded', function() {
        const images = document.querySelectorAll('.gallery-image');
        images.forEach(img => {
            img.addEventListener('load', function() {
                this.style.opacity = "1";
            });
        });
    });
</script>

</body>
</html>