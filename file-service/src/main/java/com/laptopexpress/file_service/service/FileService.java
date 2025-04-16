package com.laptopexpress.file_service.service;

import com.laptopexpress.file_service.dto.response.FileData;
import com.laptopexpress.file_service.dto.response.FileResponse;
import com.laptopexpress.file_service.exception.IdInvalidException;
import com.laptopexpress.file_service.mapper.FileMgmtMapper;
import com.laptopexpress.file_service.repository.FileMgmtRepository;
import com.laptopexpress.file_service.repository.FileRepository;
import com.laptopexpress.file_service.util.SecurityUtil;
import java.io.IOException;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class FileService {

  FileRepository fileRepository;
  FileMgmtRepository fileMgmtRepository;

  FileMgmtMapper fileMgmtMapper;


  public FileResponse uploadFile(MultipartFile file) throws IOException {
    var fileInfo = fileRepository.store(file);

    var fileMgmt = fileMgmtMapper.toFileMgmt(fileInfo);

    String userId = SecurityUtil.getCurrentUserId();
    fileMgmt.setOwnerId(userId);

    fileMgmt = fileMgmtRepository.save(fileMgmt);

    return FileResponse.builder()
        .url(fileInfo.getUrl())
        .originalFileName(file.getOriginalFilename())
        .build();
  }

  public FileData download(String fileName) throws IdInvalidException, IOException {
    var fileMgmt = fileMgmtRepository.findById(fileName)
        .orElseThrow(() -> new IdInvalidException("FILE_NOT_FOUND"));

    var resource = fileRepository.read(fileMgmt);

    return new FileData(fileMgmt.getContentType(), resource);
  }
}
