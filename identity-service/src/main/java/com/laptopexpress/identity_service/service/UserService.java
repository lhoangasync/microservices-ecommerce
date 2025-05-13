package com.laptopexpress.identity_service.service;


import com.laptopexpress.event.dto.NotificationEvent;
import com.laptopexpress.identity_service.dto.request.ResetPasswordRequest;
import com.laptopexpress.identity_service.dto.request.UserCreateRequest;
import com.laptopexpress.identity_service.dto.request.UserUpdateRequest;
import com.laptopexpress.identity_service.dto.request.VerifyOtpRequest;
import com.laptopexpress.identity_service.dto.response.PageResponse;
import com.laptopexpress.identity_service.dto.response.UserResponse;
import com.laptopexpress.identity_service.entity.Role;
import com.laptopexpress.identity_service.entity.User;
import com.laptopexpress.identity_service.exception.IdInvalidException;
import com.laptopexpress.identity_service.mapper.UserMapper;
import com.laptopexpress.identity_service.repository.RoleRepository;
import com.laptopexpress.identity_service.repository.UserRepository;
import com.laptopexpress.identity_service.repository.httpClient.FileClient;
import java.security.SecureRandom;
import java.time.Instant;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;
import org.springframework.web.multipart.MultipartFile;


@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class UserService {

  UserRepository userRepository;
  UserMapper userMapper;
  PasswordEncoder passwordEncoder;
  RoleRepository roleRepository;
  KafkaTemplate<String, Object> kafkaTemplate;

  FileClient fileClient;

  public User handleFindUserByEmail(String email) {
    return userRepository.findUserByEmail(email);
  }

  public boolean isExistedEmail(String email) {
    return userRepository.existsByEmail(email);
  }

  public void updateRefreshToken(String token, String email) {
    User currentUser = handleFindUserByEmail(email);
    if (currentUser != null) {
      currentUser.setRefreshToken(token);
      userRepository.save(currentUser);
    }
  }

  public User handleFindUserByRefreshTokenAndEmail(String refreshToken, String email) {
    return userRepository.findUserByRefreshTokenAndEmail(refreshToken, email);
  }

  //handle create user
  public UserResponse handleCreateUser(UserCreateRequest request) throws IdInvalidException {
    //check username is unique
    User userExisted = userRepository.findUserByEmail(request.getEmail());
    if (userExisted != null) {
      throw new IdInvalidException("Email " + userExisted.getEmail() + " already exists");
    }

    User user = userMapper.toUser(request);
    user.setPassword(passwordEncoder.encode(user.getPassword()));
    user.setVerified(false);

    //check role exist
    if (user.getRole() != null) {
      Role r = roleRepository.findById(user.getRole().getId()).orElse(null);
      if (r != null) {
        user.setRole(r);
      }
    }

//    NotificationEvent notificationEvent = NotificationEvent.builder()
//        .channel("EMAIL")
//        .recipient(request.getEmail())
//        .subject("Welcome our LAPTOP shop!!")
//        .body("Hello MR. " + request.getEmail())
//        .build();
//
//    //Publish message to kafka
//    kafkaTemplate.send("notifications-email", notificationEvent);

    User savedUser = userRepository.save(user);
    log.info("User created: {}", savedUser);

    handleGenerateOTP(request.getEmail());

    return userMapper.toUserResponse(savedUser);
  }

  //handle get user by id
  public UserResponse handleGetUserById(String id) {
    Optional<User> userOptional = userRepository.findById(id);
    return userOptional.map(userMapper::toUserResponse).orElse(null);
  }

  //handle get all users
  public PageResponse<UserResponse> handleGetAllUsers(int page, int size) {
    Sort sort = Sort.by("createdAt").descending();

    Pageable pageable = PageRequest.of(page - 1, size, sort);

    var pageData = userRepository.findAll(pageable);

    return PageResponse.<UserResponse>builder()
        .currentPage(page)
        .pageSize(pageData.getSize())
        .totalPages(pageData.getTotalPages())
        .totalElements(pageData.getTotalElements())
        .data(pageData.getContent().stream().map(userMapper::toUserResponse).toList())
        .build();
  }

  //delete user by id
  public void deleteUserById(String id) {
    Optional<User> userOptional = userRepository.findById(id);
    userOptional.ifPresent(userRepository::delete);
  }

  //update user
  public UserResponse handleUpdateUser(UserUpdateRequest request) throws IdInvalidException {
    User user = userRepository.findById(request.getId())
        .orElseThrow(
            () -> new IdInvalidException(
                "User with this ID = " + request.getId() + " not found"));

    if (request.getFirstName() != null) {
      user.setFirstName(request.getFirstName());
    }
    if (request.getLastName() != null) {
      user.setLastName(request.getLastName());
    }
    if (request.getUsername() != null) {
      user.setUsername(request.getUsername());
    }
    if (request.getEmail() != null) {
      user.setEmail(request.getEmail());
    }
    if (request.getPhone() != null) {
      user.setPhone(request.getPhone());
    }
    if (request.getAddress() != null) {
      user.setAddress(request.getAddress());
    }
    if (request.getImageUrl() != null) {
      user.setImageUrl(request.getImageUrl());
    }
    if (request.getGender() != null) {
      user.setGender(request.getGender());
    }

    User updatedUser = userRepository.save(user);

    return userMapper.toUserResponse(updatedUser);
  }

  //generate code OTP
  public String handleGenerateOTP(String email) throws IdInvalidException {
    User user = userRepository.findUserByEmail(email);
    if (user == null) {
      throw new IdInvalidException("User with this email = " + email + " not found1");
    }

//    if (user.isVerified()) {
//      throw new IdInvalidException("This account has been verified!");
//    }

    //Generate code OTP
    String otp = generateRandomOTP(6);
    user.setVerificationCode(otp);
    user.setOtpExpiry(Instant.now().plusSeconds(300)); //5min
    userRepository.save(user);

    NotificationEvent notificationEvent = NotificationEvent.builder()
        .channel("EMAIL")
        .recipient(email)
        .subject("Your OTP Code")
        .body("Your OTP code is: " + otp + ". It is valid for 5 minutes.")
        .build();

    kafkaTemplate.send("notifications-email", notificationEvent);
    return otp;

  }

  // Verify OTP
  public boolean handleVerifyOTP(VerifyOtpRequest request) throws IdInvalidException {
    User user = userRepository.findUserByEmail(request.getEmail());
    if (user == null) {
      throw new IdInvalidException("User with this email = " + request.getEmail() + " not found2");
    }

    //check otp
    if (user.getVerificationCode() == null || user.getOtpExpiry() == null) {
      throw new IdInvalidException(
          "User with this email = " + request.getEmail() + " have no verification code");
    }

    if (Instant.now().isAfter(user.getOtpExpiry())) {
      throw new IdInvalidException("User with this email = " + request.getEmail() + " has expired");
    }

    if (!user.getVerificationCode().equals(request.getOtp())) {
      throw new IdInvalidException(
          "User with this email = " + request.getEmail() + " has invalid verification code");
    }

    user.setVerified(true);
    user.setVerificationCode(null); //delete otp after verify
    user.setOtpExpiry(null);
    userRepository.save(user);

    return true;
  }

  private String generateRandomOTP(int length) {
    SecureRandom random = new SecureRandom();
    StringBuilder otp = new StringBuilder();
    for (int i = 0; i < length; i++) {
      otp.append(random.nextInt(10));
    }
    return otp.toString();
  }

  public boolean handleResetPassword(ResetPasswordRequest request) throws IdInvalidException {
    User user = userRepository.findUserByEmail(request.getEmail());
    if (user == null) {
      throw new IdInvalidException("User with this email = " + request.getEmail() + " not found");
    }

    user.setPassword(passwordEncoder.encode(request.getNewPassword()));
    userRepository.save(user);
    return true;
  }

  public UserResponse updateAvatar(MultipartFile file) throws IdInvalidException {
    String userId = AuthenticationService.getCurrentUserId();

    User user = userRepository.findById(userId).orElseThrow(
        () -> new IdInvalidException("User with this id = " + userId + " not found")
    );

    // upload file - invoke an api File Service
    var response = fileClient.uploadMedia(file);

    user.setImageUrl(response.getData().getUrl());

    return userMapper.toUserResponse(userRepository.save(user));

  }

}
