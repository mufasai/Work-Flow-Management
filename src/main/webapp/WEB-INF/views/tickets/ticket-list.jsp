<%-- File: src/main/webapp/WEB-INF/views/tickets/ticket-list.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Daftar Tiket</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <style>
        /* CSS yang relevan (sama seperti sebelumnya) */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Poppins", sans-serif; background: linear-gradient(135deg, #0c0c0c 0%, #1a1a2e 50%, #16213e 100%); min-height: 100vh; color: rgba(255, 255, 255, 0.9); position: relative; overflow-x: hidden; }
        body::before {
            content: ""; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: radial-gradient(circle at 20% 80%, rgba(100, 255, 218, 0.05) 0%, transparent 50%),
                        radial-gradient(circle at 80% 20%, rgba(29, 233, 182, 0.03) 0%, transparent 50%),
                        radial-gradient(circle at 40% 40%, rgba(0, 188, 212, 0.04) 0%, transparent 50%);
            animation: float 20s ease-in-out infinite; z-index: -1;
        }
        @keyframes float { 0%, 100% { transform: translateY(0px) rotate(0deg); } 33% { transform: translateY(-30px) rotate(0.5deg); } 66% { transform: translateY(20px) rotate(-0.5deg); } }
        .floating-shapes { position: fixed; width: 100%; height: 100%; pointer-events: none; z-index: -1; }
        .shape { position: absolute; background: rgba(100, 255, 218, 0.02); border: 1px solid rgba(100, 255, 218, 0.1); border-radius: 50%; animation: floatShapes 15s infinite ease-in-out; }
        .shape:nth-child(1) { width: 80px; height: 80px; top: 10%; left: 10%; animation-delay: 0s; }
        .shape:nth-child(2) { width: 60px; height: 60px; top: 70%; right: 10%; animation-delay: 2s; }
        .shape:nth-child(3) { width: 100px; height: 100px; top: 50%; left: 5%; animation-delay: 4s; }
        .shape:nth-child(4) { width: 120px; height: 120px; top: 20%; right: 5%; animation-delay: 6s; }
        @keyframes floatShapes { 0%, 100% { transform: translateY(0px) translateX(0px) rotate(0deg); } 25% { transform: translateY(-20px) translateX(10px) rotate(90deg); } 50% { transform: translateY(20px) translateX(-10px) rotate(180deg); } 75% { transform: translateY(-10px) translateX(20px) rotate(270deg); } }
        .glass { background: rgba(20, 20, 30, 0.7); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); border: 1px solid rgba(100, 255, 218, 0.2); border-radius: 20px; box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.6), inset 0 1px 0 0 rgba(255, 255, 255, 0.1); }
        .container { margin-top: 50px; padding-bottom: 50px;}
        .table-glass { background: rgba(20, 20, 30, 0.7); backdrop-filter: blur(20px); border: 1px solid rgba(100, 255, 218, 0.2); border-radius: 20px; overflow: hidden; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.6); }
        .table { color: rgba(255, 255, 255, 0.9); margin-bottom: 0; }
        .table thead th { background: linear-gradient(135deg, #64ffda 0%, #1de9b6 50%, #00bcd4 100%); color: #0c0c0c; border: none; font-weight: 600; padding: 1rem; }
        .table td { border-color: rgba(100, 255, 218, 0.1); padding: 1rem; vertical-align: middle; }
        .table tbody tr:hover { background: rgba(100, 255, 218, 0.05); }

        /* Status Badges */
        .status-badge { padding: 0.5rem 1rem; border-radius: 20px; font-weight: 500; display: inline-block; color: white; }
        .status-open { background-color: #007bff; }
        .status-assigned { background-color: #ffc107; color: #0c0c0c !important; }
        .status-in_progress { background-color: #17a2b8; }
        .status-done { background-color: #28a745; }
        .status-approved { background-color: #6f42c1; }
        .status-declined { background-color: #dc3545; }

        .btn-action { margin-right: 5px; }
        .filter-form { margin-bottom: 20px; background: rgba(20, 20, 30, 0.7); backdrop-filter: blur(20px); border: 1px solid rgba(100, 255, 218, 0.2); border-radius: 20px; padding: 20px; }
        .back-button { margin-bottom: 20px; }
        .form-select {
            background-color: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(100, 255, 218, 0.2);
            color: rgba(255, 255, 255, 0.9);
        }
        .form-select:focus {
            background-color: rgba(255, 255, 255, 0.15);
            border-color: #64ffda;
            box-shadow: 0 0 0 0.25rem rgba(100, 255, 218, 0.25);
            color: white;
        }
    </style>
</head>
<body>
    <div class="floating-shapes">
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
    </div>

    <div class="container">
        <h1 class="mb-4 text-center text-white-75">Daftar Tiket</h1>

        <div class="back-button">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i>Kembali ke Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/tickets/create" class="btn btn-success ms-2">
                <i class="fas fa-plus-circle me-2"></i>Buat Tiket Baru
            </a>
        </div>

        <div class="filter-form">
            <form action="${pageContext.request.contextPath}/tickets/filter" method="get" class="d-flex align-items-center">
                <label for="statusFilter" class="form-label me-3 mb-0 text-white-75">Filter Status:</label>
                <select id="statusFilter" name="status" class="form-select w-auto" onchange="this.form.submit()">
                    <option value="all" ${currentFilterStatus == 'all' || empty currentFilterStatus ? 'selected' : ''}>Semua Status</option>
                    <option value="open" ${currentFilterStatus == 'open' ? 'selected' : ''}>Open</option>
                    <option value="assigned" ${currentFilterStatus == 'assigned' ? 'selected' : ''}>Assigned</option>
                    <option value="in_progress" ${currentFilterStatus == 'in_progress' ? 'selected' : ''}>In Progress</option>
                    <option value="done" ${currentFilterStatus == 'done' ? 'selected' : ''}>Done</option>
                    <option value="approved" ${currentFilterStatus == 'approved' ? 'selected' : ''}>Approved</option>
                    <option value="declined" ${currentFilterStatus == 'declined' ? 'selected' : ''}>Declined</option>
                </select>
            </form>
        </div>

        <div class="table-glass">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Judul</th>
                            <th>Deskripsi</th>
                            <th>Dibuat Oleh</th>
                            <th>Ditugaskan Ke</th>
                            <th>Status</th>
                            <th>Alamat</th>
                            <th>Maps</th> <%-- <--- TAMBAHAN KOLOM DI HEADER TABEL ---> --%>
                            <th>Dibuat Pada</th>
                            <th>Diperbarui Pada</th>
                            <th>Alasan Penolakan</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ticket" items="${tickets}">
                            <tr>
                                <td>${ticket.id}</td>
                                <td>${ticket.title}</td>
                                <td>${ticket.description}</td>
                                <td>${ticket.createdBy}</td>
                                <td>${ticket.assignTo != null ? ticket.assignTo : '-'}</td>
                                <td><span class="status-badge status-${ticket.status}">${ticket.status}</span></td>
                                <td>${ticket.address}</td>
                                <td>
                                    <c:if test="${not empty ticket.maps}">
                                        <a href="${ticket.maps}" target="_blank" class="btn btn-sm btn-outline-info">Lihat Maps</a>
                                    </c:if>
                                    <c:if test="${empty ticket.maps}">-</c:if>
                                </td> <%-- <--- MENAMPILKAN DATA MAPS ---> --%>
                                <td>${ticket.createdAt}</td>
                                <td>${ticket.updatedAt}</td>
                                <td>${ticket.declinedReason != null ? ticket.declinedReason : '-'}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/tickets/updateStatus" method="post" style="display:inline-block;">
                                        <input type="hidden" name="ticketId" value="${ticket.id}" />
                                        <select name="status" class="form-select form-select-sm" onchange="this.form.submit()">
                                            <option value="open" ${ticket.status eq 'open' ? 'selected' : ''}>Open</option>
                                            <option value="assigned" ${ticket.status eq 'assigned' ? 'selected' : ''}>Assigned</option>
                                            <option value="in_progress" ${ticket.status eq 'in_progress' ? 'selected' : ''}>In Progress</option>
                                            <option value="done" ${ticket.status eq 'done' ? 'selected' : ''}>Done</option>
                                            <option value="approved" ${ticket.status eq 'approved' ? 'selected' : ''}>Approved</option>
                                            <option value="declined" ${ticket.status eq 'declined' ? 'selected' : ''}>Declined</option>
                                        </select>
                                        <%-- Untuk declineReason, Anda bisa menambahkan input modal atau input tersembunyi yang muncul via JS --%>
                                    </form>

                                    <a href="${pageContext.request.contextPath}/tickets/assign?ticketId=${ticket.id}" class="btn btn-sm btn-warning mt-1">Assign</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty tickets}">
                            <tr>
                                <td colspan="12" class="text-center text-muted">Tidak ada tiket ditemukan.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>