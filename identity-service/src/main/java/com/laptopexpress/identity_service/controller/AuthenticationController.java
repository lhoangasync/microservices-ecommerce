package com.laptopexpress.identity_service.controller;

import com.laptopexpress.identity_service.dto.request.LoginRequest;
import com.laptopexpress.identity_service.dto.request.UserCreateRequest;
import com.laptopexpress.identity_service.dto.response.ApiResponse;
import com.laptopexpress.identity_service.dto.response.LoginResponse;
import com.laptopexpress.identity_service.dto.response.UserResponse;
import com.laptopexpress.identity_service.entity.User;
import com.laptopexpress.identity_service.exception.IdInvalidException;
import com.laptopexpress.identity_service.service.AuthenticationService;
import com.laptopexpress.identity_service.service.UserService;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class AuthenticationController {
    AuthenticationManagerBuilder authenticationManagerBuilder;
    AuthenticationService authenticationService;
    UserService userService;
    PasswordEncoder passwordEncoder;

    @NonFinal
    @Value("${jwt.refresh-token-validity-in-seconds}")
    long refreshTokenValidityInSeconds;

    @PostMapping("/register")
    ResponseEntity<ApiResponse<UserResponse>> register(@Valid @RequestBody UserCreateRequest request) throws IdInvalidException {
        ApiResponse<UserResponse> apiResponse = ApiResponse.<UserResponse>builder()
                .code(HttpStatus.CREATED.value())
                .error(null)
                .data(userService.handleCreateUser(request))
                .message("Successfully registered").build();

        return ResponseEntity.status(HttpStatus.CREATED).body(apiResponse);
    }

    @PostMapping("/login")
    ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request) throws IdInvalidException {
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(
                request.getEmail(), request.getPassword());
        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);

        SecurityContextHolder.getContext().setAuthentication(authentication);

        LoginResponse loginResponse = new LoginResponse();
        User currentUser = userService.handleFindUserByEmail(request.getEmail());
        if (currentUser != null) {
            LoginResponse.UserLogin userLogin = new  LoginResponse.UserLogin(
                    currentUser.getId(),
                    currentUser.getEmail(),
                    currentUser.getUsername(),
                    currentUser.getRole()
            );

            loginResponse.setUser(userLogin);
        }

        //generate token
        String accessToken = authenticationService.generateAccessToken(authentication.getName(), loginResponse);
        loginResponse.setToken(accessToken);
        //generate refresh token
        String refreshToken = authenticationService.generateRefreshToken(request.getEmail(), loginResponse);

        //update user + refresh token
        userService.updateRefreshToken(refreshToken, request.getEmail());
        // set cookies
        ResponseCookie cookies = ResponseCookie.from("refresh_token", refreshToken)
                .httpOnly(true)
                .maxAge(refreshTokenValidityInSeconds)
                .secure(true)
                .path("/")
                .build();

        return ResponseEntity.ok()
                .header(HttpHeaders.SET_COOKIE, cookies.toString())
                .body(loginResponse);
    }

}
