package com.laptopexpress.identity_service.mapper;

import com.laptopexpress.identity_service.dto.request.UserCreateRequest;
import com.laptopexpress.identity_service.dto.response.UserResponse;
import com.laptopexpress.identity_service.entity.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UserMapper {

  User toUser(UserCreateRequest request);

  //  @Mapping(source = "role.name", target = "role.name")
  UserResponse toUserResponse(User user);
}
