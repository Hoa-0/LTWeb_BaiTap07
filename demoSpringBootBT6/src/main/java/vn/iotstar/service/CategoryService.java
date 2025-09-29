package vn.iotstar.service;

import java.util.List;
import java.util.Optional;
import vn.iotstar.entity.Category;

public interface CategoryService {

	List<Category> findAll();

	Optional<Category> findById(Long id);

	Optional<Category> findByCategoryName(String name);

	Category save(Category category);

	void delete(Integer id);
}
