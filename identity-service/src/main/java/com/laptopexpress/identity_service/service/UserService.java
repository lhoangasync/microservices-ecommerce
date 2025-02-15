package com.laptopexpress.identity_service.service;


import com.laptopexpress.identity_service.dto.request.UserCreateRequest;
import com.laptopexpress.identity_service.dto.response.UserResponse;
import com.laptopexpress.identity_service.entity.User;
import com.laptopexpress.identity_service.exception.IdInvalidException;
import com.laptopexpress.identity_service.mapper.UserMapper;
import com.laptopexpress.identity_service.repository.UserRepository;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class UserService {
    UserRepository userRepository;
    UserMapper userMapper;
    PasswordEncoder passwordEncoder;

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
        if(userExisted != null) {
            throw new IdInvalidException("Email " +  userExisted.getEmail() + " already exists");
        }

        User user = userMapper.toUser(request);
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setVerified(false);


        User savedUser = userRepository.save(user);
        log.info("User created: {}", savedUser);

        return userMapper.toUserResponse(savedUser);
    }
}
