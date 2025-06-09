<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ taglib prefix="c" uri="jakarta.tags.core" %> 
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
    <%@ include file="/WEB-INF/views/technician/navbar.jsp" %>
    <div class="d-flex">
      <!-- Sidebar -->
      <%@ include file="/WEB-INF/views/technician/sidebar.jsp" %>
      <!-- Main Content -->
      <main class="main-content">
        <div class="content-wrapper">
          <!-- Ticket Section -->
          <div id="ticket-section" class="content-section">
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
                              <td>
                                <strong>${fn:escapeXml(ticket.title)}</strong>
                              </td>
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
                                    <span class="text-muted">Not Assigned</span>
                                  </c:otherwise>
                                </c:choose>
                              </td>
                              <td>
                                <c:choose>
                                  <c:when test="${ticket.status == 'open'}">
                                    <span class="badge bg-info">
                                      <i class="fas fa-folder-open me-1"></i>Open
                                    </span>
                                  </c:when>
                                  <c:when test="${ticket.status == 'assigned'}">
                                    <span class="badge bg-warning">
                                      <i class="fas fa-user-check me-1"></i>Assigned
                                    </span>
                                  </c:when>
                                  <c:when test="${ticket.status == 'in_progress'}">
                                    <span class="badge bg-secondary">
                                      <i class="fas fa-cog me-1"></i>In Progress
                                    </span>
                                  </c:when>
                                  <c:when test="${ticket.status == 'done'}">
                                    <span class="badge bg-primary">
                                      <i class="fas fa-check me-1"></i>Done
                                    </span>
                                  </c:when>
                                  <c:when test="${ticket.status == 'approved'}">
                                    <span class="badge bg-success">
                                      <i class="fas fa-check-circle me-1"></i>Approved
                                    </span>
                                  </c:when>
                                  <c:otherwise>
                                    <span class="badge bg-light text-dark">${fn:escapeXml(ticket.status)}</span>
                                  </c:otherwise>
                                </c:choose>
                              </td>
                              <td>
                                <c:if test="${not empty ticket.createdAt}">
                                  <fmt:formatDate value="${ticket.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </c:if>
                              </td>
                              <td>
                                <c:choose>
                                  <c:when test="${not empty ticket.address}">
                                    <span title="${fn:escapeXml(ticket.address)}">
                                      <i class="fas fa-map-marker-alt me-1"></i>
                                      <c:choose>
                                        <c:when test="${fn:length(ticket.address) > 20}">
                                          ${fn:escapeXml(fn:substring(ticket.address, 0, 20))}...
                                        </c:when>
                                        <c:otherwise>
                                          ${fn:escapeXml(ticket.address)}
                                        </c:otherwise>
                                      </c:choose>
                                    </span>
                                  </c:when>
                                  <c:otherwise>
                                    <span class="text-muted">No Address</span>
                                  </c:otherwise>
                                </c:choose>
                              </td>
                              <td>
                                <div class="btn-group btn-group-sm" role="group">
                                  <!-- Standard Actions for All Status -->
                                  <button type="button" class="btn btn-outline-primary" title="View Details" 
                                          onclick="viewTicket('${ticket.id}')">
                                    <i class="fas fa-eye"></i>
                                  </button>
                                  <button type="button" class="btn btn-outline-success" title="Edit Ticket"
                                          onclick="editTicket('${ticket.id}')">
                                    <i class="fas fa-edit"></i>
                                  </button>
                                  <c:if test="${not empty ticket.maps}">
                                    <button type="button" class="btn btn-outline-info" title="View Location"
                                            onclick="viewLocation('${ticket.maps}')">
                                      <i class="fas fa-map"></i>
                                    </button>
                                  </c:if>
                                  
                                  <!-- Special Actions for Open Status Only -->
                                  <c:if test="${ticket.status == 'open'}">
                                    <button type="button" class="btn btn-outline-success" title="Accept Ticket"
                                            onclick="acceptTicket('${ticket.id}')">
                                      <i class="fas fa-check"></i> Accept
                                    </button>
                                    <button type="button" class="btn btn-outline-danger" title="Decline Ticket"
                                            onclick="showDeclineModal('${ticket.id}', '${fn:escapeXml(ticket.title)}')">
                                      <i class="fas fa-times"></i> Decline
                                    </button>
                                  </c:if>
                                </div>
                              </td>
                            </tr>
                          </c:forEach>
                        </c:when>
                        <c:otherwise>
                          <tr>
                            <td colspan="9" class="text-center text-muted py-4">
                              <i class="fas fa-inbox fa-3x mb-3"></i>
                              <br>
                              No tickets found
                            </td>
                          </tr>
                        </c:otherwise>
                      </c:choose>
                    </tbody>
                  </table>
                </div>
                
                <!-- Pagination Info -->
                <c:if test="${not empty tickets and fn:length(tickets) > 0}">
                  <div class="mt-3 text-muted" style="color: #ffffff;">
                    <small>Showing ${fn:length(tickets)} ticket(s)</small>
                  </div>
                </c:if>
              </div>
            </div>
            
            <!-- Decline Modal -->
            <div class="modal fade" id="declineModal" tabindex="-1" aria-labelledby="declineModalLabel" aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="declineModalLabel">Decline Ticket</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <div class="mb-3">
                      <label class="form-label"><strong>Ticket:</strong> <span id="declineTicketTitle"></span></label>
                    </div>
                    <div class="mb-3">
                      <label for="declineReason" class="form-label">Reason for declining:</label>
                      <textarea class="form-control" id="declineReason" rows="3" placeholder="Please provide a reason for declining this ticket..." required></textarea>
                    </div>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" onclick="confirmDeclineTicket()">
                      <i class="fas fa-times me-1"></i>Decline Ticket
                    </button>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- Toast Notifications -->
            <div class="toast-container position-fixed top-0 end-0 p-3">
              <div id="successToast" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                  <div class="toast-body">
                    <i class="fas fa-check-circle me-2"></i>
                    <span id="successMessage"></span>
                  </div>
                  <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
              </div>
              
              <div id="errorToast" class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                  <div class="toast-body">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <span id="errorMessage"></span>
                  </div>
                  <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
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

        document.getElementById(sectionName + "-section").style.display = "block";

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
      document.addEventListener('DOMContentLoaded', function() {
        const statusFilter = document.getElementById('statusFilter');
        const searchInput = document.getElementById('searchInput');
        const table = document.getElementById('ticketsTable');
        const rows = table.querySelectorAll('tbody tr[data-status]');

        function filterTable() {
          const statusValue = statusFilter.value.toLowerCase();
          const searchValue = searchInput.value.toLowerCase();

          rows.forEach(row => {
            const status = row.getAttribute('data-status').toLowerCase();
            const text = row.textContent.toLowerCase();
            
            const statusMatch = !statusValue || status === statusValue;
            const searchMatch = !searchValue || text.includes(searchValue);
            
            if (statusMatch && searchMatch) {
              row.style.display = '';
            } else {
              row.style.display = 'none';
            }
          });

          // Update visible count
          const visibleRows = Array.from(rows).filter(row => row.style.display !== 'none');
          const countElement = document.querySelector('.mt-3.text-muted small');
          if (countElement) {
            countElement.textContent = `Showing ${visibleRows.length} ticket(s)`;
          }
        }

        statusFilter.addEventListener('change', filterTable);
        searchInput.addEventListener('input', filterTable);
      });

      // Action Functions
      function viewTicket(ticketId) {
        // Implement view ticket functionality
        alert('View ticket #' + ticketId + ' - Feature to be implemented');
      }

      function editTicket(ticketId) {
        // Implement edit ticket functionality
        alert('Edit ticket #' + ticketId + ' - Feature to be implemented');
      }

      function viewLocation(mapsUrl) {
        if (mapsUrl) {
          window.open(mapsUrl, '_blank');
        }
      }
      let currentDeclineTicketId = null;

      // Function to accept ticket
      function acceptTicket(ticketId) {
          if (confirm('Are you sure you want to accept this ticket?')) {
              const formData = new FormData();
              formData.append('action', 'accept');
              formData.append('ticketId', ticketId);
              
              fetch('${pageContext.request.contextPath}/technician/ticket', {
                  method: 'POST',
                  body: formData
              })
              .then(response => response.json())
              .then(data => {
                  if (data.status === 'success') {
                      showToast('successToast', data.message);
                      // Reload page after 1.5 seconds
                      setTimeout(() => {
                          location.reload();
                      }, 1500);
                  } else {
                      showToast('errorToast', data.message);
                  }
              })
              .catch(error => {
                  console.error('Error:', error);
                  showToast('errorToast', 'An error occurred while accepting the ticket.');
              });
          }
      }

      // Function to show decline modal
      function showDeclineModal(ticketId, ticketTitle) {
          currentDeclineTicketId = ticketId;
          document.getElementById('declineTicketTitle').textContent = ticketTitle;
          document.getElementById('declineReason').value = '';
          
          const modal = new bootstrap.Modal(document.getElementById('declineModal'));
          modal.show();
      }

      // Function to confirm decline ticket
      function confirmDeclineTicket() {
          const reason = document.getElementById('declineReason').value.trim();
          
          if (!reason) {
              alert('Please provide a reason for declining the ticket.');
              return;
          }
          
          const formData = new FormData();
          formData.append('action', 'decline');
          formData.append('ticketId', currentDeclineTicketId);
          formData.append('reason', reason);
          
          fetch('${pageContext.request.contextPath}/technician/ticket', {
              method: 'POST',
              body: formData
          })
          .then(response => response.json())
          .then(data => {
              // Hide modal
              const modal = bootstrap.Modal.getInstance(document.getElementById('declineModal'));
              modal.hide();
              
              if (data.status === 'success') {
                  showToast('successToast', data.message);
                  // Reload page after 1.5 seconds
                  setTimeout(() => {
                      location.reload();
                  }, 1500);
              } else {
                  showToast('errorToast', data.message);
              }
          })
          .catch(error => {
              console.error('Error:', error);
              showToast('errorToast', 'An error occurred while declining the ticket.');
              
              // Hide modal on error too
              const modal = bootstrap.Modal.getInstance(document.getElementById('declineModal'));
              modal.hide();
          });
      }

      // Function to show toast notifications
      function showToast(toastId, message) {
          const toastElement = document.getElementById(toastId);
          const messageElement = toastElement.querySelector('[id$="Message"]');
          messageElement.textContent = message;
          
          const toast = new bootstrap.Toast(toastElement);
          toast.show();
      }

      // Existing functions (you should keep these if they exist in your original code)
      function viewTicket(ticketId) {
          // Your existing view ticket implementation
          console.log('View ticket:', ticketId);
      }

      function editTicket(ticketId) {
          // Your existing edit ticket implementation
          console.log('Edit ticket:', ticketId);
      }

      function viewLocation(maps) {
          // Your existing view location implementation
          if (maps) {
              window.open(maps, '_blank');
          }
      }

      // Filter and search functionality
      document.getElementById('statusFilter').addEventListener('change', function() {
          filterTable();
      });

      document.getElementById('searchInput').addEventListener('keyup', function() {
          filterTable();
      });

      function filterTable() {
          const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
          const searchTerm = document.getElementById('searchInput').value.toLowerCase();
          const table = document.getElementById('ticketsTable');
          const tbody = table.querySelector('tbody');
          const rows = tbody.querySelectorAll('tr[data-status]');
          
          rows.forEach(row => {
              const status = row.getAttribute('data-status');
              const rowText = row.textContent.toLowerCase();
              
              const statusMatch = !statusFilter || status === statusFilter;
              const searchMatch = !searchTerm || rowText.includes(searchTerm);
              
              if (statusMatch && searchMatch) {
                  row.style.display = '';
              } else {
                  row.style.display = 'none';
              }
          });
      }
    </script>
  </body>
</html>