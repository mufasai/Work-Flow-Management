<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="jakarta.tags.core" %> <%@ taglib prefix="fn"
uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Work Flow Management</title>
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
      rel="stylesheet"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "Poppins", sans-serif;
        background: linear-gradient(
          135deg,
          #0c0c0c 0%,
          #1a1a2e 50%,
          #16213e 100%
        );
        min-height: 100vh;
        color: rgba(255, 255, 255, 0.9);
        position: relative;
        overflow-x: hidden;
      }

      /* Animated Background */
      body::before {
        content: "";
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: radial-gradient(
            circle at 20% 80%,
            rgba(100, 255, 218, 0.05) 0%,
            transparent 50%
          ),
          radial-gradient(
            circle at 80% 20%,
            rgba(29, 233, 182, 0.03) 0%,
            transparent 50%
          ),
          radial-gradient(
            circle at 40% 40%,
            rgba(0, 188, 212, 0.04) 0%,
            transparent 50%
          );
        animation: float 20s ease-in-out infinite;
        z-index: -1;
      }

      @keyframes float {
        0%,
        100% {
          transform: translateY(0px) rotate(0deg);
        }
        33% {
          transform: translateY(-30px) rotate(0.5deg);
        }
        66% {
          transform: translateY(20px) rotate(-0.5deg);
        }
      }

      /* Floating shapes */
      .floating-shapes {
        position: fixed;
        width: 100%;
        height: 100%;
        pointer-events: none;
        z-index: -1;
      }

      .shape {
        position: absolute;
        background: rgba(100, 255, 218, 0.02);
        border: 1px solid rgba(100, 255, 218, 0.1);
        border-radius: 50%;
        animation: floatShapes 15s infinite ease-in-out;
      }

      .shape:nth-child(1) {
        width: 80px;
        height: 80px;
        top: 10%;
        left: 10%;
        animation-delay: 0s;
      }

      .shape:nth-child(2) {
        width: 60px;
        height: 60px;
        top: 70%;
        right: 10%;
        animation-delay: 2s;
      }

      .shape:nth-child(3) {
        width: 100px;
        height: 100px;
        top: 50%;
        left: 5%;
        animation-delay: 4s;
      }

      .shape:nth-child(4) {
        width: 120px;
        height: 120px;
        top: 20%;
        right: 5%;
        animation-delay: 6s;
      }

      @keyframes floatShapes {
        0%,
        100% {
          transform: translateY(0px) translateX(0px) rotate(0deg);
        }
        25% {
          transform: translateY(-20px) translateX(10px) rotate(90deg);
        }
        50% {
          transform: translateY(20px) translateX(-10px) rotate(180deg);
        }
        75% {
          transform: translateY(-10px) translateX(20px) rotate(270deg);
        }
      }

      /* Glassmorphism Components */
      .glass {
        background: rgba(20, 20, 30, 0.7);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border: 1px solid rgba(100, 255, 218, 0.2);
        border-radius: 20px;
        box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.6),
          inset 0 1px 0 0 rgba(255, 255, 255, 0.1);
      }

      .glass-hover {
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
      }

      .glass-hover::before {
        content: "";
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(
          90deg,
          transparent,
          rgba(100, 255, 218, 0.1),
          transparent
        );
        transition: left 0.5s;
        z-index: 0;
      }

      .glass-hover:hover::before {
        left: 100%;
      }

      .glass-hover:hover {
        transform: translateY(-5px);
        border-color: rgba(100, 255, 218, 0.4);
        box-shadow: 0 15px 45px 0 rgba(0, 0, 0, 0.8),
          0 0 30px rgba(100, 255, 218, 0.2);
      }

      /* Navbar */
      .navbar {
        background: rgba(20, 20, 30, 0.95);
        backdrop-filter: blur(20px);
        border-bottom: 1px solid rgba(100, 255, 218, 0.2);
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        z-index: 1030;
        height: 80px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
      }

      .navbar-brand {
        color: rgba(255, 255, 255, 0.95) !important;
        font-weight: 600;
        font-size: 1.4rem;
        text-shadow: 0 2px 20px rgba(100, 255, 218, 0.3);
      }

      .navbar-brand i {
        color: #64ffda;
        margin-right: 10px;
        animation: pulse 2s infinite;
      }

      /* Sidebar */
      .sidebar {
        background: rgba(20, 20, 30, 0.8);
        backdrop-filter: blur(20px);
        border-right: 1px solid rgba(100, 255, 218, 0.2);
        position: fixed;
        top: 80px;
        left: 0;
        width: 280px;
        height: calc(100vh - 80px);
        z-index: 1020;
        box-shadow: 4px 0 20px rgba(0, 0, 0, 0.3);
        transition: all 0.3s ease;
      }

      .sidebar-menu {
        list-style: none;
        padding: 2rem 0;
        margin: 0;
      }

      .sidebar-menu li {
        margin: 0.5rem 0;
      }

      .sidebar-menu a {
        display: flex;
        align-items: center;
        padding: 1rem 1.5rem;
        text-decoration: none;
        color: rgba(255, 255, 255, 0.7);
        border-radius: 0 25px 25px 0;
        margin-right: 1rem;
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
      }

      .sidebar-menu a::before {
        content: "";
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(
          135deg,
          #64ffda 0%,
          #1de9b6 50%,
          #00bcd4 100%
        );
        transition: left 0.3s ease;
        z-index: -1;
      }

      .sidebar-menu a:hover::before,
      .sidebar-menu a.active::before {
        left: 0;
      }

      .sidebar-menu a:hover,
      .sidebar-menu a.active {
        color: #0c0c0c;
        transform: translateX(10px);
        font-weight: 600;
        text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
      }

      .sidebar-menu i {
        width: 20px;
        margin-right: 1rem;
        text-align: center;
      }

      /* Main Content */
      .main-content {
        margin-left: 280px;
        padding-top: 80px;
        min-height: 100vh;
        width: calc(100vw - 280px); /* Viewport width minus sidebar width */
        max-width: calc(100vw - 280px);
        transition: all 0.3s ease;
        box-sizing: border-box;
      }

      .content-wrapper {
        padding: 2rem;
      }

      /* Cards */
      .welcome-card {
        background: linear-gradient(
          135deg,
          #64ffda 0%,
          #1de9b6 50%,
          #00bcd4 100%
        );
        color: #0c0c0c;
        border-radius: 20px;
        padding: 2rem;
        margin-bottom: 2rem;
        box-shadow: 0 10px 30px rgba(100, 255, 218, 0.3),
          0 0 20px rgba(100, 255, 218, 0.1);
        position: relative;
        overflow: hidden;
      }

      .welcome-card::before {
        content: "";
        position: absolute;
        top: -50%;
        right: -50%;
        width: 200%;
        height: 200%;
        background: radial-gradient(
          circle,
          rgba(255, 255, 255, 0.1) 0%,
          transparent 70%
        );
        animation: rotate 20s linear infinite;
      }

      @keyframes rotate {
        0% {
          transform: rotate(0deg);
        }
        100% {
          transform: rotate(360deg);
        }
      }

      .info-card {
        background: rgba(20, 20, 30, 0.7);
        backdrop-filter: blur(20px);
        border: 1px solid rgba(100, 255, 218, 0.2);
        border-radius: 20px;
        margin-bottom: 2rem;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.6);
        transition: all 0.3s ease;
      }

      .info-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 45px rgba(0, 0, 0, 0.8),
          0 0 30px rgba(100, 255, 218, 0.2);
      }

      .card-header {
        background: rgba(100, 255, 218, 0.1);
        border-bottom: 1px solid rgba(100, 255, 218, 0.2);
        border-radius: 20px 20px 0 0 !important;
        padding: 1.5rem;
      }

      .card-body {
        padding: 1.5rem;
        position: relative;
        z-index: 1;
      }

      /* Stats Cards */
      .stats-card {
        text-align: center;
        padding: 2rem 1rem;
        border-radius: 20px;
        background: rgba(20, 20, 30, 0.7);
        backdrop-filter: blur(20px);
        border: 1px solid rgba(100, 255, 218, 0.2);
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
      }

      .stats-card::before {
        content: "";
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(
          90deg,
          transparent,
          rgba(100, 255, 218, 0.1),
          transparent
        );
        transition: left 0.5s;
      }

      .stats-card:hover::before {
        left: 100%;
      }

      .stats-card:hover {
        transform: translateY(-10px);
        border-color: rgba(100, 255, 218, 0.4);
        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.8);
      }

      .stats-icon {
        font-size: 3rem;
        color: #64ffda;
        margin-bottom: 1rem;
        text-shadow: 0 0 20px rgba(100, 255, 218, 0.5);
      }

      .stats-number {
        font-size: 2.5rem;
        font-weight: 700;
        color: #64ffda;
        margin-bottom: 0.5rem;
        text-shadow: 0 0 20px rgba(100, 255, 218, 0.3);
      }

      .stats-label {
        color: rgba(255, 255, 255, 0.8);
        font-weight: 500;
      }

      /* Tables */
      .table-glass {
        background: rgba(20, 20, 30, 0.7);
        backdrop-filter: blur(20px);
        border: 1px solid rgba(100, 255, 218, 0.2);
        border-radius: 20px;
        overflow: hidden;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.6);
      }

      .table {
        color: rgba(255, 255, 255, 0.9);
        margin-bottom: 0;
      }

      .table thead th {
        background: linear-gradient(
          135deg,
          #64ffda 0%,
          #1de9b6 50%,
          #00bcd4 100%
        );
        color: #0c0c0c;
        border: none;
        font-weight: 600;
        padding: 1rem;
        text-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
      }

      .table td {
        border-color: rgba(100, 255, 218, 0.1);
        padding: 1rem;
      }

      .table tbody tr {
        transition: all 0.3s ease;
      }

      .table tbody tr:hover {
        background: rgba(100, 255, 218, 0.05);
        transform: scale(1.01);
      }

      /* User Avatar */
      .user-avatar {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background: linear-gradient(135deg, #64ffda, #1de9b6, #00bcd4);
        display: flex;
        align-items: center;
        justify-content: center;
        color: #0c0c0c;
        font-weight: bold;
        font-size: 1.2rem;
        box-shadow: 0 4px 15px rgba(100, 255, 218, 0.3);
        text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
      }

      /* Badges */
      .badge {
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-weight: 500;
      }

      .badge.bg-danger {
        background: linear-gradient(135deg, #ff6b6b, #ee5a24) !important;
      }

      .badge.bg-success {
        background: linear-gradient(135deg, #64ffda, #1de9b6) !important;
        color: #0c0c0c !important;
      }

      .badge.bg-primary {
        background: linear-gradient(135deg, #0984e3, #00cec9) !important;
      }

      .badge.bg-warning {
        background: linear-gradient(135deg, #fdcb6e, #f39c12) !important;
        color: #0c0c0c !important;
      }

      .badge.bg-info {
        background: linear-gradient(135deg, #74b9ff, #0984e3) !important;
      }

      /* Buttons */
      .btn-logout {
        background: linear-gradient(135deg, #ff6b6b, #ee5a24);
        border: none;
        border-radius: 15px;
        color: white;
        padding: 0.7rem 1.5rem;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3);
      }

      .btn-logout:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(255, 107, 107, 0.4);
        color: white;
      }

      /* WhatsApp Link */
      .wa-link {
        color: #25d366;
        text-decoration: none;
        transition: all 0.3s ease;
      }

      .wa-link:hover {
        color: #128c7e;
        text-shadow: 0 0 10px rgba(37, 211, 102, 0.5);
      }

      /* Mobile Responsive */
      @media (max-width: 768px) {
        .sidebar {
          left: -280px;
        }

        .sidebar.show {
          left: 0;
        }

        .main-content {
          margin-left: 0;
        }

        .sidebar-toggle {
          display: block;
          background: none;
          border: none;
          color: rgba(255, 255, 255, 0.8);
          font-size: 1.2rem;
          cursor: pointer;
        }

        .content-wrapper {
          padding: 1rem;
        }

        .stats-card {
          margin-bottom: 1rem;
        }
      }

      @media (min-width: 769px) {
        .sidebar-toggle {
          display: none;
        }
      }

      /* Animation for content sections */
      .content-section {
        animation: fadeInUp 0.6s ease-out;
      }

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

      /* Scrollbar */
      ::-webkit-scrollbar {
        width: 8px;
      }

      ::-webkit-scrollbar-track {
        background: rgba(20, 20, 30, 0.5);
      }

      ::-webkit-scrollbar-thumb {
        background: rgba(100, 255, 218, 0.3);
        border-radius: 10px;
      }

      ::-webkit-scrollbar-thumb:hover {
        background: rgba(100, 255, 218, 0.5);
      }
    </style>
  </head>
  <body>
    <!-- Floating Shapes -->
    <div class="floating-shapes">
      <div class="shape"></div>
      <div class="shape"></div>
      <div class="shape"></div>
      <div class="shape"></div>
    </div>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
      <div class="container-fluid">
        <div class="d-flex align-items-center">
          <button class="sidebar-toggle me-3" onclick="toggleSidebar()">
            <i class="fas fa-bars"></i>
          </button>
          <span class="navbar-brand mb-0">
            <i class="fas fa-chart-line"></i>
            Work Flow Management
          </span>
        </div>
        <div class="d-flex align-items-center">
          <span class="me-3" style="color: rgba(255, 255, 255, 0.8)">
            <i class="fas fa-user-circle me-2" style="color: #64ffda"></i>
            Admin User
          </span>
          <button class="btn btn-logout">
            <i class="fas fa-sign-out-alt me-2"></i>Logout
          </button>
        </div>
      </div>
    </nav>

    <div class="d-flex">
      <!-- Sidebar -->
      <div class="sidebar" id="sidebar">
        <ul class="sidebar-menu">
          <li>
            <a
              href="#dashboard"
              class="active"
              onclick="showSection('dashboard')"
            >
              <i class="fas fa-tachometer-alt"></i>
              Dashboard
            </a>
          </li>
          <li>
            <a href="#history" onclick="showSection('history')">
              <i class="fas fa-history"></i>
              History
            </a>
          </li>
          <li>
            <a href="#ticket" onclick="showSection('ticket')">
              <i class="fas fa-ticket-alt"></i>
              Ticket
            </a>
          </li>
          <li>
            <a href="#technician" onclick="showSection('technician')">
              <i class="fas fa-tools"></i>
              Technician
            </a>
          </li>
        </ul>
      </div>

      <!-- Main Content -->
      <div class="main-content">
        <div class="content-wrapper">
          <!-- Dashboard Section -->
          <div id="dashboard-section" class="content-section">
            <!-- Welcome Card -->
            <div class="welcome-card">
              <div class="row align-items-center">
                <div class="col-md-8">
                  <h3 class="mb-2" style="position: relative; z-index: 1">
                    <i class="fas fa-hand-wave me-2"></i>
                    Selamat datang, Admin ${user.username}!
                  </h3>
                  <p class="mb-2" style="position: relative; z-index: 1">
                    Anda login sebagai
                    <span
                      class="badge"
                      style="background: rgba(12, 12, 12, 0.8); color: #64ffda"
                      >Admin</span
                    >
                  </p>
                  <p class="mb-0" style="position: relative; z-index: 1">
                    Status:
                    <span
                      class="badge"
                      style="background: rgba(12, 12, 12, 0.8); color: #1de9b6"
                      >${user.status}</span
                    >
                  </p>
                </div>
                <div class="col-md-4 text-end">
                  <div
                    class="user-avatar mx-auto"
                    style="
                      width: 80px;
                      height: 80px;
                      font-size: 2rem;
                      position: relative;
                      z-index: 1;
                    "
                  >
                    A
                  </div>
                </div>
              </div>
            </div>

            <!-- Stats Row -->
            <div class="row mb-4">
              <div class="col-md-3 col-sm-6 mb-3">
                <div class="stats-card glass-hover">
                  <i class="fas fa-users stats-icon"></i>
                  <div class="stats-number">${totalUsers}</div>
                  <div class="stats-label">Total Users</div>
                </div>
              </div>
              <div class="col-md-3 col-sm-6 mb-3">
                <div class="stats-card glass-hover">
                  <i class="fas fa-ticket-alt stats-icon"></i>
                  <div class="stats-number">${activeTickets}</div>
                  <div class="stats-label">Active Tickets</div>
                </div>
              </div>
              <div class="col-md-3 col-sm-6 mb-3">
                <div class="stats-card glass-hover">
                  <i class="fas fa-tools stats-icon"></i>
                  <div class="stats-number">${technicians}</div>
                  <div class="stats-label">Technicians</div>
                </div>
              </div>
              <div class="col-md-3 col-sm-6 mb-3">
                <div class="stats-card glass-hover">
                  <i class="fas fa-check-circle stats-icon"></i>
                  <div class="stats-number">${completedTickets}</div>
                  <div class="stats-label">Completed</div>
                </div>
              </div>
            </div>

            <!-- User Info Card -->
            <div class="info-card glass-hover">
              <div class="card-header">
                <h5 class="mb-0" style="color: rgba(255, 255, 255, 0.9)">
                  <i class="fas fa-info-circle me-2"></i>
                  Informasi Akun
                </h5>
              </div>
              <div class="card-body">
                <div class="row">
                  <div class="col-md-6">
                    <p>
                      <strong>ID:</strong>
                      <code style="color: #64ffda">${user.id}</code>
                    </p>
                    <p><strong>Username:</strong> ${user.username}</p>
                    <p class="mb-0">
                      <strong>Role:</strong>
                      <span class="badge bg-danger">${user.role}</span>
                    </p>
                  </div>
                  <div class="col-md-6">
                    <p>
                      <strong>Status:</strong>
                      <span class="badge bg-success">${user.status}</span>
                    </p>
                    <p class="mb-0">
                      <strong>WhatsApp:</strong>
                      <a
                        href="https://wa.me/628123456789"
                        class="wa-link"
                        target="_blank"
                      >
                        <i class="fab fa-whatsapp me-1"></i>
                        +62 812-3456-789
                      </a>
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Users Table -->
            <div class="table-glass">
              <div class="card-header">
                <h5 class="mb-0" style="color: #ffffff">
                  <i class="fas fa-users me-2" style="color: #ffffff"></i>
                  Daftar Semua User
                </h5>
              </div>
              <div class="table-responsive">
                <table class="table">
                  <thead>
                    <tr>
                      <th>Avatar</th>
                      <th>Username</th>
                      <th>Role</th>
                      <th>Status</th>
                      <th>WhatsApp</th>
                      <th>ID</th>
                    </tr>
                  </thead>
                  <tbody>
                    <!-- Loop melalui semua user dari controller -->
                    <c:forEach var="user" items="${allUsers}">
                      <tr>
                        <!-- Avatar - ambil huruf pertama username -->
                        <td>
                          <div class="user-avatar">
                            ${fn:substring(fn:toUpperCase(user.username), 0, 1)}
                          </div>
                        </td>

                        <!-- Username -->
                        <td><strong>${user.username}</strong></td>

                        <!-- Role dengan badge berbeda -->
                        <td>
                          <c:choose>
                            <c:when test="${user.role == 'admin'}">
                              <span class="badge bg-danger">admin</span>
                            </c:when>
                            <c:when test="${user.role == 'technician'}">
                              <span class="badge bg-warning">technician</span>
                            </c:when>
                            <c:otherwise>
                              <span class="badge bg-primary">user</span>
                            </c:otherwise>
                          </c:choose>
                        </td>

                        <!-- Status -->
                        <td>
                          <c:choose>
                            <c:when
                              test="${fn:toLowerCase(user.status) == 'active'}"
                            >
                              <span class="badge bg-success">Active</span>
                            </c:when>
                            <c:otherwise>
                              <span class="badge bg-info">Available</span>
                            </c:otherwise>
                          </c:choose>
                        </td>

                        <!-- WhatsApp -->
                        <td>
                          <c:choose>
                            <c:when test="${not empty user.whatsapp}">
                              <a
                                href="https://wa.me/${fn:replace(user.whatsapp, '+', '')}"
                                class="wa-link"
                                target="_blank"
                              >
                                <i class="fab fa-whatsapp me-1"></i>
                                ${user.whatsapp}
                              </a>
                            </c:when>
                            <c:otherwise>
                              <span class="text-muted">-</span>
                            </c:otherwise>
                          </c:choose>
                        </td>

                        <!-- User ID -->
                        <td>
                          <code style="color: #64ffda">user:${user.id}</code>
                        </td>
                      </tr>
                    </c:forEach>

                    <!-- Tampilkan pesan jika tidak ada user -->
                    <c:if test="${empty allUsers}">
                      <tr>
                        <td colspan="6" class="text-center text-muted">
                          <i class="fas fa-users-slash me-2"></i>
                          Tidak ada data user
                        </td>
                      </tr>
                    </c:if>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- Users Table -->
            <!-- Optional: Pagination jika data banyak -->
            <c:if test="${fn:length(allUsers) > 10}">
              <div
                class="d-flex justify-content-between align-items-center mt-3"
              >
                <div class="text-muted">
                  Menampilkan ${fn:length(allUsers)} user
                </div>
                <nav aria-label="User pagination">
                  <ul class="pagination pagination-sm">
                    <li class="page-item disabled">
                      <span class="page-link">Previous</span>
                    </li>
                    <li class="page-item active">
                      <span class="page-link">1</span>
                    </li>
                    <li class="page-item disabled">
                      <span class="page-link">Next</span>
                    </li>
                  </ul>
                </nav>
              </div>
            </c:if>
          </div>
          <!-- Users Table -->

          <!-- History Section -->
          <div
            id="history-section"
            class="content-section"
            style="display: none"
          >
            <div class="info-card glass-hover">
              <div class="card-header">
                <h5 class="mb-0">
                  <i class="fas fa-history me-2"></i>
                  History Log
                </h5>
              </div>
              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-hover mb-0">
                    <thead>
                      <tr
                        style="
                          background: linear-gradient(
                            135deg,
                            #667eea 0%,
                            #764ba2 100%
                          );
                          color: white;
                        "
                      >
                        <th>Tanggal</th>
                        <th>User</th>
                        <th>Action</th>
                        <th>Status</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>2025-06-03 14:30</td>
                        <td>Admin User</td>
                        <td>Login to system</td>
                        <td><span class="badge bg-success">Success</span></td>
                      </tr>
                      <tr>
                        <td>2025-06-03 13:45</td>
                        <td>john_doe</td>
                        <td>Create new ticket</td>
                        <td><span class="badge bg-info">Completed</span></td>
                      </tr>
                      <tr>
                        <td>2025-06-03 12:20</td>
                        <td>maria_santos</td>
                        <td>Update profile</td>
                        <td><span class="badge bg-success">Success</span></td>
                      </tr>
                      <tr>
                        <td>2025-06-03 11:10</td>
                        <td>developer_x</td>
                        <td>Database maintenance</td>
                        <td>
                          <span class="badge bg-warning">In Progress</span>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <!-- Ticket Section -->
          <div
            id="ticket-section"
            class="content-section"
            style="display: none"
          >
            <div class="row stats-row">
              <div class="col-md-4">
                <div class="card info-card">
                  <div class="card-body text-center">
                    <i class="fas fa-ticket-alt fa-2x text-primary mb-3"></i>
                    <h5 class="mb-0 text-white">Total Tickets</h5>
                    <h2 class="text-primary">${totalTickets}</h2>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="card info-card">
                  <div class="card-body text-center">
                    <i class="fas fa-clock fa-2x text-warning mb-3"></i>
                    <h5 class="mb-0 text-white">Pending</h5>
                    <h2 class="text-warning">${openTickets}</h2>
                  </div>
                </div>
              </div>
              <div class="col-md-4">
                <div class="card info-card">
                  <div class="card-body text-center">
                    <i class="fas fa-check-circle fa-2x text-success mb-3"></i>
                    <h5 class="mb-0 text-white">Resolved</h5>
                    <h2 class="text-success">${approvedTickets}</h2>
                  </div>
                </div>
              </div>
            </div>

            <div class="info-card glass-hover">
              <div class="card-header">
                <h5 class="mb-0 text-white">
                  <i class="fa-solid fa-globe" style="color: #ffffff"></i>
                  Recent Tickets
                </h5>
              </div>

              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-hover mb-0">
                    <thead>
                      <tr
                        style="
                          background: linear-gradient(
                            135deg,
                            #667eea 0%,
                            #764ba2 100%
                          );
                          color: white;
                        "
                      >
                        <th>ID</th>
                        <th>Title</th>
                        <th>User</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Created</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td><code>#TKT001</code></td>
                        <td>Login Issue</td>
                        <td>john_doe</td>
                        <td><span class="badge bg-danger">High</span></td>
                        <td><span class="badge bg-warning">Pending</span></td>
                        <td>2025-06-03</td>
                      </tr>
                      <tr>
                        <td><code>#TKT002</code></td>
                        <td>Database Connection</td>
                        <td>maria_santos</td>
                        <td><span class="badge bg-warning">Medium</span></td>
                        <td>
                          <span class="badge bg-info">In Progress</span>
                        </td>
                        <td>2025-06-02</td>
                      </tr>
                      <tr>
                        <td><code>#TKT003</code></td>
                        <td>Feature Request</td>
                        <td>developer_x</td>
                        <td><span class="badge bg-success">Low</span></td>
                        <td>
                          <span class="badge bg-success">Resolved</span>
                        </td>
                        <td>2025-06-01</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <!-- Technician Section -->
          <div
            id="technician-section"
            class="content-section"
            style="display: none"
          >
            <div class="row stats-row">
              <div class="col-md-6">
                <div class="card info-card">
                  <div class="card-body text-center">
                    <i class="fas fa-users-cog fa-2x text-info mb-3"></i>
                    <h5>Active Technicians</h5>
                    <h2 class="text-info">5</h2>
                  </div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="card info-card">
                  <div class="card-body text-center">
                    <i class="fas fa-tasks fa-2x text-primary mb-3"></i>
                    <h5>Assigned Tasks</h5>
                    <h2 class="text-primary">12</h2>
                  </div>
                </div>
              </div>
            </div>

            <div class="card info-card">
              <div class="card-header bg-transparent">
                <h5 class="mb-0">
                  <i class="fas fa-tools me-2"></i>
                  Technician List
                </h5>
              </div>
              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-hover mb-0">
                    <thead>
                      <tr
                        style="
                          background: linear-gradient(
                            135deg,
                            #667eea 0%,
                            #764ba2 100%
                          );
                          color: white;
                        "
                      >
                        <th>Avatar</th>
                        <th>Name</th>
                        <th>Specialization</th>
                        <th>Status</th>
                        <th>Current Tasks</th>
                        <th>Contact</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>
                          <div class="user-avatar">T</div>
                        </td>
                        <td><strong>Tech Alpha</strong></td>
                        <td>Network & Security</td>
                        <td>
                          <span class="badge bg-success">Available</span>
                        </td>
                        <td>2</td>
                        <td>
                          <a
                            href="https://wa.me/628111222333"
                            class="wa-link"
                            target="_blank"
                          >
                            <i class="fab fa-whatsapp"></i>
                          </a>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <div class="user-avatar">B</div>
                        </td>
                        <td><strong>Tech Beta</strong></td>
                        <td>Database Admin</td>
                        <td><span class="badge bg-warning">Busy</span></td>
                        <td>4</td>
                        <td>
                          <a
                            href="https://wa.me/628444555666"
                            class="wa-link"
                            target="_blank"
                          >
                            <i class="fab fa-whatsapp"></i>
                          </a>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <div class="user-avatar">G</div>
                        </td>
                        <td><strong>Tech Gamma</strong></td>
                        <td>System Integration</td>
                        <td>
                          <span class="badge bg-success">Available</span>
                        </td>
                        <td>1</td>
                        <td>
                          <a
                            href="https://wa.me/628777888999"
                            class="wa-link"
                            target="_blank"
                          >
                            <i class="fab fa-whatsapp"></i>
                          </a>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <!-- Footer -->
          <div class="footer-section">
            <div class="text-center">
              <p class="text-muted mb-0">
                Work Flow Management Dashboard Application
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

    <script>
      // Function to show different sections
      function showSection(sectionName) {
        // Hide all sections
        const sections = document.querySelectorAll(".content-section");
        sections.forEach((section) => {
          section.style.display = "none";
        });

        // Show selected section
        document.getElementById(sectionName + "-section").style.display =
          "block";

        // Update active menu
        const menuItems = document.querySelectorAll(".sidebar-menu a");
        menuItems.forEach((item) => {
          item.classList.remove("active");
        });

        // Add active class to clicked menu
        event.target.closest("a").classList.add("active");
      }

      // Function to toggle sidebar on mobile
      function toggleSidebar() {
        const sidebar = document.getElementById("sidebar");
        sidebar.classList.toggle("show");
      }

      // Close sidebar when clicking outside on mobile
      document.addEventListener("click", function (event) {
        const sidebar = document.getElementById("sidebar");
        const sidebarToggle = document.querySelector(".sidebar-toggle");

        if (
          window.innerWidth <= 768 &&
          !sidebar.contains(event.target) &&
          !sidebarToggle.contains(event.target)
        ) {
          sidebar.classList.remove("show");
        }
      });

      // Adjust layout on window resize
      window.addEventListener("resize", function () {
        const mainContent = document.querySelector(".main-content");
        const sidebar = document.getElementById("sidebar");

        if (window.innerWidth > 768) {
          sidebar.classList.remove("show");
        }
      });
    </script>
  </body>
</html>
