<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>BlueWave Safaris - Admin Boats</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        /* Fancy underline animation for navbar links */
        .underline-grow {
            position: relative;
        }
        .underline-grow::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            display: block;
            margin-top: 5px;
            right: 0;
            background: #3b82f6;
            transition: width 0.3s ease, right 0.3s ease;
        }
        .underline-grow:hover::after {
            width: 100%;
            right: 0;
        }
        /* Table row shadow */
        .table-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.15);
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen flex flex-col">

<!-- Navbar -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg">
    <div class="max-w-7xl mx-auto px-6">
        <div class="flex items-center justify-between h-24">
            <div class="text-3xl font-extrabold tracking-wide whitespace-nowrap">
                <span class="text-blue-400">BlueWave</span> Safaris - Admin
            </div>
            <div class="hidden lg:flex items-center space-x-8 font-semibold text-lg">
                <a href="/admin/dashboard" class="underline-grow">Dashboard</a>
                <a href="/admin/trips" class="underline-grow">Manage Trips</a>
                <a href="/admin/users" class="underline-grow">Users</a>
                <a href="/admin/boats" class="underline-grow text-blue-400">Boats</a>
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

<main class="pt-28 pb-12">
    <div class="max-w-7xl mx-auto px-6">
        <h1 class="text-4xl font-bold mb-8 text-blue-900">Manage Boats</h1>

        <c:if test="${not empty errorMessage}">
            <div class="bg-red-100 border border-red-400 text-red-700 p-4 rounded mb-6 shadow-sm">
                <i class="fas fa-exclamation-triangle mr-2"></i>${errorMessage}
            </div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="bg-green-100 border border-green-400 text-green-700 p-4 rounded mb-6 shadow-sm">
                <i class="fas fa-check-circle mr-2"></i>${successMessage}
            </div>
        </c:if>

        <div class="overflow-x-auto">
            <table class="min-w-full bg-white rounded-lg shadow-lg overflow-hidden">
                <thead class="bg-blue-600 text-white">
                <tr>
                    <th class="py-3 px-4 text-left">ID</th>
                    <th class="py-3 px-4 text-left">Boat Name</th>
                    <th class="py-3 px-4 text-left">Boat Type</th>
                    <th class="py-3 px-4 text-left">Capacity</th>
                    <th class="py-3 px-4 text-left">Registration Number</th>
                    <th class="py-3 px-4 text-left">Status</th>
                    <th class="py-3 px-4 text-left">Driver ID</th>
                    <th class="py-3 px-4 text-left">Driver Name</th>
                    <th class="py-3 px-4 text-left">Image</th>
                    <th class="py-3 px-4 text-left">Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="boat" items="${boats}">
                    <tr class="border-b table-card transition-transform duration-300">
                        <td class="py-3 px-4">${boat.id}</td>
                        <td class="py-3 px-4 font-semibold text-blue-900">${boat.boatName}</td>
                        <td class="py-3 px-4">${boat.boatType}</td>
                        <td class="py-3 px-4">${boat.capacity}</td>
                        <td class="py-3 px-4">${boat.registrationNumber}</td>
                        <td class="py-3 px-4">
                            <span class="${boat.status == 'Available' ? 'text-green-600 font-semibold' : 'text-red-600 font-semibold'}">
                                    ${boat.status}
                            </span>
                        </td>
                        <td class="py-3 px-4">${boat.driverId}</td>
                        <td class="py-3 px-4">${boat.driverName}</td>
                        <td class="py-3 px-4">
                            <c:if test="${not empty boat.imageUrl}">
                                <img src="${boat.imageUrl}" alt="Boat Image" class="w-20 h-20 object-cover rounded-lg border border-gray-200 shadow-sm"/>
                            </c:if>
                            <c:if test="${empty boat.imageUrl}">
                                <span class="text-gray-400 italic">No Image</span>
                            </c:if>
                        </td>
                        <td class="py-3 px-4">
                            <form action="/admin/boats/remove" method="post" class="flex flex-col">
                                <input type="hidden" name="id" value="${boat.id}"/>
                                <button type="submit" class="bg-red-500 text-white px-4 py-2 rounded-lg hover:bg-red-600 transition flex items-center justify-center gap-2">
                                    <i class="fas fa-trash-alt"></i> Remove
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</main>

<footer class="bg-black text-white pt-12 mt-auto">
    <div class="max-w-7xl mx-auto px-6 text-center">
        <p class="text-gray-300 mb-4">© 2025 BlueWave Safaris — Admin Dashboard</p>
    </div>
</footer>

<script>
    const menuBtn = document.getElementById('menu-btn');
    const mobileMenu = document.getElementById('mobile-menu');
    if (menuBtn) {
        menuBtn.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));
    }
</script>
</body>
</html>
