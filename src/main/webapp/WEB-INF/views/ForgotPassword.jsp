<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>BlueWave Safaris - Forgot Password</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body class="bg-gray-900 flex items-center justify-center min-h-screen relative overflow-hidden">

<!-- Background Image -->
<div class="absolute inset-0">
    <img src="/Boat_Safari_image_2.jpg" class="w-full h-full object-cover" alt="Safari Background"/>
    <div class="absolute inset-0 bg-black bg-opacity-60"></div>
</div>

<!-- Forgot Password Card -->
<div class="relative z-10 w-[90%] max-w-2xl bg-white/10 backdrop-blur-md p-10 rounded-2xl shadow-2xl">
    <h2 class="text-3xl font-bold text-white mb-6 text-center">Reset Your Password</h2>

    <!-- Success/Error Messages -->
    <c:if test="${not empty success}">
        <p class="text-green-500 mb-4 text-center">${success}</p>
    </c:if>
    <c:if test="${not empty error}">
        <p class="text-red-500 mb-4 text-center">${error}</p>
    </c:if>

    <form action="/forgot-password" method="post" class="space-y-4">
        <input type="text" name="firstName" placeholder="First Name" required
               class="w-full px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-400"/>
        <input type="text" name="lastName" placeholder="Last Name" required
               class="w-full px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-400"/>
        <input type="email" name="email" placeholder="Email" required
               class="w-full px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-400"/>
        <input type="text" name="nic" placeholder="NIC" required
               class="w-full px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-400"/>
        <input type="tel" name="phone" placeholder="Phone Number" required
               class="w-full px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-400"/>
        <input type="password" name="newPassword" placeholder="New Password" required
               class="w-full px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-400"/>
        <input type="password" name="confirmPassword" placeholder="Confirm New Password" required
               class="w-full px-4 py-3 rounded-lg bg-white/20 text-white placeholder-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-400"/>

        <button type="submit" class="w-full py-3 bg-blue-500 hover:bg-blue-600 text-white font-semibold rounded-lg shadow-md transition">Reset Password</button>
        <a href="/login" class="block text-center text-sm text-blue-300 hover:underline mt-4">Back to Login</a>
    </form>
</div>
</body>
</html>