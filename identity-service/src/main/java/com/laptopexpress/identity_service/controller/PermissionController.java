package com.laptopexpress.identity_service.controller;


import com.laptopexpress.identity_service.dto.request.PermissionRequest;
import com.laptopexpress.identity_service.dto.response.ApiResponse;
import com.laptopexpress.identity_service.dto.response.PageResponse;
import com.laptopexpress.identity_service.dto.response.PermissionResponse;
import com.laptopexpress.identity_service.dto.response.RoleResponse;
import com.laptopexpress.identity_service.exception.IdInvalidException;
import com.laptopexpress.identity_service.service.PermissionService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/permissions")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class PermissionController {

  PermissionService permissionService;

  @PostMapping("/create")
  ApiResponse<PermissionResponse> createPermission(
      @RequestBody PermissionRequest permissionRequest) {
    return ApiResponse.<PermissionResponse>builder()
        .code(HttpStatus.CREATED.value())
        .error(null)
        .message("Permission created successfully")
        .data(permissionService.handleCreatePermission(permissionRequest))
        .build();
  }

  @GetMapping("/get-by-id/{id}")
  ApiResponse<PermissionResponse> getPermissionById(@PathVariable String id)
      throws IdInvalidException {
    return ApiResponse.<PermissionResponse>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Permission found")
        .data(permissionService.handleGetPermissionById(id))
        .build();
  }

  @GetMapping("/get-all")
  ApiResponse<PageResponse<PermissionResponse>> getAllPermissions(
      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
      @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
    return ApiResponse.<PageResponse<PermissionResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get all permissions successfully")
        .data(permissionService.handleGetAllPermissions(page, size))
        .build();
  }

  @PutMapping("/update")
  ApiResponse<PermissionResponse> updatePermission(@RequestBody PermissionRequest permissionRequest)
      throws IdInvalidException {
    return ApiResponse.<PermissionResponse>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Permission updated successfully")
        .data(permissionService.handleUpdatePermission(permissionRequest))
        .build();
  }

  @DeleteMapping("/delete/{id}")
  ApiResponse<Void> deletePermission(@PathVariable String id) throws IdInvalidException {
    permissionService.handleDeletePermission(id);
    return ApiResponse.<Void>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Permission deleted successfully")
        .data(null)
        .build();
  }
}
