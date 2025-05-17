package com.laptopexpress.identity_service.repository;

import com.laptopexpress.identity_service.entity.Address;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AddressRepository extends JpaRepository<Address, String> {

  List<Address> findByUser_Id(String userId);

}
