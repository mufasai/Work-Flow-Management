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
    <div class="sidebar" id="sidebar">
      <ul class="sidebar-menu">
        <li>
          <a href="" class="active" onclick="showSection('ticket')">
            <i class="fas fa-ticket-alt"></i>
            Ticket
          </a>
        </li>
      </ul>
    </div>
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
