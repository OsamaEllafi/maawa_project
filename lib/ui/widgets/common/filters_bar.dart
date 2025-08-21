import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../demo/models.dart';

class FiltersBar extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;
  final Map<String, dynamic> currentFilters;

  const FiltersBar({
    super.key,
    required this.onFiltersChanged,
    required this.currentFilters,
  });

  @override
  State<FiltersBar> createState() => _FiltersBarState();
}

class _FiltersBarState extends State<FiltersBar> {
  late Map<String, dynamic> _filters;

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
  }

  void _updateFilters() {
    widget.onFiltersChanged(_filters);
  }

  void _showPriceRangeDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PriceRangeBottomSheet(
        currentMin: _filters['minPrice'] ?? 0.0,
        currentMax: _filters['maxPrice'] ?? 1000.0,
        onApply: (min, max) {
          setState(() {
            _filters['minPrice'] = min;
            _filters['maxPrice'] = max;
          });
          _updateFilters();
        },
      ),
    );
  }

  void _showPropertyTypeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _PropertyTypeBottomSheet(
        selectedTypes: List<PropertyType>.from(_filters['propertyTypes'] ?? []),
        onApply: (types) {
          setState(() {
            _filters['propertyTypes'] = types;
          });
          _updateFilters();
        },
      ),
    );
  }

  void _showAmenitiesDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AmenitiesBottomSheet(
        selectedAmenities: List<String>.from(_filters['amenities'] ?? []),
        onApply: (amenities) {
          setState(() {
            _filters['amenities'] = amenities;
          });
          _updateFilters();
        },
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _filters.clear();
    });
    _updateFilters();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final hasActiveFilters = _filters.isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.06,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.gray200, width: 1)),
      ),
      child: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  'Price',
                  Icons.attach_money,
                  _filters.containsKey('minPrice') ||
                      _filters.containsKey('maxPrice'),
                  _showPriceRangeDialog,
                ),
                const SizedBox(width: 12),
                _buildFilterChip(
                  'Type',
                  Icons.home_work,
                  _filters.containsKey('propertyTypes') &&
                      (_filters['propertyTypes'] as List).isNotEmpty,
                  _showPropertyTypeDialog,
                ),
                const SizedBox(width: 12),
                _buildFilterChip(
                  'Guests',
                  Icons.person,
                  _filters.containsKey('guests'),
                  () {
                    _showGuestsDialog();
                  },
                ),
                const SizedBox(width: 12),
                _buildFilterChip(
                  'Amenities',
                  Icons.local_offer,
                  _filters.containsKey('amenities') &&
                      (_filters['amenities'] as List).isNotEmpty,
                  _showAmenitiesDialog,
                ),
                const SizedBox(width: 12),
                _buildFilterChip(
                  'Rating',
                  Icons.star,
                  _filters.containsKey('minRating'),
                  () {
                    _showRatingDialog();
                  },
                ),
                if (hasActiveFilters) ...[
                  const SizedBox(width: 12),
                  _buildClearFilterChip(),
                ],
              ],
            ),
          ),

          // Active filters summary
          if (hasActiveFilters) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryCoral.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryCoral.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: AppColors.primaryCoral,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getFiltersSummary(),
                      style: TextStyle(
                        color: AppColors.primaryCoral,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _clearFilters,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                    ),
                    child: Text(
                      'Clear all',
                      style: TextStyle(
                        color: AppColors.primaryCoral,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    IconData icon,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryCoral : AppColors.gray50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primaryCoral : AppColors.gray200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : AppColors.gray600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.gray700,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearFilterChip() {
    return GestureDetector(
      onTap: _clearFilters,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.clear, size: 16, color: AppColors.error),
            const SizedBox(width: 8),
            Text(
              'Clear',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFiltersSummary() {
    final summaries = <String>[];

    if (_filters.containsKey('minPrice') || _filters.containsKey('maxPrice')) {
      final min = _filters['minPrice'] ?? 0.0;
      final max = _filters['maxPrice'] ?? 1000.0;
      summaries.add('${min.toInt()}-${max.toInt()} LYD');
    }

    if (_filters.containsKey('propertyTypes') &&
        (_filters['propertyTypes'] as List).isNotEmpty) {
      final types = (_filters['propertyTypes'] as List<PropertyType>);
      summaries.add('${types.length} type${types.length > 1 ? 's' : ''}');
    }

    if (_filters.containsKey('guests')) {
      summaries.add('${_filters['guests']} guests');
    }

    if (_filters.containsKey('amenities') &&
        (_filters['amenities'] as List).isNotEmpty) {
      final amenities = (_filters['amenities'] as List<String>);
      summaries.add(
        '${amenities.length} amenit${amenities.length > 1 ? 'ies' : 'y'}',
      );
    }

    if (_filters.containsKey('minRating')) {
      summaries.add('${_filters['minRating']}+ stars');
    }

    return summaries.join(' • ');
  }

  void _showGuestsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _GuestsBottomSheet(
        currentGuests: _filters['guests'] ?? 1,
        onApply: (guests) {
          setState(() {
            _filters['guests'] = guests;
          });
          _updateFilters();
        },
      ),
    );
  }

  void _showRatingDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _RatingBottomSheet(
        currentRating: _filters['minRating'] ?? 0,
        onApply: (rating) {
          setState(() {
            _filters['minRating'] = rating;
          });
          _updateFilters();
        },
      ),
    );
  }
}

