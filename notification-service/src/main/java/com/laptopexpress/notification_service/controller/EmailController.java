package com.laptopexpress.notification_service.controller;

import com.laptopexpress.notification_service.dto.ApiResponse;
import com.laptopexpress.notification_service.dto.request.SendEmailRequest;
import com.laptopexpress.notification_service.dto.response.EmailResponse;
import com.laptopexpress.notification_service.exception.IdInvalidException;
import com.laptopexpress.notification_service.service.EmailService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class EmailController {

  EmailService emailService;

  @PostMapping("/email/send")
  ApiResponse<EmailResponse> sendEmail(@RequestBody SendEmailRequest request)
      throws IdInvalidException {
    return ApiResponse.<EmailResponse>builder()
        .data(emailService.sendEmail(request))
        .build();
  }
}
