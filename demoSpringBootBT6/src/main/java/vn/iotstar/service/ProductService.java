package vn.iotstar.service;

import java.util.List;
import java.util.Optional;

import vn.iotstar.entity.Product;

public interface ProductService {

	List<Product> findAll();

	Optional<Product> findById(Long id);

	Product save(Product product);

	void delete(Integer id);
}
