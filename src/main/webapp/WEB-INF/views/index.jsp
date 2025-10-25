<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>BlueWave Safaris</title>

    <!-- Tailwind CDN -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <!-- Alpine.js -->
    <script src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js" defer></script>

    <style>
        /* small custom animations */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(18px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .anim-fade-up { animation: fadeInUp 0.9s cubic-bezier(.22,.9,.38,1) both; }

        /* slow zoom for hero background image when active */
        .hero-img { transition: transform 10s linear; }
        .hero-img.active { transform: scale(1.05); }

        /* reveal helper */
        .reveal { opacity: 0; transform: translateY(18px); transition: all 0.9s ease-out; }
        .reveal.is-visible { opacity: 1; transform: translateY(0); }

        /* subtle focus ring on interactive elements */
        .focus-ring:focus { outline: 3px solid rgba(59,130,246,0.18); outline-offset: 2px; }

        /* small tweak for navbar link underline animation */
        .underline-grow::after {
            content: "";
            display: block;
            height: 3px;
            width: 0;
            background: #38bdf8; /* blue-400 */
            transition: width .28s ease;
            margin-top: 6px;
            border-radius: 2px;
        }
        .underline-grow:hover::after { width: 100%; }

        /* Custom styles for enhanced dropdown */
        .profile-dropdown {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            padding: 8px;
            width: 260px;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .dropdown-item {
            display: flex;
            align-items: center;
            padding: 10px 14px;
            border-radius: 8px;
            transition: all 0.2s ease;
            color: #4b5563;
            font-weight: 500;
            text-decoration: none;
        }

        .dropdown-item:hover {
            background-color: #f3f4f6;
            color: #1f2937;
            transform: translateX(2px);
        }

        .dropdown-item i {
            width: 20px;
            margin-right: 12px;
            text-align: center;
            font-size: 16px;
        }

        .dropdown-divider {
            height: 1px;
            background-color: #e5e7eb;
            margin: 8px 0;
        }

        .notification-badge {
            background: #ef4444;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            margin-left: auto;
        }

        .booking-history-icon {
            color: #10b981;
        }

        .notifications-icon {
            color: #f59e0b;
        }

        .profile-icon {
            color: #3b82f6;
        }

        .search-icon {
            color: #8b5cf6;
        }

        .password-icon {
            color: #ef4444;
        }

        .logout-icon {
            color: #6b7280;
        }

        /* Search suggestions styles */
        .search-suggestions {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(0, 0, 0, 0.05);
            max-height: 300px;
            overflow-y: auto;
        }

        .suggestion-item {
            display: block;
            width: 100%;
            text-align: left;
            padding: 12px 16px;
            border: none;
            background: none;
            color: #4b5563;
            font-weight: 500;
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .suggestion-item:hover {
            background-color: #f3f4f6;
            color: #1f2937;
        }

        .suggestion-item.active {
            background-color: #3b82f6;
            color: white;
        }
    </style>
</head>
<body class="bg-gray-100 text-gray-800">

<!-- NAVBAR (fixed) -->
<nav class="bg-black text-white fixed w-full z-50 shadow-lg">
    <div class="max-w-7xl mx-auto px-6">
        <div class="flex items-center justify-between h-24">
            <!-- Left: Brand (now a link to homepage) -->
            <div class="flex items-center space-x-3 flex-shrink-0">
                <i class="fas fa-ship text-3xl text-blue-400 animate-bounce"></i>
                <a href="/" class="text-3xl font-extrabold tracking-wide whitespace-nowrap">
                    <span class="text-blue-400">BlueWave</span> Safaris
                </a>
            </div>

            <!-- Middle: Search (centered) -->
            <div class="hidden lg:flex flex-grow justify-center px-6">
                <div class="relative flex items-center bg-gray-800 rounded-full px-4 py-2 w-full max-w-md shadow-md transition transform hover:scale-105"
                     x-data="searchComponent()">
                    <input
                            type="search"
                            placeholder="Search Trips..."
                            class="bg-transparent text-base text-white placeholder-gray-400 focus:outline-none w-full focus-ring"
                            aria-label="Search Trips"
                            x-model="searchQuery"
                            x-on:input.debounce.300ms="getSuggestions()"
                            x-on:keydown.arrow-down="nextSuggestion()"
                            x-on:keydown.arrow-up="prevSuggestion()"
                            x-on:keydown.enter="selectSuggestion()"
                            x-on:focus="showSuggestions = true"
                            x-on:blur="setTimeout(() => showSuggestions = false, 200)"
                    />
                    <i class="fas fa-search text-gray-400 ml-3"></i>

                    <!-- Suggestions Dropdown -->
                    <div x-show="showSuggestions && suggestions.length > 0"
                         x-transition:enter="transition ease-out duration-200"
                         x-transition:enter-start="opacity-0 scale-95"
                         x-transition:enter-end="opacity-100 scale-100"
                         class="absolute top-full left-0 right-0 mt-2 search-suggestions z-50">
                        <template x-for="(suggestion, index) in suggestions" :key="index">
                            <button
                                    x-on:click="selectSuggestion(suggestion)"
                                    x-on:mouseenter="activeIndex = index"
                                    class="suggestion-item"
                                    x-bind:class="{ 'active': activeIndex === index }"
                            >
                                <span x-text="suggestion"></span>
                            </button>
                        </template>
                    </div>

                    <!-- Loading Indicator -->
                    <div x-show="loading" class="absolute right-12 top-1/2 transform -translate-y-1/2">
                        <i class="fas fa-spinner fa-spin text-gray-400"></i>
                    </div>
                </div>
            </div>

            <!-- Right: Nav links -->
            <div class="hidden lg:flex items-center space-x-8 font-semibold text-lg whitespace-nowrap">
                <a href="/" class="underline-grow">Home</a>
                <c:choose>
                    <c:when test="${not empty username}">
                        <a href="/trips" class="underline-grow">Trips</a>
                    </c:when>
                    <c:otherwise>
                        <a href="/login" class="underline-grow">Trips</a>
                    </c:otherwise>
                </c:choose>
                <a href="#" class="underline-grow">About Us</a>
                <c:choose>
                    <c:when test="${not empty username}">
                        <a href="/reviews" class="underline-grow">Reviews</a>
                    </c:when>
                    <c:otherwise>
                        <a href="/login" class="underline-grow">Reviews</a>
                    </c:otherwise>
                </c:choose>
                <a href="/tourist-view-promotions" class="underline-grow">Promotions</a>
                <a href="#" class="underline-grow">Contact Us</a>
                <c:choose>
                    <c:when test="${empty username}">
                        <a href="/login" class="text-3xl hover:text-blue-400 transition" aria-label="Profile"><i class="fas fa-user-circle"></i></a>
                    </c:when>
                    <c:otherwise>
                        <div x-data="{ open: false }" class="relative">
                            <button x-on:click="open = !open" class="text-3xl hover:text-blue-400 transition" aria-label="Profile"><i class="fas fa-user-circle"></i></button>
                            <div x-show="open" x-on:click.away="open = false" x-transition:enter="transition ease-out duration-200"
                                 x-transition:enter-start="opacity-0 scale-95" x-transition:enter-end="opacity-100 scale-100"
                                 x-transition:leave="transition ease-in duration-150" x-transition:leave-start="opacity-100 scale-100"
                                 x-transition:leave-end="opacity-0 scale-95" class="absolute right-0 mt-2 profile-dropdown z-50">
                                <a href="/tourist/profile" class="dropdown-item">
                                    <i class="fas fa-user-circle profile-icon"></i>
                                    Profile
                                </a>
                                <a href="/booking-history" class="dropdown-item">
                                    <i class="fas fa-history booking-history-icon"></i>
                                    Booking History
                                </a>
                                <a href="/notifications" class="dropdown-item">
                                    <i class="fas fa-bell notifications-icon"></i>
                                    Notifications
                                    <span class="notification-badge">3</span>
                                </a>
                                <a href="/search-members" class="dropdown-item">
                                    <i class="fas fa-search search-icon"></i>
                                    Search Members
                                </a>
                                <div class="dropdown-divider"></div>
                                <a href="/tourist/change-password" class="dropdown-item">
                                    <i class="fas fa-key password-icon"></i>
                                    Change Password
                                </a>
                                <a href="/logout" class="dropdown-item">
                                    <i class="fas fa-sign-out-alt logout-icon"></i>
                                    Logout
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Mobile menu button -->
            <div class="lg:hidden flex items-center">
                <button id="menu-btn" class="text-white text-3xl focus:outline-none" aria-label="Open menu">
                    <i class="fas fa-bars"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- Mobile menu (hidden on large) -->
    <div id="mobile-menu" class="hidden lg:hidden bg-black px-6 py-4 space-y-4 text-lg">
        <div class="flex items-center bg-gray-800 rounded-full px-4 py-2">
            <input
                    type="search"
                    placeholder="Search Trips..."
                    class="bg-transparent text-white placeholder-gray-400 focus:outline-none w-full"
                    id="mobile-search-input"
            />
            <i class="fas fa-search text-gray-400"></i>
        </div>
        <a href="/" class="block hover:text-blue-400 transition">Home</a>
        <c:choose>
            <c:when test="${not empty username}">
                <a href="/trips" class="block hover:text-blue-400 transition">Trips</a>
            </c:when>
            <c:otherwise>
                <a href="/login" class="block hover:text-blue-400 transition">Trips</a>
            </c:otherwise>
        </c:choose>
        <a href="#" class="block hover:text-blue-400 transition">About Us</a>
        <c:choose>
            <c:when test="${not empty username}">
                <a href="/reviews" class="block hover:text-blue-400 transition">Reviews</a>
            </c:when>
            <c:otherwise>
                <a href="/login" class="block hover:text-blue-400 transition">Reviews</a>
            </c:otherwise>
        </c:choose>
        <a href="/tourist-view-promotions" class="block hover:text-blue-400 transition">Promotions</a>
        <a href="#" class="block hover:text-blue-400 transition">Contact Us</a>
        <c:choose>
            <c:when test="${empty username}">
                <a href="/login" class="block hover:text-blue-400 transition"><i class="fas fa-user-circle mr-2"></i> Login</a>
            </c:when>
            <c:otherwise>
                <a href="/profile" class="block hover:text-blue-400 transition"><i class="fas fa-user-circle mr-2"></i> Profile</a>
                <a href="/booking-history" class="block hover:text-blue-400 transition"><i class="fas fa-history mr-2"></i> Booking History</a>
                <a href="/notifications" class="block hover:text-blue-400 transition"><i class="fas fa-bell mr-2"></i> Notifications <span class="bg-red-500 text-white text-xs rounded-full px-2 py-1 ml-1">3</span></a>
                <a href="/search-members" class="block hover:text-blue-400 transition"><i class="fas fa-search mr-2"></i> Search Members</a>
                <a href="/change-password" class="block hover:text-blue-400 transition"><i class="fas fa-key mr-2"></i> Change Password</a>
                <a href="/logout" class="block hover:text-blue-400 transition"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- HERO (slides) -->
<section
        x-data="{
      slides: [
        { src: 'Boat_Safari_image_1.jpg', title: 'Discover the Wild', desc: 'Embark on an unforgettable boat safari adventure with expert guides.' },
        { src: 'Boat_Safari_image_4.jpg', title: 'Sail Through Serenity', desc: 'Glide through calm waters and watch nature come alive at every turn.' },
        { src: 'Boat_Safari_image_5.jpg', title: 'Adventure Awaits', desc: 'Experience thrilling wildlife sightings and sunset cruises.' }
      ],
      current: 0,
      startAutoplay() { this._int = setInterval(() => this.current = (this.current + 1) % this.slides.length, 4500); },
      stopAutoplay() { clearInterval(this._int); },
      prev() { this.current = (this.current - 1 + this.slides.length) % this.slides.length; },
      next() { this.current = (this.current + 1) % this.slides.length; }
    }"
        x-init="startAutoplay()"
        x-on:mouseenter="stopAutoplay()" x-on:mouseleave="startAutoplay()"
        class="relative w-full h-[70vh] pt-24 overflow-hidden"
>
    <!-- slides -->
    <template x-for="(s, i) in slides" :key="i">
        <div
                x-show="current === i"
                x-transition:enter="transition-opacity duration-700"
                x-transition:enter-start="opacity-0"
                x-transition:enter-end="opacity-100"
                x-transition:leave="transition-opacity duration-700"
                x-transition:leave-start="opacity-100"
                x-transition:leave-end="opacity-0"
                class="absolute inset-0"
        >
            <img x-bind:src="s.src" alt="" class="w-full h-full object-cover hero-img" x-bind:class="current === i ? 'active' : ''" />
            <!-- gradient overlay to left for left-aligned text readability -->
            <div class="absolute inset-0 bg-gradient-to-r from-black/70 via-black/40 to-transparent"></div>

            <!-- left-aligned content (aligned with nav px-6 and max-w) -->
            <div class="absolute inset-0 flex items-center">
                <div class="max-w-7xl mx-auto px-6 text-left">
                    <div class="max-w-2xl">
                        <c:if test="${not empty username}">
                            <p class="text-2xl font-bold text-white mb-4 anim-fade-up">👋 Welcome, ${username}!</p>
                        </c:if>
                        <h2 class="text-4xl md:text-5xl lg:text-6xl font-extrabold text-white leading-tight anim-fade-up" x-text="s.title"></h2>
                        <p class="mt-4 text-lg md:text-xl text-gray-200 anim-fade-up" x-text="s.desc"></p>
                        <div class="mt-6 anim-fade-up">
                            <a href="#trips" class="inline-block bg-blue-400 hover:bg-blue-500 text-white font-semibold px-6 py-3 rounded-full shadow-lg focus-ring">Book Now</a>
                            <a href="#contact" class="ml-3 inline-block bg-white/10 hover:bg-white/20 text-white px-5 py-3 rounded-full">Contact Us</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </template>

    <!-- arrows -->
    <button x-on:click="prev()" class="absolute left-4 top-1/2 transform -translate-y-1/2 text-white text-2xl bg-black/40 p-3 rounded-full hover:bg-black/60 focus-ring" aria-label="Previous">
        <i class="fas fa-chevron-left"></i>
    </button>
    <button x-on:click="next()" class="absolute right-4 top-1/2 transform -translate-y-1/2 text-white text-2xl bg-black/40 p-3 rounded-full hover:bg-black/60 focus-ring" aria-label="Next">
        <i class="fas fa-chevron-right"></i>
    </button>

    <!-- indicators -->
    <div class="absolute bottom-6 left-1/2 transform -translate-x-1/2 flex space-x-3">
        <template x-for="(s, i) in slides" :key="i">
            <button
                    x-on:click="current = i"
                    x-bind:class="current === i ? 'bg-blue-400' : 'bg-white/40'"
                    class="w-3 h-3 rounded-full transition"
                    x-bind:aria-label="'Go to slide ' + (i+1)"
            ></button>
        </template>
    </div>

    <!-- decorative SVG wave at hero bottom -->
    <div class="absolute bottom-0 left-0 right-0 pointer-events-none">
        <svg viewBox="0 0 1440 120" class="w-full h-20" preserveAspectRatio="none">
            <path d="M0,40 C180,120 360,0 720,40 C1080,80 1260,0 1440,40 L1440,120 L0,120 Z" fill="#F8FAFC" opacity="0.9"/>
        </svg>
    </div>
</section>

<!-- Available Safari Packages -->
<section class="py-16 bg-white reveal" id="trips">
    <div class="max-w-7xl mx-auto px-6">
        <h2 class="text-3xl md:text-4xl font-bold text-gray-800 text-center mb-12 reveal">Available Safari Packages</h2>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <article class="bg-white rounded-lg shadow-lg overflow-hidden transform transition hover:-translate-y-3 hover:shadow-2xl reveal">
                <div class="relative overflow-hidden">
                    <img src="Boat_Safari_image_1.jpg" alt="Morning Safari" class="w-full h-56 object-cover transition-transform duration-500 hover:scale-105" />
                    <div class="absolute top-3 left-3 bg-black/50 px-3 py-1 rounded-full text-white text-sm">Morning</div>
                </div>
                <div class="p-6">
                    <h3 class="text-xl font-semibold mb-2">Morning Safari</h3>
                    <p class="text-gray-600 mb-4">Start your day with a serene boat ride, spotting wildlife at dawn.</p>
                    <div class="flex items-center justify-between">
                        <div class="text-gray-800 font-semibold">$50 / hour</div>
                        <a href="#trips" class="bg-blue-400 text-white px-4 py-2 rounded-full hover:bg-blue-500 transition focus-ring">Book Now</a>
                    </div>
                </div>
            </article>

            <article class="bg-white rounded-lg shadow-lg overflow-hidden transform transition hover:-translate-y-3 hover:shadow-2xl reveal">
                <div class="relative overflow-hidden">
                    <img src="Boat_Safari_image_2.jpg" alt="Evening Safari" class="w-full h-56 object-cover transition-transform duration-500 hover:scale-105" />
                    <div class="absolute top-3 left-3 bg-black/50 px-3 py-1 rounded-full text-white text-sm">Evening</div>
                </div>
                <div class="p-6">
                    <h3 class="text-xl font-semibold mb-2">Evening Safari</h3>
                    <p class="text-gray-600 mb-4">Enjoy a magical evening cruise with stunning sunset views.</p>
                    <div class="flex items-center justify-between">
                        <div class="text-gray-800 font-semibold">$60 / hour</div>
                        <a href="#trips" class="bg-blue-400 text-white px-4 py-2 rounded-full hover:bg-blue-500 transition focus-ring">Book Now</a>
                    </div>
                </div>
            </article>

            <article class="bg-white rounded-lg shadow-lg overflow-hidden transform transition hover:-translate-y-3 hover:shadow-2xl reveal">
                <div class="relative overflow-hidden">
                    <img src="Boat_Safari_image_3.jpg" alt="Private Tour" class="w-full h-56 object-cover transition-transform duration-500 hover:scale-105" />
                    <div class="absolute top-3 left-3 bg-black/50 px-3 py-1 rounded-full text-white text-sm">Private</div>
                </div>
                <div class="p-6">
                    <h3 class="text-xl font-semibold mb-2">Private Tour</h3>
                    <p class="text-gray-600 mb-4">Exclusive tour with personalized service and privacy.</p>
                    <div class="flex items-center justify-between">
                        <div class="text-gray-800 font-semibold">$80 / hour</div>
                        <a href="#trips" class="bg-blue-400 text-white px-4 py-2 rounded-full hover:bg-blue-500 transition focus-ring">Book Now</a>
                    </div>
                </div>
            </article>
        </div>
    </div>
</section>

<!-- Contact & Location -->
<section id="contact" class="py-16 bg-gray-50 reveal">
    <div class="max-w-7xl mx-auto px-6">
        <h2 class="text-3xl md:text-4xl font-bold text-gray-800 text-center mb-12">Contact & Location</h2>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
            <!-- Contact Form -->
            <div class="bg-white p-10 rounded-2xl shadow-xl reveal hover:shadow-2xl transform hover:-translate-y-1 transition">
                <!-- Header -->
                <div class="flex items-center gap-3 mb-6 border-b pb-3">
                    <i class="fas fa-envelope-open-text text-black text-2xl"></i>
                    <h3 class="text-2xl font-bold text-gray-800">Get in Touch</h3>
                </div>

                <!-- Form -->
                <form class="space-y-6">
                    <!-- Name -->
                    <div class="relative">
                        <i class="fas fa-user absolute left-3 top-3 text-gray-400"></i>
                        <input id="name" placeholder="Your Name"
                               class="w-full pl-10 p-3 border border-gray-200 rounded-lg focus:ring-2 focus:ring-black shadow-sm transition" required />
                    </div>

                    <!-- Email -->
                    <div class="relative">
                        <i class="fas fa-envelope absolute left-3 top-3 text-gray-400"></i>
                        <input id="email" type="email" placeholder="Your Email"
                               class="w-full pl-10 p-3 border border-gray-200 rounded-lg focus:ring-2 focus:ring-black shadow-sm transition" required />
                    </div>

                    <!-- Message -->
                    <div class="relative">
                        <i class="fas fa-comment-dots absolute left-3 top-3 text-gray-400"></i>
                        <textarea id="message" rows="4" placeholder="Write your message..."
                                  class="w-full pl-10 p-3 border border-gray-200 rounded-lg focus:ring-2 focus:ring-black shadow-sm transition" required></textarea>
                    </div>

                    <!-- Button -->
                    <div>
                        <button type="submit"
                                class="w-full bg-black text-white px-6 py-3 rounded-lg font-semibold shadow-md hover:shadow-xl transform hover:-translate-y-0.5 transition">
                            <i class="fas fa-paper-plane mr-2"></i> Send Message
                        </button>
                    </div>
                </form>
            </div>

            <!-- Contact Info + Map -->
            <div class="bg-white p-8 rounded-lg shadow-lg space-y-6 reveal">
                <div>
                    <h3 class="text-xl font-semibold text-gray-800 mb-4">Contact Information</h3>
                    <ul class="space-y-3">
                        <li class="flex items-center gap-3">
                            <i class="fas fa-phone text-blue-400 text-lg w-6"></i>
                            <a href="tel:+1234567890" class="text-gray-700 hover:text-blue-400">+1 (234) 567-890</a>
                        </li>
                        <li class="flex items-center gap-3">
                            <i class="fas fa-envelope text-blue-400 text-lg w-6"></i>
                            <a href="mailto:info@bluewavesafaris.com" class="text-gray-700 hover:text-blue-400">info@bluewavesafaris.com</a>
                        </li>
                        <li class="flex items-center gap-3">
                            <i class="fab fa-whatsapp text-green-500 text-lg w-6"></i>
                            <a href="https://wa.me/1234567890" target="_blank" class="text-gray-700 hover:text-blue-400">Chat on WhatsApp</a>
                        </li>
                    </ul>
                </div>

                <div>
                    <h3 class="text-xl font-semibold text-gray-800 mb-4">Our Location</h3>
                    <div class="w-full h-64 rounded overflow-hidden">
                        <iframe class="w-full h-full border-0" src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3151.835434579426!2d-122.41941568464193!3d37.77492927975906!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8085808f8d4a8b2b%3A0x9b7a6e7c7f9e1e1e!2sBlue%20Lagoon%20Safari%20Starting%20Point!5e0!3m2!1sen!2sus!4v1694868800000" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Footer (full) -->
<footer class="bg-black text-white pt-12">
    <div class="max-w-7xl mx-auto px-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 pb-8">
            <!-- Quick Links -->
            <div>
                <h4 class="text-lg font-semibold mb-4">Quick Links</h4>
                <ul class="space-y-2 text-gray-300">
                    <li><a href="/" class="hover:text-blue-400">Home</a></li>
                    <li><a href="/trips" class="hover:text-blue-400">Trips</a></li>
                    <li><a href="#" class="hover:text-blue-400">About Us</a></li>
                    <li><a href="#" class="hover:text-blue-400">Contact Us</a></li>
                </ul>
            </div>

            <!-- Newsletter -->
            <div>
                <h4 class="text-lg font-semibold mb-4">Subscribe</h4>
                <p class="text-gray-300 mb-4">Get trip promos & updates. No spam — unsubscribe anytime.</p>
                <form class="flex gap-3 max-w-md">
                    <input type="email" placeholder="Your email" class="w-full p-3 rounded bg-white/5 placeholder-gray-300 border border-white/10 focus-ring" />
                    <button class="bg-blue-400 px-4 py-3 rounded text-black font-semibold hover:bg-blue-500">Subscribe</button>
                </form>
            </div>

            <!-- Contact & Social -->
            <div>
                <h4 class="text-lg font-semibold mb-4">Contact</h4>
                <p class="text-gray-300 mb-4">info@bluewavesafaris.com<br/>+1 (234) 567-890</p>
                <div class="flex items-center gap-4">
                    <a href="#" class="text-gray-300 hover:text-blue-400 text-xl"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-gray-300 hover:text-blue-400 text-xl"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="text-gray-300 hover:text-blue-400 text-xl"><i class="fab fa-youtube"></i></a>
                </div>
            </div>
        </div>

        <div class="border-t border-white/10 pt-6 pb-8 flex flex-col md:flex-row items-center justify-between text-sm text-gray-400">
            <div>© 2025 BlueWave Safaris — All rights reserved.</div>
            <div class="mt-3 md:mt-0 flex items-center gap-6">
                <a href="#" class="hover:text-blue-400">Terms</a>
                <a href="#" class="hover:text-blue-400">Privacy</a>
                <a href="#" class="hover:text-blue-400">Help</a>
            </div>
        </div>
    </div>
</footer>

<!-- SCRIPTS: mobile menu + scroll reveal -->
<script>
    // Search component functionality
    function searchComponent() {
        return {
            searchQuery: '',
            suggestions: [],
            activeIndex: -1,
            showSuggestions: false,
            loading: false,

            async getSuggestions() {
                if (this.searchQuery.length < 1) {
                    this.suggestions = [];
                    this.showSuggestions = false;
                    return;
                }

                this.loading = true;
                try {
                    const response = await fetch('/api/search/trips/suggestions?prefix=' + encodeURIComponent(this.searchQuery));
                    if (response.ok) {
                        this.suggestions = await response.json();
                        this.activeIndex = -1;
                        this.showSuggestions = true;
                    }
                } catch (error) {
                    console.error('Error fetching suggestions:', error);
                    this.suggestions = [];
                } finally {
                    this.loading = false;
                }
            },

            nextSuggestion(event) {
                if (this.suggestions.length > 0) {
                    event.preventDefault();
                    this.activeIndex = (this.activeIndex + 1) % this.suggestions.length;
                }
            },

            prevSuggestion(event) {
                if (this.suggestions.length > 0) {
                    event.preventDefault();
                    this.activeIndex = this.activeIndex <= 0 ? this.suggestions.length - 1 : this.activeIndex - 1;
                }
            },

            selectSuggestion(suggestion = null) {
                const selectedSuggestion = suggestion ||
                    (this.activeIndex >= 0 ? this.suggestions[this.activeIndex] : null);

                if (selectedSuggestion) {
                    // Store the selected trip name in sessionStorage to highlight later
                    sessionStorage.setItem('selectedTrip', selectedSuggestion);
                    // Redirect to trips page
                    window.location.href = '/trips?search=' + encodeURIComponent(selectedSuggestion);
                } else if (this.searchQuery.trim()) {
                    // If no suggestion selected but there's a search query, search with it
                    sessionStorage.setItem('selectedTrip', this.searchQuery);
                    window.location.href = '/trips?search=' + encodeURIComponent(this.searchQuery);
                }

                this.showSuggestions = false;
                this.suggestions = [];
            }
        }
    }

    // Mobile menu toggle
    const menuBtn = document.getElementById('menu-btn');
    const mobileMenu = document.getElementById('mobile-menu');
    if(menuBtn){
        menuBtn.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));
    }

    // Mobile search functionality
    document.addEventListener('DOMContentLoaded', function() {
        const mobileSearchInput = document.getElementById('mobile-search-input');
        if (mobileSearchInput) {
            mobileSearchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    const query = this.value.trim();
                    if (query) {
                        sessionStorage.setItem('selectedTrip', query);
                        window.location.href = '/trips?search=' + encodeURIComponent(query);
                    }
                }
            });
        }
    });

    // IntersectionObserver for reveal animations
    document.addEventListener('DOMContentLoaded', function () {
        const obsOptions = { root: null, rootMargin: '0px', threshold: 0.12 };
        const observer = new IntersectionObserver((entries, obs) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('is-visible');
                    obs.unobserve(entry.target);
                }
            });
        }, obsOptions);

        document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
        // also reveal immediate hero text elements
        document.querySelectorAll('.anim-fade-up').forEach((el) => {
            el.classList.add('is-visible'); // they already have animation, leave them visible
        });
    });
</script>
</body>
</html>