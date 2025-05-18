import 'package:ecommerce_app/features/admin/brands_page.dart';
import 'package:ecommerce_app/features/admin/categories_page.dart';
import 'package:ecommerce_app/features/admin/products_page.dart';
import 'package:ecommerce_app/features/authentication/screens/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import page files

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Current selected menu item
  String _selectedMenuItem = "Dashboard";

  // Get content based on selected menu item
  Widget _getContentForSelectedItem() {
    switch (_selectedMenuItem) {
      case "Dashboard":
        return _buildDashboardContent();
      // case "Media":
      //   return const MediaPage();
      // case "Banners":
      //   return const BannersPage();
      case "Products":
        return const ProductsPage();
      case "Categories":
        return const CategoriesPage();
      case "Brands":
        return const BrandsPage();
      // case "Customers":
      //   return const CustomersPage();
      // case "Orders":
      //   return const OrdersPage();
      // case "Coupons":
      //   return const CouponsPage();
      // case "Settings":
      //   return const SettingsPage();
      default:
        return _buildDashboardContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedMenuItem),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage("https://via.placeholder.com/150"),
          ),
          const SizedBox(width: 20),
        ],
      ),
      drawer:
          MediaQuery.of(context).size.width < 1200
              ? _buildDrawer() // Use drawer for smaller screens
              : null,
      body:
          MediaQuery.of(context).size.width < 1200
              ? _getContentForSelectedItem() // Only main content for smaller screens
              : Row(
                children: [
                  // Left Sidebar for larger screens
                  Container(
                    width: 240,
                    color: Colors.white,
                    child: _buildDrawerContent(),
                  ),
                  // Main Content
                  Expanded(child: _getContentForSelectedItem()),
                ],
              ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(child: _buildDrawerContent());
  }

  Widget _buildDrawerContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // App Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "T",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(left: 2, bottom: 20),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "MENU",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Menu items
          // _buildMenuItemWithSelection(Icons.dashboard, "Dashboard"),
          // _buildMenuItemWithSelection(Icons.image, "Media"),
          // _buildMenuItemWithSelection(Icons.view_carousel, "Banners"),
          _buildMenuItemWithSelection(Icons.inventory_2, "Products"),
          _buildMenuItemWithSelection(Icons.category, "Categories"),
          _buildMenuItemWithSelection(Icons.local_offer, "Brands"),

          // _buildMenuItemWithSelection(Icons.people, "Customers"),
          // _buildMenuItemWithSelection(Icons.shopping_cart, "Orders"),
          // _buildMenuItemWithSelection(Icons.card_giftcard, "Coupons"),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "OTHER",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // _buildMenuItemWithSelection(Icons.settings, "Settings"),
          _buildLogoutMenuItem(Icons.logout, "Logout"),
        ],
      ),
    );
  }

  Widget _buildMenuItemWithSelection(IconData icon, String title) {
    final bool isSelected = _selectedMenuItem == title;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[600],
        ),
        title: Text(
          title,
          style: TextStyle(color: isSelected ? Colors.white : Colors.grey[800]),
        ),
        onTap: () {
          setState(() {
            _selectedMenuItem = title;
          });

          // Close drawer if on small screen
          if (MediaQuery.of(context).size.width < 1200) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildLogoutMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title, style: TextStyle(color: Colors.grey[800])),
      onTap: () {
        _showLogoutDialog();
      },
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              // Perform logout action here
              Get.back();
              Get.offAll(
                () => const OnBoardingScreen(),
              ); // Navigate to login page
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  // Dashboard content
  Widget _buildDashboardContent() {
    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Dashboard",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Stats Cards
              _buildStatsCardsSection(),
              const SizedBox(height: 20),
              // Charts Row
              _buildChartsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCardsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // For very small screens, stack the cards vertically
        if (constraints.maxWidth < 600) {
          return Column(
            children: [
              _buildStatCard(
                "Sales total",
                "\$29628.61",
                "+25%",
                Colors.green,
                "Compared to Dec 2023",
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                "Average Order Value",
                "\$2116.33",
                "-15%",
                Colors.red,
                "Compared to Dec 2023",
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                "Total Orders",
                "\$14",
                "+44%",
                Colors.green,
                "Compared to Dec 2023",
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                "Visitors",
                "25,035",
                "+2%",
                Colors.green,
                "Compared to Dec 2023",
              ),
            ],
          );
        }

        // For medium screens, use a 2x2 grid
        if (constraints.maxWidth < 1200) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      "Sales total",
                      "\$29628.61",
                      "+25%",
                      Colors.green,
                      "Compared to Dec 2023",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      "Average Order Value",
                      "\$2116.33",
                      "-15%",
                      Colors.red,
                      "Compared to Dec 2023",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      "Total Orders",
                      "\$14",
                      "+44%",
                      Colors.green,
                      "Compared to Dec 2023",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      "Visitors",
                      "25,035",
                      "+2%",
                      Colors.green,
                      "Compared to Dec 2023",
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        // For large screens, use a single row
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Sales total",
                "\$29628.61",
                "+25%",
                Colors.green,
                "Compared to Dec 2023",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                "Average Order Value",
                "\$2116.33",
                "-15%",
                Colors.red,
                "Compared to Dec 2023",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                "Total Orders",
                "\$14",
                "+44%",
                Colors.green,
                "Compared to Dec 2023",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                "Visitors",
                "25,035",
                "+2%",
                Colors.green,
                "Compared to Dec 2023",
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChartsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // For smaller screens, stack the charts vertically
        if (constraints.maxWidth < 900) {
          return Column(
            children: [
              Container(
                height: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Weekly Sales",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "192.6",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: _buildWeeklyChart()),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Orders Status",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child: _buildOrderStatusChart()),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Status", style: TextStyle(color: Colors.grey)),
                        Text("Orders", style: TextStyle(color: Colors.grey)),
                        Text("Total", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        // For larger screens, use a row
        return SizedBox(
          height: 400,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Weekly Sales Chart
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Weekly Sales",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "192.6",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(child: _buildWeeklyChart()),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Orders Status Chart
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Orders Status",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(child: _buildOrderStatusChart()),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Status", style: TextStyle(color: Colors.grey)),
                          Text("Orders", style: TextStyle(color: Colors.grey)),
                          Text("Total", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String percentage,
    Color color,
    String compareText,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  percentage,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            compareText,
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildChartBar(
              "Mon",
              0.8,
              constraints.maxHeight * 0.8,
              Colors.blue,
            ),
            _buildChartBar(
              "Tue",
              0.4,
              constraints.maxHeight * 0.4,
              Colors.blue,
            ),
            _buildChartBar(
              "Wed",
              0.0,
              constraints.maxHeight * 0.0,
              Colors.blue,
            ),
            _buildChartBar(
              "Thu",
              0.0,
              constraints.maxHeight * 0.0,
              Colors.blue,
            ),
            _buildChartBar(
              "Fri",
              0.0,
              constraints.maxHeight * 0.0,
              Colors.blue,
            ),
            _buildChartBar(
              "Sat",
              0.0,
              constraints.maxHeight * 0.0,
              Colors.blue,
            ),
            _buildChartBar(
              "Sun",
              0.0,
              constraints.maxHeight * 0.0,
              Colors.blue,
            ),
          ],
        );
      },
    );
  }

  Widget _buildChartBar(
    String label,
    double heightFactor,
    double height,
    Color color,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildOrderStatusChart() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: CustomPaint(painter: DonutChartPainter()),
          ),
          const Text(
            "14",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Donut Chart Painter
class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Define segments
    final segments = [
      {'color': Colors.green, 'value': 5, 'start': 0.0, 'sweep': 0.36},
      {'color': Colors.blue, 'value': 5, 'start': 0.36, 'sweep': 0.36},
      {'color': Colors.purple, 'value': 3, 'start': 0.72, 'sweep': 0.21},
      {'color': Colors.red, 'value': 1, 'start': 0.93, 'sweep': 0.07},
    ];

    // Draw segments
    for (var segment in segments) {
      final paint =
          Paint()
            ..color = segment['color'] as Color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 25;

      canvas.drawArc(
        rect,
        (segment['start'] as double) * 2 * 3.14,
        (segment['sweep'] as double) * 2 * 3.14,
        false,
        paint,
      );
    }

    // Draw center white circle
    final centerPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius - 25, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
