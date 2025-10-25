<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>BlueWave Safaris - Login</title>

    <!-- Tailwind CDN -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <!-- Alpine.js -->
    <script src="https://unpkg.com/alpinejs@3.13.3/dist/cdn.min.js" defer></script>

    <style>
        .role-required-field {
            display: none;
        }
    </style>
</head>
<body class="bg-gray-900 flex items-center justify-center min-h-screen relative overflow-hidden">

<!-- Background Image -->
<div class="absolute inset-0">
    <img src="/Boat_Safari_image_2.jpg" class="w-full h-full object-cover" alt="Safari Background"/>
    <div class="absolute inset-0 bg-black bg-opacity-60"></div>
</div>

<!-- Login/Register Card -->
<div x-data="{ isSignUp: false, selectedRole: '' }"
     class="relative z-10 flex flex-col md:flex-row w-[90%] max-w-5xl shadow-2xl rounded-2xl overflow-hidden">

    <!-- Left Side: Welcome / Image -->
    <div class="hidden md:flex w-1/2 bg-gradient-to-br from-blue-500 to-blue-700 p-12 text-white flex-col justify-center items-center text-center">
        <h2 class="text-4xl font-bold mb-6">🌊 BlueWave Safaris</h2>
        <p class="text-lg mb-8">Embark on your next adventure with us. Sign in or create an account to get started!</p>
        <img src="/Boat_Safari_image_1.jpg" alt="Safari Adventure" class="rounded-xl shadow-lg w-72 hover:scale-105 transition"/>
    </div>

    <!-- Right Side: Form -->
    <div class="w-full md:w-1/2 bg-white/10 backdrop-blur-md p-10 flex flex-col justify-center">

        <!-- Sign In -->
        <div x-show="!isSignUp" x-transition>
            <h2 class="text-3xl font-bold text-white mb-6">Welcome Back</h2>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <p class="text-red-500 mb-4">${error}</p>
            </c:if>

            <!-- Social Buttons -->
            <div class="flex gap-4 justify-center mb-6">
                <a href="#" class="bg-white/20 hover:bg-blue-500 p-3 rounded-full text-white transition"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="bg-white/20 hover:bg-red-500 p-3 rounded-full text-white transition"><i class="fab fa-google"></i></a>
                <a href="#" class="bg-white/20 hover:bg-blue-400 p-3 rounded-full text-white transition"><i class="fab fa-linkedin-in"></i></a>
            </div>

            <form action="/login" method="post" class="space-y-4">
                <input type="email" name="email" placeholder="Email" required
                       class="w-full px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-400"/>
                <input type="password" name="password" placeholder="Password" required
                       class="w-full px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-400"/>
                <a href="/forgot-password" class="text-sm text-blue-300 hover:underline">Forgot your password?</a>

                <button type="submit" class="w-full py-3 bg-blue-500 hover:bg-blue-600 text-white font-semibold rounded-lg shadow-md transition">Sign In</button>
                <button type="button" @click="isSignUp = true; selectedRole = '';"
                        class="w-full py-3 bg-white/20 hover:bg-white/30 text-white font-semibold rounded-lg shadow-md transition">Create Account</button>
            </form>
        </div>

        <!-- Sign Up -->
        <div x-show="isSignUp" x-transition>
            <h2 class="text-3xl font-bold text-white mb-6">Create Account</h2>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <p class="text-red-500 mb-4">${error}</p>
            </c:if>

            <form action="/register" method="post" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <input type="text" name="firstName" placeholder="First Name" required class="col-span-1 px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:ring-2 focus:ring-blue-400"/>
                <input type="text" name="lastName" placeholder="Last Name" required class="col-span-1 px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:ring-2 focus:ring-blue-400"/>
                <input type="email" name="email" placeholder="Email" required class="col-span-2 px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:ring-2 focus:ring-blue-400"/>
                <input type="password" name="password" placeholder="Password" required class="col-span-1 px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:ring-2 focus:ring-blue-400"/>
                <input type="password" name="confirmPassword" placeholder="Confirm Password" required class="col-span-1 px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:ring-2 focus:ring-blue-400"/>
                <input type="text" name="nic" placeholder="NIC" required class="col-span-1 px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:ring-2 focus:ring-blue-400"/>
                <input type="number" name="age" placeholder="Age" required class="col-span-1 px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:ring-2 focus:ring-blue-400"/>
                <input type="tel" name="phone" placeholder="Phone Number" required class="col-span-2 px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:ring-2 focus:ring-blue-400"/>

                <select name="role" x-model="selectedRole" required class="col-span-2 px-4 py-3 rounded-lg bg-white/20 text-white focus:ring-2 focus:ring-blue-400">
                    <option value="" disabled selected>Select Role</option>
                    <option value="Tourist">Tourist</option>
                    <option value="Boat Driver">Boat Driver</option>
                    <option value="Tour Guide">Tour Guide</option>
                </select>

                <div x-show="selectedRole === 'Boat Driver'" class="col-span-2">
                    <input type="text" name="licenseNumber" placeholder="License Number (Required for Boat Drivers)" class="w-full px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:ring-2 focus:ring-blue-400" required x-bind:required="selectedRole === 'Boat Driver'"/>
                </div>

                <div x-show="selectedRole === 'Tour Guide'" class="col-span-2">
                    <select name="language" class="w-full px-4 py-3 rounded-lg bg-white/20 text-white focus:ring-2 focus:ring-blue-400" required x-bind:required="selectedRole === 'Tour Guide'">
                        <option value="" disabled selected>Select Language</option>
                        <option value="English">English</option>
                        <option value="Sinhala">Sinhala</option>
                        <option value="Tamil">Tamil</option>
                    </select>
                </div>

                <button type="submit" class="col-span-2 py-3 bg-blue-500 hover:bg-blue-600 text-white font-semibold rounded-lg shadow-md transition">Sign Up</button>
                <button type="button" @click="isSignUp = false; selectedRole = '';"
                        class="col-span-2 py-3 bg-white/20 hover:bg-white/30 text-white font-semibold rounded-lg shadow-md transition">Back to Sign In</button>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('alpine:init', () => {
        Alpine.data('formData', () => ({
            isSignUp: false,
            selectedRole: '',
            initialize() {
                this.$watch('selectedRole', (value) => {
                    console.log('Selected role changed to:', value);
                });
            }
        }));
    });
</script>