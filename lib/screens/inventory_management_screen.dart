// lib/screens/inventory_management_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  State<InventoryManagementScreen> createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  final List<InventoryItem> _inventory = [
    InventoryItem(id: '1', name: 'Emergency Water Bottles', quantity: 500, status: 'Available', category: 'Water'),
    InventoryItem(id: '2', name: 'Medical First Aid Kits', quantity: 25, status: 'Available', category: 'Medical'),
    InventoryItem(id: '3', name: 'Emergency Blankets', quantity: 8, status: 'Low Stock', category: 'Shelter'),
    InventoryItem(id: '4', name: 'Portable Generators', quantity: 3, status: 'Deployed', category: 'Equipment'),
    InventoryItem(id: '5', name: 'Food Ration Packs', quantity: 150, status: 'Available', category: 'Food'),
    InventoryItem(id: '6', name: 'Communication Radios', quantity: 2, status: 'Low Stock', category: 'Communication'),
  ];

  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Water', 'Medical', 'Shelter', 'Equipment', 'Food', 'Communication'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: Navigator.canPop(context) ? IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: const Text('Inventory Management'),
        backgroundColor: AppTheme.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddItemDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 768;
            final padding = isTablet ? 24.0 : 16.0;
            
            return Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isTablet),
                  const SizedBox(height: 24),
                  _buildCategoryFilter(context, isTablet),
                  const SizedBox(height: 24),
                  _buildInventoryStats(context, isTablet),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _buildInventoryList(context, isTablet),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.inventory_2,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resource Inventory',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage disaster response resources',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context, bool isTablet) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          
          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedCategory = category;
              });
            },
            backgroundColor: Colors.white,
            selectedColor: AppTheme.primary.withOpacity(0.1),
            checkmarkColor: AppTheme.primary,
            labelStyle: TextStyle(
              color: isSelected ? AppTheme.primary : AppTheme.neutral600,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          );
        },
      ),
    );
  }

  Widget _buildInventoryStats(BuildContext context, bool isTablet) {
    final filteredItems = _getFilteredItems();
    final available = filteredItems.where((item) => item.status == 'Available').length;
    final lowStock = filteredItems.where((item) => item.status == 'Low Stock').length;
    final deployed = filteredItems.where((item) => item.status == 'Deployed').length;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isTablet) {
          return Row(
            children: [
              Expanded(child: _buildStatCard('Total Items', filteredItems.length.toString(), Icons.inventory, AppTheme.primary)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Available', available.toString(), Icons.check_circle, AppTheme.success)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Low Stock', lowStock.toString(), Icons.warning, AppTheme.warning)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Deployed', deployed.toString(), Icons.send, AppTheme.info)),
            ],
          );
        } else {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatCard('Total', filteredItems.length.toString(), Icons.inventory, AppTheme.primary)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('Available', available.toString(), Icons.check_circle, AppTheme.success)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildStatCard('Low Stock', lowStock.toString(), Icons.warning, AppTheme.warning)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('Deployed', deployed.toString(), Icons.send, AppTheme.info)),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.neutral800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.neutral600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList(BuildContext context, bool isTablet) {
    final filteredItems = _getFilteredItems();
    
    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: AppTheme.neutral400),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.neutral600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: filteredItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildInventoryCard(context, item, isTablet);
      },
    );
  }

  Widget _buildInventoryCard(BuildContext context, InventoryItem item, bool isTablet) {
    final statusColor = _getStatusColor(item.status);
    
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(item.category),
                  color: statusColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.neutral800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.neutral600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.status,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.neutral600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.quantity.toString(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.neutral800,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditItemDialog(item),
                    color: AppTheme.primary,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showDeleteConfirmation(item),
                    color: AppTheme.error,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<InventoryItem> _getFilteredItems() {
    if (_selectedCategory == 'All') {
      return _inventory;
    }
    return _inventory.where((item) => item.category == _selectedCategory).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return AppTheme.success;
      case 'Low Stock':
        return AppTheme.warning;
      case 'Deployed':
        return AppTheme.info;
      default:
        return AppTheme.neutral600;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Water':
        return Icons.water_drop;
      case 'Medical':
        return Icons.medical_services;
      case 'Shelter':
        return Icons.home;
      case 'Equipment':
        return Icons.build;
      case 'Food':
        return Icons.restaurant;
      case 'Communication':
        return Icons.radio;
      default:
        return Icons.inventory_2;
    }
  }

  void _showAddItemDialog() {
    // Placeholder for add item dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Item functionality - UI placeholder')),
    );
  }

  void _showEditItemDialog(InventoryItem item) {
    // Placeholder for edit item dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${item.name} - UI placeholder')),
    );
  }

  void _showDeleteConfirmation(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete ${item.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _inventory.removeWhere((i) => i.id == item.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.name} deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class InventoryItem {
  final String id;
  final String name;
  final int quantity;
  final String status;
  final String category;

  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.status,
    required this.category,
  });
}