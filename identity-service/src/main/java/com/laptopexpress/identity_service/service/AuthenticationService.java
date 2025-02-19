package com.laptopexpress.identity_service.service;


import com.laptopexpress.identity_service.dto.request.IntrospectRequest;
import com.laptopexpress.identity_service.dto.response.IntrospectResponse;
import com.laptopexpress.identity_service.dto.response.LoginResponse;
import com.laptopexpress.identity_service.entity.InvalidatedToken;
import com.laptopexpress.identity_service.exception.IdInvalidException;
import com.laptopexpress.identity_service.repository.InvalidatedTokenRepository;
import com.nimbusds.jose.JOSEException;
import com.nimbusds.jose.JWSVerifier;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jose.util.Base64;
import com.nimbusds.jwt.SignedJWT;
import java.text.ParseException;
import java.util.Date;
import java.util.Map;
import java.util.UUID;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.*;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AuthenticationService {

  public static final MacAlgorithm JWT_ALGORITHM = MacAlgorithm.HS512;

  JwtDecoder jwtDecoder;
  JwtEncoder jwtEncoder;
  InvalidatedTokenRepository invalidatedTokenRepository;

  @NonFinal
  @Value("${jwt.secret-key}")
  String jwtKey;

  @NonFinal
  @Value("${jwt.token-validity-in-seconds}")
  long accessTokenExpiration;

  @NonFinal
  @Value("${jwt.refresh-token-validity-in-seconds}")
  long refreshTokenExpiration;

  public void invalidateRefreshToken(String refreshToken) {
    Jwt decodedToken = jwtDecoder.decode(refreshToken);
    System.out.println(">>>>> check: " + decodedToken.getTokenValue());
    String jti = decodedToken.getId();
    Instant expiryTime = decodedToken.getExpiresAt();

    InvalidatedToken invalidatedToken = InvalidatedToken.builder()
        .id(jti)
        .expiryTime(Date.from(expiryTime))
        .build();

    invalidatedTokenRepository.save(invalidatedToken);
  }

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

  private SecretKey getSecretKey() {
    byte[] keyBytes = Base64.from(jwtKey).decode();
    return new SecretKeySpec(keyBytes, 0, keyBytes.length,
        AuthenticationService.JWT_ALGORITHM.getName());
  }

  public Jwt checkValidRefreshToken(String token) {
    NimbusJwtDecoder jwtDecoder = NimbusJwtDecoder.withSecretKey(getSecretKey())
        .macAlgorithm(JWT_ALGORITHM)
        .build();

    try {
      Jwt jwt = jwtDecoder.decode(token);
      if (jwt.getExpiresAt() != null && jwt.getExpiresAt().isBefore(Instant.now())) {
        throw new JwtException("Refresh token has expired");
      }
      return jwt;
    } catch (JwtException e) {
      log.error(">>> Refresh Token error: {}", e.getMessage());
      throw e;
    }
  }


  //Generate Access Token
  public String generateAccessToken(String email, LoginResponse loginResponse) {
    LoginResponse.UserInsideToken userInsideToken = LoginResponse.UserInsideToken.builder()
        .id(loginResponse.getUser().getId())
        .email(loginResponse.getUser().getEmail())
        .username(loginResponse.getUser().getUsername())
        .build();

    Instant now = Instant.now();
    Instant validity = now.plus(accessTokenExpiration, ChronoUnit.SECONDS);

    //payload
    JwtClaimsSet jwtClaimsSet = JwtClaimsSet.builder()
        .issuedAt(now)
        .expiresAt(validity)
        .subject(email)
        .claim("user", userInsideToken)
        .id(UUID.randomUUID().toString())
        .build();

    //header
    JwsHeader jwsHeader = JwsHeader.with(JWT_ALGORITHM).build();
    return jwtEncoder.encode(JwtEncoderParameters.from(jwsHeader, jwtClaimsSet))
        .getTokenValue();
  }

  //Generate Refresh Token
  public String generateRefreshToken(String email, LoginResponse loginResponse) {
    LoginResponse.UserInsideToken userInsideToken = LoginResponse.UserInsideToken.builder()
        .id(loginResponse.getUser().getId())
        .email(loginResponse.getUser().getEmail())
        .username(loginResponse.getUser().getUsername())
        .build();

    Instant now = Instant.now();
    Instant validity = now.plus(refreshTokenExpiration, ChronoUnit.SECONDS);

    //payload
    JwtClaimsSet jwtClaimsSet = JwtClaimsSet.builder()
        .issuedAt(now)
        .expiresAt(validity)
        .subject(email)
        .claim("user", userInsideToken)
        .id(UUID.randomUUID().toString())
        .build();

    //header
    JwsHeader jwsHeader = JwsHeader.with(JWT_ALGORITHM).build();
    return jwtEncoder.encode(JwtEncoderParameters.from(jwsHeader, jwtClaimsSet))
        .getTokenValue();
  }


  public static Optional<String> getCurrentUserLogin() {
    SecurityContext securityContext = SecurityContextHolder.getContext();
    return Optional.ofNullable(extractPrincipal(securityContext.getAuthentication()));
  }

  private static String extractPrincipal(Authentication authentication) {
    if (authentication == null) {
      return null;
    } else if (authentication.getPrincipal() instanceof UserDetails springSecurityUser) {
      return springSecurityUser.getUsername();
    } else if (authentication.getPrincipal() instanceof Jwt jwt) {
      return jwt.getSubject();
    } else if (authentication.getPrincipal() instanceof String s) {
      return s;
    }
    return null;
  }

  public static Optional<String> getCurrentUserJWT() {
    SecurityContext securityContext = SecurityContextHolder.getContext();
    return Optional.ofNullable(securityContext.getAuthentication())
        .filter(authentication -> authentication.getCredentials() instanceof String)
        .map(authentication -> (String) authentication.getCredentials());
  }

  public IntrospectResponse introspect(IntrospectRequest request) {
    var token = request.getToken();
    boolean isValid = true;

    try {
      verifyToken(token, false);
    } catch (IdInvalidException | JOSEException | ParseException e) {
      isValid = false;
    }

    return IntrospectResponse.builder().valid(isValid).build();
  }

  public SignedJWT verifyToken(String token, boolean isRefresh)
      throws JOSEException, ParseException, IdInvalidException {
    log.info("Verifying token: {}", token);

    JWSVerifier verifier = new MACVerifier(getSecretKey());
    SignedJWT signedJWT = SignedJWT.parse(token);

    Date expiryTime = (isRefresh) ? new Date(signedJWT.getJWTClaimsSet()
        .getIssueTime()
        .toInstant()
        .plus(refreshTokenExpiration, ChronoUnit.SECONDS)
        .toEpochMilli()) : signedJWT.getJWTClaimsSet().getExpirationTime();

    log.info("Token expiry time: {}", expiryTime);

    boolean verified = signedJWT.verify(verifier);
    log.info("JWT verification status: {}", verified);

    if (!(verified && expiryTime.after(new Date()))) {
      throw new JOSEException("Expired or invalid JWT");
    }

    if (invalidatedTokenRepository.existsById(signedJWT.getJWTClaimsSet().getJWTID())) {
      throw new IdInvalidException("UNAUTHENTICATED");
    }

    return signedJWT;
  }


}
