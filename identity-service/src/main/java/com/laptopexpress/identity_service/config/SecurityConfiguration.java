package com.laptopexpress.identity_service.config;

import com.laptopexpress.identity_service.service.AuthenticationService;
import com.nimbusds.jose.jwk.source.ImmutableSecret;
import com.nimbusds.jose.util.Base64;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.jwt.*;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.security.web.SecurityFilterChain;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfiguration {

  @Value("${jwt.secret-key}")
  String jwtKey;

  String[] PUBLIC_ENDPOINTS = {
      "/auth/register", "/auth/login", "/auth/refresh",
      "/auth/introspect", "/auth/verify-otp", "/auth/resend-otp",
      "/auth/reset-password",
  };


  @Bean
  SecurityFilterChain securityFilterChain(HttpSecurity http,
      CustomAuthenticationEntryPoint customAuthenticationEntryPoint) throws Exception {
    http
        .authorizeHttpRequests(auth -> auth
            .requestMatchers(PUBLIC_ENDPOINTS).permitAll()
            .anyRequest().authenticated())
        .oauth2ResourceServer((oauth2) -> oauth2.jwt(Customizer.withDefaults())
            .authenticationEntryPoint(customAuthenticationEntryPoint))
        .formLogin(form -> form.disable())
        .csrf(c -> c.disable())
        .cors(Customizer.withDefaults())
        .sessionManagement(
            session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS));
    return http.build();
  }

  private SecretKey getSecretKey() {
    byte[] keyBytes = Base64.from(jwtKey).decode();
    return new SecretKeySpec(keyBytes, 0, keyBytes.length,
        AuthenticationService.JWT_ALGORITHM.getName());
  }

  @Bean
  PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder(10);
  }

  @Bean
  public JwtEncoder jwtEncoder() {
    return new NimbusJwtEncoder(new ImmutableSecret<>(getSecretKey()));
  }

  @Bean
  public JwtDecoder jwtDecoder() {
    NimbusJwtDecoder jwtDecoder = NimbusJwtDecoder.withSecretKey(
        getSecretKey()).macAlgorithm(AuthenticationService.JWT_ALGORITHM).build();
    return token -> {
      try {
        return jwtDecoder.decode(token);
      } catch (JwtException e) {
        System.out.println(">>> JWT error: " + e.getMessage());
        throw e;
      }
    };
  }

  @Bean
  public JwtAuthenticationConverter jwtAuthenticationConverter() {
    JwtGrantedAuthoritiesConverter grantedAuthoritiesConverter = new JwtGrantedAuthoritiesConverter();
    grantedAuthoritiesConverter.setAuthorityPrefix("");
    grantedAuthoritiesConverter.setAuthoritiesClaimName("permission");
    JwtAuthenticationConverter jwtAuthenticationConverter = new JwtAuthenticationConverter();
    jwtAuthenticationConverter.setJwtGrantedAuthoritiesConverter(grantedAuthoritiesConverter);
    return jwtAuthenticationConverter;
  }
}
