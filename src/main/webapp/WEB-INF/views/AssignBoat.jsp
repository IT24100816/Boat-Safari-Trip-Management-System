<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>BlueWave Safaris - Assign Boat</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        /* Wave Animation Background */
        .wave-background {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%);
            overflow: hidden;
            z-index: -1;
        }
        .wave {
            position: absolute;
            bottom: -200px;
            left: 0;
            width: 200%;
            height: 200px;
            background: url('data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"%3E%3Cpath fill="%23ffffff" fill-opacity="0.2" d="M0,128L48,138.7C96,149,192,171,288,186.7C384,203,480,213,576,208C672,203,768,181,864,176C960,171,1056,181,1152,181.3C1248,181,1344,171,1392,165.3L1440,160L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"%3E%3C/path%3E%3C/svg%3E');
            animation: wave 7s infinite linear;
            transform: rotate(0deg);
        }
        .wave:nth-child(2) {
            animation: wave 10s infinite linear;
            animation-delay: -3s;
            bottom: -250px;
            opacity: 0.5;
        }
        @keyframes wave {
            0% { transform: translateX(0); }
            100% { transform: translateX(-50%); }
        }

        /* Card Animation */
        .boat-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            overflow: hidden;
        }
        .boat-card:hover {
            transform: translateY(-10px) scale(1.03);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
        }

        /* Slide-in Animation for Cards */
        @keyframes slideIn {
            from { transform: translateY(50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        .slide-in {
            animation: slideIn 0.5s ease-out forwards;
        }

        /* Selected Boat Preview */
        .selected-boat {
            border: 2px solid #3b82f6;
            background: rgba(59, 130, 246, 0.1);
        }

        /* Responsive Adjustments */
        @media (max-width: 640px) {
            .boat-card { margin-bottom: 1rem; }
            .boat-preview img { max-height: 150px; }
        }
    </style>
</head>
<body class="min-h-screen flex flex-col relative text-gray-800 font-sans">
<!-- Wave Background -->
<div class="wave-background">
    <div class="wave"></div>
    <div class="wave"></div>
</div>

<!-- Navbar -->
<nav class="bg-black bg-opacity-90 text-white fixed w-full z-50 shadow-lg backdrop-blur-md">
    <div class="max-w-7xl mx-auto px-6">
        <div class="flex items-center justify-between h-20">
            <div class="flex items-center space-x-4 flex-shrink-0">
                <a href="/boat-driver/dashboard" class="text-3xl font-extrabold tracking-wide text-white flex items-center">
                    <span class="text-blue-400">BlueWave</span> Safaris
                    <i class="fas fa-anchor ml-2 text-blue-300 animate-pulse"></i>
                </a>
            </div>
            <div class="lg:hidden flex items-center">
                <a href="/boat-driver/dashboard" class="text-white text-2xl hover:text-blue-300 transition" aria-label="Back">
                    <i class="fas fa-arrow-left"></i>
                </a>
            </div>
        </div>
    </div>
</nav>

<!-- Main Content -->
<section class="max-w-7xl mx-auto px-6 py-16 flex-1 relative z-10 mt-20">
    <div class="bg-white bg-opacity-95 rounded-xl shadow-2xl p-8 max-w-3xl mx-auto">
        <h2 class="text-3xl font-bold text-gray-800 mb-6 text-center flex items-center justify-center">
            <i class="fas fa-ship text-blue-500 mr-3 animate-bounce"></i> Assign Boat to Booking
        </h2>
        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-6 text-center animate-pulse">
                    ${error}
            </div>
        </c:if>

        <!-- Boat Selection Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
            <c:forEach var="boat" items="${availableBoats}" varStatus="loop">
                <div class="boat-card slide-in" style="animation-delay: ${loop.index * 0.1}s">
                    <div class="relative overflow-hidden">
                        <img src="${boat.imageUrl}" alt="${boat.boatName} Image" class="w-full h-48 object-cover rounded-t-lg">
                        <div class="p-4">
                            <h3 class="text-xl font-semibold text-gray-800">${boat.boatName}</h3>
                            <p class="text-gray-600">Reg: ${boat.registrationNumber}</p>
                            <p class="text-gray-600">Type: ${boat.boatType}</p>
                            <p class="text-gray-600">Capacity: ${boat.capacity} passengers</p>
                            <button type="button" class="mt-4 w-full bg-blue-500 hover:bg-blue-600 text-white py-2 rounded-lg font-medium transition select-boat"
                                    data-boat-id="${boat.id}">
                                <i class="fas fa-check mr-2"></i> Select
                            </button>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Hidden Form for Submission -->
        <form id="assignForm" action="/boat-driver/assign-confirm" method="post" class="space-y-4 hidden">
            <input type="hidden" name="bookingId" value="${bookingId}">
            <input type="hidden" name="boatId" id="selectedBoatId">
            <button type="submit" class="w-full bg-green-500 hover:bg-green-600 text-white py-3 px-6 rounded-lg font-semibold text-lg transition-all duration-300 transform hover:scale-105 flex items-center justify-center">
                <i class="fas fa-paper-plane mr-2"></i> Confirm Assignment
            </button>
        </form>

        <!-- Boat Preview -->
        <div id="boatPreview" class="mt-6 p-6 bg-gray-50 rounded-lg border-2 border-transparent transition-all duration-300">
            <h3 class="text-xl font-semibold text-gray-700 mb-2">Selected Boat Preview</h3>
            <div id="previewContent" class="text-center opacity-0 transition-opacity duration-300">
                <img id="previewImage" src="" alt="Selected Boat Image" class="w-full h-48 object-cover rounded-lg mb-4">
                <p id="previewName" class="text-lg font-medium text-gray-800"></p>
                <p id="previewReg" class="text-gray-600"></p>
                <p id="previewType" class="text-gray-600"></p>
                <p id="previewCapacity" class="text-gray-600"></p>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="bg-black bg-opacity-90 text-white py-6 mt-auto relative z-10">
    <div class="max-w-7xl mx-auto px-6 text-center">
        <p class="text-gray-400 animate-pulse">© 2025 BlueWave Safaris — Boat Driver Dashboard</p>
    </div>
</footer>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const boatCards = document.querySelectorAll('.boat-card');
        const assignForm = document.getElementById('assignForm');
        const selectedBoatIdInput = document.getElementById('selectedBoatId');
        const boatPreview = document.getElementById('boatPreview');
        const previewImage = document.getElementById('previewImage');
        const previewName = document.getElementById('previewName');
        const previewReg = document.getElementById('previewReg');
        const previewType = document.getElementById('previewType');
        const previewCapacity = document.getElementById('previewCapacity');
        let selectedBoat = null;

        boatCards.forEach(card => {
            card.addEventListener('click', (e) => {
                if (e.target.classList.contains('select-boat')) {
                    const boatId = card.querySelector('.select-boat').getAttribute('data-boat-id');
                    selectedBoatIdInput.value = boatId;

                    // Update preview
                    const imgSrc = card.querySelector('img').src;
                    const name = card.querySelector('h3').textContent;
                    const reg = card.querySelector('p:nth-child(2)').textContent;
                    const type = card.querySelector('p:nth-child(3)').textContent;
                    const capacity = card.querySelector('p:nth-child(4)').textContent;

                    previewImage.src = imgSrc;
                    previewName.textContent = name;
                    previewReg.textContent = reg;
                    previewType.textContent = type;
                    previewCapacity.textContent = capacity;
                    boatPreview.classList.add('selected-boat');
                    previewContent.style.opacity = '1';

                    // Show form
                    assignForm.classList.remove('hidden');

                    // Deselect other cards
                    boatCards.forEach(c => c.classList.remove('selected-boat'));
                    card.classList.add('selected-boat');
                    selectedBoat = card;
                }
            });
        });

        // Handle form submission
        assignForm.addEventListener('submit', (e) => {
            if (!selectedBoat) {
                e.preventDefault();
                alert('Please select a boat first!');
            }
        });
    });
</script>
</body>
</html>