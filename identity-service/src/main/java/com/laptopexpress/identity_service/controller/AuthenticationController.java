package com.laptopexpress.identity_service.controller;

import com.laptopexpress.identity_service.dto.request.IntrospectRequest;
import com.laptopexpress.identity_service.dto.request.LoginRequest;
import com.laptopexpress.identity_service.dto.request.UserCreateRequest;
import com.laptopexpress.identity_service.dto.request.VerifyOtpRequest;
import com.laptopexpress.identity_service.dto.response.ApiResponse;
import com.laptopexpress.identity_service.dto.response.IntrospectResponse;
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
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

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
  @Value("${jwt.token-validity-in-seconds}")
  long accessTokenExpiration;

  @NonFinal
  @Value("${jwt.refresh-token-validity-in-seconds}")
  long refreshTokenValidityInSeconds;

  @PostMapping("/introspect")
  ApiResponse<IntrospectResponse> authenticate(@RequestBody IntrospectRequest request) {
    var result = authenticationService.introspect(request);
    return ApiResponse.<IntrospectResponse>builder().data(result).build();
  }

  @PostMapping("/register")
  ResponseEntity<ApiResponse<UserResponse>> register(@Valid @RequestBody UserCreateRequest request)
      throws IdInvalidException {
    ApiResponse<UserResponse> apiResponse = ApiResponse.<UserResponse>builder()
        .code(HttpStatus.CREATED.value())
        .error(null)
        .data(userService.handleCreateUser(request))
        .message("Successfully registered").build();

    return ResponseEntity.status(HttpStatus.CREATED).body(apiResponse);
  }

  @PostMapping("/login")
  public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request)
      throws IdInvalidException {
    UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(
        request.getEmail(), request.getPassword());

    Authentication authentication = authenticationManagerBuilder.getObject()
        .authenticate(authenticationToken);

    User currentUser = userService.handleFindUserByEmail(request.getEmail());

    if (currentUser == null) {
      throw new IdInvalidException("User not found");
    }
    if (!currentUser.isVerified()) {
      throw new IdInvalidException("Account not verified. Please verify your OTP.");
    }

    SecurityContextHolder.getContext().setAuthentication(authentication);

    LoginResponse loginResponse = new LoginResponse();
    LoginResponse.UserLogin userLogin = new LoginResponse.UserLogin(
        currentUser.getId(),
        currentUser.getEmail(),
        currentUser.getUsername(),
        currentUser.getRole()
    );
    loginResponse.setUser(userLogin);

    String accessToken = authenticationService.generateAccessToken(authentication.getName(),
        loginResponse);
    loginResponse.setToken(accessToken);

    String refreshToken = authenticationService.generateRefreshToken(request.getEmail(),
        loginResponse);
    userService.updateRefreshToken(refreshToken, request.getEmail());

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

  @GetMapping("/my-account")
  ApiResponse<LoginResponse.UserGetAccount> getMyAccount() {
    String email = AuthenticationService.getCurrentUserLogin().isPresent() ?
        AuthenticationService.getCurrentUserLogin().get() : "";
    User currentUser = userService.handleFindUserByEmail(email);
    LoginResponse.UserLogin userLogin = new LoginResponse.UserLogin();
    LoginResponse.UserGetAccount userGetAccount = new LoginResponse.UserGetAccount();
    if (currentUser != null) {
      userLogin.setId(currentUser.getId());
      userLogin.setEmail(currentUser.getEmail());
      userLogin.setUsername(currentUser.getUsername());
      userLogin.setRole(currentUser.getRole());

      userGetAccount.setUser(userLogin);
    }

    return ApiResponse.<LoginResponse.UserGetAccount>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .data(userGetAccount)
        .message("Get your account successfully!")
        .build();
  }

  @GetMapping("/refresh")
  ResponseEntity<ApiResponse<LoginResponse>> refreshToken(
      @CookieValue(name = "refresh_token", defaultValue = "noneCookies") String refreshToken)
      throws IdInvalidException {

    //check if cookies is existed
    if (refreshToken.equals("noneCookies")) {
      throw new IdInvalidException("Missing cookies!!!");
    }

    //check valid
    Jwt decodedToken = authenticationService.checkValidRefreshToken(refreshToken);
    String email = decodedToken.getSubject();

    // save refresh old token in invalidated token
    authenticationService.invalidateRefreshToken(refreshToken);

    //check user by refresh token + email
    User user = userService.handleFindUserByRefreshTokenAndEmail(refreshToken, email);
    if (user == null) {
      throw new IdInvalidException("Invalid refresh token!!!");
    }

    LoginResponse result = new LoginResponse();
    User currentUser = userService.handleFindUserByEmail(email);
    if (currentUser != null) {
      LoginResponse.UserLogin userLogin = new LoginResponse.UserLogin(
          currentUser.getId(),
          currentUser.getEmail(),
          currentUser.getUsername(),
          currentUser.getRole()
      );
      result.setUser(userLogin);
    }

    //generate token again
    String token = authenticationService.generateAccessToken(email, result);
    result.setToken(token);

    //create refresh token again
    String new_refresh_token = authenticationService.generateRefreshToken(email, result);

    //update user + refresh token
    userService.updateRefreshToken(new_refresh_token, email);

    //set cookies
    ResponseCookie cookies = ResponseCookie.from("refresh_token", new_refresh_token)
        .httpOnly(true)
        .maxAge(refreshTokenValidityInSeconds)
        .secure(true)
        .path("/")
        .build();

    return ResponseEntity.ok()
        .header(HttpHeaders.SET_COOKIE, cookies.toString())
        .body(ApiResponse.<LoginResponse>builder()
            .data(result)
            .message("Refresh token successfully!")
            .code(HttpStatus.OK.value())
            .build());

  }

  @PostMapping("/logout")
  ResponseEntity<ApiResponse<Void>> logout() throws IdInvalidException {
    String email = AuthenticationService.getCurrentUserLogin().isPresent()
        ? AuthenticationService.getCurrentUserLogin().get() : "";

    if (email.isEmpty()) {
      throw new IdInvalidException("Invalid token!!!...");
    }

    //set refresh token = null
    userService.updateRefreshToken("", email);

    //set cookies
    ResponseCookie cookies = ResponseCookie.from("refresh_token", "")
        .httpOnly(true)
        .maxAge(0)
        .secure(true)
        .path("/")
        .build();

    return ResponseEntity.ok().header(HttpHeaders.SET_COOKIE, cookies.toString())
        .body(ApiResponse.<Void>builder()
            .code(HttpStatus.OK.value())
            .error(null)
            .data(null)
            .message("Logout successfully!")
            .build());
  }

  @PostMapping("/verify-otp")
  ApiResponse<String> verifyOtp(@RequestBody VerifyOtpRequest verifyOtpRequest)
      throws IdInvalidException {
    return ApiResponse.<String>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .data(null)
        .message(userService.handleVerifyOTP(verifyOtpRequest) ? "Account verified successfully"
            : "Verification failed")
        .build();
  }

  @PostMapping("/resend-otp")
  ApiResponse<String> resendOTP(@RequestParam String email) throws IdInvalidException {
    return ApiResponse.<String>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .data(userService.handleGenerateOTP(email))
        .message("OTP has been resent to: " + email)
        .build();
  }

}
