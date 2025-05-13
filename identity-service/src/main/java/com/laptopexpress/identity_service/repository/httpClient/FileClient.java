package com.laptopexpress.identity_service.repository.httpClient;

import com.laptopexpress.identity_service.dto.response.ApiResponse;
import com.laptopexpress.identity_service.dto.response.FileResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

@FeignClient(name = "file-service", url = "http://localhost:8087/file")
public interface FileClient {

  @PostMapping(value = "/media/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
  ApiResponse<FileResponse> uploadMedia(@RequestPart("file") MultipartFile file);
}
