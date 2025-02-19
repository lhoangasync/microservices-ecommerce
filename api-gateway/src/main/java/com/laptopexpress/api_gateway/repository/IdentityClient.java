package com.laptopexpress.api_gateway.repository;

import com.laptopexpress.api_gateway.dto.request.IntrospectRequest;
import com.laptopexpress.api_gateway.dto.response.ApiResponse;
import com.laptopexpress.api_gateway.dto.response.IntrospectResponse;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.service.annotation.PostExchange;
import reactor.core.publisher.Mono;

@Repository
public interface IdentityClient {

  @PostExchange(url = "/auth/introspect", contentType = MediaType.APPLICATION_JSON_VALUE)
  Mono<ApiResponse<IntrospectResponse>> introspect(@RequestBody IntrospectRequest request);
}
