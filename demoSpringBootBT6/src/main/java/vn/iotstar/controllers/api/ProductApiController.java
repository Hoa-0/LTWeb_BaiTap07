package vn.iotstar.controllers.api;

import java.util.List;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.iotstar.entity.Product;
import vn.iotstar.entity.Category;
import vn.iotstar.service.ProductService;
import vn.iotstar.service.CategoryService;
import vn.iotstar.service.IStorageService;

@RestController
@RequestMapping("/api/product")
public class ProductApiController {

	@Autowired
	private ProductService productService;

	@Autowired
	private CategoryService categoryService;

	@Autowired
	private IStorageService storageService;

	@GetMapping
	public ResponseEntity<List<Product>> getAll() {
		return ResponseEntity.ok(productService.findAll());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Product> getById(@PathVariable("id") Long id) {
		return productService.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	@PostMapping
	public ResponseEntity<Product> create(@RequestParam("productName") String name,
			@RequestParam("unitPrice") Double price, @RequestParam("quantity") Integer qty,
			@RequestParam("status") Short status, @RequestParam("discount") Double discount,
			@RequestParam("description") String desc, @RequestParam("categoryId") Long categoryId,
			@RequestParam(value = "imageFile", required = false) MultipartFile image) {
		Product product = new Product();
		product.setProductName(name);
		product.setUnitPrice(price);
		product.setQuantity(qty);
		product.setStatus(status);
		product.setDiscount(discount);
		product.setDescription(desc);
		categoryService.findById(categoryId).ifPresent(product::setCategory);
		if (image != null && !image.isEmpty()) {
			String filename = storageService.getSorageFilename(image, UUID.randomUUID().toString());
			storageService.store(image, filename);
			product.setImages(filename);
		}
		return ResponseEntity.ok(productService.save(product));
	}

	@PutMapping("/{id}")
	public ResponseEntity<Product> update(@PathVariable("id") Long id, @RequestParam("productName") String name,
			@RequestParam("unitPrice") Double price, @RequestParam("quantity") Integer qty,
			@RequestParam("status") Short status, @RequestParam("discount") Double discount,
			@RequestParam("description") String desc, @RequestParam("categoryId") Long categoryId,
			@RequestParam(value = "imageFile", required = false) MultipartFile image) {
		return productService.findById(id).map(prod -> {
			prod.setProductName(name);
			prod.setUnitPrice(price);
			prod.setQuantity(qty);
			prod.setStatus(status);
			prod.setDiscount(discount);
			prod.setDescription(desc);
			categoryService.findById(categoryId).ifPresent(prod::setCategory);
			if (image != null && !image.isEmpty()) {
				String filename = storageService.getSorageFilename(image, UUID.randomUUID().toString());
				storageService.store(image, filename);
				prod.setImages(filename);
			}
			return ResponseEntity.ok(productService.save(prod));
		}).orElse(ResponseEntity.notFound().build());
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
		productService.delete(id.intValue());
		return ResponseEntity.ok().build();
	}
}
