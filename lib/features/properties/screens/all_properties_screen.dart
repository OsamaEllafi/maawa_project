import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../demo/demo_data.dart';
import '../../../demo/models.dart';
import '../../home/widgets/enhanced_property_card.dart';
import 'package:go_router/go_router.dart';

class AllPropertiesScreen extends StatefulWidget {
  const AllPropertiesScreen({super.key});

  @override
  State<AllPropertiesScreen> createState() => _AllPropertiesScreenState();
}

class _AllPropertiesScreenState extends State<AllPropertiesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Filter states
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int? _guestCount;
  RangeValues? _priceRange;
  String? _selectedCategory;
  Set<String> _selectedAmenities = {};
  RangeValues? _bedroomRange;
  RangeValues? _bathroomRange;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final properties = _filteredProperties;

    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: ThemeColors.getAppBarBackground(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColors.getGray700(context)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'All Properties',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 400 ? 18 : 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: _hasActiveFilters()
                  ? AppColors.primaryCoral
                  : ThemeColors.getGray700(context),
            ),
            onPressed: _showFiltersBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filters section
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: ThemeColors.getSurface(context),
              border: Border(
                bottom: BorderSide(
                  color: ThemeColors.getBorder(context),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.getSurface(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ThemeColors.getBorder(context),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ThemeColors.getShadow(context),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search properties...',
                      hintStyle: TextStyle(
                        color: ThemeColors.getGray500(context),
                        fontSize: screenWidth < 400 ? 14 : 16,
                      ),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCoral,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: ThemeColors.getGray500(context),
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Quick filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        context,
                        _checkInDate != null && _checkOutDate != null
                            ? '${_checkInDate!.day}/${_checkInDate!.month} - ${_checkOutDate!.day}/${_checkOutDate!.month}'
                            : 'Any dates',
                        Icons.calendar_today,
                        isActive: _checkInDate != null && _checkOutDate != null,
                        onTap: () => _showDatePicker(),
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        context,
                        _guestCount != null
                            ? '$_guestCount guests'
                            : 'Add guests',
                        Icons.person_add,
                        isActive: _guestCount != null,
                        onTap: () => _showGuestPicker(),
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        context,
                        _priceRange != null
                            ? '\$${_priceRange!.start.round()}-\$${_priceRange!.end.round()}'
                            : 'Price',
                        Icons.attach_money,
                        isActive: _priceRange != null,
                        onTap: () => _showPricePicker(),
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        context,
                        _selectedCategory != null ? _selectedCategory! : 'Type',
                        Icons.home,
                        isActive: _selectedCategory != null,
                        onTap: () => _showTypePicker(),
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip(
                        context,
                        _selectedAmenities.isNotEmpty
                            ? '${_selectedAmenities.length} amenities'
                            : 'Amenities',
                        Icons.list,
                        isActive: _selectedAmenities.isNotEmpty,
                        onTap: () => _showAmenitiesPicker(),
                      ),
                    ],
                  ),
                ),

                // Active filters summary
                if (_hasActiveFilters()) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Active filters: ',
                        style: TextStyle(
                          color: ThemeColors.getGray600(context),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            if (_checkInDate != null && _checkOutDate != null)
                              _buildActiveFilterChip('Dates'),
                            if (_guestCount != null)
                              _buildActiveFilterChip('Guests'),
                            if (_priceRange != null)
                              _buildActiveFilterChip('Price'),
                            if (_selectedCategory != null)
                              _buildActiveFilterChip('Type'),
                            if (_selectedAmenities.isNotEmpty)
                              _buildActiveFilterChip('Amenities'),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _clearAllFilters,
                        child: Text(
                          'Clear all',
                          style: TextStyle(
                            color: AppColors.primaryCoral,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Results count
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: 16,
            ),
            child: Row(
              children: [
                Text(
                  '${properties.length} properties found',
                  style: TextStyle(
                    color: ThemeColors.getGray600(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                // Sort options
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.sort,
                    color: ThemeColors.getGray600(context),
                  ),
                  onSelected: (value) {
                    // TODO: Implement sorting
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'price_low',
                      child: Text('Price: Low to High'),
                    ),
                    const PopupMenuItem(
                      value: 'price_high',
                      child: Text('Price: High to Low'),
                    ),
                    const PopupMenuItem(
                      value: 'rating',
                      child: Text('Highest Rated'),
                    ),
                    const PopupMenuItem(
                      value: 'newest',
                      child: Text('Newest First'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Properties list
          Expanded(
            child: properties.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                    ),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      final property = properties[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: EnhancedPropertyCard(
                          property: property,
                          useFixedHeight: true,
                          onTap: () => _navigateToPropertyDetails(property),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<DemoProperty> get _filteredProperties {
    var properties = DemoData.properties;

    // Search filter
    if (_searchQuery.isNotEmpty) {
      properties = properties.where((property) {
        final query = _searchQuery.toLowerCase();
        return property.title.toLowerCase().contains(query) ||
            property.location.city.toLowerCase().contains(query) ||
            property.location.country.toLowerCase().contains(query) ||
            property.type.displayName.toLowerCase().contains(query);
      }).toList();
    }

    // Date filter
    if (_checkInDate != null && _checkOutDate != null) {
      // TODO: Implement date availability filtering
    }

    // Guest filter
    if (_guestCount != null) {
      properties = properties
          .where((property) => property.capacity >= _guestCount!)
          .toList();
    }

    // Price filter
    if (_priceRange != null) {
      properties = properties.where((property) {
        return property.pricePerNight >= _priceRange!.start &&
            property.pricePerNight <= _priceRange!.end;
      }).toList();
    }

    // Category filter
    if (_selectedCategory != null) {
      properties = properties
          .where((property) => property.type.displayName == _selectedCategory)
          .toList();
    }

    // Amenities filter
    if (_selectedAmenities.isNotEmpty) {
      properties = properties.where((property) {
        return _selectedAmenities.every(
          (amenity) => property.amenities.contains(amenity),
        );
      }).toList();
    }

    return properties;
  }

  bool _hasActiveFilters() {
    return _checkInDate != null ||
        _checkOutDate != null ||
        _guestCount != null ||
        _priceRange != null ||
        _selectedCategory != null ||
        _selectedAmenities.isNotEmpty;
  }

  void _clearAllFilters() {
    setState(() {
      _checkInDate = null;
      _checkOutDate = null;
      _guestCount = null;
      _priceRange = null;
      _selectedCategory = null;
      _selectedAmenities.clear();
    });
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    IconData icon, {
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryCoral.withValues(alpha: 0.1)
              : ThemeColors.getGray50(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.primaryCoral
                : ThemeColors.getBorder(context),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive
                  ? AppColors.primaryCoral
                  : ThemeColors.getGray600(context),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isActive
                      ? AppColors.primaryCoral
                      : ThemeColors.getGray700(context),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  fontSize: screenWidth < 400 ? 12 : 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryCoral.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryCoral.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.primaryCoral,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: ThemeColors.getGray400(context),
          ),
          const SizedBox(height: 16),
          Text(
            'No properties found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: ThemeColors.getGray600(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ThemeColors.getGray500(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _clearAllFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCoral,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  void _navigateToPropertyDetails(DemoProperty property) {
    context.push('/properties/${property.id}');
  }

  // Filter picker methods (same as home screen)
  void _showDatePicker() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _checkInDate != null && _checkOutDate != null
          ? DateTimeRange(start: _checkInDate!, end: _checkOutDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primaryCoral),
          ),
          child: child!,
        );
      },
    ).then((dateRange) {
      if (dateRange != null) {
        setState(() {
          _checkInDate = dateRange.start;
          _checkOutDate = dateRange.end;
        });
      }
    });
  }

  void _showGuestPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ThemeColors.getSurface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ThemeColors.getGray300(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Number of Guests',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _guestCount != null && _guestCount! > 1
                      ? () => setState(() => _guestCount = _guestCount! - 1)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                  iconSize: 32,
                ),
                Text(
                  '${_guestCount ?? 1}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      setState(() => _guestCount = (_guestCount ?? 1) + 1),
                  icon: const Icon(Icons.add_circle_outline),
                  iconSize: 32,
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _guestCount = _guestCount ?? 1;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCoral,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Apply'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showPricePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ThemeColors.getSurface(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ThemeColors.getGray300(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Price Range',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              RangeSlider(
                values: _priceRange ?? const RangeValues(50, 500),
                min: 50,
                max: 500,
                divisions: 18,
                labels: RangeLabels(
                  '\$${(_priceRange?.start ?? 50).round()}',
                  '\$${(_priceRange?.end ?? 500).round()}',
                ),
                onChanged: (values) {
                  setModalState(() {
                    _priceRange = values;
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCoral,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Apply'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showTypePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ThemeColors.getSurface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ThemeColors.getGray300(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Property Type',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...PropertyType.values.map(
              (type) => ListTile(
                leading: Icon(_getCategoryIcon(type)),
                title: Text(type.displayName),
                trailing: _selectedCategory == type.displayName
                    ? const Icon(Icons.check, color: AppColors.primaryCoral)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedCategory = _selectedCategory == type.displayName
                        ? null
                        : type.displayName;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showAmenitiesPicker() {
    final availableAmenities = [
      'WiFi',
      'Air Conditioning',
      'Kitchen',
      'Balcony',
      'Security',
      'Parking',
      'Private Pool',
      'Garden',
      'BBQ',
      'Beach Access',
      'Gym',
      'Concierge',
      'Rooftop Terrace',
      'City View',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ThemeColors.getSurface(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ThemeColors.getGray300(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Amenities',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 300,
                child: ListView(
                  children: availableAmenities
                      .map(
                        (amenity) => CheckboxListTile(
                          title: Text(amenity),
                          value: _selectedAmenities.contains(amenity),
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                _selectedAmenities.add(amenity);
                              } else {
                                _selectedAmenities.remove(amenity);
                              }
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCoral,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Apply'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ThemeColors.getSurface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ThemeColors.getGray300(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Advanced Filters',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // Add more advanced filters here if needed
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(PropertyType type) {
    switch (type) {
      case PropertyType.apartment:
        return Icons.apartment;
      case PropertyType.villa:
        return Icons.villa;
      case PropertyType.studio:
        return Icons.single_bed;
      case PropertyType.penthouse:
        return Icons.apartment;
      case PropertyType.townhouse:
        return Icons.home;
    }
  }
}
