<%-- File: src/main/webapp/WEB-INF/views/tickets/create-ticket.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Buat Tiket Baru</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        /* CSS yang relevan (sama seperti sebelumnya) */
        body { font-family: "Poppins", sans-serif; background: linear-gradient(135deg, #0c0c0c 0%, #1a1a2e 50%, #16213e 100%); min-height: 100vh; color: rgba(255, 255, 255, 0.9); }
        .container { margin-top: 50px; padding-bottom: 50px; }
        .form-glass { background: rgba(20, 20, 30, 0.7); backdrop-filter: blur(20px); border: 1px solid rgba(100, 255, 218, 0.2); border-radius: 20px; padding: 30px; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.6); }
        .form-control, .form-select {
            background-color: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(100, 255, 218, 0.2);
            color: rgba(255, 255, 255, 0.9);
        }
        .form-control:focus, .form-select:focus {
            background-color: rgba(255, 255, 255, 0.15);
            border-color: #64ffda;
            box-shadow: 0 0 0 0.25rem rgba(100, 255, 218, 0.25);
            color: white;
        }
        .form-control::placeholder { color: rgba(255, 255, 255, 0.6); }
        .form-label { color: rgba(255, 255, 255, 0.8); }
        .btn-primary { background: linear-gradient(135deg, #64ffda, #1de9b6); border: none; color: #0c0c0c; }
        .btn-primary:hover { background: linear-gradient(135deg, #1de9b6, #00bcd4); color: #0c0c0c; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="mb-4 text-center text-white-75">Buat Tiket Baru</h1>
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="form-glass">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            ${error}
                        </div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/tickets/create" method="post">
                        <div class="mb-3">
                            <label for="title" class="form-label">Judul Tiket:</label>
                            <input type="text" class="form-control" id="title" name="title" required>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Deskripsi:</label>
                            <textarea class="form-control" id="description" name="description" rows="5" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="createdBy" class="form-label">Dibuat Oleh (Nama User):</label>
                            <input type="text" class="form-control" id="createdBy" name="createdBy" value="${sessionScope.user.username}" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="address" class="form-label">Alamat:</label>
                            <input type="text" class="form-control" id="address" name="address">
                        </div>
                        <div class="mb-3">
                            <label for="maps" class="form-label">Link Google Maps (URL):</label>
                            <input type="url" class="form-control" id="maps" name="maps" placeholder="Contoh: https://maps.app.goo.gl/...">
                        </div>
                        <button type="submit" class="btn btn-primary w-100 mt-3">Submit Tiket</button>
                    </form>
                    <a href="${pageContext.request.contextPath}/tickets" class="btn btn-secondary w-100 mt-2">Kembali ke Daftar Tiket</a>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>