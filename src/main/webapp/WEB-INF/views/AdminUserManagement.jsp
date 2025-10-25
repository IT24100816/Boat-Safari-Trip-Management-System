<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Admin User Management</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
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

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .fade-in { animation: fadeIn 0.8s ease-out forwards; }
    .card-hover { transition: transform 0.3s, box-shadow 0.3s; }
    .card-hover:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2); }
    .input-focus:focus { outline: none; ring: 2px solid #3b82f6; transition: ring 0.2s; }
    .error-message {
      color: #e53e3e;
      background-color: #fed7d7;
      border: 1px solid #feb2b2;
      padding: 0.75rem;
      border-radius: 0.375rem;
      margin-bottom: 1rem;
    }
    .char-count {
      font-size: 0.875rem;
      color: #6b7280;
      text-align: right;
      margin-top: 0.25rem;
    }
    .char-count.warning { color: #e53e3e; }
    .collapsible {
      transition: max-height 0.3s ease-out, opacity 0.2s ease;
      overflow: hidden;
    }
    .table-fixed { table-layout: fixed; width: 100%; }
    .table-fixed th, .table-fixed td { word-wrap: break-word; overflow-wrap: break-word; }
    .header-bg {
      background: linear-gradient(135deg, #1e40af, #3b82f6);
      background-image: url('https://images.unsplash.com/photo-1501785888041-af3ef285b470?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80');
      background-size: cover;
      background-position: center;
      background-blend-mode: overlay;
    }
    .modal { transition: opacity 0.3s ease; }
  </style>
</head>
<body class="bg-gray-100 text-gray-800 min-h-screen flex flex-col">
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
        <a href="/admin/users" class="underline-grow text-blue-400">Users</a>
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

<!-- Header -->
<header class="relative pt-24 header-bg text-white text-center py-16 overflow-hidden">
  <div class="absolute inset-0 bg-black bg-opacity-50"></div>
  <div class="relative z-10">
    <h1 class="text-4xl md:text-5xl font-extrabold mb-3 drop-shadow-lg">User Management</h1>
    <p class="text-lg md:text-xl mb-4 drop-shadow-md">Effortlessly manage your BlueWave Safaris team</p>
    <i class="fas fa-users-cog text-5xl md:text-6xl animate-pulse text-blue-300"></i>
  </div>
</header>

<!-- Main Content -->
<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 flex-1">
  <!-- Error/Success Messages -->
  <c:if test="${not empty successMessage}">
    <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4 fade-in" role="alert">
      <strong>Success!</strong> <span>${successMessage}</span>
    </div>
  </c:if>
  <c:if test="${not empty errorMessage}">
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4 fade-in" role="alert">
      <strong>Error!</strong> <span>${errorMessage}</span>
    </div>
  </c:if>

  <!-- User Management Sections -->
  <div x-data="{ openSection: null, editUser: null, newUser: { role: '', firstName: '', lastName: '', email: '', password: '', nic: '', age: '', phone: '', licenseNumber: '', language: '' } }" class="space-y-6">
    <!-- Add New User Form -->
    <div class="bg-white rounded-lg shadow-lg p-6 card-hover fade-in">
      <h2 class="text-2xl font-bold text-gray-800 mb-4">Add New User</h2>
      <form id="addUserForm" action="/admin/users/add" method="post" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <div>
          <label for="role" class="block text-sm font-medium text-gray-700">Role</label>
          <select id="role" name="role" x-model="newUser.role" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus">
            <option value="">Select Role</option>
            <option value="Tourist">Tourist</option>
            <option value="BoatDriver">Boat Driver</option>
            <option value="TourGuide">Tour Guide</option>
            <option value="BookingManager">Booking Manager</option>
            <option value="MarketingCoordinator">Marketing Coordinator</option>
          </select>
        </div>
        <div>
          <label for="firstName" class="block text-sm font-medium text-gray-700">First Name</label>
          <input id="firstName" name="firstName" type="text" x-model="newUser.firstName" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
        </div>
        <div>
          <label for="lastName" class="block text-sm font-medium text-gray-700">Last Name</label>
          <input id="lastName" name="lastName" type="text" x-model="newUser.lastName" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
        </div>
        <div>
          <label for="email" class="block text-sm font-medium text-gray-700">Email</label>
          <input id="email" name="email" type="email" x-model="newUser.email" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
        </div>
        <div>
          <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
          <input id="password" name="password" type="password" x-model="newUser.password" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
        </div>
        <div>
          <label for="nic" class="block text-sm font-medium text-gray-700">NIC</label>
          <input id="nic" name="nic" type="text" x-model="newUser.nic" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
        </div>
        <div>
          <label for="age" class="block text-sm font-medium text-gray-700">Age</label>
          <input id="age" name="age" type="number" min="18" x-model="newUser.age" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
        </div>
        <div>
          <label for="phone" class="block text-sm font-medium text-gray-700">Phone</label>
          <input id="phone" name="phone" type="text" x-model="newUser.phone" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
        </div>
        <div x-show="newUser.role === 'BoatDriver'" class="sm:col-span-1 lg:col-span-1">
          <label for="licenseNumber" class="block text-sm font-medium text-gray-700">License Number</label>
          <input id="licenseNumber" name="licenseNumber" type="text" x-model="newUser.licenseNumber" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
        </div>
        <div x-show="newUser.role === 'TourGuide'" class="sm:col-span-1 lg:col-span-1">
          <label for="language" class="block text-sm font-medium text-gray-700">Language</label>
          <input id="language" name="language" type="text" x-model="newUser.language" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
        </div>
        <div class="sm:col-span-2 lg:col-span-3 flex justify-end">
          <button type="submit" class="inline-flex items-center px-6 py-3 bg-green-600 text-white font-semibold rounded-lg shadow-md hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 transition duration-300">
            <i class="fas fa-plus mr-2"></i> Add User
          </button>
        </div>
      </form>
    </div>

    <!-- User Lists -->
    <div class="space-y-6">
      <!-- Tourists -->
      <div class="bg-white rounded-lg shadow-lg p-6 card-hover fade-in">
        <h2 class="text-2xl font-bold text-gray-800 mb-4 flex justify-between items-center">
          Tourists <button @click="openSection = openSection === 'tourists' ? null : 'tourists'" class="text-blue-500 hover:text-blue-700"><i class="fas fa-chevron-down"></i></button>
        </h2>
        <div x-show="openSection === 'tourists'" class="collapsible overflow-hidden" x-bind:style="openSection === 'tourists' ? 'max-height: 500px; opacity: 1' : 'max-height: 0; opacity: 0'">
          <div class="overflow-y-auto max-h-96">
            <table class="table-fixed w-full text-sm text-left text-gray-500">
              <thead class="text-xs text-gray-700 uppercase bg-gray-50 sticky top-0">
              <tr>
                <th class="px-4 py-2 w-1/12">ID</th>
                <th class="px-4 py-2 w-2/12">First Name</th>
                <th class="px-4 py-2 w-2/12">Last Name</th>
                <th class="px-4 py-2 w-2/12">Email</th>
                <th class="px-4 py-2 w-2/12">NIC</th>
                <th class="px-4 py-2 w-1/12">Age</th>
                <th class="px-4 py-2 w-1/12">Phone</th>
                <th class="px-4 py-2 w-1/12">Role</th>
                <th class="px-4 py-2 w-1/12">Actions</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="tourist" items="${tourists}">
                <tr class="bg-white border-b hover:bg-gray-50">
                  <td class="px-4 py-2">${tourist.id}</td>
                  <td class="px-4 py-2">${tourist.firstName}</td>
                  <td class="px-4 py-2">${tourist.lastName}</td>
                  <td class="px-4 py-2">${tourist.email}</td>
                  <td class="px-4 py-2">${tourist.nic}</td>
                  <td class="px-4 py-2">${tourist.age}</td>
                  <td class="px-4 py-2">${tourist.phone}</td>
                  <td class="px-4 py-2">${tourist.role}</td>
                  <td class="px-4 py-2">
                    <button @click="editUser = { id: ${tourist.id}, role: 'Tourist', firstName: '${tourist.firstName}', lastName: '${tourist.lastName}', email: '${tourist.email}', password: '', nic: '${tourist.nic}', age: ${tourist.age}, phone: '${tourist.phone}', licenseNumber: '', language: '' }" class="text-blue-500 hover:text-blue-700 mr-2"><i class="fas fa-edit"></i></button>
                    <form action="/admin/users/delete" method="post" style="display:inline;">
                      <input type="hidden" name="id" value="${tourist.id}" />
                      <input type="hidden" name="role" value="Tourist" />
                      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                      <button type="submit" class="text-red-500 hover:text-red-700"><i class="fas fa-trash"></i></button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Boat Drivers -->
      <div class="bg-white rounded-lg shadow-lg p-6 card-hover fade-in">
        <h2 class="text-2xl font-bold text-gray-800 mb-4 flex justify-between items-center">
          Boat Drivers <button @click="openSection = openSection === 'boatDrivers' ? null : 'boatDrivers'" class="text-blue-500 hover:text-blue-700"><i class="fas fa-chevron-down"></i></button>
        </h2>
        <div x-show="openSection === 'boatDrivers'" class="collapsible overflow-hidden" x-bind:style="openSection === 'boatDrivers' ? 'max-height: 500px; opacity: 1' : 'max-height: 0; opacity: 0'">
          <div class="overflow-y-auto max-h-96">
            <table class="table-fixed w-full text-sm text-left text-gray-500">
              <thead class="text-xs text-gray-700 uppercase bg-gray-50 sticky top-0">
              <tr>
                <th class="px-4 py-2 w-1/12">ID</th>
                <th class="px-4 py-2 w-2/12">First Name</th>
                <th class="px-4 py-2 w-2/12">Last Name</th>
                <th class="px-4 py-2 w-2/12">Email</th>
                <th class="px-4 py-2 w-1/12">NIC</th>
                <th class="px-4 py-2 w-1/12">Age</th>
                <th class="px-4 py-2 w-1/12">Phone</th>
                <th class="px-4 py-2 w-1/12">License #</th>
                <th class="px-4 py-2 w-1/12">Role</th>
                <th class="px-4 py-2 w-1/12">Actions</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="driver" items="${boatDrivers}">
                <tr class="bg-white border-b hover:bg-gray-50">
                  <td class="px-4 py-2">${driver.id}</td>
                  <td class="px-4 py-2">${driver.firstName}</td>
                  <td class="px-4 py-2">${driver.lastName}</td>
                  <td class="px-4 py-2">${driver.email}</td>
                  <td class="px-4 py-2">${driver.nic}</td>
                  <td class="px-4 py-2">${driver.age}</td>
                  <td class="px-4 py-2">${driver.phone}</td>
                  <td class="px-4 py-2">${driver.licenseNumber}</td>
                  <td class="px-4 py-2">${driver.role}</td>
                  <td class="px-4 py-2">
                    <button @click="editUser = { id: ${driver.id}, role: 'BoatDriver', firstName: '${driver.firstName}', lastName: '${driver.lastName}', email: '${driver.email}', password: '', nic: '${driver.nic}', age: ${driver.age}, phone: '${driver.phone}', licenseNumber: '${driver.licenseNumber}', language: '' }" class="text-blue-500 hover:text-blue-700 mr-2"><i class="fas fa-edit"></i></button>
                    <form action="/admin/users/delete" method="post" style="display:inline;">
                      <input type="hidden" name="id" value="${driver.id}" />
                      <input type="hidden" name="role" value="BoatDriver" />
                      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                      <button type="submit" class="text-red-500 hover:text-red-700"><i class="fas fa-trash"></i></button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Tour Guides -->
      <div class="bg-white rounded-lg shadow-lg p-6 card-hover fade-in">
        <h2 class="text-2xl font-bold text-gray-800 mb-4 flex justify-between items-center">
          Tour Guides <button @click="openSection = openSection === 'tourGuides' ? null : 'tourGuides'" class="text-blue-500 hover:text-blue-700"><i class="fas fa-chevron-down"></i></button>
        </h2>
        <div x-show="openSection === 'tourGuides'" class="collapsible overflow-hidden" x-bind:style="openSection === 'tourGuides' ? 'max-height: 500px; opacity: 1' : 'max-height: 0; opacity: 0'">
          <div class="overflow-y-auto max-h-96">
            <table class="table-fixed w-full text-sm text-left text-gray-500">
              <thead class="text-xs text-gray-700 uppercase bg-gray-50 sticky top-0">
              <tr>
                <th class="px-4 py-2 w-1/12">ID</th>
                <th class="px-4 py-2 w-2/12">First Name</th>
                <th class="px-4 py-2 w-2/12">Last Name</th>
                <th class="px-4 py-2 w-2/12">Email</th>
                <th class="px-4 py-2 w-1/12">NIC</th>
                <th class="px-4 py-2 w-1/12">Age</th>
                <th class="px-4 py-2 w-1/12">Phone</th>
                <th class="px-4 py-2 w-1/12">Language</th>
                <th class="px-4 py-2 w-1/12">Role</th>
                <th class="px-4 py-2 w-1/12">Actions</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="guide" items="${tourGuides}">
                <tr class="bg-white border-b hover:bg-gray-50">
                  <td class="px-4 py-2">${guide.id}</td>
                  <td class="px-4 py-2">${guide.firstName}</td>
                  <td class="px-4 py-2">${guide.lastName}</td>
                  <td class="px-4 py-2">${guide.email}</td>
                  <td class="px-4 py-2">${guide.nic}</td>
                  <td class="px-4 py-2">${guide.age}</td>
                  <td class="px-4 py-2">${guide.phone}</td>
                  <td class="px-4 py-2">${guide.language}</td>
                  <td class="px-4 py-2">${guide.role}</td>
                  <td class="px-4 py-2">
                    <button @click="editUser = { id: ${guide.id}, role: 'TourGuide', firstName: '${guide.firstName}', lastName: '${guide.lastName}', email: '${guide.email}', password: '', nic: '${guide.nic}', age: ${guide.age}, phone: '${guide.phone}', licenseNumber: '', language: '${guide.language}' }" class="text-blue-500 hover:text-blue-700 mr-2"><i class="fas fa-edit"></i></button>
                    <form action="/admin/users/delete" method="post" style="display:inline;">
                      <input type="hidden" name="id" value="${guide.id}" />
                      <input type="hidden" name="role" value="TourGuide" />
                      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                      <button type="submit" class="text-red-500 hover:text-red-700"><i class="fas fa-trash"></i></button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Booking Managers -->
      <div class="bg-white rounded-lg shadow-lg p-6 card-hover fade-in">
        <h2 class="text-2xl font-bold text-gray-800 mb-4 flex justify-between items-center">
          Booking Managers <button @click="openSection = openSection === 'bookingManagers' ? null : 'bookingManagers'" class="text-blue-500 hover:text-blue-700"><i class="fas fa-chevron-down"></i></button>
        </h2>
        <div x-show="openSection === 'bookingManagers'" class="collapsible overflow-hidden" x-bind:style="openSection === 'bookingManagers' ? 'max-height: 500px; opacity: 1' : 'max-height: 0; opacity: 0'">
          <div class="overflow-y-auto max-h-96">
            <table class="table-fixed w-full text-sm text-left text-gray-500">
              <thead class="text-xs text-gray-700 uppercase bg-gray-50 sticky top-0">
              <tr>
                <th class="px-4 py-2 w-1/12">ID</th>
                <th class="px-4 py-2 w-2/12">First Name</th>
                <th class="px-4 py-2 w-2/12">Last Name</th>
                <th class="px-4 py-2 w-2/12">Email</th>
                <th class="px-4 py-2 w-1/12">NIC</th>
                <th class="px-4 py-2 w-1/12">Age</th>
                <th class="px-4 py-2 w-1/12">Phone</th>
                <th class="px-4 py-2 w-1/12">Role</th>
                <th class="px-4 py-2 w-1/12">Actions</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="manager" items="${bookingManagers}">
                <tr class="bg-white border-b hover:bg-gray-50">
                  <td class="px-4 py-2">${manager.id}</td>
                  <td class="px-4 py-2">${manager.firstName}</td>
                  <td class="px-4 py-2">${manager.lastName}</td>
                  <td class="px-4 py-2">${manager.email}</td>
                  <td class="px-4 py-2">${manager.nic}</td>
                  <td class="px-4 py-2">${manager.age}</td>
                  <td class="px-4 py-2">${manager.phone}</td>
                  <td class="px-4 py-2">${manager.role}</td>
                  <td class="px-4 py-2">
                    <button @click="editUser = { id: ${manager.id}, role: 'BookingManager', firstName: '${manager.firstName}', lastName: '${manager.lastName}', email: '${manager.email}', password: '', nic: '${manager.nic}', age: ${manager.age}, phone: '${manager.phone}', licenseNumber: '', language: '' }" class="text-blue-500 hover:text-blue-700 mr-2"><i class="fas fa-edit"></i></button>
                    <form action="/admin/users/delete" method="post" style="display:inline;">
                      <input type="hidden" name="id" value="${manager.id}" />
                      <input type="hidden" name="role" value="BookingManager" />
                      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                      <button type="submit" class="text-red-500 hover:text-red-700"><i class="fas fa-trash"></i></button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Marketing Coordinators -->
      <div class="bg-white rounded-lg shadow-lg p-6 card-hover fade-in">
        <h2 class="text-2xl font-bold text-gray-800 mb-4 flex justify-between items-center">
          Marketing Coordinators <button @click="openSection = openSection === 'marketingCoordinators' ? null : 'marketingCoordinators'" class="text-blue-500 hover:text-blue-700"><i class="fas fa-chevron-down"></i></button>
        </h2>
        <div x-show="openSection === 'marketingCoordinators'" class="collapsible overflow-hidden" x-bind:style="openSection === 'marketingCoordinators' ? 'max-height: 500px; opacity: 1' : 'max-height: 0; opacity: 0'">
          <div class="overflow-y-auto max-h-96">
            <table class="table-fixed w-full text-sm text-left text-gray-500">
              <thead class="text-xs text-gray-700 uppercase bg-gray-50 sticky top-0">
              <tr>
                <th class="px-4 py-2 w-1/12">ID</th>
                <th class="px-4 py-2 w-2/12">First Name</th>
                <th class="px-4 py-2 w-2/12">Last Name</th>
                <th class="px-4 py-2 w-2/12">Email</th>
                <th class="px-4 py-2 w-1/12">NIC</th>
                <th class="px-4 py-2 w-1/12">Age</th>
                <th class="px-4 py-2 w-1/12">Phone</th>
                <th class="px-4 py-2 w-1/12">Role</th>
                <th class="px-4 py-2 w-1/12">Actions</th>
              </tr>
              </thead>
              <tbody>
              <c:forEach var="coordinator" items="${marketingCoordinators}">
                <tr class="bg-white border-b hover:bg-gray-50">
                  <td class="px-4 py-2">${coordinator.id}</td>
                  <td class="px-4 py-2">${coordinator.firstName}</td>
                  <td class="px-4 py-2">${coordinator.lastName}</td>
                  <td class="px-4 py-2">${coordinator.email}</td>
                  <td class="px-4 py-2">${coordinator.nic}</td>
                  <td class="px-4 py-2">${coordinator.age}</td>
                  <td class="px-4 py-2">${coordinator.phone}</td>
                  <td class="px-4 py-2">${coordinator.role}</td>
                  <td class="px-4 py-2">
                    <button @click="editUser = { id: ${coordinator.id}, role: 'MarketingCoordinator', firstName: '${coordinator.firstName}', lastName: '${coordinator.lastName}', email: '${coordinator.email}', password: '', nic: '${coordinator.nic}', age: ${coordinator.age}, phone: '${coordinator.phone}', licenseNumber: '', language: '' }" class="text-blue-500 hover:text-blue-700 mr-2"><i class="fas fa-edit"></i></button>
                    <form action="/admin/users/delete" method="post" style="display:inline;">
                      <input type="hidden" name="id" value="${coordinator.id}" />
                      <input type="hidden" name="role" value="MarketingCoordinator" />
                      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                      <button type="submit" class="text-red-500 hover:text-red-700"><i class="fas fa-trash"></i></button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- Edit User Modal -->
    <div x-show="editUser" class="fixed inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-50 modal" x-cloak>
      <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <h2 class="text-2xl font-bold text-gray-800 mb-4">Edit User</h2>
        <form action="/admin/users/edit" method="post" class="space-y-4">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
          <input type="hidden" name="id" x-model="editUser.id" />
          <input type="hidden" name="role" x-model="editUser.role" />
          <div>
            <label for="editFirstName" class="block text-sm font-medium text-gray-700">First Name</label>
            <input id="editFirstName" name="firstName" type="text" x-model="editUser.firstName" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
          </div>
          <div>
            <label for="editLastName" class="block text-sm font-medium text-gray-700">Last Name</label>
            <input id="editLastName" name="lastName" type="text" x-model="editUser.lastName" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
          </div>
          <div>
            <label for="editEmail" class="block text-sm font-medium text-gray-700">Email</label>
            <input id="editEmail" name="email" type="email" x-model="editUser.email" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
          </div>
          <div>
            <label for="editPassword" class="block text-sm font-medium text-gray-700">Password</label>
            <input id="editPassword" name="password" type="password" x-model="editUser.password" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
          </div>
          <div>
            <label for="editNic" class="block text-sm font-medium text-gray-700">NIC</label>
            <input id="editNic" name="nic" type="text" x-model="editUser.nic" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
          </div>
          <div>
            <label for="editAge" class="block text-sm font-medium text-gray-700">Age</label>
            <input id="editAge" name="age" type="number" min="18" x-model="editUser.age" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
          </div>
          <div>
            <label for="editPhone" class="block text-sm font-medium text-gray-700">Phone</label>
            <input id="editPhone" name="phone" type="text" x-model="editUser.phone" required class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
          </div>
          <div x-show="editUser.role === 'BoatDriver'">
            <label for="editLicenseNumber" class="block text-sm font-medium text-gray-700">License Number</label>
            <input id="editLicenseNumber" name="licenseNumber" type="text" x-model="editUser.licenseNumber" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
          </div>
          <div x-show="editUser.role === 'TourGuide'">
            <label for="editLanguage" class="block text-sm font-medium text-gray-700">Language</label>
            <input id="editLanguage" name="language" type="text" x-model="editUser.language" class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md input-focus" />
          </div>
          <div class="flex justify-end space-x-4">
            <button type="submit" class="inline-flex items-center px-6 py-3 bg-blue-600 text-white font-semibold rounded-lg shadow-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 transition duration-300">
              <i class="fas fa-save mr-2"></i> Save
            </button>
            <button @click="editUser = null" class="inline-flex items-center px-6 py-3 bg-gray-500 text-white font-semibold rounded-lg shadow-md hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-gray-400 transition duration-300">
              <i class="fas fa-times mr-2"></i> Cancel
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</main>

<!-- Footer -->
<footer class="bg-black text-white pt-6 mt-auto">
  <div class="max-w-7xl mx-auto px-6 text-center">
    <p class="text-gray-300">© 2025 BlueWave Safaris — Admin User Management</p>
  </div>
</footer>

<script>
  const menuBtn = document.getElementById('menu-btn');
  const mobileMenu = document.getElementById('mobile-menu');
  if (menuBtn) {
    menuBtn.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));
  }

  document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.fade-in').forEach((el, index) => {
      el.style.opacity = 0;
      el.style.animationDelay = `${index * 0.2}s`;
      setTimeout(() => el.classList.add('fade-in'), 100);
    });
  });
</script>