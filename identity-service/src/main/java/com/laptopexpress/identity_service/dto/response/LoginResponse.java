package com.laptopexpress.identity_service.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.laptopexpress.identity_service.entity.Role;
import lombok.*;

@Getter
@Setter
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LoginResponse {
    @JsonProperty("access_token")
    private String token;
    private LoginResponse.UserLogin user;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Data
    public static class UserLogin {
        private String id;
        private String email;
        private String username;
        private Role role;
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Data
    public static class UserGetAccount {
        private UserLogin user;
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    @Data
    public static class UserInsideToken {
        private String id;
        private String email;
        private String username;
    }
}
