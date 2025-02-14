package com.laptopexpress.identity_service.mapper;

import com.laptopexpress.identity_service.dto.request.UserCreateRequest;
import com.laptopexpress.identity_service.dto.response.UserResponse;
import com.laptopexpress.identity_service.entity.User;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserMapper {
    User toUser(UserCreateRequest request);

    UserResponse toUserResponse(User user);
}
