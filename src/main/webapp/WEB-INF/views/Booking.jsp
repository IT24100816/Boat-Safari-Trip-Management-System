<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.boatsafari.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>BlueWave Safaris - Booking</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body class="bg-gradient-to-r from-blue-50 to-indigo-100 text-gray-800 min-h-screen flex flex-col">

<!-- Navbar -->
<nav class="bg-gradient-to-r from-black via-gray-900 to-black text-white fixed top-0 w-full z-50 shadow-lg">
    <div class="max-w-7xl mx-auto px-6">
        <div class="flex items-center justify-between h-20">
            <div class="flex items-center space-x-3 flex-shrink-0">
                <i class="fas fa-ship text-3xl text-blue-400 animate-bounce"></i>
                <a href="/" class="text-2xl font-extrabold tracking-wide whitespace-nowrap">
                    <span class="text-blue-400">BlueWave</span> Safaris
                </a>
            </div>
            <div class="flex items-center space-x-6">
                <c:if test="${not empty user}">
          <span class="text-white font-medium">👋 Welcome,
            <span class="text-blue-400">${user.firstName} ${user.lastName}</span>
          </span>
                </c:if>
                <a href="/logout" class="text-xl hover:text-blue-400 transition"><i class="fas fa-sign-out-alt"></i></a>
            </div>
        </div>
    </div>
</nav>

