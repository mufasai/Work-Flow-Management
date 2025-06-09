<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="jakarta.tags.core" %> <%@ taglib prefix="fn"
uri="jakarta.tags.functions" %> <%@ taglib prefix="fmt" uri="jakarta.tags.fmt"
%>
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
    <%@ include file="/WEB-INF/views/admin/navbar.jsp" %>
    <div class="d-flex">
      <!-- Sidebar -->
      <%@ include file="/WEB-INF/views/admin/sidebar.jsp" %>
      <!-- Main Content -->
      <main class="main-content">
        <div class="content-wrapper">
            <!-- Error Message Display -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${error}
                </div>
            </c:if>

            <!-- Statistics Cards -->
            <div class="row stats-row">
                <div class="col-md-2">
                    <div class="card info-card">
                        <div class="card-body text-center">
                            <i class="fas fa-ticket-alt fa-2x text-primary mb-3"></i>
                            <h6 class="mb-0 text-white">Total</h6>
                            <h3 class="text-primary">${totalTickets != null ? totalTickets : 0}</h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="card info-card">
                        <div class="card-body text-center">
                            <i class="fas fa-folder-open fa-2x text-info mb-3"></i>
                            <h6 class="mb-0 text-white">Open</h6>
                            <h3 class="text-info">${openTickets != null ? openTickets : 0}</h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="card info-card">
                        <div class="card-body text-center">
                            <i class="fas fa-user-check fa-2x text-warning mb-3"></i>
                            <h6 class="mb-0 text-white">Assigned</h6>
                            <h3 class="text-warning">${assignedTickets != null ? assignedTickets : 0}</h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="card info-card">
                        <div class="card-body text-center">
                            <i class="fas fa-cog fa-2x text-secondary mb-3"></i>
                            <h6 class="mb-0 text-white">Progress</h6>
                            <h3 class="text-secondary">${inProgressTickets != null ? inProgressTickets : 0}</h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="card info-card">
                        <div class="card-body text-center">
                            <i class="fas fa-check fa-2x text-primary mb-3"></i>
                            <h6 class="mb-0 text-white">Done</h6>
                            <h3 class="text-primary">${doneTickets != null ? doneTickets : 0}</h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="card info-card">
                        <div class="card-body text-center">
                            <i class="fas fa-check-circle fa-2x text-success mb-3"></i>
                            <h6 class="mb-0 text-white">Approved</h6>
                            <h3 class="text-success">${approvedTickets != null ? approvedTickets : 0}</h3>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tickets Table -->
            <div class="info-card glass-hover">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 text-white">
                        <i class="fa-solid fa-list" style="color: #ffffff"></i>
                        All Tickets
                    </h5>
                    <div class="d-flex gap-2">
                        <!-- Create New Ticket Button -->
                        <button type="button" class="btn btn-success btn-sm" onclick="openCreateModal()">
                            <i class="fas fa-plus"></i> Create Ticket
                        </button>
                        
                        <!-- Filter by Status -->
                        <select id="statusFilter" class="form-select form-select-sm" style="width: auto;">
                            <option value="">All Status</option>
                            <option value="open">Open</option>
                            <option value="assigned">Assigned</option>
                            <option value="in_progress">In Progress</option>
                            <option value="done">Done</option>
                            <option value="approved">Approved</option>
                        </select>
                        
                        <!-- Search Input -->
                        <input type="text" id="searchInput" class="form-control form-control-sm" placeholder="Search tickets..." style="width: 200px;">
                    </div>
                </div>

                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0" id="ticketsTable">
                            <thead>
                                <tr style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                                    <th>ID</th>
                                    <th>Title</th>
                                    <th>Description</th>
                                    <th>Created By</th>
                                    <th>Assigned To</th>
                                    <th>Status</th>
                                    <th>Created At</th>
                                    <th>Address</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty tickets}">
                                        <c:forEach var="ticket" items="${tickets}" varStatus="status">
                                            <tr data-status="${ticket.status}">
                                                <td><code>#${ticket.id}</code></td>
                                                <td><strong>${fn:escapeXml(ticket.title)}</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${fn:length(ticket.description) > 50}">
                                                            <span title="${fn:escapeXml(ticket.description)}">
                                                                ${fn:escapeXml(fn:substring(ticket.description, 0, 50))}...
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${fn:escapeXml(ticket.description)}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <i class="fas fa-user me-1"></i>
                                                    ${fn:escapeXml(ticket.createdBy)}
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty ticket.assignTo}">
                                                            <i class="fas fa-user-check me-1"></i>
                                                            ${fn:escapeXml(ticket.assignTo)}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">
                                                                <i class="fas fa-clock me-1"></i>
                                                                Not assigned
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${ticket.status == 'open'}">
                                                            <span class="badge bg-info">Open</span>
                                                        </c:when>
                                                        <c:when test="${ticket.status == 'assigned'}">
                                                            <span class="badge bg-warning">Assigned</span>
                                                        </c:when>
                                                        <c:when test="${ticket.status == 'in_progress'}">
                                                            <span class="badge bg-secondary">In Progress</span>
                                                        </c:when>
                                                        <c:when test="${ticket.status == 'done'}">
                                                            <span class="badge bg-primary">Done</span>
                                                        </c:when>
                                                        <c:when test="${ticket.status == 'approved'}">
                                                            <span class="badge bg-success">Approved</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-dark">${fn:escapeXml(ticket.status)}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <small class="text-muted">
                                                        <fmt:formatDate value="${ticket.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </small>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty ticket.address}">
                                                            <span title="${fn:escapeXml(ticket.address)}">
                                                                <i class="fas fa-map-marker-alt me-1"></i>
                                                                <c:choose>
                                                                    <c:when test="${fn:length(ticket.address) > 30}">
                                                                        ${fn:escapeXml(fn:substring(ticket.address, 0, 30))}...
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${fn:escapeXml(ticket.address)}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="btn-group btn-group-sm" role="group">
                                                        <button type="button" class="btn btn-outline-info" onclick="viewTicket('${ticket.id}')" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-outline-warning" onclick="editTicket('${ticket.id}')" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-outline-danger" onclick="deleteTicket('${ticket.id}')" title="Delete">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="9" class="text-center text-muted py-4">
                                                <i class="fas fa-inbox fa-2x mb-2"></i>
                                                <br>
                                                No tickets found
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Create Ticket Modal -->
    <div class="modal fade" id="createTicketModal" tabindex="-1" aria-labelledby="createTicketModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="createTicketModalLabel">
                        <i class="fas fa-plus-circle me-2"></i>Create New Ticket
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="createTicketForm">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="createTitle" class="form-label">Title <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="createTitle" name="title" required maxlength="255">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="createAssignTo" class="form-label">Assign To</label>
                                    <select class="form-select" id="createAssignTo" name="assignTo">
                                        <option value="">Select Technician</option>
                                        <!-- Options will be loaded dynamically -->
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="createDescription" class="form-label">Description <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="createDescription" name="description" rows="4" required maxlength="1000"></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="createAddress" class="form-label">Address</label>
                            <textarea class="form-control" id="createAddress" name="address" rows="2" maxlength="500"></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="createMaps" class="form-label">Maps URL</label>
                            <input type="url" class="form-control" id="createMaps" name="maps" placeholder="https://maps.google.com/...">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancel
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i>Create Ticket
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Ticket Modal -->
    <div class="modal fade" id="editTicketModal" tabindex="-1" aria-labelledby="editTicketModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editTicketModalLabel">
                        <i class="fas fa-edit me-2"></i>Edit Ticket
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="editTicketForm">
                    <input type="hidden" id="editTicketId" name="ticketId">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editTitle" class="form-label">Title <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="editTitle" name="title" required maxlength="255">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="editStatus" class="form-label">Status</label>
                                    <select class="form-select" id="editStatus" name="status">
                                        <option value="open">Open</option>
                                        <option value="assigned">Assigned</option>
                                        <option value="in_progress">In Progress</option>
                                        <option value="done">Done</option>
                                        <option value="approved">Approved</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editAssignTo" class="form-label">Assign To</label>
                            <select class="form-select" id="editAssignTo" name="assignTo">
                                <option value="">Select Technician</option>
                                <!-- Options will be loaded dynamically -->
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editDescription" class="form-label">Description <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="editDescription" name="description" rows="4" required maxlength="1000"></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editAddress" class="form-label">Address</label>
                            <textarea class="form-control" id="editAddress" name="address" rows="2" maxlength="500"></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editMaps" class="form-label">Maps URL</label>
                            <input type="url" class="form-control" id="editMaps" name="maps" placeholder="https://maps.google.com/...">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Cancel
                        </button>
                        <button type="submit" class="btn btn-warning">
                            <i class="fas fa-save me-1"></i>Update Ticket
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- View Ticket Modal -->
    <div class="modal fade" id="viewTicketModal" tabindex="-1" aria-labelledby="viewTicketModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewTicketModalLabel">
                        <i class="fas fa-eye me-2"></i>Ticket Details
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Ticket ID</label>
                                <p id="viewTicketIdDisplay" class="form-control-plaintext"></p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Status</label>
                                <p id="viewStatusDisplay" class="form-control-plaintext"></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Title</label>
                        <p id="viewTitleDisplay" class="form-control-plaintext"></p>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Description</label>
                        <p id="viewDescriptionDisplay" class="form-control-plaintext" style="white-space: pre-wrap;"></p>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Created By</label>
                                <p id="viewCreatedByDisplay" class="form-control-plaintext"></p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Assigned To</label>
                                <p id="viewAssignToDisplay" class="form-control-plaintext"></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Address</label>
                        <p id="viewAddressDisplay" class="form-control-plaintext"></p>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Maps</label>
                        <p id="viewMapsDisplay" class="form-control-plaintext"></p>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Created At</label>
                                <p id="viewCreatedAtDisplay" class="form-control-plaintext"></p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Updated At</label>
                                <p id="viewUpdatedAtDisplay" class="form-control-plaintext"></p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Close
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

    <script>
      // Function to show different sections
      function showSection(sectionName) {
        const sections = document.querySelectorAll(".content-section");
        sections.forEach((section) => {
          section.style.display = "none";
        });

        document.getElementById(sectionName + "-section").style.display =
          "block";

        const menuItems = document.querySelectorAll(".sidebar-menu a");
        menuItems.forEach((item) => {
          item.classList.remove("active");
        });

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
        const sidebar = document.getElementById("sidebar");
        if (window.innerWidth > 768) {
          sidebar.classList.remove("show");
        }
      });

      // Filter and Search Functions
      document.addEventListener("DOMContentLoaded", function () {
        const statusFilter = document.getElementById("statusFilter");
        const searchInput = document.getElementById("searchInput");
        const table = document.getElementById("ticketsTable");
        const rows = table.querySelectorAll("tbody tr[data-status]");

        function filterTable() {
          const statusValue = statusFilter.value.toLowerCase();
          const searchValue = searchInput.value.toLowerCase();

          rows.forEach((row) => {
            const status = row.getAttribute("data-status").toLowerCase();
            const text = row.textContent.toLowerCase();

            const statusMatch = !statusValue || status === statusValue;
            const searchMatch = !searchValue || text.includes(searchValue);

            if (statusMatch && searchMatch) {
              row.style.display = "";
            } else {
              row.style.display = "none";
            }
          });

          // Update visible count
          const visibleRows = Array.from(rows).filter(
            (row) => row.style.display !== "none"
          );
          const countElement = document.querySelector(".mt-3.text-muted small");
          if (countElement) {
            countElement.textContent = `Showing ${visibleRows.length} ticket(s)`;
          }
        }

        statusFilter.addEventListener("change", filterTable);
        searchInput.addEventListener("input", filterTable);
      });

      // Action Functions
      function viewTicket(ticketId) {
        // Implement view ticket functionality
        alert("View ticket #" + ticketId + " - Feature to be implemented");
      }

      function editTicket(ticketId) {
        // Implement edit ticket functionality
        alert("Edit ticket #" + ticketId + " - Feature to be implemented");
      }

      function viewLocation(mapsUrl) {
        if (mapsUrl) {
          window.open(mapsUrl, "_blank");
        }
      }
      let allTickets = [];

        // DOM Ready
        document.addEventListener('DOMContentLoaded', function() {
            initializeTicketTable();
            setupEventListeners();
            loadTechnicians();
        });

        function initializeTicketTable() {
            const table = document.getElementById('ticketsTable');
            const rows = table.querySelectorAll('tbody tr[data-status]');
            
            allTickets = Array.from(rows).map(row => {
                return {
                    element: row,
                    status: row.getAttribute('data-status'),
                    text: row.textContent.toLowerCase()
                };
            });
        }

        function setupEventListeners() {
            // Status filter
            document.getElementById('statusFilter').addEventListener('change', filterTickets);
            
            // Search input
            document.getElementById('searchInput').addEventListener('input', filterTickets);
            
            // Form submissions
            document.getElementById('createTicketForm').addEventListener('submit', handleCreateTicket);
            document.getElementById('editTicketForm').addEventListener('submit', handleEditTicket);
        }

        function filterTickets() {
            const statusFilter = document.getElementById('statusFilter').value;
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();

            allTickets.forEach(ticket => {
                let show = true;

                // Status filter
                if (statusFilter && ticket.status !== statusFilter) {
                    show = false;
                }

                // Search filter
                if (searchTerm && !ticket.text.includes(searchTerm)) {
                    show = false;
                }

                ticket.element.style.display = show ? '' : 'none';
            });
        }

        function openCreateModal() {
            document.getElementById('createTicketForm').reset();
            new bootstrap.Modal(document.getElementById('createTicketModal')).show();
        }

        function handleCreateTicket(e) {
            e.preventDefault();
            
            const formData = new FormData(e.target);
            formData.append('action', 'create');

            fetch('${pageContext.request.contextPath}/admin/ticket', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showAlert('success', data.message);
                    bootstrap.Modal.getInstance(document.getElementById('createTicketModal')).hide();
                    setTimeout(() => location.reload(), 1000);
                } else {
                    showAlert('danger', data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('danger', 'An error occurred while creating the ticket');
            });
        }

        function editTicket(ticketId) {
            fetch('${pageContext.request.contextPath}/admin/ticket?action=view&ticketId=' + ticketId)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const ticket = data.ticket;
                    
                    document.getElementById('editTicketId').value = ticket.id;
                    document.getElementById('editTitle').value = ticket.title;
                    document.getElementById('editDescription').value = ticket.description;
                    document.getElementById('editStatus').value = ticket.status;
                    document.getElementById('editAssignTo').value = ticket.assignTo || '';
                    document.getElementById('editAddress').value = ticket.address || '';
                    document.getElementById('editMaps').value = ticket.maps || '';
                    
                    new bootstrap.Modal(document.getElementById('editTicketModal')).show();
                } else {
                    showAlert('danger', data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('danger', 'Failed to load ticket details');
            });
        }

        function handleEditTicket(e) {
            e.preventDefault();
            
            const formData = new FormData(e.target);
            formData.append('action', 'update');

            fetch('${pageContext.request.contextPath}/admin/ticket', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showAlert('success', data.message);
                    bootstrap.Modal.getInstance(document.getElementById('editTicketModal')).hide();
                    setTimeout(() => location.reload(), 1000);
                } else {
                    showAlert('danger', data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('danger', 'An error occurred while updating the ticket');
            });
        }

        function viewTicket(ticketId) {
            fetch('${pageContext.request.contextPath}/admin/ticket?action=view&ticketId=' + ticketId)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const ticket = data.ticket;
                    
                    document.getElementById('viewTicketIdDisplay').textContent = '#' + ticket.id;
                    document.getElementById('viewTitleDisplay').textContent = ticket.title;
                    document.getElementById('viewDescriptionDisplay').textContent = ticket.description;
                    document.getElementById('viewCreatedByDisplay').textContent = ticket.createdBy;
                    document.getElementById('viewAssignToDisplay').textContent = ticket.assignTo || 'Not assigned';
                    document.getElementById('viewAddressDisplay').textContent = ticket.address || '-';
                    document.getElementById('viewMapsDisplay').innerHTML = ticket.maps ? 
                        `<a href="${ticket.maps}" target="_blank" class="btn btn-sm btn-outline-primary"><i class="fas fa-external-link-alt"></i> Open Maps</a>` : '-';
                    document.getElementById('viewCreatedAtDisplay').textContent = formatDateTime(ticket.createdAt);
                    document.getElementById('viewUpdatedAtDisplay').textContent = formatDateTime(ticket.updatedAt);
                    
                    // Status badge
                    const statusBadge = getStatusBadge(ticket.status);
                    document.getElementById('viewStatusDisplay').innerHTML = statusBadge;
                    
                    new bootstrap.Modal(document.getElementById('viewTicketModal')).show();
                } else {
                    showAlert('danger', data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showAlert('danger', 'Failed to load ticket details');
            });
        }

        function deleteTicket(ticketId) {
            if (confirm('Are you sure you want to delete this ticket? This action cannot be undone.')) {
                const formData = new FormData();
                formData.append('action', 'delete');
                formData.append('ticketId', ticketId);

                fetch('${pageContext.request.contextPath}/admin/ticket', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showAlert('success', data.message);
                        setTimeout(() => location.reload(), 1000);
                    } else {
                        showAlert('danger', data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showAlert('danger', 'An error occurred while deleting the ticket');
                });
            }
        }
        
    </script>
  </body>
</html>
