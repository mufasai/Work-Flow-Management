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
                  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
  </body>
</html>
