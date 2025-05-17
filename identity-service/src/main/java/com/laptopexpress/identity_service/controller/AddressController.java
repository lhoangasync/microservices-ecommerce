package com.laptopexpress.identity_service.controller;

import com.laptopexpress.identity_service.dto.request.AddressRequest;
import com.laptopexpress.identity_service.dto.request.AddressUpdateRequest;
import com.laptopexpress.identity_service.dto.response.AddressResponse;
import com.laptopexpress.identity_service.dto.response.ApiResponse;
import com.laptopexpress.identity_service.exception.IdInvalidException;
import com.laptopexpress.identity_service.service.AddressService;
import java.util.List;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/addresses")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class AddressController {

  AddressService addressService;

  @PostMapping("/create")
  ApiResponse<AddressResponse> addAddress(@RequestBody AddressRequest addressRequest)
      throws IdInvalidException {
    return ApiResponse.<AddressResponse>builder()
        .code(HttpStatus.CREATED.value())
        .error(null)
        .message("Add Address Successfully!")
        .data(addressService.createAddress(addressRequest))
        .build();
  }

  @GetMapping("/get-all")
  ApiResponse<List<AddressResponse>> getAllAddresses() {
    return ApiResponse.<List<AddressResponse>>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Get All Addresses Successfully!")
        .data(addressService.getAllAddresses())
        .build();
  }

  @PutMapping("/update")
  ApiResponse<AddressResponse> updateAddress(@RequestBody AddressUpdateRequest request)
      throws IdInvalidException {
    return ApiResponse.<AddressResponse>builder()
        .code(HttpStatus.OK.value())
        .error(null)
        .message("Update Address Successfully!")
        .data(addressService.updateAddress(request))
        .build();
  }

}
