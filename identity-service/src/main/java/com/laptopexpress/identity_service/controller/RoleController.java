package com.laptopexpress.identity_service.controller;

import com.laptopexpress.identity_service.dto.request.RoleRequest;
import com.laptopexpress.identity_service.dto.response.ApiResponse;
import com.laptopexpress.identity_service.dto.response.PageResponse;
import com.laptopexpress.identity_service.dto.response.RoleResponse;
import com.laptopexpress.identity_service.exception.IdInvalidException;
import com.laptopexpress.identity_service.service.RoleService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/roles")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class RoleController {

  RoleService roleService;


  /**
   * API to fetch role details by ID.
   *
   * @param id The ID of the role to retrieve.
   * @return ApiResponse containing role details.
   * @throws IdInvalidException If the provided ID does not exist.
   */
  @GetMapping("/get-by-id/{id}")
  ApiResponse<RoleResponse> getRoleById(@PathVariable String id) throws IdInvalidException {
    return ApiResponse.<RoleResponse>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .data(roleService.handleGetRoleById(id))
        .message("Get role by id successfully!")
        .build();
  }

  /**
   * API to create a new role.
   *
   * @param roleRequest Object containing role details.
   * @return ApiResponse containing the newly created role details.
   */
  @PostMapping("/create")
  ApiResponse<RoleResponse> createRole(@RequestBody RoleRequest roleRequest) {
    return ApiResponse.<RoleResponse>builder()
        .code(HttpStatus.CREATED.value())
        .error(null)
        .data(roleService.handleCreateRole(roleRequest))
        .message("Create role successfully!")
        .build();
  }

  @GetMapping("/get-all")
  ApiResponse<PageResponse<RoleResponse>> getAllRoles(
      @RequestParam(value = "page", required = false, defaultValue = "1") int page,
      @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
    return ApiResponse.<PageResponse<RoleResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get all roles successfully")
        .data(roleService.handleGetAllRoles(page, size))
        .build();
  }

  @PutMapping("/update")
  ApiResponse<RoleResponse> updateRole(@RequestBody RoleRequest roleRequest)
      throws IdInvalidException {
    return ApiResponse.<RoleResponse>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .data(roleService.handleUpdateRole(roleRequest))
        .message("Update role successfully!")
        .build();
  }

  @DeleteMapping("/delete/{id}")
  ApiResponse<Void> deleteRole(@PathVariable String id) throws IdInvalidException {
    roleService.handleDeleteRole(id);
    return ApiResponse.<Void>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .data(null)
        .message("Delete role successfully!")
        .build();
  }
}
