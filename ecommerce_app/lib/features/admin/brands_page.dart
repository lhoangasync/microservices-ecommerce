import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ecommerce_app/utils/http/http_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({Key? key}) : super(key: key);

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  final localStorage = GetStorage();
  final List<dynamic> _brands = [];
  bool _isLoading = true;
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _isLoading = false;

    _loadBrands();
  }

  Future<void> _loadBrands() async {
    print(
      'Bắt đầu tải thương hiệu: page=$_currentPage, isLoading=$_isLoading, hasMoreData=$_hasMoreData',
    );

    if (!_hasMoreData) {
      print('-> Bỏ qua vì _hasMoreData = $_hasMoreData');
      return;
    }

    if (_isLoading) {
      print('Đang tải rồi, bỏ qua');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Đang gửi request API...');
      final response = await THttpHelper.get(
        'brand/brands/get-all?page=$_currentPage&size=$_pageSize',
        useToken: true,
      );
      print('Nhận response API: ${response['code']}');
      print('Full response: $response');

      if (mounted) {
        setState(() {
          _isLoading = false;

          if (response['code'] == 200) {
            // Truy cập vào data lồng nhau chính xác
            final outerData = response['data'];

            if (outerData != null && outerData['data'] != null) {
              final innerData = outerData['data'];

              if (innerData != null &&
                  innerData['data'] != null &&
                  innerData['data'] is List) {
                final List<dynamic> newBrands = List<dynamic>.from(
                  innerData['data'],
                );
                print('Tìm thấy ${newBrands.length} thương hiệu mới');

                // Cập nhật _hasMoreData dựa trên currentPage và totalPages
                final int totalPages = innerData['totalPages'] ?? 1;
                _hasMoreData = _currentPage < totalPages;

                _brands.addAll(newBrands);
                _currentPage++;
              } else {
                print('Không tìm thấy mảng brands trong response');
                _hasMoreData = false;
              }
            } else {
              print('Không tìm thấy dữ liệu trong response');
              _hasMoreData = false;
            }
          } else {
            print('API trả về lỗi: ${response['message']}');
            _hasMoreData = false;
            _showSnackBar('Không thể tải thương hiệu: ${response['message']}');
          }
        });
      }

      _isLoading = false;

      print(
        'Kết thúc tải thương hiệu: _isLoading=$_isLoading, _hasMoreData=$_hasMoreData, số lượng brands=${_brands.length}',
      );
    } catch (e) {
      print('Lỗi ngoại lệ khi tải thương hiệu: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasMoreData = false;
        });
        _showSnackBar('Lỗi: $e');
      }
    }
  }

  // Refresh danh sách
  Future<void> _refreshBrands() async {
    setState(() {
      _brands.clear();
      _currentPage = 1;
      _hasMoreData = true;
    });
    await _loadBrands();
  }

  // Tạo thương hiệu mới
  Future<void> _createBrand(
    String name,
    String description,
    String image, {
    bool isFeature = false, // Thêm tham số isFeature mặc định là false
  }) async {
    try {
      final response = await THttpHelper.post('brand/brands/create', {
        'name': name,
        'description': description,
        'image': image,
        'isFeature': isFeature, // Thêm trường isFeature
      }, useToken: true);

      if (response['code'] == 201) {
        _showSnackBar('Thêm thương hiệu thành công');
        _refreshBrands();
      } else {
        _showSnackBar('Không thể tạo thương hiệu: ${response['message']}');
      }
    } catch (e) {
      _showSnackBar('Lỗi: $e');
    }
  }

  Future<void> _updateBrand(
    String id,
    String name,
    String description,
    String image, {
    bool? isFeature, // Thêm tham số isFeature optional
  }) async {
    try {
      final Map<String, dynamic> data = {
        'id': id,
        'name': name,
        'description': description,
        'image': image,
      };

      // Chỉ thêm isFeature nếu được cung cấp
      if (isFeature != null) {
        data['isFeature'] = isFeature;
      }

      final response = await THttpHelper.put(
        'brand/brands/update',
        data,
        useToken: true,
      );

      _isLoading = false;

      if (response['code'] == 200) {
        _showSnackBar('Cập nhật thương hiệu thành công');
        _refreshBrands();
      } else {
        _showSnackBar('Không thể cập nhật thương hiệu: ${response['message']}');
      }
    } catch (e) {
      _showSnackBar('Lỗi: $e');
    }
  }

  // Xóa thương hiệu
  Future<void> _deleteBrand(String id) async {
    try {
      final response = await THttpHelper.delete(
        'brand/brands/delete/$id',
        useToken: true,
      );

      if (response['code'] == 200) {
        _showSnackBar('Xóa thương hiệu thành công');
        _refreshBrands();
      } else {
        _showSnackBar('Không thể xóa thương hiệu: ${response['message']}');
      }
      _isLoading = false;
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

  // Upload file cho web
  Future<String> _uploadFileForWeb(Uint8List bytes, String fileName) async {
    try {
      const baseUrl = 'http://192.168.0.117:8888/api/v1';

      final formData = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/file/media/upload'),
      );

      final token = localStorage.read('ACCESS_TOKEN');
      if (token != null) {
        formData.headers['Authorization'] = 'Bearer $token';
      }

      formData.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: fileName),
      );

      final response = await formData.send();
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['data'] != null) {
          return responseData['data']['url'] ?? '';
        }
        return '';
      } else {
        throw Exception('Upload thất bại: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi upload: $e');
    }
  }

  // Chọn ảnh từ thư viện
  Future<Map<String, dynamic>> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          return {'bytes': bytes, 'name': pickedFile.name, 'path': null};
        } else {
          return {'bytes': null, 'name': null, 'path': pickedFile.path};
        }
      }
      return {};
    } catch (e) {
      _showSnackBar('Không thể chọn ảnh: $e');
      return {};
    }
  }

  // Hiện snackbar thông báo
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Dialog thêm/sửa thương hiệu
  void _showAddEditBrandDialog({Map<String, dynamic>? brand}) {
    final bool isEditing = brand != null;
    final nameController = TextEditingController(
      text: isEditing ? brand['name'] : '',
    );
    final descriptionController = TextEditingController(
      text: isEditing ? brand['description'] : '',
    );
    final imageController = TextEditingController(
      text: isEditing ? brand['image'] : '',
    );
    bool isFeature =
        isEditing
            ? (brand['isFeature'] ?? false)
            : false; // Khởi tạo giá trị isFeature

    Widget imagePreview = const SizedBox.shrink();
    bool isUploading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Cập nhật preview ảnh (phần code này giữ nguyên)
            if (imageController.text.isNotEmpty) {
              imagePreview = ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageController.text,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        height: 120,
                        width: 120,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                ),
              );
            } else {
              imagePreview = Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, size: 50, color: Colors.grey),
              );
            }

            return AlertDialog(
              title: Text(
                isEditing ? 'Cập nhật thương hiệu' : 'Thêm thương hiệu mới',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tên thương hiệu
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên thương hiệu',
                        hintText: 'Nhập tên thương hiệu',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Mô tả
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả',
                        hintText: 'Nhập mô tả thương hiệu',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Ảnh (phần code này giữ nguyên)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: imageController,
                            decoration: const InputDecoration(
                              labelText: 'URL hình ảnh',
                              hintText: 'Nhập URL hình ảnh',
                            ),
                            onChanged: (_) {
                              setState(() {
                                // Cập nhật preview khi URL thay đổi
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed:
                              isUploading
                                  ? null
                                  : () async {
                                    // Logic để upload ảnh (giữ nguyên)
                                    final imageData = await _pickImage();
                                    if (imageData.isNotEmpty) {
                                      setState(() {
                                        isUploading = true;
                                      });

                                      try {
                                        String imageUrl;
                                        if (kIsWeb &&
                                            imageData['bytes'] != null) {
                                          imageUrl = await _uploadFileForWeb(
                                            imageData['bytes'],
                                            imageData['name'],
                                          );
                                        } else if (!kIsWeb &&
                                            imageData['path'] != null) {
                                          imageUrl = await _uploadFile(
                                            File(imageData['path']),
                                          );
                                        } else {
                                          throw Exception('Không thể tải ảnh');
                                        }

                                        setState(() {
                                          imageController.text = imageUrl;
                                          isUploading = false;
                                        });
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

                    // Thêm checkbox cho isFeature
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: isFeature,
                          onChanged: (value) {
                            setState(() {
                              isFeature = value ?? false;
                            });
                          },
                        ),
                        const Text('Đặt làm thương hiệu nổi bật'),
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

                    if (name.isEmpty) {
                      _showSnackBar('Tên thương hiệu không được để trống');
                      return;
                    }

                    Navigator.of(context).pop();
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      if (isEditing) {
                        await _updateBrand(
                          brand['id'],
                          name,
                          description,
                          image,
                          isFeature: isFeature, // Truyền giá trị isFeature
                        );
                      } else {
                        await _createBrand(
                          name,
                          description,
                          image,
                          isFeature: isFeature, // Truyền giá trị isFeature
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
  }

  // Dialog xác nhận xóa
  void _confirmDeleteBrand(Map<String, dynamic> brand) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa thương hiệu "${brand['name']}"?',
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
                  await _deleteBrand(brand['id']);
                } catch (e) {
                  setState(() {
                    _isLoading = false;
                  });
                  _showSnackBar('Không thể xóa thương hiệu: $e');
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
        onRefresh: _refreshBrands,
        child:
            _isLoading && _brands.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _brands.isEmpty
                ? const Center(child: Text('Không có thương hiệu nào'))
                : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        _hasMoreData &&
                        !_isLoading) {
                      _loadBrands();
                      return true;
                    }
                    return false;
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: _brands.length + (_hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _brands.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final brand = _brands[index];
                      return _buildBrandCard(brand);
                    },
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditBrandDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Card hiển thị thương hiệu
  Widget _buildBrandCard(Map<String, dynamic> brand) {
    // Lấy giá trị isFeature từ brand, mặc định là false nếu không có
    final bool isFeature = brand['isFeature'] ?? false;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // Nếu là thương hiệu nổi bật, thêm border màu hoặc đổi màu nền
      color: isFeature ? Colors.amber.shade50 : null,
      child: InkWell(
        onTap: () => _showBrandDetails(brand),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ảnh thương hiệu
            Stack(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child:
                        brand['image'] != null &&
                                brand['image'].toString().isNotEmpty
                            ? Image.network(
                              brand['image'],
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                            )
                            : Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.business,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                  ),
                ),

                // Hiển thị badge "Nổi bật" nếu isFeature = true
                if (isFeature)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Nổi bật',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Tên thương hiệu
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          brand['name'] ?? 'Không có tên',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Thêm icon star nếu là thương hiệu nổi bật
                      if (isFeature)
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    brand['description'] ?? 'Không có mô tả',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Các nút thao tác
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                    onPressed: () => _showAddEditBrandDialog(brand: brand),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () => _confirmDeleteBrand(brand),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hiển thị chi tiết thương hiệu
  void _showBrandDetails(Map<String, dynamic> brand) {
    final bool isFeature = brand['isFeature'] ?? false;

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
              // Ảnh thương hiệu
              if (brand['image'] != null &&
                  brand['image'].toString().isNotEmpty)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        brand['image'],
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

                    // Hiển thị badge "Nổi bật" nếu isFeature = true
                    if (isFeature)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Nổi bật',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

              // Thông tin thương hiệu
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            brand['name'] ?? 'Không có tên',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isFeature)
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      brand['description'] ?? 'Không có mô tả',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    // Thêm dòng hiển thị trạng thái nổi bật
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Trạng thái:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isFeature
                              ? 'Thương hiệu nổi bật'
                              : 'Thương hiệu thường',
                          style: TextStyle(
                            color: isFeature ? Colors.amber : Colors.grey[600],
                            fontWeight:
                                isFeature ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
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
                        _showAddEditBrandDialog(brand: brand);
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
