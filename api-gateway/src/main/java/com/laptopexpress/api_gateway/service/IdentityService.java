package com.laptopexpress.api_gateway.service;

import com.laptopexpress.api_gateway.dto.request.IntrospectRequest;
import com.laptopexpress.api_gateway.dto.response.ApiResponse;
import com.laptopexpress.api_gateway.dto.response.IntrospectResponse;
import com.laptopexpress.api_gateway.repository.IdentityClient;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class IdentityService {

  IdentityClient identityClient;

  public Mono<ApiResponse<IntrospectResponse>> introspect(String token) {
    log.info("Calling introspect for token: {}",
        token);  // Thêm log để kiểm tra service có gọi tới đây không
    return identityClient.introspect(IntrospectRequest.builder()
        .token(token)
        .build());
  }
}
