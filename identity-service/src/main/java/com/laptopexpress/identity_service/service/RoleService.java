package com.laptopexpress.identity_service.service;

import com.laptopexpress.identity_service.dto.request.RoleRequest;
import com.laptopexpress.identity_service.dto.response.PageResponse;
import com.laptopexpress.identity_service.dto.response.RoleResponse;
import com.laptopexpress.identity_service.entity.Permission;
import com.laptopexpress.identity_service.entity.Role;
import com.laptopexpress.identity_service.exception.IdInvalidException;
import com.laptopexpress.identity_service.mapper.RoleMapper;
import com.laptopexpress.identity_service.repository.PermissionRepository;
import com.laptopexpress.identity_service.repository.RoleRepository;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;


@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class RoleService {

  RoleRepository roleRepository;
  PermissionRepository permissionRepository;
  RoleMapper roleMapper;

  // generate role
  public RoleResponse handleCreateRole(RoleRequest roleRequest) {
    var role = roleMapper.toRole(roleRequest);
    //check permissions input
    if (role.getPermissions() != null) {
      List<String> permissionRequests = role.getPermissions()
          .stream().map(Permission::getId)
          .toList();

      List<Permission> permissions = permissionRepository.findByIdIn(permissionRequests);
      role.setPermissions(permissions);
    }
    return roleMapper.toRoleResponse(roleRepository.save(role));
  }

  // fetch role by id
  public RoleResponse handleGetRoleById(String id) throws IdInvalidException {
    Optional<Role> role = roleRepository.findById(id);
    return role.map(roleMapper::toRoleResponse)
        .orElseThrow(() -> new IdInvalidException("Role with this ID = " + id + " not found"));
  }

  // fetch all roles
  public PageResponse<RoleResponse> handleGetAllRoles(int page, int size) {
    Sort sort = Sort.by("createdAt").descending();

    Pageable pageable = PageRequest.of(page - 1, size, sort);

    var pageData = roleRepository.findAll(pageable);

    return PageResponse.<RoleResponse>builder()
        .currentPage(page)
        .pageSize(pageData.getSize())
        .totalPages(pageData.getTotalPages())
        .totalElements(pageData.getTotalElements())
        .data(pageData.getContent().stream().map(roleMapper::toRoleResponse).toList())
        .build();
  }


  //update role
  public RoleResponse handleUpdateRole(RoleRequest roleRequest) throws IdInvalidException {
    var role = roleMapper.toRole(roleRequest);

    Role roleDB = roleRepository.findById(role.getId())
        .orElseThrow(
            () -> new IdInvalidException("Role with this ID = " + role.getId() + " not found"));

    roleDB.setName(role.getName());
    roleDB.setDescription(role.getDescription());
    roleDB.setActive(role.isActive());

    if (role.getPermissions() != null) {
      List<String> requestPermissionIds = role.getPermissions()
          .stream()
          .map(Permission::getId)
          .toList();

      List<Permission> updatedPermissions = permissionRepository.findByIdIn(requestPermissionIds);
      roleDB.setPermissions(updatedPermissions);
    }

    return roleMapper.toRoleResponse(roleRepository.save(roleDB));
  }

  //delete role
  public void handleDeleteRole(String id) throws IdInvalidException {
    Role roleDB = roleRepository.findById(id)
        .orElseThrow(
            () -> new IdInvalidException("Role with this ID = " + id + " not found"));
    roleRepository.delete(roleDB);
  }

}
