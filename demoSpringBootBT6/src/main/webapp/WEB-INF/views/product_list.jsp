<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<title>Product Management</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="bg-light">

	<div class="container mt-4">
		<h2 class="mb-3 text-primary">🛒 Product Management</h2>

		<!-- Button trigger modal -->
		<button class="btn btn-success mb-3" data-bs-toggle="modal"
			data-bs-target="#productModal" onclick="resetForm()">➕ Add
			Product</button>

		<!-- Table -->
		<table class="table table-hover table-bordered align-middle">
			<thead class="table-dark">
				<tr>
					<th>ID</th>
					<th>Name</th>
					<th>Price</th>
					<th>Qty</th>
					<th>Discount</th>
					<th>Status</th>
					<th>Image</th>
					<th>Actions</th>
				</tr>
			</thead>
			<tbody id="productTable"></tbody>
		</table>
	</div>

	<!-- Modal -->
	<div class="modal fade" id="productModal" tabindex="-1">
		<div class="modal-dialog">
			<form id="productForm" enctype="multipart/form-data">
				<div class="modal-content">
					<div class="modal-header bg-primary text-white">
						<h5 class="modal-title">Product</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
					</div>
					<div class="modal-body">
						<input type="hidden" id="productId" />
						<div class="mb-3">
							<label>Name</label><input type="text" id="productName"
								class="form-control" required />
						</div>
						<div class="mb-3">
							<label>Price</label><input type="number" step="0.01"
								id="unitPrice" class="form-control" required />
						</div>
						<div class="mb-3">
							<label>Quantity</label><input type="number" id="quantity"
								class="form-control" required />
						</div>
						<div class="mb-3">
							<label>Discount</label><input type="number" step="0.01"
								id="discount" class="form-control" />
						</div>
						<div class="mb-3">
							<label>Status</label><input type="number" id="status"
								class="form-control" value="1" />
						</div>
						<div class="mb-3">
							<label>Description</label>
							<textarea id="description" class="form-control"></textarea>
						</div>
						<div class="mb-3">
							<label>Category ID</label><input type="number" id="categoryId"
								class="form-control" required />
						</div>
						<div class="mb-3">
							<label>Image</label><input type="file" id="imageFile"
								class="form-control" />
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
    const API = "/api/product";

    function loadProducts() {
        $.get(API, function (data) {
            let rows = "";
            $.each(data, function (i, prod) {
                rows += `<tr>
                    <td>${prod.productId}</td>
                    <td>${prod.productName}</td>
                    <td>${prod.unitPrice}</td>
                    <td>${prod.quantity}</td>
                    <td>${prod.discount || 0}</td>
                    <td>${prod.status}</td>
                    <td><img src="/uploads/${prod.images}" class="img-thumbnail" style="width:60px;height:60px"></td>
                    <td>
                        <button class="btn btn-sm btn-warning me-1" onclick="editProduct(${prod.productId})">✏ Edit</button>
                        <button class="btn btn-sm btn-danger" onclick="deleteProduct(${prod.productId})">🗑 Delete</button>
                    </td>
                </tr>`;
            });
            $("#productTable").html(rows);
        });
    }

    function resetForm() {
        $("#productForm")[0].reset();
        $("#productId").val("");
    }

    function editProduct(id) {
        $.get(`${API}/${id}`, function (prod) {
            $("#productId").val(prod.productId);
            $("#productName").val(prod.productName);
            $("#unitPrice").val(prod.unitPrice);
            $("#quantity").val(prod.quantity);
            $("#discount").val(prod.discount);
            $("#status").val(prod.status);
            $("#description").val(prod.description);
            $("#categoryId").val(prod.category.categoryId);
            $("#productModal").modal("show");
        });
    }

    $("#productForm").submit(function (e) {
        e.preventDefault();
        let id = $("#productId").val();
        let formData = new FormData();
        formData.append("productName", $("#productName").val());
        formData.append("unitPrice", $("#unitPrice").val());
        formData.append("quantity", $("#quantity").val());
        formData.append("discount", $("#discount").val());
        formData.append("status", $("#status").val());
        formData.append("description", $("#description").val());
        formData.append("categoryId", $("#categoryId").val());
        if ($("#imageFile")[0].files.length > 0) {
            formData.append("imageFile", $("#imageFile")[0].files[0]);
        }

        if (id) {
            $.ajax({
                url: `${API}/${id}`,
                type: "PUT",
                data: formData,
                processData: false,
                contentType: false,
                success: function () {
                    $("#productModal").modal("hide");
                    loadProducts();
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
                    $("#productModal").modal("hide");
                    loadProducts();
                }
            });
        }
    });

    function deleteProduct(id) {
        if (confirm("Are you sure to delete?")) {
            $.ajax({
                url: `${API}/${id}`,
                type: "DELETE",
                success: loadProducts
            });
        }
    }

    $(document).ready(loadProducts);
</script>
</body>
</html>
