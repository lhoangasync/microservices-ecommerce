import 'dart:convert';
import 'dart:io';
import 'package:ecommerce_app/utils/http/http_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final localStorage = GetStorage();
  final url = THttpHelper.baseUrl;

  final List<dynamic> _categories = [];
  bool _isLoading = true;
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
    _loadCategories();
  }

  // Load danh sách danh mục
  Future<void> _loadCategories() async {
    print(
      'Bắt đầu tải danh mục: page=$_currentPage, isLoading=$_isLoading, hasMoreData=$_hasMoreData',
    );

    if (!_hasMoreData || _isLoading) {
      print(
        '-> Bỏ qua vì _hasMoreData = $_hasMoreData hoặc _isLoading = $_isLoading',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Đang gửi request API...');
      final response = await THttpHelper.get(
        'category/categories/get-all?page=$_currentPage&size=$_pageSize',
        useToken: true,
      );
      print('Nhận response API: ${response['code']}');
      print('Full response: $response');

      if (response['code'] == 200) {
        // Cấu trúc lồng nhau có thể giống brand: data.data.data
        final outerData = response['data'];

        if (outerData != null) {
          List<dynamic> newCategories = [];

          // Xử lý cho cả hai trường hợp: cấu trúc lồng nhau hoặc cấu trúc cũ
          if (outerData['data'] != null) {
            // Trường hợp 1: response.data.data
            final innerData = outerData['data'];

            if (innerData['data'] != null && innerData['data'] is List) {
              // Cấu trúc: response.data.data.data (mảng)
              newCategories = List<dynamic>.from(innerData['data']);
              print(
                'Cấu trúc lồng 2 lớp: Tìm thấy ${newCategories.length} danh mục mới',
              );
            } else if (innerData['content'] != null &&
                innerData['content'] is List) {
              // Cấu trúc cũ: response.data.data.content (mảng)
              newCategories = List<dynamic>.from(innerData['content']);
              print(
                'Cấu trúc cũ: Tìm thấy ${newCategories.length} danh mục mới',
              );
            } else if (innerData is List) {
              // Cấu trúc: response.data.data (là mảng trực tiếp)
              newCategories = List<dynamic>.from(innerData);
              print(
                'Cấu trúc lồng 1 lớp: Tìm thấy ${newCategories.length} danh mục mới',
              );
            }
          } else if (outerData['content'] != null &&
              outerData['content'] is List) {
            // Trường hợp 2: response.data.content (cấu trúc cũ)
            newCategories = List<dynamic>.from(outerData['content']);
            print(
              'Cấu trúc cũ không lồng: Tìm thấy ${newCategories.length} danh mục mới',
            );
          }

          setState(() {
            if (newCategories.length < _pageSize) {
              _hasMoreData = false;
            }
            _categories.addAll(newCategories);
            _currentPage++;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _hasMoreData = false;
          });
          print('Không tìm thấy dữ liệu trong response');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Không thể tải danh mục: ${response['message']}');
        print('API trả về lỗi: ${response['message']}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Lỗi: $e');
      print('Lỗi ngoại lệ khi tải danh mục: $e');
    }
  }

  // Refresh danh sách
  Future<void> _refreshCategories() async {
    setState(() {
      _categories.clear();
      _currentPage = 1;
      _hasMoreData = true;
    });
    await _loadCategories();
  }

  // Tạo danh mục mới
  Future<void> _createCategory(
    String name,
    String description,
    String image, {
    String? parentId,
  }) async {
    try {
      // Tạo dữ liệu request
      final Map<String, dynamic> data = {
        'name': name,
        'description': description,
        'image': image,
      };

      // Thêm parentId nếu được cung cấp
      if (parentId != null && parentId.isNotEmpty) {
        data['parentId'] = parentId;
      }

      final response = await THttpHelper.post(
        'category/categories/create',
        data,
        useToken: true,
      );

      if (response['code'] == 200) {
        _showSnackBar('Thêm danh mục thành công');
        setState(() {
          _isLoading = false;
        });
        _refreshCategories();
      } else {
        _showSnackBar('Không thể tạo danh mục: ${response['message']}');
        setState(() {
          _isLoading = false;
        });
        ;
      }
    } catch (e) {
      _showSnackBar('Lỗi: $e');
    }
  }

  // Cập nhật danh mục
  Future<void> _updateCategory(
    String id,
    String name,
    String description,
    String image, {
    String? parentId,
  }) async {
    try {
      // Tạo dữ liệu request
      final Map<String, dynamic> data = {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
      };

      // Thêm parentId nếu được cung cấp
      if (parentId != null && parentId.isNotEmpty) {
        data['parentId'] = parentId;
      }

      final response = await THttpHelper.put(
        'category/categories/update',
        data,
        useToken: true,
      );

      if (response['code'] == 200) {
        _showSnackBar('Cập nhật danh mục thành công');
        setState(() {
          _isLoading = false;
        });
        _refreshCategories();
      } else {
        _showSnackBar('Không thể cập nhật danh mục: ${response['message']}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showSnackBar('Lỗi: $e');
    }
  }

  // Xóa danh mục
  Future<void> _deleteCategory(String id) async {
    try {
      final response = await THttpHelper.delete(
        'category/categories/delete/$id',
        useToken: true,
      );

      if (response['code'] == 200) {
        _showSnackBar('Xóa danh mục thành công');
        setState(() {
          _isLoading = false;
        });
        _refreshCategories();
      } else {
        _showSnackBar('Không thể xóa danh mục: ${response['message']}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showSnackBar('Lỗi: $e');
    }
  }

  // Upload file
  Future<String> _uploadFile(File file) async {
    try {
      final response = await THttpHelper.uploadMultipartFile(
        'file/media/upload',
        'file',
        file.path,
        useToken: true,
      );

      if (response['code'] == 201 || response['code'] == 200) {
        if (response['data'] != null) {
          // Giả sử URL tải xuống được trả về trong data.downloadUrl
          final String url = response['data']['url'] ?? '';
          return url;
        }
        throw Exception('File upload không trả về URL');
      } else {
        throw Exception('Upload thất bại: ${response['message']}');
      }
    } catch (e) {
      throw Exception('Lỗi upload: $e');
    }
  }

  // Chọn ảnh từ thư viện
  // Future<File?> _pickImage() async {
  //   try {
  //     final ImagePicker picker = ImagePicker();
  //     final XFile? pickedFile = await picker.pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 80,
  //     );

  //     if (pickedFile != null) {
  //       return File(pickedFile.path);
  //     }
  //     return null;
  //   } catch (e) {
  //     _showSnackBar('Không thể chọn ảnh: $e');
  //     return null;
  //   }
  // }

  // Thêm hàm upload cho web
  Future<String> _uploadFileForWeb(Uint8List bytes, String fileName) async {
    try {
      // Tạo FormData để gửi lên server
      final formData = http.MultipartRequest(
        'POST',
        Uri.parse('$url/file/media/upload'),
      );

      // Thêm token
      final token = localStorage.read('ACCESS_TOKEN');
      if (token != null) {
        formData.headers['Authorization'] = 'Bearer $token';
      }

      // Thêm file dưới dạng bytes
      formData.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: fileName),
      );

      // Gửi request
      final response = await formData.send();
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData['data']['url'] ?? '';
      } else {
        throw Exception('Upload thất bại: ${responseData['message']}');
      }
    } catch (e) {
      throw Exception('Lỗi upload: $e');
    }
  }

  // Hiện snackbar thông báo
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Dialog thêm/sửa danh mục
  void _showAddEditCategoryDialog({dynamic category}) {
    final bool isEditing = category != null;
    final nameController = TextEditingController(
      text: isEditing ? category['name'] : '',
    );
    final descriptionController = TextEditingController(
      text: isEditing ? category['description'] : '',
    );
    final imageController = TextEditingController(
      text: isEditing ? category['image'] : '',
    );
    final parentIdController = TextEditingController(
      text: isEditing ? category['parentId'] ?? '' : '',
    );

    File? selectedImageFile;
    Uint8List? webImage;
    bool isUploading = false;

    // Tạo dropdown để chọn danh mục cha
    String? selectedParentId = isEditing ? category['parentId'] : null;

    // Lọc danh mục để loại bỏ danh mục hiện tại (tránh chọn chính nó làm cha)
    List<dynamic> parentOptions =
        _categories
            .where((c) => !isEditing || c['id'] != category['id'])
            .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Widget hiển thị ảnh preview (phần này giữ nguyên)
            Widget imagePreview;
            if (kIsWeb && webImage != null) {
              imagePreview = ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  webImage!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              );
            } else if (!kIsWeb && selectedImageFile != null) {
              imagePreview = ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  selectedImageFile!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              );
            } else if (imageController.text.isNotEmpty) {
              imagePreview = ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageController.text,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.grey,
                      ),
                ),
              );
            } else {
              imagePreview = Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, size: 50, color: Colors.grey),
              );
            }

            return AlertDialog(
              title: Text(
                isEditing ? 'Cập nhật danh mục' : 'Thêm danh mục mới',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tên danh mục
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên danh mục',
                        hintText: 'Nhập tên danh mục',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Mô tả
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả',
                        hintText: 'Nhập mô tả danh mục',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // URL hình ảnh
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: imageController,
                            decoration: const InputDecoration(
                              labelText: 'URL hình ảnh',
                              hintText: 'Nhập URL hình ảnh',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed:
                              isUploading
                                  ? null
                                  : () async {
                                    // Logic để upload ảnh (giữ nguyên)
                                    final picker = ImagePicker();
                                    final pickedFile = await picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 80,
                                    );

                                    if (pickedFile != null) {
                                      setState(() {
                                        isUploading = true;
                                      });

                                      try {
                                        if (kIsWeb) {
                                          final bytes =
                                              await pickedFile.readAsBytes();
                                          webImage = bytes;
                                          final imageUrl =
                                              await _uploadFileForWeb(
                                                bytes,
                                                pickedFile.name,
                                              );
                                          setState(() {
                                            imageController.text = imageUrl;
                                            isUploading = false;
                                          });
                                        } else {
                                          selectedImageFile = File(
                                            pickedFile.path,
                                          );
                                          final imageUrl = await _uploadFile(
                                            selectedImageFile!,
                                          );
                                          setState(() {
                                            imageController.text = imageUrl;
                                            isUploading = false;
                                          });
                                        }
                                      } catch (e) {
                                        setState(() {
                                          isUploading = false;
                                        });
                                        _showSnackBar(
                                          'Không thể tải lên ảnh: $e',
                                        );
                                      }
                                    }
                                  },
                          child:
                              isUploading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text('Chọn'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    imagePreview,
                    const SizedBox(height: 16),

                    // Dropdown chọn danh mục cha
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Danh mục cha',
                        hintText: 'Chọn danh mục cha (nếu có)',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedParentId,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedParentId = newValue;
                          parentIdController.text = newValue ?? '';
                        });
                      },
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Không có danh mục cha'),
                        ),
                        ...parentOptions.map<DropdownMenuItem<String>>((
                          dynamic parent,
                        ) {
                          return DropdownMenuItem<String>(
                            value: parent['id'],
                            child: Text(parent['name'] ?? 'Không có tên'),
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final description = descriptionController.text.trim();
                    final image = imageController.text.trim();
                    final parentId = parentIdController.text.trim();

                    if (name.isEmpty) {
                      _showSnackBar('Tên danh mục không được để trống');
                      return;
                    }

                    Navigator.of(context).pop();
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      if (isEditing) {
                        await _updateCategory(
                          category['id'],
                          name,
                          description,
                          image,
                          parentId: parentId.isNotEmpty ? parentId : null,
                        );
                      } else {
                        await _createCategory(
                          name,
                          description,
                          image,
                          parentId: parentId.isNotEmpty ? parentId : null,
                        );
                      }
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
                      _showSnackBar('Đã xảy ra lỗi: $e');
                    }
                  },
                  child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
                ),
              ],
            );
          },
        );
      },
    );
  } // Dialog thêm/sửa danh mục

  // Dialog xác nhận xóa
  void _confirmDeleteCategory(dynamic category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa danh mục "${category['name']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = true;
                });

                try {
                  await _deleteCategory(category['id']);
                } catch (e) {
                  setState(() {
                    _isLoading = false;
                  });
                  _showSnackBar('Không thể xóa danh mục: $e');
                }
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshCategories,
        child:
            _isLoading && _categories.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _categories.isEmpty
                ? const Center(child: Text('Không có danh mục nào'))
                : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        _hasMoreData &&
                        !_isLoading) {
                      _loadCategories();
                      return true;
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: _categories.length + (_hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _categories.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final category = _categories[index];

                      // Tìm tên danh mục cha (nếu có)
                      String parentName = '';
                      if (category['parentId'] != null &&
                          category['parentId'].toString().isNotEmpty) {
                        final parentCategory = _categories.firstWhere(
                          (c) => c['id'] == category['parentId'],
                          orElse: () => <String, dynamic>{},
                        );
                        parentName =
                            parentCategory.isNotEmpty
                                ? parentCategory['name']
                                : '';
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading:
                              category['image'] != null &&
                                      category['image'].toString().isNotEmpty
                                  ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      category['image'],
                                    ),
                                    onBackgroundImageError:
                                        (_, __) => const Icon(Icons.error),
                                  )
                                  : const CircleAvatar(
                                    child: Icon(Icons.category),
                                  ),
                          title: Text(category['name'] ?? 'Không có tên'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category['description'] ?? 'Không có mô tả',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (parentName.isNotEmpty)
                                Text(
                                  'Danh mục cha: $parentName',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[700],
                                  ),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed:
                                    () => _showAddEditCategoryDialog(
                                      category: category,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed:
                                    () => _confirmDeleteCategory(category),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Hiển thị chi tiết danh mục nếu cần
                            _showCategoryDetails(category);
                          },
                        ),
                      );
                    },
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditCategoryDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Hiển thị chi tiết danh mục
  void _showCategoryDetails(Map<String, dynamic> category) {
    // Tìm tên danh mục cha (nếu có)
    String parentName = '';
    if (category['parentId'] != null &&
        category['parentId'].toString().isNotEmpty) {
      final parentCategory = _categories.firstWhere(
        (c) => c['id'] == category['parentId'],
        orElse: () => <String, dynamic>{},
      );
      parentName = parentCategory.isNotEmpty ? parentCategory['name'] : '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ảnh danh mục
              if (category['image'] != null &&
                  category['image'].toString().isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    category['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),

              // Thông tin danh mục
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['name'] ?? 'Không có tên',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['description'] ?? 'Không có mô tả',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    if (parentName.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text(
                            'Danh mục cha:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            parentName,
                            style: TextStyle(color: Colors.blue[700]),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Nút đóng
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Đóng'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showAddEditCategoryDialog(category: category);
                      },
                      child: const Text('Chỉnh sửa'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
