import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class PricingManagementWidget extends StatefulWidget {
  const PricingManagementWidget({super.key});

  @override
  State<PricingManagementWidget> createState() =>
      _PricingManagementWidgetState();
}

class _PricingManagementWidgetState extends State<PricingManagementWidget> {
  final List<Map<String, dynamic>> _services = [
    {
      'id': 'photo_editing',
      'name': 'Photo Editing',
      'price': 1.50,
      'unit': 'per photo',
      'description': 'Professional photo enhancement',
      'isActive': true,
    },
    {
      'id': 'twilight_photo',
      'name': 'Twilight Photo',
      'price': 15.00,
      'unit': 'per image',
      'description': 'Transform day photos into twilight shots',
      'isActive': true,
    },
    {
      'id': 'virtual_staging',
      'name': 'Virtual Staging',
      'price': 20.00,
      'unit': 'per image',
      'description': 'Furnish empty rooms digitally',
      'isActive': true,
    },
    {
      'id': 'item_removal_small',
      'name': 'Small Item Removal',
      'price': 5.00,
      'unit': 'per photo',
      'description': 'Remove up to 3 small items',
      'isActive': true,
    },
    {
      'id': 'item_removal_large',
      'name': 'Large Item Removal',
      'price': 12.00,
      'unit': 'per photo',
      'description': 'Remove 4+ items or furniture',
      'isActive': true,
    },
    {
      'id': 'floorplan_2d',
      'name': '2D Floorplan Creation',
      'price': 25.00,
      'unit': 'per floorplan',
      'description': 'Professional floorplan from video',
      'isActive': true,
    },
    {
      'id': 'photo_branding',
      'name': 'Photo Branding',
      'price': 3.00,
      'unit': 'per job',
      'description': 'Add custom logo to photos',
      'isActive': true,
    },
    {
      'id': 'branded_delivery',
      'name': 'Branded Gallery Delivery',
      'price': 9.00,
      'unit': 'per delivery',
      'description': 'Custom branded download page',
      'isActive': true,
    },
    {
      'id': 'subscription',
      'name': 'Monthly Subscription',
      'price': 15.00,
      'unit': 'per month',
      'description': 'Unlimited whitelabeling & branding',
      'isActive': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassmorphicContainer(
            opacity: 0.1,
            borderRadius: BorderRadius.circular(16),
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Icon(
                  Icons.attach_money,
                  color: AppTheme.yellow,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Pricing Management',
                        style: GoogleFonts.poppins(
                          color: AppTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Edit prices and manage service availability',
                        style: GoogleFonts.poppins(
                          color: AppTheme.white.withAlpha(179),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_services.where((s) => s['isActive']).length} Active',
                    style: GoogleFonts.poppins(
                      color: AppTheme.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Services List
          ...(_services.map((service) => _buildServiceCard(service)).toList()),

          SizedBox(height: 3.h),

          // Add New Service Button
          GlassmorphicContainer(
            opacity: 0.1,
            borderRadius: BorderRadius.circular(16),
            padding: EdgeInsets.all(4.w),
            child: InkWell(
              onTap: () => _showAddServiceDialog(),
              borderRadius: BorderRadius.circular(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: AppTheme.yellow,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Add New Service',
                    style: GoogleFonts.poppins(
                      color: AppTheme.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return GlassmorphicContainer(
      opacity: 0.1,
      borderRadius: BorderRadius.circular(12),
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['name'],
                      style: GoogleFonts.poppins(
                        color: AppTheme.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      service['description'],
                      style: GoogleFonts.poppins(
                        color: AppTheme.white.withAlpha(179),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: service['isActive'],
                onChanged: (value) {
                  setState(() {
                    service['isActive'] = value;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${service['name']} ${value ? 'enabled' : 'disabled'}'),
                      backgroundColor: AppTheme.yellow,
                    ),
                  );
                },
                activeColor: AppTheme.yellow,
                inactiveThumbColor: AppTheme.white.withAlpha(128),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.yellow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '\$${service['price'].toStringAsFixed(2)} ${service['unit']}',
                  style: GoogleFonts.poppins(
                    color: AppTheme.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showEditPriceDialog(service),
                child: Text(
                  'Edit Price',
                  style: GoogleFonts.poppins(
                    color: AppTheme.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _showEditDescriptionDialog(service),
                child: Text(
                  'Edit Description',
                  style: GoogleFonts.poppins(
                    color: AppTheme.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditPriceDialog(Map<String, dynamic> service) {
    final TextEditingController priceController = TextEditingController(
      text: service['price'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.backgroundElevated,
        title: Text(
          'Edit Price - ${service['name']}',
          style: GoogleFonts.poppins(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Price (\$)',
                prefixText: '\$',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Unit: ${service['unit']}',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newPrice = double.tryParse(priceController.text);
              if (newPrice != null && newPrice > 0) {
                setState(() {
                  service['price'] = newPrice;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Price updated for ${service['name']}'),
                    backgroundColor: AppTheme.yellow,
                  ),
                );
              }
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.accentStart),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditDescriptionDialog(Map<String, dynamic> service) {
    final TextEditingController descController = TextEditingController(
      text: service['description'],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.backgroundElevated,
        title: Text(
          'Edit Description - ${service['name']}',
          style: GoogleFonts.poppins(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextFormField(
          controller: descController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                service['description'] = descController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Description updated for ${service['name']}'),
                  backgroundColor: AppTheme.yellow,
                ),
              );
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.accentStart),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddServiceDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController unitController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.backgroundElevated,
        title: Text(
          'Add New Service',
          style: GoogleFonts.poppins(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Service Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Price (\$)',
                prefixText: '\$',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: unitController,
              decoration: InputDecoration(
                labelText: 'Unit (e.g., per photo)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: descController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Description',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty &&
                  unitController.text.isNotEmpty) {
                final newService = {
                  'id': nameController.text.toLowerCase().replaceAll(' ', '_'),
                  'name': nameController.text,
                  'price': double.tryParse(priceController.text) ?? 0.0,
                  'unit': unitController.text,
                  'description': descController.text.isEmpty
                      ? 'New service'
                      : descController.text,
                  'isActive': true,
                };
                setState(() {
                  _services.add(newService);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('New service added: ${newService['name']}'),
                    backgroundColor: AppTheme.yellow,
                  ),
                );
              }
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.accentStart),
            child: Text('Add Service'),
          ),
        ],
      ),
    );
  }
}
