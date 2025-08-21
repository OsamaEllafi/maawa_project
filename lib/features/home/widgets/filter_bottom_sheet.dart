import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../demo/models.dart';

class FilterBottomSheet extends StatefulWidget {
  final String? selectedCategory;
  final RangeValues? priceRange;
  final int? guestCount;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final List<String> selectedAmenities;
  final Function(FilterData) onApply;

  const FilterBottomSheet({
    super.key,
    this.selectedCategory,
    this.priceRange,
    this.guestCount,
    this.checkInDate,
    this.checkOutDate,
    required this.selectedAmenities,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String? _selectedCategory;
  late RangeValues? _priceRange;
  late int? _guestCount;
  late DateTime? _checkInDate;
  late DateTime? _checkOutDate;
  late List<String> _selectedAmenities;

  final List<String> _availableAmenities = [
    'WiFi', 'Air Conditioning', 'Kitchen', 'Balcony', 'Security', 
    'Parking', 'Private Pool', 'Garden', 'BBQ', 'Beach Access',
    'Gym', 'Concierge', 'Rooftop Terrace', 'City View'
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _priceRange = widget.priceRange;
    _guestCount = widget.guestCount;
    _checkInDate = widget.checkInDate;
    _checkOutDate = widget.checkOutDate;
    _selectedAmenities = List.from(widget.selectedAmenities);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Header
          Row(
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _clearAllFilters,
                child: Text(
                  'Clear all',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Type Section
                  _buildSectionTitle('Property Type'),
                  const SizedBox(height: 12),
                  _buildPropertyTypeSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Price Range Section
                  _buildSectionTitle('Price Range'),
                  const SizedBox(height: 12),
                  _buildPriceRangeSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Guests Section
                  _buildSectionTitle('Number of Guests'),
                  const SizedBox(height: 12),
                  _buildGuestSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Dates Section
                  _buildSectionTitle('Check-in & Check-out'),
                  const SizedBox(height: 12),
                  _buildDatesSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Amenities Section
                  _buildSectionTitle('Amenities'),
                  const SizedBox(height: 12),
                  _buildAmenitiesSection(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryCoral,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildPropertyTypeSection() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: PropertyType.values.map((type) {
        final isSelected = _selectedCategory == type.name;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = isSelected ? null : type.name;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.primaryCoral.withValues(alpha: 0.1)
                  : AppColors.gray50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.primaryCoral : AppColors.gray200,
                width: 1,
              ),
            ),
            child: Text(
              type.displayName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? AppColors.primaryCoral : AppColors.gray700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      children: [
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
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${(_priceRange?.start ?? 50).round()}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '\$${(_priceRange?.end ?? 500).round()}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuestSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _guestCount != null && _guestCount! > 1
              ? () => setState(() => _guestCount = _guestCount! - 1)
              : null,
          icon: Icon(
            Icons.remove_circle_outline,
            color: _guestCount != null && _guestCount! > 1
                ? AppColors.primaryCoral
                : AppColors.gray400,
          ),
          iconSize: 32,
        ),
        Text(
          '${_guestCount ?? 1} guests',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: () => setState(() => _guestCount = (_guestCount ?? 1) + 1),
          icon: const Icon(
            Icons.add_circle_outline,
            color: AppColors.primaryCoral,
          ),
          iconSize: 32,
        ),
      ],
    );
  }

  Widget _buildDatesSection() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _selectCheckInDate,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Check-in',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _checkInDate != null 
                        ? '${_checkInDate!.day}/${_checkInDate!.month}/${_checkInDate!.year}'
                        : 'Select date',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: _selectCheckOutDate,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Check-out',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.gray600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _checkOutDate != null 
                        ? '${_checkOutDate!.day}/${_checkOutDate!.month}/${_checkOutDate!.year}'
                        : 'Select date',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      children: _availableAmenities.map((amenity) => CheckboxListTile(
        title: Text(amenity),
        value: _selectedAmenities.contains(amenity),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              _selectedAmenities.add(amenity);
            } else {
              _selectedAmenities.remove(amenity);
            }
          });
        },
        activeColor: AppColors.primaryCoral,
        contentPadding: EdgeInsets.zero,
      )).toList(),
    );
  }

  void _selectCheckInDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
        // Clear check-out if it's before check-in
        if (_checkOutDate != null && _checkOutDate!.isBefore(picked)) {
          _checkOutDate = null;
        }
      });
    }
  }

  void _selectCheckOutDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate ?? 
          (_checkInDate?.add(const Duration(days: 1)) ?? DateTime.now().add(const Duration(days: 1))),
      firstDate: _checkInDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
      });
    }
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

  void _applyFilters() {
    widget.onApply(FilterData(
      selectedCategory: _selectedCategory,
      priceRange: _priceRange,
      guestCount: _guestCount,
      checkInDate: _checkInDate,
      checkOutDate: _checkOutDate,
      selectedAmenities: _selectedAmenities,
    ));
    Navigator.pop(context);
  }
}

class FilterData {
  final String? selectedCategory;
  final RangeValues? priceRange;
  final int? guestCount;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final List<String> selectedAmenities;

  FilterData({
    this.selectedCategory,
    this.priceRange,
    this.guestCount,
    this.checkInDate,
    this.checkOutDate,
    required this.selectedAmenities,
  });
}
