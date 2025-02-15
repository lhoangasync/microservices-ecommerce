package com.laptopexpress.identity_service.repository;

import com.laptopexpress.identity_service.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import javax.sql.RowSet;
import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, String> {
    boolean existsByEmail(String email);

    User findUserByEmail(String email);

    User findUserByRefreshTokenAndEmail(String refreshToken, String email);

}
