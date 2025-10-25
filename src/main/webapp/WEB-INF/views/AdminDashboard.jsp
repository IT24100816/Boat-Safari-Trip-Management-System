<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" x-data="{ formData: { name: '', description: '', time: '', duration: '', price: '', type: '', capacity: '', locationName: '', googleMapsLink: '' } }">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>BlueWave Safaris - Admin Dashboard</title>

    <!-- Tailwind CDN -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <!-- Alpine.js -->
    <script src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js" defer></script>

    <style>


        .underline-grow {
            position: relative;
            display: inline-block;
        }
        .underline-grow::after {
            content: "";
            position: absolute;
            width: 0;
            height: 2px;
            display: block;
            margin-top: 4px;
            right: 0;
            background: #3b82f6;
            transition: width 0.3s ease;
        }
        .underline-grow:hover::after {
            width: 100%;
            left: 0;
            background: #3b82f6;
        }
        /* Custom animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .fade-in { animation: fadeIn 0.8s ease-out forwards; }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        .pulse { animation: pulse 1.5s infinite; }

        /* Gradient background for dashboard */
        .dashboard-bg { background: linear-gradient(135deg, #1e3a8a, #60a5fa); }

        /* Card styling with shadow and hover lift */
        .card-hover { transition: transform 0.3s, box-shadow 0.3s; }
        .card-hover:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2); }

        /* Form input focus animation */
        .input-focus:focus { outline: none; ring: 2px solid #3b82f6; transition: ring 0.2s; }

        /* Error message styling */
        .error-message {
            color: #e53e3e;
            background-color: #fed7d7;
            border: 1px solid #feb2b2;
            padding: 0.75rem;
            border-radius: 0.375rem;
            margin-bottom: 1rem;
        }

        /* Character count styling */
        .char-count {
            font-size: 0.875rem;
            color: #6b7280;
            text-align: right;
            margin-top: 0.25rem;
        }
        .char-count.warning {
            color: #e53e3e;
        }
    </style>
</head>
<body class="bg-gray-100 text-gray-800 dashboard-bg min-h-screen flex flex-col">

<!-- Navbar -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg">
    <div class="max-w-7xl mx-auto px-6">
        <div class="flex items-center justify-between h-24">
            <div class="text-3xl font-extrabold tracking-wide whitespace-nowrap">
                <span class="text-blue-400">BlueWave</span> Safaris - Admin
            </div>
            <div class="hidden lg:flex items-center space-x-8 font-semibold text-lg">
                <a href="/admin/dashboard" class="underline-grow text-blue-400">Dashboard</a>
                <a href="/admin/trips" class="underline-grow">Manage Trips</a>
                <a href="/admin/users" class="underline-grow">Users</a>
                <a href="/admin/boats" class="underline-grow">Boats</a>
                <a href="/admin/bookings" class="underline-grow">Bookings</a>
                <a href="/admin/promotions" class="underline-grow">Promotions</a>
                <a href="/admin/profile" class="underline-grow">Profile</a>
                <a href="/logout" class="text-3xl hover:text-blue-400 transition"><i class="fas fa-sign-out-alt"></i></a>
            </div>
            <button id="menu-btn" class="lg:hidden text-white text-3xl focus:outline-none">
                <i class="fas fa-bars"></i>
            </button>
        </div>
    </div>
    <div id="mobile-menu" class="hidden lg:hidden bg-black px-6 py-4 space-y-4 text-lg">
        <a href="/admin/dashboard" class="block hover:text-blue-400">Dashboard</a>
        <a href="/admin/trips" class="block hover:text-blue-400">Manage Trips</a>
        <a href="/admin/users" class="block hover:text-blue-400">Users</a>
        <a href="/admin/boats" class="block hover:text-blue-400">Boats</a>
        <a href="/admin/bookings" class="block hover:text-blue-400">Bookings</a>
        <a href="/admin/promotions" class="block hover:text-blue-400">Promotions</a>
        <a href="/admin/profile" class="block hover:text-blue-400">Profile</a>
        <a href="/logout" class="block hover:text-blue-400"><i class="fas fa-sign-out-alt mr-2"></i>Logout</a>
    </div>
</nav>

<!-- Hero Header with Animation -->
<header class="relative w-full h-96 pt-24 overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-r from-blue-900 to-blue-500 opacity-80"></div>
    <img src="/Boat_Safari_image_6.jpg" alt="Admin Dashboard Background" class="w-full h-full object-cover pulse"/>
    <div class="absolute inset-0 flex items-center justify-center text-white text-center fade-in">
        <h1 class="text-5xl font-bold mb-4">Admin Dashboard</h1>
        <p class="text-xl">Create and Manage Safari Trips Seamlessly</p>
    </div>
</header>

<!-- Main Content: Create Trip Form -->
<section class="py-16 bg-white">
    <div class="max-w-4xl mx-auto px-6">
        <!-- Error message container -->
        <div id="errorMessage" class="error-message hidden"></div>

        <div class="bg-white rounded-lg shadow-xl p-8 card-hover fade-in">
            <h2 class="text-3xl font-bold text-gray-800 mb-6 text-center">Create New Trip</h2>
            <form id="tripForm" enctype="multipart/form-data" class="space-y-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="name" class="block text-sm font-medium text-gray-700">Trip Name</label>
                        <input id="name" name="name" type="text" required x-model="formData.name" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 input-focus"/>
                    </div>
                    <div>
                        <label for="type" class="block text-sm font-medium text-gray-700">Type</label>
                        <select id="type" name="type" required x-model="formData.type" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 input-focus">
                            <option value="">Select Type</option>
                            <option value="Morning">Morning</option>
                            <option value="Evening">Evening</option>
                            <option value="Private">Private</option>
                        </select>
                    </div>
                    <div>
                        <label for="time" class="block text-sm font-medium text-gray-700">Time</label>
                        <input id="time" name="time" type="time" required x-model="formData.time" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 input-focus"/>
                    </div>
                    <div>
                        <label for="duration" class="block text-sm font-medium text-gray-700">Duration (hours)</label>
                        <input id="duration" name="duration" type="number" min="1" required x-model="formData.duration" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 input-focus"/>
                    </div>
                    <div>
                        <label for="price" class="block text-sm font-medium text-gray-700">Price ($/hour)</label>
                        <input id="price" name="price" type="number" min="0" step="0.01" required x-model="formData.price" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 input-focus"/>
                    </div>
                    <div>
                        <label for="capacity" class="block text-sm font-medium text-gray-700">Capacity</label>
                        <input id="capacity" name="capacity" type="number" min="1" required x-model="formData.capacity" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 input-focus"/>
                    </div>
                </div>
                <div>
                    <label for="locationName" class="block text-sm font-medium text-gray-700">Location</label>
                    <input id="locationName" name="locationName" type="text" required x-model="formData.locationName" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 input-focus"/>
                </div>
                <div>
                    <label for="googleMapsLink" class="block text-sm font-medium text-gray-700">Google Maps Link</label>
                    <input id="googleMapsLink" name="googleMapsLink" type="url" placeholder="https://maps.google.com/..." x-model="formData.googleMapsLink" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 input-focus"/>
                </div>
                <div>
                    <label for="tripPicture" class="block text-sm font-medium text-gray-700">Trip Picture</label>
                    <input id="tripPicture" name="tripPicture" type="file" accept="image/*" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 input-focus"/>
                </div>
                <div>
                    <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
                    <textarea id="description" name="description" rows="4" required x-model="formData.description"
                              maxlength="1000"
                              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 input-focus"
                              oninput="updateCharCount(this)"></textarea>
                    <div id="charCount" class="char-count">0/1000 characters</div>
                </div>
                <div class="text-center">
                    <button type="submit" class="inline-flex items-center px-6 py-3 bg-blue-600 text-white font-semibold rounded-full shadow-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 transition duration-300">
                        <i class="fas fa-plus mr-2"></i> Create Trip
                    </button>
                </div>
            </form>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="bg-black text-white pt-12 mt-auto">
    <div class="max-w-7xl mx-auto px-6 text-center">
        <p class="text-gray-300 mb-4">© 2025 BlueWave Safaris — Admin Dashboard</p>
    </div>
</footer>

<!-- SCRIPTS: mobile menu + animations + AJAX form submission -->
<script>
    // Mobile menu toggle
    const menuBtn = document.getElementById('menu-btn');
    const mobileMenu = document.getElementById('mobile-menu');
    if (menuBtn) {
        menuBtn.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));
    }

    // Apply fade-in animation on load
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.fade-in').forEach((el, index) => {
            el.style.opacity = 0;
            el.style.animationDelay = `${index * 0.2}s`;
            setTimeout(() => el.classList.add('fade-in'), 100);
        });

        // Initialize character count
        updateCharCount(document.getElementById('description'));
    });

    // Character count updater
    function updateCharCount(textarea) {
        const charCount = document.getElementById('charCount');
        const currentLength = textarea.value.length;
        const maxLength = textarea.getAttribute('maxlength');

        charCount.textContent = `${currentLength}/${maxLength} characters`;

        if (currentLength > maxLength * 0.9) {
            charCount.classList.add('warning');
        } else {
            charCount.classList.remove('warning');
        }
    }

    // AJAX form submission
    document.getElementById('tripForm').addEventListener('submit', function(event) {
        event.preventDefault(); // Prevent default form submission

        const formData = new FormData(this);
        const errorMessage = document.getElementById('errorMessage');

        // Validate description length
        const description = document.getElementById('description').value;
        if (description.length > 1000) {
            errorMessage.textContent = 'Description is too long. Maximum 1000 characters allowed.';
            errorMessage.classList.remove('hidden');
            return;
        }

        // Show loading state
        const submitButton = this.querySelector('button[type="submit"]');
        const originalText = submitButton.innerHTML;
        submitButton.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i> Creating...';
        submitButton.disabled = true;

        // Hide any previous error messages
        errorMessage.classList.add('hidden');

        fetch('/admin/create-trip', {
            method: 'POST',
            body: formData,
            headers: {
                'X-Requested-With': 'XMLHttpRequest' // Add this header to identify AJAX requests
            }
        })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(errorData => {
                        throw new Error(errorData.error || 'Network response was not ok');
                    });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    alert(data.success);
                    // Reset form fields
                    this.reset();
                    // Clear Alpine.js formData
                    Alpine.store('formData', {
                        name: '',
                        description: '',
                        time: '',
                        duration: '',
                        price: '',
                        type: '',
                        capacity: '',
                        locationName: '',
                        googleMapsLink: ''
                    });
                    // Reset character count
                    updateCharCount(document.getElementById('description'));
                } else if (data.error) {
                    throw new Error(data.error);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                // Show detailed error message
                errorMessage.textContent = error.message || 'Failed to create trip. Please try again.';
                errorMessage.classList.remove('hidden');
            })
            .finally(() => {
                // Restore button state
                submitButton.innerHTML = originalText;
                submitButton.disabled = false;
            });
    });

    // Ensure Alpine.js integrates with the form
    document.addEventListener('alpine:init', () => {
        Alpine.store('formData', {
            name: '',
            description: '',
            time: '',
            duration: '',
            price: '',
            type: '',
            capacity: '',
            locationName: '',
            googleMapsLink: ''
        });
    });
</script>
</body>
</html>