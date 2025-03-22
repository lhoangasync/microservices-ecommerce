package com.laptopexpress.identity_service.config;


import com.laptopexpress.identity_service.entity.Permission;
import com.laptopexpress.identity_service.entity.Role;
import com.laptopexpress.identity_service.entity.User;
import com.laptopexpress.identity_service.enums.GenderEnum;
import com.laptopexpress.identity_service.repository.PermissionRepository;
import com.laptopexpress.identity_service.repository.RoleRepository;
import com.laptopexpress.identity_service.repository.UserRepository;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class DatabaseInitializer implements CommandLineRunner {

  @Autowired
  private PermissionRepository permissionRepository;

  @Autowired
  private RoleRepository roleRepository;

  @Autowired
  private UserRepository userRepository;

  @Autowired
  private PasswordEncoder passwordEncoder;

  @Override
  public void run(String... args) throws Exception {
    System.out.println(">>>>> START DATABASE INITIALIZER <<<<<");
    long countPermissions = this.permissionRepository.count();
    long countRoles = this.roleRepository.count();
    long countUsers = this.userRepository.count();
    if (countPermissions == 0) {
      ArrayList<Permission> arr = new ArrayList<>();
      arr.add(new Permission("Create a permission", "/permissions/create", "POST",
          "PERMISSIONS"));
      arr.add(new Permission("Update a permission", "/permissions/update", "PUT",
          "PERMISSIONS"));
      arr.add(new Permission("Delete a permission", "/permissions/delete/{id}", "DELETE",
          "PERMISSIONS"));
      arr.add(
          new Permission("Get a permission by id", "/permissions/get-by-id/{id}", "GET",
              "PERMISSIONS"));
      arr.add(
          new Permission("Get permissions with pagination", "/permissions/get-all", "GET",
              "PERMISSIONS"));

      arr.add(new Permission("Create a role", "/roles/create", "POST", "ROLES"));
      arr.add(new Permission("Update a role", "/roles/update", "PUT", "ROLES"));
      arr.add(new Permission("Delete a role", "/roles/delete/{id}", "DELETE", "ROLES"));
      arr.add(new Permission("Get a role by id", "/roles/get-by-id/{id}", "GET", "ROLES"));
      arr.add(
          new Permission("Get roles with pagination", "/roles/get-all", "GET", "ROLES"));

      arr.add(new Permission("Create a user", "/users/create", "POST", "USERS"));
      arr.add(new Permission("Update a user", "/users/update", "PUT", "USERS"));
      arr.add(new Permission("Delete a user", "/users/delete/{id}", "DELETE", "USERS"));
      arr.add(new Permission("Get a user by id", "/users/get-by-id/{id}", "GET", "USERS"));
      arr.add(
          new Permission("Get users with pagination", "/users/get-all", "GET", "USERS"));

      this.permissionRepository.saveAll(arr);
    }
    if (countRoles == 0) {
      List<Permission> allPermissions = this.permissionRepository.findAll();

      Role adminRole = Role.builder()
          .name("SUPER_ADMIN")
          .description("ADMIN - FULL PERMISSIONS")
          .active(true)
          .permissions(allPermissions)
          .build();

      this.roleRepository.save(adminRole);
    }
    if (countUsers == 0) {
      User adminUser = User.builder()
          .email("admin@gmail.com")
          .address("Ho Chi Minh")
          .phone("09017329**")
          .gender(GenderEnum.MALE)
          .username("admin")
          .verified(true)
          .password(passwordEncoder.encode("123456"))
          .build();

      Role adminRole = this.roleRepository.findByName("SUPER_ADMIN");
      if (adminRole != null) {
        adminUser.setRole(adminRole);
      }
      this.userRepository.save(adminUser);
    }
    if (countPermissions > 0 && countRoles > 0 && countUsers > 0) {
      System.out.println(">>> SKIP INIT DATABASE ~ ALREADY HAVE DATA...");
    } else {
      System.out.println(">>> END INIT DATABASE");
    }
  }
}
