<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="id">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - Sistem Akademik</title>
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
        height: 100vh;
        overflow: hidden;
        background: linear-gradient(
          135deg,
          #0c0c0c 0%,
          #1a1a2e 50%,
          #16213e 100%
        );
        position: relative;
      }

      /* Animated Background */
      body::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: radial-gradient(
            circle at 20% 80%,
            rgba(0, 255, 255, 0.1) 0%,
            transparent 50%
          ),
          radial-gradient(
            circle at 80% 20%,
            rgba(255, 255, 255, 0.05) 0%,
            transparent 50%
          ),
          radial-gradient(
            circle at 40% 40%,
            rgba(100, 255, 218, 0.08) 0%,
            transparent 50%
          );
        animation: float 20s ease-in-out infinite;
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
        position: absolute;
        width: 100%;
        height: 100%;
        overflow: hidden;
        z-index: 0;
      }

      .shape {
        position: absolute;
        background: rgba(255, 255, 255, 0.03);
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
        left: 80%;
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
        left: 85%;
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

      .main-container {
        height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        position: relative;
        z-index: 1;
      }

      .login-card {
        background: rgba(20, 20, 30, 0.7);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border: 1px solid rgba(100, 255, 218, 0.2);
        border-radius: 20px;
        padding: 3rem 2.5rem;
        width: 100%;
        max-width: 420px;
        box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.6),
          inset 0 1px 0 0 rgba(255, 255, 255, 0.1),
          inset 0 -1px 0 0 rgba(100, 255, 218, 0.1);
        position: relative;
        overflow: hidden;
        transition: all 0.3s ease;
      }

      .login-card::before {
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

      .login-card:hover::before {
        left: 100%;
      }

      .login-card:hover {
        transform: translateY(-5px);
        border-color: rgba(100, 255, 218, 0.4);
        box-shadow: 0 15px 45px 0 rgba(0, 0, 0, 0.8),
          inset 0 1px 0 0 rgba(255, 255, 255, 0.2),
          0 0 30px rgba(100, 255, 218, 0.2);
      }

      .logo-section {
        text-align: center;
        margin-bottom: 2rem;
      }

      .logo-icon {
        width: 80px;
        height: 80px;
        background: linear-gradient(135deg, #64ffda, #1de9b6, #00bcd4);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 1rem;
        box-shadow: 0 10px 30px rgba(100, 255, 218, 0.3),
          0 0 20px rgba(100, 255, 218, 0.2);
        animation: pulse 2s infinite;
      }

      @keyframes pulse {
        0% {
          transform: scale(1);
        }
        50% {
          transform: scale(1.05);
        }
        100% {
          transform: scale(1);
        }
      }

      .logo-icon i {
        font-size: 2rem;
        color: #0c0c0c;
        text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
      }

      .login-title {
        color: rgba(255, 255, 255, 0.95);
        font-weight: 600;
        font-size: 1.8rem;
        margin-bottom: 0.5rem;
        text-shadow: 0 2px 20px rgba(100, 255, 218, 0.3);
      }

      .login-subtitle {
        color: rgba(255, 255, 255, 0.6);
        font-weight: 300;
        font-size: 0.9rem;
      }

      .form-floating {
        margin-bottom: 1.5rem;
      }

      .form-floating .form-control {
        background: rgba(30, 30, 40, 0.6);
        border: 1px solid rgba(100, 255, 218, 0.2);
        border-radius: 15px;
        color: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(10px);
        transition: all 0.3s ease;
        font-size: 1rem;
        padding: 1rem 1rem;
        height: calc(3.5rem + 2px);
      }

      .form-floating .form-control:focus {
        background: rgba(30, 30, 40, 0.8);
        border-color: rgba(100, 255, 218, 0.6);
        box-shadow: 0 0 0 0.25rem rgba(100, 255, 218, 0.15),
          0 0 20px rgba(100, 255, 218, 0.1);
        color: rgba(255, 255, 255, 1);
      }

      .form-floating .form-control::placeholder {
        color: rgba(255, 255, 255, 0.4);
      }

      .form-floating label {
        color: rgba(255, 255, 255, 0.7);
        font-weight: 400;
      }

      .btn-login {
        background: linear-gradient(
          135deg,
          #64ffda 0%,
          #1de9b6 50%,
          #00bcd4 100%
        );
        border: none;
        border-radius: 15px;
        color: #0c0c0c;
        font-weight: 600;
        padding: 1rem;
        font-size: 1.1rem;
        width: 100%;
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
        box-shadow: 0 10px 30px rgba(100, 255, 218, 0.3),
          0 0 20px rgba(100, 255, 218, 0.1);
        text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
      }

      .btn-login::before {
        content: "";
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(
          135deg,
          #1de9b6 0%,
          #64ffda 50%,
          #00e5ff 100%
        );
        transition: left 0.3s ease;
        z-index: -1;
      }

      .btn-login:hover::before {
        left: 0;
      }

      .btn-login:hover {
        transform: translateY(-2px);
        box-shadow: 0 15px 40px rgba(100, 255, 218, 0.4),
          0 0 30px rgba(100, 255, 218, 0.2);
      }

      .error-message {
        background: rgba(50, 20, 20, 0.8);
        border: 1px solid rgba(255, 82, 82, 0.3);
        color: rgba(255, 255, 255, 0.9);
        border-radius: 10px;
        padding: 0.75rem 1rem;
        margin-bottom: 1.5rem;
        backdrop-filter: blur(10px);
        animation: shake 0.5s ease-in-out;
        box-shadow: 0 4px 20px rgba(255, 82, 82, 0.1);
      }

      @keyframes shake {
        0%,
        100% {
          transform: translateX(0);
        }
        25% {
          transform: translateX(-5px);
        }
        75% {
          transform: translateX(5px);
        }
      }

      .input-group {
        position: relative;
      }

      .input-icon {
        position: absolute;
        right: 15px;
        top: 50%;
        transform: translateY(-50%);
        color: rgba(100, 255, 218, 0.6);
        z-index: 10;
        cursor: pointer;
        transition: color 0.3s ease;
      }

      .input-icon:hover {
        color: rgba(100, 255, 218, 0.9);
      }

      /* Responsive design */
      @media (max-width: 768px) {
        .login-card {
          margin: 1rem;
          padding: 2rem 1.5rem;
        }

        .login-title {
          font-size: 1.5rem;
        }
      }

      /* Loading animation */
      .btn-login:disabled {
        opacity: 0.7;
        cursor: not-allowed;
      }

      .spinner-border-sm {
        width: 1rem;
        height: 1rem;
      }
    </style>
  </head>

  <body>
    <!-- Floating shapes background -->
    <div class="floating-shapes">
      <div class="shape"></div>
      <div class="shape"></div>
      <div class="shape"></div>
      <div class="shape"></div>
    </div>

    <div class="main-container">
      <div class="login-card">
        <div class="logo-section">
          <div class="logo-icon">
            <i class="fa-solid fa-globe"></i>
          </div>
          <h2 class="login-title">Work Flow Management</h2>
          <p class="login-subtitle">Silakan masuk untuk melanjutkan</p>
        </div>

        <c:if test="${not empty error}">
          <div class="error-message">
            <i class="fas fa-exclamation-triangle me-2"></i>
            ${error}
          </div>
        </c:if>

        <form
          action="${pageContext.request.contextPath}/login"
          method="post"
          id="loginForm"
        >
          <div class="form-floating mb-3">
            <input
              type="text"
              class="form-control"
              id="username"
              name="username"
              placeholder="Username"
              required
            />
            <label for="username">
              <i class="fas fa-user me-2"></i>Username
            </label>
          </div>

          <div class="form-floating mb-4">
            <div class="input-group">
              <input
                type="password"
                class="form-control"
                id="password"
                name="password"
                placeholder="Password"
                required
              />
              <span class="input-icon" onclick="togglePassword()">
                <i class="fas fa-eye" id="toggleIcon"></i>
              </span>
            </div>
            <label for="password">
              <i class="fas fa-lock me-2"></i>Password
            </label>
          </div>

          <button type="submit" class="btn btn-login" id="loginBtn">
            <span class="btn-text">
              <i class="fas fa-sign-in-alt me-2"></i>
              Masuk
            </span>
            <span class="btn-loading d-none">
              <span
                class="spinner-border spinner-border-sm me-2"
                role="status"
              ></span>
              Memproses...
            </span>
          </button>
        </form>
      </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>

    <script>
      // Toggle password visibility
      function togglePassword() {
        const passwordInput = document.getElementById("password");
        const toggleIcon = document.getElementById("toggleIcon");

        if (passwordInput.type === "password") {
          passwordInput.type = "text";
          toggleIcon.classList.remove("fa-eye");
          toggleIcon.classList.add("fa-eye-slash");
        } else {
          passwordInput.type = "password";
          toggleIcon.classList.remove("fa-eye-slash");
          toggleIcon.classList.add("fa-eye");
        }
      }

      // Form submission with loading state
      document
        .getElementById("loginForm")
        .addEventListener("submit", function () {
          const loginBtn = document.getElementById("loginBtn");
          const btnText = loginBtn.querySelector(".btn-text");
          const btnLoading = loginBtn.querySelector(".btn-loading");

          loginBtn.disabled = true;
          btnText.classList.add("d-none");
          btnLoading.classList.remove("d-none");
        });

      // Add floating animation to form elements
      document.addEventListener("DOMContentLoaded", function () {
        const formElements = document.querySelectorAll(".form-control");

        formElements.forEach((element, index) => {
          element.style.animationDelay = `${index * 0.1}s`;
          element.classList.add("animate__animated", "animate__fadeInUp");
        });
      });

      // Add ripple effect to button
      document
        .querySelector(".btn-login")
        .addEventListener("click", function (e) {
          const ripple = document.createElement("span");
          const rect = this.getBoundingClientRect();
          const size = Math.max(rect.width, rect.height);
          ripple.style.width = ripple.style.height = size + "px";
          ripple.style.left = e.clientX - rect.left - size / 2 + "px";
          ripple.style.top = e.clientY - rect.top - size / 2 + "px";
          ripple.style.position = "absolute";
          ripple.style.borderRadius = "50%";
          ripple.style.background = "rgba(255, 255, 255, 0.3)";
          ripple.style.transform = "scale(0)";
          ripple.style.animation = "ripple 0.6s linear";
          ripple.style.pointerEvents = "none";

          this.style.position = "relative";
          this.style.overflow = "hidden";
          this.appendChild(ripple);

          setTimeout(() => {
            ripple.remove();
          }, 600);
        });

      // Add CSS for ripple animation
      const style = document.createElement("style");
      style.textContent = `
            @keyframes ripple {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
        `;
      document.head.appendChild(style);
    </script>
  </body>
</html>
