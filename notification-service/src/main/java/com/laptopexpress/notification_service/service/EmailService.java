package com.laptopexpress.notification_service.service;

import com.laptopexpress.notification_service.dto.request.EmailRequest;
import com.laptopexpress.notification_service.dto.request.SendEmailRequest;
import com.laptopexpress.notification_service.dto.request.Sender;
import com.laptopexpress.notification_service.dto.response.EmailResponse;
import com.laptopexpress.notification_service.exception.IdInvalidException;
import com.laptopexpress.notification_service.repository.httpClient.EmailClient;
import feign.FeignException;
import java.util.List;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class EmailService {

  EmailClient emailClient;

  @Value("${notification.email.brevo-apikey}")
  @NonFinal
  String apiKey;

  public EmailResponse sendEmail(SendEmailRequest request) throws IdInvalidException {
    EmailRequest emailRequest = EmailRequest.builder()
        .sender(Sender.builder()
            .name("lhoangdev DotCom")
            .email("vatcvietmy123456@gmail.com")
            .build())
        .to(List.of(request.getTo()))
        .subject(request.getSubject())
        .htmlContent(request.getHtmlContent())
        .build();
    try {
      return emailClient.sendEmail(apiKey, emailRequest);
    } catch (FeignException e) {
      throw new IdInvalidException("Cannot send email!");
    }
  }
}
