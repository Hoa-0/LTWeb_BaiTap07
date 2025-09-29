<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<title>Category Management</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="bg-light">

	<div class="container mt-4">
		<h2 class="mb-3 text-primary">📂 Category Management</h2>

		<!-- Button trigger modal -->
		<button class="btn btn-success mb-3" data-bs-toggle="modal"
			data-bs-target="#categoryModal" onclick="resetForm()">➕ Add
			Category</button>

		<!-- Table -->
		<table class="table table-hover table-bordered align-middle">
			<thead class="table-dark">
				<tr>
					<th>ID</th>
					<th>Icon</th>
					<th>Name</th>
					<th style="width: 150px;">Actions</th>
				</tr>
			</thead>
			<tbody id="categoryTable"></tbody>
		</table>
	</div>

	<!-- Modal -->
	<div class="modal fade" id="categoryModal" tabindex="-1">
		<div class="modal-dialog">
			<form id="categoryForm" enctype="multipart/form-data">
				<div class="modal-content">
					<div class="modal-header bg-primary text-white">
						<h5 class="modal-title">Category</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
					</div>
					<div class="modal-body">
						<input type="hidden" id="categoryId" />
						<div class="mb-3">
							<label>Name</label> <input type="text" id="categoryName"
								class="form-control" required />
						</div>
						<div class="mb-3">
							<label>Icon</label> <input type="file" id="iconFile"
								class="form-control" /> <small class="text-muted">Upload
								new icon to change</small>
						</div>
					</div>
					<div class="modal-footer">
						<button type="submit" class="btn btn-success">💾 Save</button>
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">❌ Cancel</button>
					</div>
				</div>
			</form>
		</div>
	</div>

	<script>
    const API = "/api/category";

    function loadCategories() {
        $.get(API, function (data) {
            let rows = "";
            $.each(data, function (i, cate) {
                rows += `<tr>
                    <td>${cate.categoryId}</td>
                    <td><img src="/uploads/${cate.icon}" class="img-thumbnail" style="width:60px;height:60px"></td>
                    <td>${cate.categoryName}</td>
                    <td>
                        <button class="btn btn-sm btn-warning me-1" onclick="editCategory(${cate.categoryId})">✏ Edit</button>
                        <button class="btn btn-sm btn-danger" onclick="deleteCategory(${cate.categoryId})">🗑 Delete</button>
                    </td>
                </tr>`;
            });
            $("#categoryTable").html(rows);
        });
    }

    function resetForm() {
        $("#categoryId").val("");
        $("#categoryName").val("");
        $("#iconFile").val("");
    }

    function editCategory(id) {
        $.get(`${API}/${id}`, function (cate) {
            $("#categoryId").val(cate.categoryId);
            $("#categoryName").val(cate.categoryName);
            $("#categoryModal").modal("show");
        });
    }

    $("#categoryForm").submit(function (e) {
        e.preventDefault();
        let id = $("#categoryId").val();
        let formData = new FormData();
        formData.append("categoryName", $("#categoryName").val());
        if ($("#iconFile")[0].files.length > 0) {
            formData.append("icon", $("#iconFile")[0].files[0]);
        }

        if (id) {
            $.ajax({
                url: `${API}/${id}`,
                type: "PUT",
                data: formData,
                processData: false,
                contentType: false,
                success: function () {
                    $("#categoryModal").modal("hide");
                    loadCategories();
                }
            });
        } else {
            $.ajax({
                url: API,
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function () {
                    $("#categoryModal").modal("hide");
                    loadCategories();
                }
            });
        }
    });

    function deleteCategory(id) {
        if (confirm("Are you sure to delete?")) {
            $.ajax({
                url: `${API}/${id}`,
                type: "DELETE",
                success: loadCategories
            });
        }
    }

    $(document).ready(loadCategories);
</script>
</body>
</html>
