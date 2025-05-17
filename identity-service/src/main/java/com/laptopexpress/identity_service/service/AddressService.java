package com.laptopexpress.identity_service.service;

import com.laptopexpress.identity_service.dto.request.AddressRequest;
import com.laptopexpress.identity_service.dto.request.AddressUpdateRequest;
import com.laptopexpress.identity_service.dto.response.AddressResponse;
import com.laptopexpress.identity_service.entity.Address;
import com.laptopexpress.identity_service.entity.User;
import com.laptopexpress.identity_service.exception.IdInvalidException;
import com.laptopexpress.identity_service.mapper.AddressMapper;
import com.laptopexpress.identity_service.repository.AddressRepository;
import com.laptopexpress.identity_service.repository.UserRepository;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class AddressService {

  AddressRepository addressRepository;
  UserRepository userRepository;
  AddressMapper addressMapper;

  // add address
  public AddressResponse createAddress(AddressRequest addressRequest) throws IdInvalidException {
    String userId = AuthenticationService.getCurrentUserId();
    User user = userRepository.findById(userId)
        .orElseThrow(() -> new IdInvalidException("User not found with ID: " + userId));

    Address address = addressMapper.toAddress(addressRequest);
    address.setUser(user);

    Address savedAddress = addressRepository.save(address);
    return addressMapper.toAddressResponse(savedAddress);
  }

  // get all addresses sorted by createdAt (newest first)
  public List<AddressResponse> getAllAddresses() {
    String userId = AuthenticationService.getCurrentUserId();
    List<Address> addresses = addressRepository.findByUser_Id(userId);

    return addresses.stream()
        .sorted(Comparator.comparing(Address::getCreatedAt, Comparator.nullsLast(
            Comparator.reverseOrder())))
        .map(addressMapper::toAddressResponse)
        .collect(Collectors.toList());
  }

  // update address
  public AddressResponse updateAddress(AddressUpdateRequest request) throws IdInvalidException {
    Address address = addressRepository.findById(request.getId())
        .orElseThrow(() -> new IdInvalidException("Address not found with ID: " + request.getId()));

    if (request.getName() != null) {
      address.setName(request.getName());
    }
    if (request.getStreet() != null) {
      address.setStreet(request.getStreet());
    }
    if (request.getCity() != null) {
      address.setCity(request.getCity());
    }
    if (request.getState() != null) {
      address.setState(request.getState());
    }
    if (request.getCountry() != null) {
      address.setCountry(request.getCountry());
    }
    if (request.getPhoneNumber() != null) {
      address.setPhoneNumber(request.getPhoneNumber());
    }
    if (request.getSelectedAddress() != null) {
      address.setSelectedAddress(request.getSelectedAddress());
    }

    Address updatedAddress = addressRepository.save(address);
    return addressMapper.toAddressResponse(updatedAddress);
  }

}
