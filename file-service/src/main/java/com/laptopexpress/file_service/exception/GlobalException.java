package com.laptopexpress.file_service.exception;


import com.laptopexpress.file_service.dto.ApiResponse;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.resource.NoResourceFoundException;

@RestControllerAdvice
public class GlobalException {

  // handle get all exception
  @ExceptionHandler(Exception.class)
  public ResponseEntity<ApiResponse<Object>> handleAllException(Exception ex) {
    ApiResponse<Object> res = ApiResponse.builder()
        .code(HttpStatus.INTERNAL_SERVER_ERROR.value())
        .message(ex.getMessage())
        .error("Internal Server Error")
        .build();

    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(res);
  }

  //Exception
  @ExceptionHandler(value = {
      UsernameNotFoundException.class,
      BadCredentialsException.class,
      IdInvalidException.class,
  })
  public ResponseEntity<ApiResponse<Object>> handleException(Exception ex) {
    ApiResponse<Object> res = ApiResponse.builder()
        .code(HttpStatus.BAD_REQUEST.value())
        .message(ex.getMessage())
        .error("Something wrong !!!...")
        .build();

    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(res);
  }

  @ExceptionHandler(value = {
      NoResourceFoundException.class,
  })
  public ResponseEntity<ApiResponse<Object>> handleNotFoundException(Exception ex) {
    ApiResponse<Object> res = ApiResponse.builder()
        .code(HttpStatus.NOT_FOUND.value())
        .message(ex.getMessage())
        .error("404 Not Found. URL may not exist...")
        .build();

    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(res);
  }

  @ExceptionHandler(value = MethodArgumentNotValidException.class)
  public ResponseEntity<ApiResponse<Object>> validationError(
      MethodArgumentNotValidException methodArgumentNotValidException) {

    BindingResult bindingResult = methodArgumentNotValidException.getBindingResult();
    List<FieldError> fieldErrors = bindingResult.getFieldErrors();

    List<String> errors = fieldErrors.stream()
        .map(FieldError::getDefaultMessage)
        .collect(Collectors.toList());

    ApiResponse<Object> res = ApiResponse.builder()
        .code(HttpStatus.BAD_REQUEST.value())
        .error(methodArgumentNotValidException.getBody().getDetail())
        .message(errors.size() > 1 ? errors : errors.getFirst())
        .build();

    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(res);
  }

  @ExceptionHandler(value = {
      PermissionException.class,
  })
  public ResponseEntity<ApiResponse<Object>> handlePermissionException(Exception ex) {
    ApiResponse<Object> res = ApiResponse.builder()
        .code(HttpStatus.FORBIDDEN.value())
        .message(ex.getMessage())
        .error("Forbidden !!!!! (File-service)")
        .build();
    return ResponseEntity.status(HttpStatus.FORBIDDEN).body(res);
  }
}