<!-- Booking Layout -->
<section class="max-w-7xl mx-auto px-6 py-20 flex-grow mt-10">
    <div class="grid lg:grid-cols-3 gap-10">

        <!-- Left: Booking Form -->
        <div class="lg:col-span-2 bg-white rounded-2xl shadow-xl p-8 transform hover:scale-[1.01] transition">
            <h1 class="text-3xl font-bold text-gray-800 mb-6 flex items-center gap-2">
                <i class="fas fa-calendar-alt text-blue-500"></i> Book Your Safari
            </h1>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                    <span class="block sm:inline">${error}</span>
                </div>
            </c:if>

            <form action="/submit-booking" method="post" enctype="multipart/form-data" class="space-y-6">
                <!-- Hidden Fields -->
                <input type="hidden" name="tripId" value="${trip.id}" />
                <input type="hidden" name="tripName" value="${trip.name}" />
                <%
                    User user = (User) session.getAttribute("user");
                    if (user instanceof com.boatsafari.model.Tourist) {
                        com.boatsafari.model.Tourist tourist = (com.boatsafari.model.Tourist) user;
                %>
                <input type="hidden" name="userId" value="<%= tourist.getId() %>" />
                <input type="hidden" name="nic" value="<%= tourist.getNic() %>" />
                <% } %>
                <input type="hidden" name="username" value="${user.firstName} ${user.lastName}" />

                <!-- Booking Details -->
                <div class="grid md:grid-cols-2 gap-6">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700">📅 Booking Date</label>
                        <input type="date" name="bookingDate" required
                               class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-blue-400 shadow-sm"/>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700">⏱ Hours</label>
                        <input type="number" name="hours" id="hours" min="1" max="${trip.duration}" value="1" required
                               onchange="calculateTotal()"
                               class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-blue-400 shadow-sm"/>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700">👥 Passengers</label>
                        <input type="number" name="passengers" id="passengers" min="1" max="${trip.capacity}" value="1" required
                               onchange="calculateTotal()"
                               class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-blue-400 shadow-sm"/>
                    </div>
                </div>

                <!-- Payment Breakdown -->
                <div class="bg-gradient-to-r from-blue-50 to-blue-100 p-5 rounded-xl border border-blue-200 shadow-inner">
                    <h3 class="font-semibold text-gray-800 mb-3 flex items-center gap-2"><i class="fas fa-credit-card text-blue-500"></i> Payment Info</h3>
                    <div class="grid md:grid-cols-3 gap-4">
                        <div>
                            <label class="text-sm text-gray-600">Subtotal</label>
                            <input type="text" id="subtotal" readonly class="w-full p-2 bg-white border rounded shadow-sm"/>
                        </div>
                        <div>
                            <label class="text-sm text-gray-600">Discount</label>
                            <input type="text" id="discount" readonly class="w-full p-2 bg-white border rounded shadow-sm"/>
                        </div>
                        <div>
                            <label class="text-sm text-gray-600">Total</label>
                            <input type="text" id="totalAmount" name="totalAmount" readonly class="w-full p-2 bg-white border rounded font-bold text-blue-600 shadow-sm"/>
                        </div>
                    </div>
                    <c:if test="${not empty promotion}">
                        <p class="mt-2 text-sm text-green-600 font-medium">🎉 Promo: ${promotion.discountPercentage}% off (Includes ${trip.type == 'morning' ? '5%' : trip.type == 'evening' ? '7.5%' : trip.type == 'private' ? '10%' : '0%'} trip type discount, ≥${promotion.passengers} passengers, ≥${promotion.hours} hrs)</p>
                    </c:if>
                </div>

                <!-- Upload Payment -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700">📤 Upload Payment Slip</label>
                    <input type="file" name="paymentSlip" accept="image/*" required
                           class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-blue-400 shadow-sm"/>
                </div>

                <!-- Bank Details -->
                <div class="bg-blue-50 p-5 rounded-lg border border-blue-200 shadow-md">
                    <p class="font-semibold text-lg">💳 Bank Details</p>
                    <p><b>Account:</b> W M S A Jayasena</p>
                    <p><b>No:</b> 100652805851</p>
                    <p><b>Bank:</b> Sampath Bank, Colombo Branch</p>
                </div>

                <!-- Submit -->
                <button type="submit" class="w-full bg-gradient-to-r from-blue-500 to-indigo-500 text-white py-3 rounded-full font-semibold hover:from-blue-600 hover:to-indigo-600 shadow-lg transform hover:scale-105 transition">
                    <i class="fas fa-check"></i> Confirm Booking
                </button>
            </form>
        </div>

        <!-- Right: Trip Snapshot -->
        <div class="bg-white rounded-2xl shadow-lg p-6 hover:shadow-2xl transition transform hover:-translate-y-1">
            <h2 class="text-2xl font-bold mb-3 text-gray-800 flex items-center gap-2">
                <i class="fas fa-ship text-blue-500"></i> ${trip.name}
            </h2>

            <c:if test="${not empty trip.pictureUrl}">
                <img src="${trip.pictureUrl}" alt="${trip.name} Image"
                     class="w-full h-48 object-cover rounded-lg mb-4 shadow-md"/>
            </c:if>

            <!-- Rating -->
            <div class="flex items-center mb-4">
                <span class="text-yellow-400 text-lg"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="far fa-star"></i></span>
                <span class="ml-2 text-sm text-gray-600">(4.2 / 5 - 120 reviews)</span>
            </div>

            <!-- Trip Info -->
            <div class="space-y-2 mb-4">
                <p class="text-gray-700"><span class="bg-blue-100 text-blue-600 px-2 py-1 rounded-full text-xs">Price/hr:</span> $${trip.price}</p>
                <p class="text-gray-700"><span class="bg-green-100 text-green-600 px-2 py-1 rounded-full text-xs">Capacity:</span> ${trip.capacity}</p>
                <p class="text-gray-700"><span class="bg-purple-100 text-purple-600 px-2 py-1 rounded-full text-xs">Duration:</span> ${trip.duration} hrs</p>
                <p class="text-gray-700"><span class="bg-yellow-100 text-yellow-600 px-2 py-1 rounded-full text-xs">Location:</span> ${trip.locationName}</p>
                <p class="text-gray-700"><span class="bg-red-100 text-red-600 px-2 py-1 rounded-full text-xs">Type:</span> ${trip.type}</p>
            </div>

            <!-- Description -->
            <p class="text-sm text-gray-600 mb-4">
                🌊 Experience an unforgettable journey across the crystal waters. Perfect for families, friends, and adventurers who love the sea.
            </p>

            <!-- Special Offer -->
            <c:if test="${not empty promotion}">
                <div class="bg-gradient-to-r from-green-100 to-green-200 text-green-800 text-sm font-semibold px-4 py-2 rounded-lg mb-4 shadow-sm flex items-center gap-2">
                    <i class="fas fa-gift"></i> Special Offer: ${promotion.discountPercentage}% off (Includes ${trip.type == 'morning' ? '5%' : trip.type == 'evening' ? '7.5%' : trip.type == 'private' ? '10%' : '0%'} trip type discount, ≥${promotion.passengers} & hours ≥${promotion.hours})!
                </div>
            </c:if>

            <!-- Buttons -->
            <div class="flex items-center justify-between mt-3">
                <a href="${trip.googleMapsLink}" target="_blank"
                   class="px-4 py-2 text-sm bg-blue-100 text-blue-600 rounded-full hover:bg-blue-200 transition">
                    <i class="fas fa-map"></i> View Map
                </a>
                <button type="button"
                        class="px-5 py-2 bg-gradient-to-r from-blue-500 to-indigo-500 text-white rounded-full font-semibold hover:from-blue-600 hover:to-indigo-600 shadow-md transform hover:scale-105 transition">
                    <i class="fas fa-ship"></i> Book Now
                </button>
            </div>
        </div>

    </div>
</section>

<!-- Footer -->
<footer class="bg-black text-white py-6 text-center mt-10">
    <p class="text-gray-400 text-sm">© 2025 BlueWave Safaris — All Rights Reserved</p>
</footer>

<script>
    function calculateTotal() {
        const hours = document.getElementById('hours').value;
        const passengers = document.getElementById('passengers').value;
        const pricePerHour = ${trip.price};
        const subtotal = hours * pricePerHour * passengers;
        let discount = 0;
        <c:if test="${not empty promotion}">
        if (passengers >= ${promotion.passengers} && hours >= ${promotion.hours}) {
            discount = (subtotal * ${promotion.discountPercentage}) / 100;
        }
        </c:if>
        document.getElementById('subtotal').value = subtotal.toFixed(2);
        document.getElementById('discount').value = discount.toFixed(2);
        document.getElementById('totalAmount').value = (subtotal - discount).toFixed(2);
    }
    window.onload = calculateTotal;
</script>

</body>
</html>