// Price Range Bottom Sheet
class _PriceRangeBottomSheet extends StatefulWidget {
  final double currentMin;
  final double currentMax;
  final Function(double, double) onApply;

  const _PriceRangeBottomSheet({
    required this.currentMin,
    required this.currentMax,
    required this.onApply,
  });

  @override
  State<_PriceRangeBottomSheet> createState() => _PriceRangeBottomSheetState();
}

class _PriceRangeBottomSheetState extends State<_PriceRangeBottomSheet> {
  late RangeValues _rangeValues;

  @override
  void initState() {
    super.initState();
    _rangeValues = RangeValues(widget.currentMin, widget.currentMax);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price Range (LYD per night)',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                RangeSlider(
                  values: _rangeValues,
                  min: 0,
                  max: 1000,
                  divisions: 100,
                  labels: RangeLabels(
                    _rangeValues.start.round().toString(),
                    _rangeValues.end.round().toString(),
                  ),
                  onChanged: (values) {
                    setState(() {
                      _rangeValues = values;
                    });
                  },
                  activeColor: AppColors.primaryCoral,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('LYD ${_rangeValues.start.round()}'),
                    Text('LYD ${_rangeValues.end.round()}'),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_rangeValues.start, _rangeValues.end);
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Property Type Bottom Sheet
class _PropertyTypeBottomSheet extends StatefulWidget {
  final List<PropertyType> selectedTypes;
  final Function(List<PropertyType>) onApply;

  const _PropertyTypeBottomSheet({
    required this.selectedTypes,
    required this.onApply,
  });

  @override
  State<_PropertyTypeBottomSheet> createState() =>
      _PropertyTypeBottomSheetState();
}

class _PropertyTypeBottomSheetState extends State<_PropertyTypeBottomSheet> {
  late List<PropertyType> _selectedTypes;

  @override
  void initState() {
    super.initState();
    _selectedTypes = List.from(widget.selectedTypes);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Property Type',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ...PropertyType.values.map((type) {
                  return CheckboxListTile(
                    title: Text(type.displayName),
                    value: _selectedTypes.contains(type),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedTypes.add(type);
                        } else {
                          _selectedTypes.remove(type);
                        }
                      });
                    },
                    activeColor: AppColors.primaryCoral,
                  );
                }).toList(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_selectedTypes);
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Amenities Bottom Sheet
class _AmenitiesBottomSheet extends StatefulWidget {
  final List<String> selectedAmenities;
  final Function(List<String>) onApply;

  const _AmenitiesBottomSheet({
    required this.selectedAmenities,
    required this.onApply,
  });

  @override
  State<_AmenitiesBottomSheet> createState() => _AmenitiesBottomSheetState();
}

class _AmenitiesBottomSheetState extends State<_AmenitiesBottomSheet> {
  late List<String> _selectedAmenities;
  final List<String> _availableAmenities = [
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
    'Rooftop Terrace',
    'City View',
    'Concierge',
    'Gym',
    'Washing Machine',
    'Dishwasher',
    'TV',
    'Heating',
  ];

  @override
  void initState() {
    super.initState();
    _selectedAmenities = List.from(widget.selectedAmenities);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amenities',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: _availableAmenities.length,
                    itemBuilder: (context, index) {
                      final amenity = _availableAmenities[index];
                      final isSelected = _selectedAmenities.contains(amenity);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedAmenities.remove(amenity);
                            } else {
                              _selectedAmenities.add(amenity);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryCoral
                                : AppColors.gray50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryCoral
                                  : AppColors.gray200,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.gray600,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  amenity,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.gray700,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_selectedAmenities);
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Guests Bottom Sheet
class _GuestsBottomSheet extends StatefulWidget {
  final int currentGuests;
  final Function(int) onApply;

  const _GuestsBottomSheet({
    required this.currentGuests,
    required this.onApply,
  });

  @override
  State<_GuestsBottomSheet> createState() => _GuestsBottomSheetState();
}

class _GuestsBottomSheetState extends State<_GuestsBottomSheet> {
  late int _guests;

  @override
  void initState() {
    super.initState();
    _guests = widget.currentGuests;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Number of Guests',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _guests > 1
                          ? () => setState(() => _guests--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: _guests > 1
                          ? AppColors.primaryCoral
                          : AppColors.gray400,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      '$_guests',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: _guests < 20
                          ? () => setState(() => _guests++)
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                      color: _guests < 20
                          ? AppColors.primaryCoral
                          : AppColors.gray400,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_guests);
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Rating Bottom Sheet
class _RatingBottomSheet extends StatefulWidget {
  final int currentRating;
  final Function(int) onApply;

  const _RatingBottomSheet({
    required this.currentRating,
    required this.onApply,
  });

  @override
  State<_RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<_RatingBottomSheet> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.currentRating;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Minimum Rating',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => setState(() => _rating = index + 1),
                      child: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 40,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                Text(
                  _rating == 0 ? 'Any rating' : '$_rating+ stars',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_rating);
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
