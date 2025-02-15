package com.laptopexpress.identity_service.controller;


import com.laptopexpress.identity_service.dto.request.UserCreateRequest;
import com.laptopexpress.identity_service.dto.request.UserUpdateRequest;
import com.laptopexpress.identity_service.dto.response.ApiResponse;
import com.laptopexpress.identity_service.dto.response.PageResponse;
import com.laptopexpress.identity_service.dto.response.UserResponse;
import com.laptopexpress.identity_service.exception.IdInvalidException;
import com.laptopexpress.identity_service.mapper.UserMapper;
import com.laptopexpress.identity_service.service.UserService;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class UserController {

    private final UserService userService;

    @PostMapping("/create")
    ApiResponse<UserResponse> createUser(@Valid @RequestBody UserCreateRequest request) throws IdInvalidException {
        return  ApiResponse.<UserResponse>builder()
                .code(HttpStatus.CREATED.value())
                .error(null)
                .message("Created User Successfully!!!")
                .data(userService.handleCreateUser(request))
                .build();
    }

    @GetMapping("/get-all")
    ApiResponse<PageResponse<UserResponse>> getAllUsers(
            @RequestParam(value = "page", required = false, defaultValue = "1") int page,
            @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
        return ApiResponse.<PageResponse<UserResponse>>builder()
                .code(HttpStatus.OK.value())
                .error(null)
                .message("Get all users successfully")
                .data(userService.handleGetAllUsers(page, size))
                .build();
    }

    @GetMapping("/get-by-id/{id}")
    ApiResponse<UserResponse> getUserById(@PathVariable String id) throws IdInvalidException {
        UserResponse userResponse = userService.handleGetUserById(id);
        if(userResponse == null) {
            throw new IdInvalidException("User with this ID = " + id + " not found");
        }
        return ApiResponse.<UserResponse>builder()
                .code(HttpStatus.OK.value())
                .error(null)
                .data(userResponse)
                .message("Get all users successfully")
                .build();
    }

    @PutMapping("/update")
    ApiResponse<UserResponse> updateUser(@Valid @RequestBody UserUpdateRequest request) throws IdInvalidException {
        return ApiResponse.<UserResponse>builder()
                .code(HttpStatus.OK.value())
                .error(null)
                .data(userService.handleUpdateUser(request))
                .message("Update user successfully")
                .build();
    }

    @DeleteMapping("/delete/{id}")
    ApiResponse<Void> deleteUser(@PathVariable String id) throws IdInvalidException {
        userService.deleteUserById(id);
        return  ApiResponse.<Void>builder()
                .code(HttpStatus.OK.value())
                .error(null)
                .data(null)
                .message("Delete user successfully")
                .build();
    }
}
