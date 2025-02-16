package com.laptopexpress.identity_service.mapper;

import com.laptopexpress.identity_service.dto.request.RoleRequest;
import com.laptopexpress.identity_service.dto.response.RoleResponse;
import com.laptopexpress.identity_service.entity.Role;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface RoleMapper {
    Role toRole(RoleRequest request);

    RoleResponse toRoleResponse(Role role);
}
