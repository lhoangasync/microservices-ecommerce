import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ecommerce_app/utils/http/http_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final localStorage = GetStorage();
  final List<dynamic> _products = [];
  late List<dynamic> _categories = [];
  late List<dynamic> _brands = [];
  bool _isLoading = true;
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMoreData = true;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCategories();
    _loadBrands();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load danh sách sản phẩm
  Future<void> _loadProducts() async {
    if (!_hasMoreData || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await THttpHelper.get(
        'product/products/get-all?page=$_currentPage&size=$_pageSize',
        useToken: true,
      );

      if (response['code'] == 200) {
        final responseData = response['data'];
        if (responseData['data'] != null &&
            responseData['data']['content'] != null) {
          final List<dynamic> newProducts = responseData['data']['content'];

          setState(() {
            if (newProducts.length < _pageSize) {
              _hasMoreData = false;
            }
            _products.addAll(newProducts);
            _currentPage++;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _hasMoreData = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Không thể tải sản phẩm: ${response['message']}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Lỗi: $e');
    }
  }

  // Load danh sách danh mục
  Future<void> _loadCategories() async {
    try {
      final response = await THttpHelper.get(
        'category/categories/get-all?page=1&size=100',
        useToken: true,
      );

      if (response['code'] == 200) {
        final responseData = response['data'];
        if (responseData['data'] != null &&
            responseData['data']['content'] != null) {
          setState(() {
            _categories = responseData['data']['content'];
          });
        }
      }
    } catch (e) {
      _showSnackBar('Không thể tải danh mục: $e');
    }
  }

  // Load danh sách thương hiệu
  Future<void> _loadBrands() async {
    try {
      final response = await THttpHelper.get(
        'brand/brands/get-all?page=1&size=100',
        useToken: true,
      );

      if (response['code'] == 200) {
        final responseData = response['data'];
        if (responseData['data'] != null &&
            responseData['data']['content'] != null) {
          setState(() {
            _brands = responseData['data']['content'];
          });
        }
      }
    } catch (e) {
      _showSnackBar('Không thể tải thương hiệu: $e');
    }
  }

  // Refresh danh sách
  Future<void> _refreshProducts() async {
    setState(() {
      _products.clear();
      _currentPage = 1;
      _hasMoreData = true;
    });
    await _loadProducts();
  }

  // Tạo sản phẩm mới
  Future<void> _createProduct(Map<String, dynamic> productData) async {
    try {
      // Đảm bảo rằng cấu trúc của productData khớp với ProductRequest

      // Nếu variants không có trường attributeVariant, thêm mảng rỗng
      if (productData['variants'] != null) {
        for (var variant in productData['variants']) {
          if (variant['attributeVariant'] == null) {
            variant['attributeVariant'] = [];
          }
        }
      }

      // Nếu không có attributes, thêm mảng rỗng
      if (productData['attributes'] == null) {
        productData['attributes'] = [];
      }

      // Đảm bảo trường thumbnail có giá trị nếu cần
      if (productData['thumbnail'] == null &&
          productData['image'] != null &&
          productData['image'].isNotEmpty) {
        productData['thumbnail'] = productData['image'][0];
      }

      print('Dữ liệu sản phẩm gửi lên: $productData');

      final response = await THttpHelper.post(
        'product/products/create',
        productData,
        useToken: true,
      );

      if (response['code'] == 201) {
        _showSnackBar('Thêm sản phẩm thành công');
        _refreshProducts();
      } else {
        _showSnackBar('Không thể tạo sản phẩm: ${response['message']}');
      }
    } catch (e) {
      _showSnackBar('Lỗi: $e');
    }
  }

  // Cập nhật sản phẩm
  Future<void> _updateProduct(Map<String, dynamic> productData) async {
    try {
      // Đảm bảo rằng cấu trúc của productData khớp với ProductUpdateRequest

      // Nếu variants không có trường attributeVariant, thêm mảng rỗng
      if (productData['variants'] != null) {
        for (var variant in productData['variants']) {
          if (variant['attributeVariant'] == null) {
            variant['attributeVariant'] = [];
          }
        }
      }

      // Nếu không có attributes, thêm mảng rỗng
      if (productData['attributes'] == null) {
        productData['attributes'] = [];
      }

      // Đảm bảo trường thumbnail có giá trị nếu cần
      if (productData['thumbnail'] == null &&
          productData['image'] != null &&
          productData['image'].isNotEmpty) {
        productData['thumbnail'] = productData['image'][0];
      }

      print('Dữ liệu sản phẩm cập nhật: $productData');

      final response = await THttpHelper.put(
        'product/products/update',
        productData,
        useToken: true,
      );

      if (response['code'] == 200) {
        _showSnackBar('Cập nhật sản phẩm thành công');
        _refreshProducts();
      } else {
        _showSnackBar('Không thể cập nhật sản phẩm: ${response['message']}');
      }
    } catch (e) {
      _showSnackBar('Lỗi: $e');
    }
  }

  // Xóa sản phẩm
  Future<void> _deleteProduct(String id) async {
    try {
      final response = await THttpHelper.delete(
        'product/products/delete/$id',
        useToken: true,
      );

      if (response['code'] == 200) {
        _showSnackBar('Xóa sản phẩm thành công');
        _refreshProducts();
      } else {
        _showSnackBar('Không thể xóa sản phẩm: ${response['message']}');
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
      const baseUrl =
          'http://192.168.0.117:8888/api/v1'; // URL cần điều chỉnh theo THttpHelper

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

  // Dialog thêm/sửa sản phẩm
  void _showAddEditProductDialog({Map<String, dynamic>? product}) {
    final bool isEditing = product != null;

    // Controllers
    final nameController = TextEditingController(
      text: isEditing ? product['name'] : '',
    );
    final descriptionController = TextEditingController(
      text: isEditing ? product['description'] : '',
    );
    final priceController = TextEditingController(
      text:
          isEditing && product['price'] != null
              ? product['price'].toString()
              : '',
    );
    final salePriceController = TextEditingController(
      text:
          isEditing && product['salePrice'] != null
              ? product['salePrice'].toString()
              : '',
    );

    // Selected values
    String? selectedCategoryId = isEditing ? product['categoryId'] : null;
    String? selectedBrandId = isEditing ? product['brandId'] : null;
    String selectedStatus =
        isEditing ? (product['status'] ?? 'ACTIVE') : 'ACTIVE';

    // Images and thumbnail
    List<String> productImages =
        isEditing ? List<String>.from(product['image'] ?? []) : [];
    String? thumbnailUrl = isEditing ? product['thumbnail'] : null;

    // Variants
    List<Map<String, dynamic>> variants = [];
    if (isEditing && product['variants'] != null) {
      variants = List<Map<String, dynamic>>.from(
        product['variants'].map(
          (v) => {
            'variantId': v['variantId'],
            'variantName': v['variantName'],
            'price': v['price'],
            'salePrice': v['salePrice'],
            'quantity': v['quantity'],
            'stockStatus': v['stockStatus'] ?? 'IN_STOCK',
            'image': v['image'],
          },
        ),
      );
    }
    if (variants.isEmpty) {
      variants.add({
        'variantId': null,
        'variantName': '',
        'price': 0.0,
        'salePrice': null,
        'quantity': 0,
        'stockStatus': 'IN_STOCK',
        'image': null,
      });
    }

    // Uploading state
    bool isUploading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 800,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      isEditing ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm mới',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Hủy',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final name = nameController.text.trim();
                          final description = descriptionController.text.trim();
                          final price =
                              double.tryParse(priceController.text.trim()) ??
                              0.0;
                          final salePrice =
                              salePriceController.text.trim().isNotEmpty
                                  ? double.tryParse(
                                    salePriceController.text.trim(),
                                  )
                                  : null;

                          if (name.isEmpty) {
                            _showSnackBar('Tên sản phẩm không được để trống');
                            return;
                          }

                          if (selectedCategoryId == null) {
                            _showSnackBar('Vui lòng chọn danh mục');
                            return;
                          }

                          if (selectedBrandId == null) {
                            _showSnackBar('Vui lòng chọn thương hiệu');
                            return;
                          }

                          if (productImages.isEmpty) {
                            _showSnackBar('Vui lòng thêm ít nhất một hình ảnh');
                            return;
                          }

                          if (variants.isEmpty ||
                              variants[0]['variantName'].isEmpty) {
                            _showSnackBar('Vui lòng thêm ít nhất một biến thể');
                            return;
                          }

                          // Chuẩn bị dữ liệu
                          final Map<String, dynamic> productData = {
                            'name': name,
                            'description': description,
                            'price': price,
                            'salePrice': salePrice,
                            'image': productImages,
                            'thumbnail':
                                thumbnailUrl ??
                                (productImages.isNotEmpty
                                    ? productImages[0]
                                    : null),
                            'categoryId': selectedCategoryId,
                            'brandId': selectedBrandId,
                            'status': selectedStatus,
                            'variants': variants,
                          };

                          if (isEditing) {
                            productData['id'] = product['id'];
                          }

                          Navigator.of(context).pop();
                          this.setState(() {
                            _isLoading = true;
                          });

                          try {
                            if (isEditing) {
                              await _updateProduct(productData);
                            } else {
                              await _createProduct(productData);
                            }
                          } catch (e) {
                            this.setState(() {
                              _isLoading = false;
                            });
                            _showSnackBar('Đã xảy ra lỗi: $e');
                          }
                        },
                        child: Text(
                          isEditing ? 'Cập nhật' : 'Thêm',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  body: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thông tin cơ bản
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Thông tin cơ bản',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Tên sản phẩm
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Tên sản phẩm',
                                    hintText: 'Nhập tên sản phẩm',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Mô tả
                                TextField(
                                  controller: descriptionController,
                                  decoration: InputDecoration(
                                    labelText: 'Mô tả',
                                    hintText: 'Nhập mô tả sản phẩm',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                ),
                                SizedBox(height: 16),

                                // Giá gốc và giá khuyến mãi
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: priceController,
                                        decoration: InputDecoration(
                                          labelText: 'Giá gốc',
                                          hintText: 'Nhập giá gốc',
                                          border: OutlineInputBorder(),
                                          prefixText: 'VND ',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: TextField(
                                        controller: salePriceController,
                                        decoration: InputDecoration(
                                          labelText: 'Giá khuyến mãi',
                                          hintText:
                                              'Nhập giá khuyến mãi (nếu có)',
                                          border: OutlineInputBorder(),
                                          prefixText: 'VND ',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),

                                // Danh mục và thương hiệu
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Danh mục',
                                          border: OutlineInputBorder(),
                                        ),
                                        value: selectedCategoryId,
                                        hint: Text('Chọn danh mục'),
                                        items:
                                            _categories.map<
                                              DropdownMenuItem<String>
                                            >((category) {
                                              return DropdownMenuItem<String>(
                                                value: category['id'],
                                                child: Text(category['name']),
                                              );
                                            }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedCategoryId = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Thương hiệu',
                                          border: OutlineInputBorder(),
                                        ),
                                        value: selectedBrandId,
                                        hint: Text('Chọn thương hiệu'),
                                        items:
                                            _brands.map<
                                              DropdownMenuItem<String>
                                            >((brand) {
                                              return DropdownMenuItem<String>(
                                                value: brand['id'],
                                                child: Text(brand['name']),
                                              );
                                            }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedBrandId = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),

                                // Trạng thái
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Trạng thái',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedStatus,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'ACTIVE',
                                      child: Text('Kích hoạt'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'INACTIVE',
                                      child: Text('Vô hiệu hóa'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedStatus = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Hình ảnh và Thumbnail
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hình ảnh sản phẩm',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Hình đầu tiên sẽ được sử dụng làm thumbnail nếu không chọn ảnh đại diện riêng',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Hiển thị thumbnail
                                if (thumbnailUrl != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ảnh đại diện (Thumbnail)',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Stack(
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.blue,
                                                width: 2,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                thumbnailUrl!,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (_, __, ___) => Container(
                                                      width: 120,
                                                      height: 120,
                                                      color: Colors.grey[300],
                                                      child: Icon(
                                                        Icons.broken_image,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  thumbnailUrl = null;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  ),

                                Text(
                                  'Tất cả hình ảnh',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    ...productImages
                                        .map(
                                          (url) => Stack(
                                            children: [
                                              Container(
                                                width: 120,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color:
                                                        thumbnailUrl == url
                                                            ? Colors.blue
                                                            : Colors.grey,
                                                    width:
                                                        thumbnailUrl == url
                                                            ? 2
                                                            : 1,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                    url,
                                                    width: 120,
                                                    height: 120,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          _,
                                                          __,
                                                          ___,
                                                        ) => Container(
                                                          width: 120,
                                                          height: 120,
                                                          color:
                                                              Colors.grey[300],
                                                          child: Icon(
                                                            Icons.broken_image,
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              // Button to set as thumbnail
                                              if (thumbnailUrl != url)
                                                Positioned(
                                                  left: 0,
                                                  top: 0,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        thumbnailUrl = url;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                        4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.star,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              // Button to delete image
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      productImages.remove(url);
                                                      if (thumbnailUrl == url) {
                                                        thumbnailUrl =
                                                            productImages
                                                                    .isNotEmpty
                                                                ? productImages[0]
                                                                : null;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                    InkWell(
                                      onTap:
                                          isUploading
                                              ? null
                                              : () async {
                                                final imageData =
                                                    await _pickImage();
                                                if (imageData.isNotEmpty) {
                                                  setState(() {
                                                    isUploading = true;
                                                  });

                                                  try {
                                                    String imageUrl;
                                                    if (kIsWeb &&
                                                        imageData['bytes'] !=
                                                            null) {
                                                      imageUrl =
                                                          await _uploadFileForWeb(
                                                            imageData['bytes'],
                                                            imageData['name'],
                                                          );
                                                    } else if (!kIsWeb &&
                                                        imageData['path'] !=
                                                            null) {
                                                      imageUrl =
                                                          await _uploadFile(
                                                            File(
                                                              imageData['path'],
                                                            ),
                                                          );
                                                    } else {
                                                      throw Exception(
                                                        'Không thể tải ảnh',
                                                      );
                                                    }

                                                    setState(() {
                                                      productImages.add(
                                                        imageUrl,
                                                      );
                                                      if (thumbnailUrl ==
                                                          null) {
                                                        thumbnailUrl = imageUrl;
                                                      }
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
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        child:
                                            isUploading
                                                ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                                : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.add_photo_alternate,
                                                      size: 40,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'Thêm ảnh',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Biến thể
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Biến thể sản phẩm',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.add),
                                      label: Text('Thêm biến thể'),
                                      onPressed: () {
                                        setState(() {
                                          variants.add({
                                            'variantId': null,
                                            'variantName': '',
                                            'price': 0.0,
                                            'salePrice': null,
                                            'quantity': 0,
                                            'stockStatus': 'IN_STOCK',
                                            'image': null,
                                          });
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),

                                // Danh sách biến thể
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: variants.length,
                                  itemBuilder: (context, index) {
                                    final variant = variants[index];
                                    final variantNameController =
                                        TextEditingController(
                                          text: variant['variantName'],
                                        );
                                    final priceController =
                                        TextEditingController(
                                          text: variant['price'].toString(),
                                        );
                                    final salePriceController =
                                        TextEditingController(
                                          text:
                                              variant['salePrice'] != null
                                                  ? variant['salePrice']
                                                      .toString()
                                                  : '',
                                        );
                                    final quantityController =
                                        TextEditingController(
                                          text: variant['quantity'].toString(),
                                        );

                                    return Card(
                                      margin: EdgeInsets.only(bottom: 16),
                                      elevation: 2,
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Biến thể #${index + 1}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                if (variants.length > 1)
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        variants.removeAt(
                                                          index,
                                                        );
                                                      });
                                                    },
                                                  ),
                                              ],
                                            ),
                                            SizedBox(height: 16),

                                            // Tên biến thể
                                            TextField(
                                              controller: variantNameController,
                                              decoration: InputDecoration(
                                                labelText: 'Tên biến thể',
                                                hintText:
                                                    'Ví dụ: 8GB RAM + 128GB',
                                                border: OutlineInputBorder(),
                                              ),
                                              onChanged: (value) {
                                                variants[index]['variantName'] =
                                                    value;
                                              },
                                            ),
                                            SizedBox(height: 16),

                                            // Giá và Giá khuyến mãi
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller: priceController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Giá gốc',
                                                      hintText: 'Nhập giá',
                                                      border:
                                                          OutlineInputBorder(),
                                                      prefixText: 'VND ',
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onChanged: (value) {
                                                      variants[index]['price'] =
                                                          double.tryParse(
                                                            value,
                                                          ) ??
                                                          0.0;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        salePriceController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Giá khuyến mãi',
                                                      hintText:
                                                          'Nhập giá KM (nếu có)',
                                                      border:
                                                          OutlineInputBorder(),
                                                      prefixText: 'VND ',
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onChanged: (value) {
                                                      variants[index]['salePrice'] =
                                                          value.isEmpty
                                                              ? null
                                                              : double.tryParse(
                                                                value,
                                                              );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 16),

                                            // Số lượng
                                            TextField(
                                              controller: quantityController,
                                              decoration: InputDecoration(
                                                labelText: 'Số lượng',
                                                hintText: 'Nhập số lượng',
                                                border: OutlineInputBorder(),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                variants[index]['quantity'] =
                                                    int.tryParse(value) ?? 0;
                                              },
                                            ),
                                            SizedBox(height: 16),

                                            // Trạng thái kho
                                            DropdownButtonFormField<String>(
                                              decoration: InputDecoration(
                                                labelText: 'Trạng thái kho',
                                                border: OutlineInputBorder(),
                                              ),
                                              value: variant['stockStatus'],
                                              items: const [
                                                DropdownMenuItem(
                                                  value: 'IN_STOCK',
                                                  child: Text('Còn hàng'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'OUT_OF_STOCK',
                                                  child: Text('Hết hàng'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'PRE_ORDER',
                                                  child: Text('Đặt trước'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'DISCONTINUED',
                                                  child: Text(
                                                    'Ngừng kinh doanh',
                                                  ),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  variants[index]['stockStatus'] =
                                                      value!;
                                                });
                                              },
                                            ),

                                            // Thêm phần để chọn hình ảnh cho variant (tùy chọn)
                                            SizedBox(height: 16),
                                            Text(
                                              'Hình ảnh riêng cho biến thể (tùy chọn)',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                if (variant['image'] != null)
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        width: 80,
                                                        height: 80,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          child: Image.network(
                                                            variant['image'],
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (
                                                                  _,
                                                                  __,
                                                                  ___,
                                                                ) => Container(
                                                                  color:
                                                                      Colors
                                                                          .grey[300],
                                                                  child: Icon(
                                                                    Icons
                                                                        .broken_image,
                                                                  ),
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: 0,
                                                        top: 0,
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              variants[index]['image'] =
                                                                  null;
                                                            });
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                  4,
                                                                ),
                                                            decoration:
                                                                BoxDecoration(
                                                                  color:
                                                                      Colors
                                                                          .red,
                                                                  shape:
                                                                      BoxShape
                                                                          .circle,
                                                                ),
                                                            child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                              size: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                SizedBox(width: 8),
                                                ElevatedButton.icon(
                                                  icon: Icon(
                                                    Icons.add_photo_alternate,
                                                    size: 16,
                                                  ),
                                                  label: Text(
                                                    variant['image'] != null
                                                        ? 'Thay đổi ảnh'
                                                        : 'Thêm ảnh',
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 8,
                                                            ),
                                                      ),
                                                  onPressed: () async {
                                                    final imageData =
                                                        await _pickImage();
                                                    if (imageData.isNotEmpty) {
                                                      setState(() {
                                                        isUploading = true;
                                                      });

                                                      try {
                                                        String imageUrl;
                                                        if (kIsWeb &&
                                                            imageData['bytes'] !=
                                                                null) {
                                                          imageUrl =
                                                              await _uploadFileForWeb(
                                                                imageData['bytes'],
                                                                imageData['name'],
                                                              );
                                                        } else if (!kIsWeb &&
                                                            imageData['path'] !=
                                                                null) {
                                                          imageUrl =
                                                              await _uploadFile(
                                                                File(
                                                                  imageData['path'],
                                                                ),
                                                              );
                                                        } else {
                                                          throw Exception(
                                                            'Không thể tải ảnh',
                                                          );
                                                        }

                                                        setState(() {
                                                          variants[index]['image'] =
                                                              imageUrl;
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
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Dialog xác nhận xóa
  void _confirmDeleteProduct(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa sản phẩm "${product['name']}"?',
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
                  await _deleteProduct(product['id']);
                } catch (e) {
                  setState(() {
                    _isLoading = false;
                  });
                  _showSnackBar('Không thể xóa sản phẩm: $e');
                }
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Hiển thị chi tiết sản phẩm
  void _showProductDetails(Map<String, dynamic> product) {
    final List<dynamic> images = product['image'] ?? [];
    final String? thumbnail = product['thumbnail'];
    final String categoryName = _getCategoryName(product['categoryId']);
    final String brandName = _getBrandName(product['brandId']);
    final bool hasVariants =
        product['variants'] != null && product['variants'].isNotEmpty;
    final double price =
        product['price'] != null
            ? double.tryParse(product['price'].toString()) ?? 0.0
            : 0.0;
    final double? salePrice =
        product['salePrice'] != null
            ? double.tryParse(product['salePrice'].toString())
            : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 800,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị hình ảnh chính (thumbnail hoặc ảnh đầu tiên)
                  if (thumbnail != null || images.isNotEmpty)
                    Container(
                      height: 300,
                      child: PageView.builder(
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          final imageUrl =
                              index == 0 && thumbnail != null
                                  ? thumbnail
                                  : images[index];
                          return Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                  ),
                                ),
                          );
                        },
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên sản phẩm
                        Text(
                          product['name'] ?? 'Không có tên',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Giá và giá khuyến mãi
                        if (price > 0 || salePrice != null)
                          Row(
                            children: [
                              if (salePrice != null) ...[
                                Text(
                                  _formatPrice(salePrice),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  _formatPrice(price),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ] else
                                Text(
                                  _formatPrice(price),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),

                        const SizedBox(height: 16),

                        // Trạng thái
                        _statusBadge(product['status'] ?? 'ACTIVE'),
                        const SizedBox(height: 16),

                        // Thông tin cơ bản
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Thông tin cơ bản',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _infoItem(
                                        'Danh mục',
                                        categoryName,
                                      ),
                                    ),
                                    Expanded(
                                      child: _infoItem(
                                        'Thương hiệu',
                                        brandName,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Mô tả:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product['description'] ?? 'Không có mô tả',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tất cả hình ảnh (bao gồm thumbnail)
                        if (images.isNotEmpty)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tất cả hình ảnh',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      // Hiển thị thumbnail đầu tiên nếu có
                                      if (thumbnail != null)
                                        Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.blue,
                                              width: 2,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Stack(
                                              children: [
                                                Image.network(
                                                  thumbnail,
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (_, __, ___) => Container(
                                                        color: Colors.grey[300],
                                                        child: Icon(
                                                          Icons.broken_image,
                                                        ),
                                                      ),
                                                ),
                                                Positioned(
                                                  left: 0,
                                                  top: 0,
                                                  child: Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ...images
                                          .where((url) => url != thumbnail)
                                          .map(
                                            (url) => Container(
                                              width: 120,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  url,
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (_, __, ___) => Container(
                                                        width: 120,
                                                        height: 120,
                                                        color: Colors.grey[300],
                                                        child: Icon(
                                                          Icons.broken_image,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),

                        // Biến thể
                        if (hasVariants)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Biến thể sản phẩm',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columnSpacing: 20,
                                      columns: const [
                                        DataColumn(label: Text('Tên biến thể')),
                                        DataColumn(label: Text('Giá gốc')),
                                        DataColumn(label: Text('Giá KM')),
                                        DataColumn(label: Text('Số lượng')),
                                        DataColumn(label: Text('Trạng thái')),
                                        DataColumn(label: Text('Hình ảnh')),
                                      ],
                                      rows:
                                          product['variants'].map<DataRow>((
                                            variant,
                                          ) {
                                            return DataRow(
                                              cells: [
                                                DataCell(
                                                  Text(
                                                    variant['variantName'] ??
                                                        '',
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    _formatPrice(
                                                      variant['price'] ?? 0,
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  variant['salePrice'] != null
                                                      ? Text(
                                                        _formatPrice(
                                                          variant['salePrice'],
                                                        ),
                                                      )
                                                      : Text('-'),
                                                ),
                                                DataCell(
                                                  Text(
                                                    '${variant['quantity'] ?? 0}',
                                                  ),
                                                ),
                                                DataCell(
                                                  _stockStatusBadge(
                                                    variant['stockStatus'] ??
                                                        'IN_STOCK',
                                                  ),
                                                ),
                                                DataCell(
                                                  variant['image'] != null
                                                      ? Container(
                                                        width: 40,
                                                        height: 40,
                                                        child: Image.network(
                                                          variant['image'],
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (
                                                                _,
                                                                __,
                                                                ___,
                                                              ) => Icon(
                                                                Icons
                                                                    .broken_image,
                                                                size: 24,
                                                              ),
                                                        ),
                                                      )
                                                      : Text('-'),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Nút thao tác
                  Padding(
                    padding: const EdgeInsets.all(16),
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
                            _showAddEditProductDialog(product: product);
                          },
                          child: const Text('Chỉnh sửa'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Hiển thị một mục thông tin
  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // Hiển thị trạng thái sản phẩm
  Widget _statusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'ACTIVE':
        color = Colors.green;
        label = 'Kích hoạt';
        break;
      case 'INACTIVE':
        color = Colors.grey;
        label = 'Vô hiệu hóa';
        break;
      default:
        color = Colors.blue;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Hiển thị trạng thái tồn kho
  Widget _stockStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'IN_STOCK':
        color = Colors.green;
        label = 'Còn hàng';
        break;
      case 'OUT_OF_STOCK':
        color = Colors.red;
        label = 'Hết hàng';
        break;
      case 'PRE_ORDER':
        color = Colors.orange;
        label = 'Đặt trước';
        break;
      case 'DISCONTINUED':
        color = Colors.grey;
        label = 'Ngừng kinh doanh';
        break;
      default:
        color = Colors.blue;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Lấy tên danh mục từ ID
  String _getCategoryName(String? categoryId) {
    if (categoryId == null) return 'Không xác định';

    final category = _categories.firstWhere(
      (c) => c['id'] == categoryId,
      orElse: () => null,
    );

    return category != null ? category['name'] : 'Không xác định';
  }

  // Lấy tên thương hiệu từ ID
  String _getBrandName(String? brandId) {
    if (brandId == null) return 'Không xác định';

    final brand = _brands.firstWhere(
      (b) => b['id'] == brandId,
      orElse: () => null,
    );

    return brand != null ? brand['name'] : 'Không xác định';
  }

  // Định dạng giá tiền
  String _formatPrice(dynamic price) {
    if (price == null) return '0 VND';

    // Chuyển đổi về double nếu cần
    final double amount =
        price is double ? price : double.tryParse('$price') ?? 0;

    // Định dạng số với dấu phân cách hàng nghìn
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} VND';
  }

  // Lấy giá thấp nhất từ danh sách biến thể
  double _getLowestPrice(List<dynamic> variants) {
    if (variants.isEmpty) return 0;

    double? lowestPrice;

    for (var variant in variants) {
      // Ưu tiên giá khuyến mãi nếu có
      final priceToUse =
          variant['salePrice'] != null
              ? variant['salePrice']
              : variant['price'] ?? 0;
      final double priceValue =
          priceToUse is double
              ? priceToUse
              : double.tryParse('$priceToUse') ?? 0;

      if (lowestPrice == null || priceValue < lowestPrice) {
        lowestPrice = priceValue;
      }
    }

    return lowestPrice ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    // Lọc sản phẩm theo từ khóa tìm kiếm
    final filteredProducts =
        _searchQuery.isEmpty
            ? _products
            : _products.where((product) {
              final name = product['name']?.toString().toLowerCase() ?? '';
              final description =
                  product['description']?.toString().toLowerCase() ?? '';
              final query = _searchQuery.toLowerCase();
              return name.contains(query) || description.contains(query);
            }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sản phẩm'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600]),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm sản phẩm',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Hiển thị số lượng sản phẩm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hiển thị ${filteredProducts.length} sản phẩm',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                // Dropdown sắp xếp (có thể bổ sung sau)
              ],
            ),
          ),

          // Danh sách sản phẩm
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshProducts,
              child:
                  _isLoading && _products.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : filteredProducts.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'Không tìm thấy sản phẩm phù hợp'
                                  : 'Chưa có sản phẩm nào',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (_searchQuery.isEmpty) ...[
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text('Thêm sản phẩm mới'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () => _showAddEditProductDialog(),
                              ),
                            ],
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount:
                            filteredProducts.length +
                            (_hasMoreData && _searchQuery.isEmpty ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == filteredProducts.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final product = filteredProducts[index];
                          return _buildProductCard(product);
                        },
                      ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditProductDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Thêm sản phẩm'),
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Card hiển thị sản phẩm cải tiến
  Widget _buildProductCard(Map<String, dynamic> product) {
    final List<dynamic> images = product['image'] ?? [];
    final String? thumbnail = product['thumbnail'];
    final String mainImage = thumbnail ?? (images.isNotEmpty ? images[0] : '');
    final String categoryName = _getCategoryName(product['categoryId']);
    final String brandName = _getBrandName(product['brandId']);
    final bool hasVariants =
        product['variants'] != null && product['variants'].isNotEmpty;
    final double lowestPrice =
        hasVariants ? _getLowestPrice(product['variants']) : 0.0;
    final double price =
        product['price'] != null
            ? double.tryParse(product['price'].toString()) ?? 0.0
            : 0.0;
    final double? salePrice =
        product['salePrice'] != null
            ? double.tryParse(product['salePrice'].toString())
            : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showProductDetails(product),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh sản phẩm (thumbnail)
              Hero(
                tag: 'product_image_${product['id']}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      mainImage.isNotEmpty
                          ? Image.network(
                            mainImage,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                ),
                          )
                          : Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                ),
              ),
              const SizedBox(width: 16),

              // Thông tin sản phẩm
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product['name'] ?? 'Không có tên',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _statusBadge(product['status'] ?? 'ACTIVE'),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Metadata với icons
                    Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            categoryName,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.business_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            brandName,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Hiển thị giá gốc/giá khuyến mãi hoặc giá biến thể
                    if (hasVariants)
                      Row(
                        children: [
                          Text(
                            'Giá từ: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            _formatPrice(lowestPrice),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${product['variants'].length} biến thể',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      )
                    else if (price > 0 || salePrice != null)
                      Row(
                        children: [
                          if (salePrice != null) ...[
                            Text(
                              _formatPrice(salePrice),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              _formatPrice(price),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ] else
                            Text(
                              _formatPrice(price),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),

              // Các nút thao tác - Đổi thành menu button
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _showAddEditProductDialog(product: product);
                      break;
                    case 'delete':
                      _confirmDeleteProduct(product);
                      break;
                    case 'view':
                      _showProductDetails(product);
                      break;
                  }
                },
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Xem chi tiết'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Chỉnh sửa'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Xóa'),
                          ],
                        ),
                      ),
                    ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
