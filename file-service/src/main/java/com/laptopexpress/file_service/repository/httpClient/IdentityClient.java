package com.laptopexpress.file_service.repository.httpClient;


import com.laptopexpress.file_service.dto.ApiResponse;
import com.laptopexpress.file_service.dto.response.UserAccountResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;

@FeignClient(name = "identity-service", url = "http://localhost:8080/identity")
public interface IdentityClient {

  @GetMapping("/auth/my-account")
  ApiResponse<UserAccountResponse> getMyAccount(@RequestHeader("Authorization") String token);
}
