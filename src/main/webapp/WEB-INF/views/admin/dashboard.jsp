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
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
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
          <a href="${pageContext.request.contextPath}/login">
            <button class="btn btn-logout">
              <i class="fas fa-sign-out-alt me-2"></i>Logout
            </button>
          </a>
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
            <a
              href="${pageContext.request.contextPath}/admin/ticket"
              onclick="showSection('ticket')"
            >
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
