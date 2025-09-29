package vn.iotstar.controllers.api;

import java.util.List;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.iotstar.entity.Category;
import vn.iotstar.service.CategoryService;
import vn.iotstar.service.IStorageService;

@RestController
@RequestMapping("/api/category")
public class CategoryApiController {

	@Autowired
	private CategoryService categoryService;

	@Autowired
	private IStorageService storageService;

	@GetMapping
	public ResponseEntity<List<Category>> getAll() {
		return ResponseEntity.ok(categoryService.findAll());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Category> getById(@PathVariable("id") Long id) {
		return categoryService.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	@PostMapping
	public ResponseEntity<Category> create(@RequestParam("categoryName") String name,
			@RequestParam(value = "icon", required = false) MultipartFile icon) {
		Category cate = new Category();
		cate.setCategoryName(name);
		if (icon != null && !icon.isEmpty()) {
			String filename = storageService.getSorageFilename(icon, UUID.randomUUID().toString());
			storageService.store(icon, filename);
			cate.setIcon(filename);
		}
		return ResponseEntity.ok(categoryService.save(cate));
	}

	@PutMapping("/{id}")
	public ResponseEntity<Category> update(@PathVariable("id") Long id, @RequestParam("categoryName") String name,
			@RequestParam(value = "icon", required = false) MultipartFile icon) {
		return categoryService.findById(id).map(cate -> {
			cate.setCategoryName(name);
			if (icon != null && !icon.isEmpty()) {
				String filename = storageService.getSorageFilename(icon, UUID.randomUUID().toString());
				storageService.store(icon, filename);
				cate.setIcon(filename);
			}
			return ResponseEntity.ok(categoryService.save(cate));
		}).orElse(ResponseEntity.notFound().build());
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
		categoryService.delete(id.intValue());
		return ResponseEntity.ok().build();
	}
}
