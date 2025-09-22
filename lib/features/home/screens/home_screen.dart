import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../demo/demo_data.dart';
import '../../../demo/models.dart';
import '../widgets/media_carousel.dart';
import '../widgets/enhanced_property_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCategory;
  RangeValues? _priceRange;
  int? _guestCount;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  List<String> _selectedAmenities = [];
  String _searchQuery = '';

  List<DemoProperty> get _filteredProperties {
    var properties = DemoData.properties
        .where((p) => p.status == PropertyStatus.published)
        .toList();

    if (_searchQuery.isNotEmpty) {
      properties = properties
          .where(
            (p) =>
                p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.location.city.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                p.location.address.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    if (_selectedCategory != null) {
      properties = properties
          .where((p) => p.type.name == _selectedCategory)
          .toList();
    }

    if (_priceRange != null) {
      properties = properties
          .where(
            (p) =>
                p.pricePerNight >= _priceRange!.start &&
                p.pricePerNight <= _priceRange!.end,
          )
          .toList();
    }

    if (_guestCount != null) {
      properties = properties.where((p) => p.capacity >= _guestCount!).toList();
    }

    if (_selectedAmenities.isNotEmpty) {
      properties = properties
          .where(
            (p) => _selectedAmenities.every(
              (amenity) => p.amenities.contains(amenity),
            ),
          )
          .toList();
    }

    return properties;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;

    // Show loading or redirect if user is not available
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Get demo data
    final properties = _filteredProperties;
    final categories = PropertyType.values;

    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Enhanced Header
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.06, // 24px on 400px screen
                  16,
                  screenWidth * 0.06,
                  24,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row with logo and user info
                    Row(
                      children: [
                        // Logo
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'frontend/assets/branding/Logo1.png',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Brand name
                        Flexible(
                          child: Text(
                            'MAAWA',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryCoral,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        // User role badge
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryCoral.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primaryCoral.withValues(
                                  alpha: 0.2,
                                ),
                                width: 1,
                              ),
                            ),
                                                    child: Text(
                          user.role.toString().split('.').last.toUpperCase(),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.primaryCoral,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Welcome text
                    Text(
                      'Welcome back, ${user.name}!',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth < 400 ? 24 : 28,
                            height: 1.2,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Find your perfect stay',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.gray600,
                        fontSize: screenWidth < 400 ? 14 : 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            // Enhanced Search Section
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  screenWidth * 0.06,
                  0,
                  screenWidth * 0.06,
                  32,
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
                            color: AppColors.shadowLight,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        decoration: InputDecoration(
                          hintText: 'Where are you going?',
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
                                  onPressed: () =>
                                      setState(() => _searchQuery = ''),
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
                            isActive:
                                _checkInDate != null && _checkOutDate != null,
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
                            _selectedCategory != null
                                ? _selectedCategory!
                                : 'Type',
                            Icons.home_work,
                            isActive: _selectedCategory != null,
                            onTap: () => _showTypePicker(),
                          ),
                          const SizedBox(width: 12),
                          _buildFilterChip(
                            context,
                            _selectedAmenities.isNotEmpty
                                ? '${_selectedAmenities.length} amenities'
                                : 'Amenities',
                            Icons.local_offer,
                            isActive: _selectedAmenities.isNotEmpty,
                            onTap: () => _showAmenitiesPicker(),
                          ),
                          if (_hasActiveFilters()) ...[
                            const SizedBox(width: 12),
                            _buildClearFiltersChip(context),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Media Carousel Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Discover Libya',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth < 400 ? 20 : 22,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              'Explore all',
                              style: TextStyle(
                                color: AppColors.primaryCoral,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Media carousel
                    const MediaCarousel(),
                  ],
                ),
              ),
            ),

            // Featured Properties Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              _hasActiveFilters() || _searchQuery.isNotEmpty
                                  ? 'Search Results (${properties.length})'
                                  : 'Featured Properties',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth < 400 ? 20 : 22,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push('/properties/all'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              'See all',
                              style: TextStyle(
                                color: AppColors.primaryCoral,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Property cards
                    if (properties.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.06,
                        ),
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppColors.gray50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.gray200),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: AppColors.gray400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No properties found',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.gray600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try adjusting your filters or search terms',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.gray500),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 340,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                          ),
                          itemCount: properties.length,
                          itemBuilder: (context, index) {
                            final property = properties[index];
                            return Container(
                              width: screenWidth < 400 ? 260 : 280,
                              margin: const EdgeInsets.only(right: 16),
                              child: EnhancedPropertyCard(
                                property: property,
                                onTap: () {
                                  // Navigate to property details
                                  context.push('/properties/${property.id}');
                                },
                                onFavoriteToggle: () {
                                  // Toggle favorite
                                  setState(() {
                                    // In a real app, this would update the user's favorites
                                    // For now, we'll just trigger a rebuild
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Categories Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                      ),
                      child: Text(
                        'Explore by Category',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth < 400 ? 20 : 22,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Category items
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final colors = [
                            AppColors.primaryCoral,
                            AppColors.primaryTurquoise,
                            AppColors.primaryTurquoise,
                            AppColors.primaryCoral,
                            AppColors.primaryTurquoise,
                          ];

                          final isSelected = _selectedCategory == category.name;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = isSelected
                                    ? null
                                    : category.name;
                              });
                            },
                            child: Container(
                              width: screenWidth < 400 ? 80 : 100,
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  Container(
                                    width: screenWidth < 400 ? 60 : 70,
                                    height: screenWidth < 400 ? 60 : 70,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? colors[index % colors.length]
                                          : colors[index % colors.length]
                                                .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colors[index % colors.length]
                                              .withValues(
                                                alpha: isSelected ? 0.3 : 0.2,
                                              ),
                                          blurRadius: isSelected ? 12 : 8,
                                          offset: Offset(0, isSelected ? 6 : 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(category),
                                      color: isSelected
                                          ? Colors.white
                                          : colors[index % colors.length],
                                      size: screenWidth < 400 ? 28 : 32,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Flexible(
                                    child: Text(
                                      category.displayName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                            fontSize: screenWidth < 400
                                                ? 12
                                                : 14,
                                            color: isSelected
                                                ? colors[index % colors.length]
                                                : null,
                                          ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
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

  Widget _buildClearFiltersChip(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: _clearAllFilters,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.error, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.clear, size: 16, color: AppColors.error),
            const SizedBox(width: 8),
            Text(
              'Clear all',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
                fontSize: screenWidth < 400 ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedCategory != null ||
        _priceRange != null ||
        _guestCount != null ||
        _checkInDate != null ||
        _checkOutDate != null ||
        _selectedAmenities.isNotEmpty;
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategory = null;
      _priceRange = null;
      _guestCount = null;
      _checkInDate = null;
      _checkOutDate = null;
      _selectedAmenities.clear();
    });
  }

  void _showDatePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _checkInDate != null && _checkOutDate != null
          ? DateTimeRange(start: _checkInDate!, end: _checkOutDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _checkInDate = picked.start;
        _checkOutDate = picked.end;
      });
    }
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
                color: AppColors.gray300,
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
                  color: AppColors.gray300,
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
                color: AppColors.gray300,
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
                trailing: _selectedCategory == type.name
                    ? const Icon(Icons.check, color: AppColors.primaryCoral)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedCategory = _selectedCategory == type.name
                        ? null
                        : type.name;
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
                  color: AppColors.gray300,
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
                          activeColor: AppColors.primaryCoral,
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

  IconData _getCategoryIcon(PropertyType type) {
    switch (type) {
      case PropertyType.apartment:
        return Icons.apartment;
      case PropertyType.villa:
        return Icons.villa;
      case PropertyType.studio:
        return Icons.bed;
      case PropertyType.penthouse:
        return Icons.apartment_outlined;
      case PropertyType.townhouse:
        return Icons.home;
    }
  }
}
