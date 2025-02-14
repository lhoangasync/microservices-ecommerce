package com.laptopexpress.identity_service.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.laptopexpress.identity_service.service.AuthenticationService;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.Instant;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "permissions")
public class Permission {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    String id;

    String name;
    String apiPath;
    String method;
    String module;

    Instant createdAt;
    Instant updatedAt;
    String createdBy;
    String updatedBy;

    @ManyToMany(fetch = FetchType.LAZY, mappedBy = "permissions")
    @JsonIgnore
    List<Role> roles;
    @PrePersist
    public void handleBeforeCreate() {
        this.createdBy = AuthenticationService.getCurrentUserLogin().isPresent()
                ? AuthenticationService.getCurrentUserLogin().get()
                : "";

        this.createdAt = Instant.now();
    }

    @PreUpdate
    public void handleBeforeUpdate() {
        this.updatedBy = AuthenticationService.getCurrentUserLogin().isPresent()
                ? AuthenticationService.getCurrentUserLogin().get()
                : "";

        this.updatedAt = Instant.now();
    }

}
