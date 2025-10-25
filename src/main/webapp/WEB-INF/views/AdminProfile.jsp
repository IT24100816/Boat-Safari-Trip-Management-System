<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BlueWave Safaris - Admin Profile</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <script src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
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
      0%, 100% {
        transform: translateY(0px);
      }
      50% {
        transform: translateY(-10px);
      }
    }

    @keyframes gradientShift {
      0% {
        background-position: 0% 50%;
      }
      50% {
        background-position: 100% 50%;
      }
      100% {
        background-position: 0% 50%;
      }
    }

    .animate-fade-in-up {
      animation: fadeInUp 0.6s ease-out;
    }

    .animate-float {
      animation: float 3s ease-in-out infinite;
    }

    .animate-gradient {
      background: linear-gradient(-45deg, #3b82f6, #8b5cf6, #06b6d4, #10b981);
      background-size: 400% 400%;
      animation: gradientShift 8s ease infinite;
    }

    .glass-effect {
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.2);
    }

    .gradient-text {
      background: linear-gradient(135deg, #3b82f6, #8b5cf6);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .card-hover {
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .card-hover:hover {
      transform: translateY(-5px);
      box-shadow: 0 20px 40px -12px rgba(0, 0, 0, 0.25);
    }

    .input-glow:focus {
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
      border-color: #3b82f6;
    }

    .underline-grow::after {
      content: "";
      display: block;
      height: 3px;
      width: 0;
      background: #38bdf8;
      transition: width .28s ease;
      margin-top: 6px;
      border-radius: 2px;
    }

    .underline-grow:hover::after {
      width: 100%;
    }
  </style>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col text-gray-800" x-data="{ deleteModal: false, loading: false, mobileMenu: false }">

<!-- Navigation Bar - Matching your original design -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg">
  <div class="max-w-7xl mx-auto px-6">
    <div class="flex items-center justify-between h-24">
      <!-- Logo -->
      <div class="text-3xl font-extrabold tracking-wide whitespace-nowrap">
        <span class="text-blue-400">BlueWave</span> Safaris - Admin
      </div>

      <!-- Desktop Navigation -->
      <div class="hidden lg:flex items-center space-x-8 font-semibold text-lg whitespace-nowrap">
        <a href="/admin/dashboard" class="underline-grow">Dashboard</a>
        <a href="/admin/trips" class="underline-grow">Manage Trips</a>
        <a href="/admin/users" class="underline-grow">Users</a>
        <a href="/admin/boats" class="underline-grow">Boats</a>
        <a href="/admin/bookings" class="underline-grow">Bookings</a>
        <a href="/admin/promotions" class="underline-grow">Promotions</a>
        <a href="/admin/profile" class="underline-grow text-blue-400">Profile</a>
        <a href="/logout" class="text-3xl hover:text-blue-400 transition"><i class="fas fa-sign-out-alt"></i></a>
      </div>

      <!-- Mobile Menu Button -->
      <button @click="mobileMenu = !mobileMenu" class="lg:hidden text-white text-3xl focus:outline-none">
        <i class="fas fa-bars"></i>
      </button>
    </div>
  </div>

  <!-- Mobile Navigation -->
  <div x-show="mobileMenu" class="lg:hidden bg-black px-6 py-4 space-y-4 text-lg">
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

<!-- Hero Header -->
<header class="relative w-full h-80 pt-24 overflow-hidden">
  <div class="absolute inset-0 animate-gradient"></div>
  <div class="absolute inset-0 bg-black/40"></div>
  <div class="relative z-10 h-full flex items-center justify-center text-white text-center animate-fade-in-up">
    <div class="max-w-4xl mx-auto px-6">
      <div class="w-20 h-20 bg-white/20 rounded-full flex items-center justify-center mx-auto mb-6 backdrop-blur-sm border border-white/30 animate-float">
        <i class="fas fa-user-shield text-3xl"></i>
      </div>
      <h1 class="text-5xl font-bold mb-4 drop-shadow-lg">Admin Profile</h1>
      <p class="text-xl opacity-90">Manage your account settings and preferences</p>
    </div>
  </div>

  <!-- Waves -->
  <div class="absolute bottom-0 left-0 right-0">
    <svg viewBox="0 0 1200 120" preserveAspectRatio="none" class="w-full h-12">
      <path d="M0,0V46.29c47.79,22.2,103.59,32.17,158,28,70.36-5.37,136.33-33.31,206.8-37.5C438.64,32.43,512.34,53.67,583,72.05c69.27,18,138.3,24.88,209.4,13.08,36.15-6,69.85-17.84,104.45-29.34C989.49,25,1113-14.29,1200,52.47V0Z" opacity=".25" class="fill-white"></path>
      <path d="M0,0V15.81C13,36.92,27.64,56.86,47.69,72.05,99.41,111.27,165,111,224.58,91.58c31.15-10.15,60.09-26.07,89.67-39.8,40.92-19,84.73-46,130.83-49.67,36.26-2.85,70.9,9.42,98.6,31.56,31.77,25.39,62.32,62,103.63,73,40.44,10.79,81.35-6.69,119.13-24.28s75.16-39,116.92-43.05c59.73-5.85,113.28,22.88,168.9,38.84,30.2,8.66,59,6.17,87.09-7.5,22.43-10.89,48-26.93,60.65-49.24V0Z" opacity=".5" class="fill-white"></path>
      <path d="M0,0V5.63C149.93,59,314.09,71.32,475.83,42.57c43-7.64,84.23-20.12,127.61-26.46,59-8.63,112.48,12.24,165.56,35.4C827.93,77.22,886,95.24,951.2,90c86.53-7,172.46-45.71,248.8-84.81V0Z" class="fill-white"></path>
    </svg>
  </div>
</header>

<!-- Main Content -->
<main class="flex-1 py-12">
  <div class="max-w-6xl mx-auto px-6">

    <!-- Alert Messages -->
    <div class="mb-8 space-y-4">
      <c:if test="${not empty errorMessage}">
        <div class="bg-red-500 bg-opacity-80 border border-red-700 text-white p-4 rounded-lg text-center animate-fade-in-up">
          <i class="fas fa-exclamation-circle mr-2"></i>${errorMessage}
        </div>
      </c:if>
      <c:if test="${not empty successMessage}">
        <div class="bg-green-500 bg-opacity-80 border border-green-700 text-white p-4 rounded-lg text-center animate-fade-in-up">
          <i class="fas fa-check-circle mr-2"></i>${successMessage}
        </div>
      </c:if>
    </div>

    <c:if test="${not empty admin}">
      <!-- Profile Card -->
      <div class="grid grid-cols-1 lg:grid-cols-4 gap-8 mb-8">
        <!-- Profile Sidebar -->
        <div class="lg:col-span-1">
          <div class="card-hover bg-white rounded-2xl p-6 shadow-xl border border-gray-100 animate-fade-in-up">
            <div class="text-center">
              <div class="w-24 h-24 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full mx-auto mb-4 flex items-center justify-center">
                <i class="fas fa-user-shield text-3xl text-white"></i>
              </div>
              <h3 class="text-xl font-bold text-gray-800 mb-1">${admin.firstName} ${admin.lastName}</h3>
              <p class="text-blue-600 font-medium mb-2">${admin.role}</p>
              <div class="flex justify-center space-x-4 text-gray-500">
                <div class="text-center">
                  <div class="font-bold text-gray-800">${admin.age}</div>
                  <div class="text-xs">Age</div>
                </div>
                <div class="text-center">
                  <div class="font-bold text-gray-800">Active</div>
                  <div class="text-xs">Status</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Quick Stats -->
          <div class="card-hover bg-white rounded-2xl p-6 shadow-xl border border-gray-100 mt-6 animate-fade-in-up" style="animation-delay: 0.1s">
            <h4 class="font-semibold text-gray-800 mb-4 flex items-center">
              <i class="fas fa-chart-line mr-2 text-blue-500"></i>
              Quick Stats
            </h4>
            <div class="space-y-3">
              <div class="flex justify-between items-center">
                <span class="text-sm text-gray-600">Total Trips</span>
                <span class="font-bold text-blue-600">24</span>
              </div>
              <div class="flex justify-between items-center">
                <span class="text-sm text-gray-600">Active Users</span>
                <span class="font-bold text-green-600">156</span>
              </div>
              <div class="flex justify-between items-center">
                <span class="text-sm text-gray-600">Bookings</span>
                <span class="font-bold text-purple-600">89</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Profile Form -->
        <div class="lg:col-span-3">
          <div class="card-hover bg-white rounded-2xl p-8 shadow-xl border border-gray-100 animate-fade-in-up" style="animation-delay: 0.2s">
            <div class="flex items-center justify-between mb-8">
              <h2 class="text-2xl font-bold text-gray-800">Profile Information</h2>
              <div class="w-3 h-3 bg-green-500 rounded-full animate-pulse"></div>
            </div>

            <form action="/admin/profile/edit" method="post" class="space-y-6" @submit="loading = true">
              <!-- Hidden ID Field -->
              <input type="hidden" name="id" value="${admin.id}">

              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Personal Information -->
                <div class="space-y-4">
                  <h3 class="text-lg font-semibold text-gray-800 border-l-4 border-blue-500 pl-3">Personal Information</h3>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">First Name</label>
                    <input type="text" name="firstName" value="${admin.firstName}"
                           class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 input-glow" required>
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Last Name</label>
                    <input type="text" name="lastName" value="${admin.lastName}"
                           class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 input-glow" required>
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Age</label>
                    <input type="number" name="age" value="${admin.age}"
                           class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 input-glow" min="18" max="100">
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">NIC</label>
                    <input type="text" name="nic" value="${admin.nic}"
                           class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 input-glow" required>
                  </div>
                </div>

                <!-- Contact Information -->
                <div class="space-y-4">
                  <h3 class="text-lg font-semibold text-gray-800 border-l-4 border-green-500 pl-3">Contact Information</h3>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
                    <div class="relative">
                      <input type="email" name="email" value="${admin.email}"
                             class="w-full p-3 pl-10 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 input-glow" required>
                      <i class="fas fa-envelope absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    </div>
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Phone Number</label>
                    <div class="relative">
                      <input type="text" name="phone" value="${admin.phone}"
                             class="w-full p-3 pl-10 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 input-glow">
                      <i class="fas fa-phone absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    </div>
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Password</label>
                    <div class="relative">
                      <input type="password" name="password" value="${admin.password}"
                             class="w-full p-3 pl-10 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-200 input-glow" required>
                      <i class="fas fa-lock absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    </div>
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Role</label>
                    <input type="text" name="role" value="${admin.role}" readonly
                           class="w-full p-3 border border-gray-300 rounded-lg bg-gray-100 text-gray-600 cursor-not-allowed">
                  </div>
                </div>
              </div>

              <!-- Action Buttons -->
              <div class="flex flex-col sm:flex-row gap-4 pt-6 border-t border-gray-200">
                <button type="submit"
                        class="bg-blue-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-all duration-200 shadow-lg hover:shadow-xl flex items-center justify-center min-w-[140px]"
                        :disabled="loading">
                  <i class="fas fa-save mr-2" x-show="!loading"></i>
                  <i class="fas fa-spinner fa-spin mr-2" x-show="loading"></i>
                  <span x-text="loading ? 'Saving...' : 'Save Changes'"></span>
                </button>

                <button type="button"
                        @click="deleteModal = true"
                        class="bg-red-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-red-700 transition-all duration-200 shadow-lg hover:shadow-xl flex items-center justify-center min-w-[140px]">
                  <i class="fas fa-trash mr-2"></i>
                  Delete Account
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </c:if>

    <c:if test="${empty admin}">
      <!-- Empty State -->
      <div class="text-center py-16 animate-fade-in-up">
        <div class="w-24 h-24 bg-gray-200 rounded-full flex items-center justify-center mx-auto mb-6">
          <i class="fas fa-user-slash text-3xl text-gray-400"></i>
        </div>
        <h3 class="text-2xl font-bold text-gray-600 mb-2">No Profile Data</h3>
        <p class="text-gray-500 mb-6">Unable to load admin profile information.</p>
        <a href="/admin/dashboard" class="bg-blue-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-all duration-200 inline-flex items-center">
          <i class="fas fa-arrow-left mr-2"></i>
          Back to Dashboard
        </a>
      </div>
    </c:if>
  </div>
</main>

<!-- Delete Confirmation Modal -->
<div x-show="deleteModal" x-transition:enter="transition ease-out duration-200"
     x-transition:enter-start="opacity-0 scale-95" x-transition:enter-end="opacity-100 scale-100"
     x-transition:leave="transition ease-in duration-150" x-transition:leave-start="opacity-100 scale-100"
     x-transition:leave-end="opacity-0 scale-95"
     class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
  <div class="bg-white rounded-2xl p-6 w-full max-w-md shadow-2xl animate-fade-in-up" @click.away="deleteModal = false">
    <div class="text-center mb-6">
      <div class="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
        <i class="fas fa-exclamation-triangle text-2xl text-red-600"></i>
      </div>
      <h3 class="text-xl font-bold text-gray-800 mb-2">Delete Account</h3>
      <p class="text-gray-600">This action cannot be undone. All your data will be permanently removed.</p>
    </div>

    <form action="/admin/profile/delete" method="post" class="space-y-4">
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">Confirm Password</label>
        <div class="relative">
          <input type="password" name="confirmPassword"
                 class="w-full p-3 pl-10 border border-red-300 rounded-lg focus:ring-2 focus:ring-red-500 focus:border-transparent transition-all duration-200"
                 placeholder="Enter your password" required>
          <i class="fas fa-key absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
        </div>
      </div>

      <div class="flex gap-3">
        <button type="submit"
                class="bg-red-600 text-white px-4 py-3 rounded-lg font-semibold hover:bg-red-700 transition-all duration-200 flex-1 flex items-center justify-center">
          <i class="fas fa-trash mr-2"></i>
          Delete Account
        </button>
        <button type="button"
                @click="deleteModal = false"
                class="bg-gray-500 text-white px-4 py-3 rounded-lg font-semibold hover:bg-gray-600 transition-all duration-200 flex-1 flex items-center justify-center">
          <i class="fas fa-times mr-2"></i>
          Cancel
        </button>
      </div>
    </form>
  </div>
</div>

<!-- Footer -->
<footer class="bg-black bg-opacity-80 text-white py-8 mt-auto">
  <div class="max-w-7xl mx-auto px-6 text-center">
    <p class="text-gray-300">© 2025 BlueWave Safaris — Admin Dashboard</p>
  </div>
</footer>
</body>
</html>