<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>BlueWave Safaris - Booking Manager</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* Fade Animation */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .fade-in-up {
            animation: fadeInUp 0.8s ease-out forwards;
        }

        /* Bounce Animation for Buttons */
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-10px); }
            60% { transform: translateY(-5px); }
        }
        .bounce-on-hover:hover {
            animation: bounce 0.8s ease-in-out;
        }

        /* Card Shadow and Hover Effect */
        .card-hover {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .card-hover:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }

        /* Custom Styles */
        .form-section {
            margin-bottom: 20px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
        }
        .input-field {
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .input-field:focus {
            border-color: #4dd0e1;
            box-shadow: 0 0 5px rgba(77, 208, 225, 0.5);
        }
        .select-field {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='currentColor' class='w-4 h-4 absolute right-2 top-1/2 transform -translate-y-1/2 text-gray-400'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.5rem center;
        }
    </style>
</head>
<body class="bg-white text-gray-800 min-h-screen flex flex-col font-sans">
<!-- Navbar -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg">
    <div class="max-w-7xl mx-auto px-6">
        <div class="flex items-center justify-between h-24">
            <div class="flex items-center space-x-4 flex-shrink-0">
                <i class="fas fa-anchor text-3xl text-blue-300 animate-bounce"></i>
                <div class="text-3xl font-extrabold tracking-wide">
                    <span class="text-blue-200">BlueWave</span> Safaris - Booking Manager
                </div>
            </div>
            <div class="hidden lg:flex items-center space-x-8 font-semibold text-lg">
                <a href="/booking-manager/dashboard" class="hover:text-blue-200 transition flex items-center">
                    <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
                </a>
                <a href="/available-bookings" class="hover:text-blue-200 transition flex items-center">
                    <i class="fas fa-calendar-check mr-2"></i> Available Bookings
                </a>
                <a href="/booking-manager/profile" class="hover:text-blue-200 transition flex items-center">
                    <i class="fas fa-user mr-2"></i> Profile
                </a>
                <a href="/logout" class="text-3xl hover:text-blue-200 transition" aria-label="Logout">
                    <i class="fas fa-sign-out-alt"></i>
                </a>
            </div>
            <div class="lg:hidden flex items-center">
                <button id="menu-btn" class="text-white text-3xl focus:outline-none" aria-label="Open menu">
                    <i class="fas fa-bars"></i>
                </button>
            </div>
        </div>
    </div>
    <div id="mobile-menu" class="hidden lg:hidden bg-black px-6 py-4 space-y-4 text-lg">
        <a href="/booking-manager/dashboard" class="block hover:text-blue-200 transition flex items-center">
            <i class="fas fa-tachometer-alt mr-2"></i> Dashboard
        </a>
        <a href="/available-bookings" class="block hover:text-blue-200 transition flex items-center">
            <i class="fas fa-calendar-check mr-2"></i> Available Bookings
        </a>
        <a href="/booking-manager/profile" class="block hover:text-blue-200 transition flex items-center">
            <i class="fas fa-user mr-2"></i> Profile
        </a>
        <a href="/logout" class="block hover:text-blue-200 transition flex items-center">
            <i class="fas fa-sign-out-alt mr-2"></i> Logout
        </a>
    </div>
</nav>

<!-- Header -->
<header class="pt-28">
    <div class="max-w-7xl mx-auto px-6 text-center">
        <h1 class="text-5xl font-bold text-gray-900 bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-blue-300 animate-pulse">
            Welcome, <c:out value="${sessionScope.username}"/>
        </h1>
        <p class="mt-4 text-xl text-gray-700">Manage Your Bookings with Ease</p>
    </div>
</header>

<!-- Success/Error Messages with Icons -->
<c:if test="${not empty successMessage}">
    <div class="max-w-7xl mx-auto px-6 mt-4">
        <div class="bg-green-100 border border-green-400 text-green-700 px-6 py-4 rounded-lg relative fade-in-up flex items-center">
            <i class="fas fa-check-circle text-2xl mr-3"></i>
            <strong class="font-bold">Success!</strong>
            <span class="ml-2">${successMessage}</span>
        </div>
    </div>
</c:if>
<c:if test="${not empty errorMessage}">
    <div class="max-w-7xl mx-auto px-6 mt-4">
        <div class="bg-red-100 border border-red-400 text-red-700 px-6 py-4 rounded-lg relative fade-in-up flex items-center">
            <i class="fas fa-exclamation-triangle text-2xl mr-3"></i>
            <strong class="font-bold">Error!</strong>
            <span class="ml-2">${errorMessage}</span>
        </div>
    </div>
</c:if>

<!-- Main Content with Card Design -->
<section class="max-w-7xl mx-auto px-6 py-12 flex-1">
    <div class="bg-white rounded-xl shadow-2xl p-8 mb-8 form-section fade-in-up card-hover">
        <h2 class="text-3xl font-bold text-gray-900 mb-6 flex items-center">
            <i class="fas fa-plus-circle text-blue-500 mr-3 animate-spin-slow"></i> Create New Booking
        </h2>
        <form action="/booking-manager/add-booking" method="post" id="bookingForm" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

            <div class="mb-6">
                <label class="block text-gray-700 text-sm font-semibold mb-2 flex items-center">
                    <i class="fas fa-user-tie text-blue-500 mr-2"></i> Tourist Name *
                </label>
                <select name="touristId" id="touristSelect" required class="w-full p-3 border border-gray-300 rounded-lg input-field select-field focus:outline-none">
                    <option value="">Select Tourist</option>
                </select>
                <input type="hidden" name="touristName" id="touristName">
                <input type="hidden" name="touristNic" id="touristNic">
            </div>

            <div class="mb-6">
                <label class="block text-gray-700 text-sm font-semibold mb-2 flex items-center">
                    <i class="fas fa-users text-blue-500 mr-2"></i> Passengers *
                </label>
                <input type="number" name="passengers" min="1" required class="w-full p-3 border border-gray-300 rounded-lg input-field focus:outline-none">
            </div>

            <div class="mb-6">
                <label class="block text-gray-700 text-sm font-semibold mb-2 flex items-center">
                    <i class="fas fa-clock text-blue-500 mr-2"></i> Hours *
                </label>
                <input type="number" name="hours" step="0.5" min="1" required class="w-full p-3 border border-gray-300 rounded-lg input-field focus:outline-none">
            </div>

            <div class="mb-6">
                <label class="block text-gray-700 text-sm font-semibold mb-2 flex items-center">
                    <i class="fas fa-dollar-sign text-blue-500 mr-2"></i> Total Amount ($) *
                </label>
                <input type="number" name="totalAmount" step="0.01" min="0" required class="w-full p-3 border border-gray-300 rounded-lg input-field focus:outline-none">
            </div>

            <div class="mb-6">
                <label class="block text-gray-700 text-sm font-semibold mb-2 flex items-center">
                    <i class="fas fa-calendar-day text-blue-500 mr-2"></i> Booking Date *
                </label>
                <input type="date" name="bookingDate" required class="w-full p-3 border border-gray-300 rounded-lg input-field focus:outline-none">
            </div>

            <div class="mb-6">
                <label class="block text-gray-700 text-sm font-semibold mb-2 flex items-center">
                    <i class="fas fa-ship text-blue-500 mr-2"></i> Boat Name *
                </label>
                <select name="boatId" id="boatSelect" required class="w-full p-3 border border-gray-300 rounded-lg input-field select-field focus:outline-none">
                    <option value="">Select Boat</option>
                </select>
                <input type="hidden" name="boatName" id="boatName">
                <input type="hidden" name="boatRegistrationNumber" id="boatRegistrationNumber">
                <input type="hidden" name="boatCapacity" id="boatCapacity">
            </div>

            <div class="mb-6">
                <label class="block text-gray-700 text-sm font-semibold mb-2 flex items-center">
                    <i class="fas fa-user-captain text-blue-500 mr-2"></i> Boat Driver Name *
                </label>
                <select name="driverId" id="driverSelect" required class="w-full p-3 border border-gray-300 rounded-lg input-field select-field focus:outline-none">
                    <option value="">Select Driver</option>
                </select>
                <input type="hidden" name="driverName" id="driverName">
                <input type="hidden" name="driverLicenseNumber" id="driverLicenseNumber">
                <input type="hidden" name="driverPhone" id="driverPhone">
            </div>

            <div class="mb-6">
                <label class="block text-gray-700 text-sm font-semibold mb-2 flex items-center">
                    <i class="fas fa-calendar-check text-blue-500 mr-2"></i> Assigned Date *
                </label>
                <input type="date" name="assignedDate" required class="w-full p-3 border border-gray-300 rounded-lg input-field focus:outline-none">
            </div>

            <div class="mb-6">
                <label class="block text-gray-700 text-sm font-semibold mb-2 flex items-center">
                    <i class="fas fa-map-marked-alt text-blue-500 mr-2"></i> Trip Name *
                </label>
                <select name="tripId" id="tripSelect" required class="w-full p-3 border border-gray-300 rounded-lg input-field select-field focus:outline-none">
                    <option value="">Select Trip</option>
                </select>
                <input type="hidden" name="tripName" id="tripName">
            </div>

            <div class="mb-6">
                <label class="block text-gray-700 text-sm font-semibold mb-2 flex items-center">
                    <i class="fas fa-info-circle text-blue-500 mr-2"></i> Status *
                </label>
                <select name="status" required class="w-full p-3 border border-gray-300 rounded-lg input-field select-field focus:outline-none">
                    <option value="Assigned">Assigned</option>
                    <option value="In Progress">In Progress</option>
                    <option value="Completed">Completed</option>
                    <option value="Cancelled">Cancelled</option>
                </select>
            </div>

            <div class="mb-6 md:col-span-2 lg:col-span-3">
                <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-lg focus:outline-none focus:shadow-outline bounce-on-hover flex items-center">
                    <i class="fas fa-plus mr-2"></i> Add Booking
                </button>
            </div>
        </form>
    </div>
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
    document.addEventListener('DOMContentLoaded', function() {
        const menuBtn = document.getElementById('menu-btn');
        const mobileMenu = document.getElementById('mobile-menu');
        if (menuBtn && mobileMenu) {
            menuBtn.addEventListener('click', () => {
                mobileMenu.classList.toggle('hidden');
                menuBtn.classList.toggle('text-blue-300');
            });
        }

        const today = new Date().toISOString().split('T')[0];
        document.querySelector('input[name="bookingDate"]').value = today;
        document.querySelector('input[name="assignedDate"]').value = today;

        // Fetch and populate dropdowns with animation
        $.get('/api/tourists', function(data) {
            const select = $('#touristSelect');
            select.append(data).addClass('fade-in-up');
            select.on('change', function() {
                const selectedOption = $(this).find('option:selected');
                $('#touristName').val(selectedOption.data('name'));
                $('#touristNic').val(selectedOption.data('nic'));
            });
        });

        $.get('/api/boats', function(data) {
            const select = $('#boatSelect');
            select.append(data).addClass('fade-in-up');
            select.on('change', function() {
                const selectedOption = $(this).find('option:selected');
                $('#boatName').val(selectedOption.data('name'));
                $('#boatRegistrationNumber').val(selectedOption.data('registration'));
                $('#boatCapacity').val(selectedOption.data('capacity'));
            });
        });

        $.get('/api/drivers', function(data) {
            const select = $('#driverSelect');
            select.append(data).addClass('fade-in-up');
            select.on('change', function() {
                const selectedOption = $(this).find('option:selected');
                $('#driverName').val(selectedOption.data('name'));
                $('#driverLicenseNumber').val(selectedOption.data('license'));
                $('#driverPhone').val(selectedOption.data('phone'));
            });
        });

        $.get('/api/trips', function(data) {
            const select = $('#tripSelect');
            select.append(data).addClass('fade-in-up');
            select.on('change', function() {
                const selectedOption = $(this).find('option:selected');
                $('#tripName').val(selectedOption.data('name'));
            });
        });

        document.querySelectorAll('.fade-in-up').forEach((el, index) => {
            el.style.opacity = 0;
            el.style.animationDelay = `${index * 0.3}s`;
            setTimeout(() => el.classList.add('fade-in-up'), 200);
        });
    });
</script>
<style>
    /* Slow Spin Animation for Icon */
    @keyframes spin-slow {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }
    .animate-spin-slow {
        animation: spin-slow 4s linear infinite;
    }
</style>
</body>
</html>