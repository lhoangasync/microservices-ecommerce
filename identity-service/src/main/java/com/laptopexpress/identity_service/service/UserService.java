package com.laptopexpress.identity_service.service;


import com.laptopexpress.identity_service.dto.request.UserCreateRequest;
import com.laptopexpress.identity_service.dto.request.UserUpdateRequest;
import com.laptopexpress.identity_service.dto.response.PageResponse;
import com.laptopexpress.identity_service.dto.response.RoleResponse;
import com.laptopexpress.identity_service.dto.response.UserResponse;
import com.laptopexpress.identity_service.entity.Role;
import com.laptopexpress.identity_service.entity.User;
import com.laptopexpress.identity_service.exception.IdInvalidException;
import com.laptopexpress.identity_service.mapper.UserMapper;
import com.laptopexpress.identity_service.repository.RoleRepository;
import com.laptopexpress.identity_service.repository.UserRepository;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;


@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class UserService {

  UserRepository userRepository;
  UserMapper userMapper;
  PasswordEncoder passwordEncoder;
  RoleService roleService;
  RoleRepository roleRepository;

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

    User savedUser = userRepository.save(user);
    log.info("User created: {}", savedUser);

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

}
