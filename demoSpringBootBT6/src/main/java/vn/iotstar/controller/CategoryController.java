package vn.iotstar.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.iotstar.entity.Category;
import vn.iotstar.service.CategoryService;

import java.io.File;
import java.io.IOException;

@Controller
@RequestMapping("/admin/categories")
public class CategoryController {

	@Autowired
	private CategoryService categoryService;

	@GetMapping
	public String listCategories(Model model, @RequestParam(name = "page", defaultValue = "0") int page,
			@RequestParam(name = "size", defaultValue = "10") int size) {
		model.addAttribute("listCate", categoryService.findAll());
		model.addAttribute("currentPage", page);
		return "category/list";
	}

	@GetMapping("/add")
	public String addCategoryForm(Model model) {
		model.addAttribute("cate", new Category());
		return "category/add";
	}

	@PostMapping("/add")
	public String addCategory(Category category, @RequestParam("imageFile") MultipartFile imageFile)
			throws IOException {
		if (!imageFile.isEmpty()) {
			String fileName = System.currentTimeMillis() + "_" + imageFile.getOriginalFilename();
			File uploadDir = new File(System.getProperty("user.dir") + "/uploads/category");
			if (!uploadDir.exists()) {
				uploadDir.mkdirs();
			}
			File uploadFile = new File(uploadDir, fileName);
			imageFile.transferTo(uploadFile);
			category.setIcon(fileName);
		}
		categoryService.save(category);
		return "redirect:/admin/categories";
	}

	@GetMapping("/delete/{id}")
	public String deleteCategory(@PathVariable("id") Integer id) {
		categoryService.delete(id);
		return "redirect:/admin/categories";
	}
}
