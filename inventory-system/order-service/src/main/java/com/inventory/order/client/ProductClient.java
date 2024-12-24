package com.inventory.order.client;

import com.inventory.order.dto.ProductDTO;
import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import org.springframework.graphql.client.HttpGraphQlClient;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Component
public class ProductClient {
    private final HttpGraphQlClient graphQlClient;

    public ProductClient(WebClient.Builder webClientBuilder) {
        WebClient webClient = webClientBuilder
            .baseUrl("http://localhost:8081/graphql")
            .build();
        this.graphQlClient = HttpGraphQlClient.builder(webClient).build();
    }

    @CircuitBreaker(name = "productService", fallbackMethod = "getProductFallback")
    public ProductDTO getProduct(Long id) {
        String query = """
            query($id: ID!) {
                product(id: $id) {
                    id
                    name
                    price
                    stock
                }
            }
        """;

        return graphQlClient.document(query)
                .variable("id", id)
                .retrieve("product")
                .toEntity(ProductDTO.class)
                .block();
    }

    private ProductDTO getProductFallback(Long id, Exception ex) {
        // Fallback logic when product service is down
        throw new RuntimeException("Product service is not available");
    }
} 