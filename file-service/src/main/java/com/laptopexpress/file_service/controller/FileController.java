package com.laptopexpress.file_service.controller;

import com.laptopexpress.file_service.dto.ApiResponse;
import com.laptopexpress.file_service.dto.response.FileResponse;
import com.laptopexpress.file_service.exception.IdInvalidException;
import com.laptopexpress.file_service.service.FileService;
import java.io.IOException;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class FileController {

  FileService fileService;

  @PostMapping("/media/upload")
  ApiResponse<FileResponse> uploadMedia(@RequestParam("file") MultipartFile file)
      throws IOException {
    return ApiResponse.<FileResponse>builder()
        .data(fileService.uploadFile(file))
        .error(null)
        .code(HttpStatus.CREATED.value())
        .message("Upload file successful!")
        .build();
  }

  @GetMapping("/media/download/{fileName}")
  ResponseEntity<Resource> downloadMedia(@PathVariable String fileName)
      throws IdInvalidException, IOException {
    var fileData = fileService.download(fileName);
    return ResponseEntity.<Resource>ok()
        .header(HttpHeaders.CONTENT_TYPE, fileData.contentType())
        .body(fileData.resource());

  }


}
