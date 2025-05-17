package com.laptopexpress.identity_service.mapper;

import com.laptopexpress.identity_service.dto.request.AddressRequest;
import com.laptopexpress.identity_service.dto.response.AddressResponse;
import com.laptopexpress.identity_service.entity.Address;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface AddressMapper {

  Address toAddress(AddressRequest addressRequest);

  AddressResponse toAddressResponse(Address address);
}
