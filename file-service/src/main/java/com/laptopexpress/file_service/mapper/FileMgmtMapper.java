package com.laptopexpress.file_service.mapper;

import com.laptopexpress.file_service.dto.FileInfo;
import com.laptopexpress.file_service.entity.FileMgmt;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface FileMgmtMapper {

  @Mapping(target = "id", source = "name")
  FileMgmt toFileMgmt(FileInfo fileInfo);

}
