package com.laptopexpress.identity_service.service;

import com.laptopexpress.identity_service.dto.request.PermissionRequest;
import com.laptopexpress.identity_service.dto.response.PageResponse;
import com.laptopexpress.identity_service.dto.response.PermissionResponse;
import com.laptopexpress.identity_service.entity.Permission;
import com.laptopexpress.identity_service.exception.IdInvalidException;
import com.laptopexpress.identity_service.mapper.PermissionMapper;
import com.laptopexpress.identity_service.repository.PermissionRepository;
import java.util.Optional;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class PermissionService {

  PermissionRepository permissionRepository;
  PermissionMapper permissionMapper;

  // generate permission
  public PermissionResponse handleCreatePermission(PermissionRequest permissionRequest) {
    var permission = permissionMapper.toPermission(permissionRequest);
    permissionRepository.save(permission);
    return permissionMapper.toPermissionResponse(permission);
  }

  // fetch permission by id
  public PermissionResponse handleGetPermissionById(String id) throws IdInvalidException {
    Optional<Permission> permission = permissionRepository.findById(id);
    return permission.map(permissionMapper::toPermissionResponse)
        .orElseThrow(
            () -> new IdInvalidException("Permission with this ID = " + id + " isn't existed!"));
  }

  // fetch all permissions
  public PageResponse<PermissionResponse> handleGetAllPermissions(int page, int size) {
    Sort sort = Sort.by("createdAt").descending();

    Pageable pageable = PageRequest.of(page - 1, size, sort);

    var pageData = permissionRepository.findAll(pageable);

    return PageResponse.<PermissionResponse>builder()
        .currentPage(page)
        .pageSize(pageData.getSize())
        .totalPages(pageData.getTotalPages())
        .totalElements(pageData.getTotalElements())
        .data(pageData.getContent().stream().map(permissionMapper::toPermissionResponse).toList())
        .build();
  }

  // update permission
  public PermissionResponse handleUpdatePermission(PermissionRequest permissionRequest)
      throws IdInvalidException {
    var permission = permissionMapper.toPermission(permissionRequest);
    Permission permissionDB = permissionRepository.findById(permission.getId()).orElseThrow(
        () -> new IdInvalidException(
            "Permission with this ID = " + permission.getId() + " isn't existed!")
    );
    permissionDB.setName(permission.getName());
    permissionDB.setApiPath(permission.getApiPath());
    permissionDB.setMethod(permission.getMethod());
    permissionDB.setModule(permission.getModule());

    permissionDB = permissionRepository.save(permissionDB);
    return permissionMapper.toPermissionResponse(permissionDB);
  }

  // delete permission
  public void handleDeletePermission(String id) throws IdInvalidException {
    Permission permissionDB = permissionRepository.findById(id).orElseThrow(
        () -> new IdInvalidException(
            "Permission with this ID = " + id + " isn't existed!")
    );
    permissionDB.getRoles().forEach(role -> role.getPermissions().remove(permissionDB));

    permissionRepository.delete(permissionDB);
  }
}
