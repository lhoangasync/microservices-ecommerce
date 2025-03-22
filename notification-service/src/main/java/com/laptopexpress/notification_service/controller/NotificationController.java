package com.laptopexpress.notification_service.controller;

import com.laptopexpress.event.dto.NotificationEvent;
import com.laptopexpress.notification_service.dto.request.Recipient;
import com.laptopexpress.notification_service.dto.request.SendEmailRequest;
import com.laptopexpress.notification_service.exception.IdInvalidException;
import com.laptopexpress.notification_service.service.EmailService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class NotificationController {

  EmailService emailService;

  @KafkaListener(topics = "notifications-email")
  public void listenNotificationDelivery(NotificationEvent message) throws IdInvalidException {
    log.info("Message received: {}", message);
    emailService.sendEmail(SendEmailRequest.builder()
        .to(Recipient.builder().email(message.getRecipient()).build())
        .subject(message.getSubject())
        .htmlContent(message.getBody())
        .build());
  }
}
