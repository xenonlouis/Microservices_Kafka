package com.inventory.product.controller;

import com.inventory.product.model.Product;
import com.inventory.product.service.ProductService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class ProductController {
    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @QueryMapping
    public List<Product> products() {
        return productService.getAllProducts();
    }

    @QueryMapping
    public Product product(@Argument Long id) {
        return productService.getProduct(id);
    }

    @MutationMapping
    public Product createProduct(@Argument String name, @Argument String description, 
                               @Argument Double price, @Argument Integer stock) {
        Product product = new Product();
        product.setName(name);
        product.setDescription(description);
        product.setPrice(price);
        product.setStock(stock);
        return productService.saveProduct(product);
    }
} 