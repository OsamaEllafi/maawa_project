import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/properties/entities/property.dart';
import '../../../domain/properties/properties_repository.dart';

class OwnerPropertyEditScreen extends StatefulWidget {
  final String? propertyId; // null for create, non-null for edit

  const OwnerPropertyEditScreen({super.key, this.propertyId});

  @override
  State<OwnerPropertyEditScreen> createState() => _OwnerPropertyEditScreenState();
}

class _OwnerPropertyEditScreenState extends State<OwnerPropertyEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  final _capacityController = TextEditingController();
  final _checkinTimeController = TextEditingController();
  final _checkoutTimeController = TextEditingController();

  PropertyType _selectedType = PropertyType.apartment;
  List<String> _selectedAmenities = [];
  bool _isLoading = false;
  Property? _property;

  final List<String> _availableAmenities = [
    'WiFi',
    'Air Conditioning',
    'Kitchen',
    'Washing Machine',
    'TV',
    'Parking',
    'Garden',
    'Balcony',
    'Pool',
    'Gym',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.propertyId != null) {
      _loadProperty();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    _checkinTimeController.dispose();
    _checkoutTimeController.dispose();
    super.dispose();
  }

  Future<void> _loadProperty() async {
    if (widget.propertyId == null) return;

    setState(() => _isLoading = true);
    try {
      final property = await ServiceLocator().propertiesRepository.getOwnerProperty(widget.propertyId!);
      setState(() {
        _property = property;
        _titleController.text = property.title;
        _descriptionController.text = property.description;
        _addressController.text = property.address;
        _priceController.text = property.pricePerNight.toString();
        _capacityController.text = property.capacity.toString();
        _checkinTimeController.text = property.checkinTime;
        _checkoutTimeController.text = property.checkoutTime;
        _selectedType = property.type;
        _selectedAmenities = List.from(property.amenities);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading property: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProperty() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final capacity = int.tryParse(_capacityController.text) ?? 1;

      if (widget.propertyId == null) {
        // Create new property
        await ServiceLocator().propertiesRepository.createProperty(
          title: _titleController.text,
          description: _descriptionController.text,
          type: _selectedType.name,
          address: _addressController.text,
          pricePerNight: price,
          capacity: capacity,
          amenities: _selectedAmenities,
          checkinTime: _checkinTimeController.text,
          checkoutTime: _checkoutTimeController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Property created successfully')),
        );
      } else {
        // Update existing property
        await ServiceLocator().propertiesRepository.updateProperty(
          widget.propertyId!,
          title: _titleController.text,
          description: _descriptionController.text,
          type: _selectedType.name,
          address: _addressController.text,
          pricePerNight: price,
          capacity: capacity,
          amenities: _selectedAmenities,
          checkinTime: _checkinTimeController.text,
          checkoutTime: _checkoutTimeController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Property updated successfully')),
        );
      }

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving property: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: ThemeColors.getAppBarBackground(context),
        elevation: 0,
        title: Text(
          widget.propertyId == null ? 'Create Property' : 'Edit Property',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColors.getGray700(context)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _saveProperty,
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppColors.primaryCoral,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading && widget.propertyId != null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(),
                    const SizedBox(height: 24),
                    _buildPropertyDetailsSection(),
                    const SizedBox(height: 24),
                    _buildAmenitiesSection(),
                    const SizedBox(height: 24),
                    _buildTimingSection(),
                    const SizedBox(height: 32),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveProperty,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryCoral,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            widget.propertyId == null ? 'Create Property' : 'Update Property',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ThemeColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Property Title',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a property title';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPropertyDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ThemeColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<PropertyType>(
          value: _selectedType,
          decoration: InputDecoration(
            labelText: 'Property Type',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: PropertyType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type.name.toUpperCase()),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedType = value);
            }
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price per Night (LYD)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _capacityController,
                decoration: InputDecoration(
                  labelText: 'Capacity',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter capacity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amenities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ThemeColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableAmenities.map((amenity) {
            final isSelected = _selectedAmenities.contains(amenity);
            return FilterChip(
              label: Text(amenity),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAmenities.add(amenity);
                  } else {
                    _selectedAmenities.remove(amenity);
                  }
                });
              },
              selectedColor: AppColors.primaryCoral.withValues(alpha: 0.2),
              checkmarkColor: AppColors.primaryCoral,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Check-in/Check-out Times',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ThemeColors.getTextPrimary(context),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _checkinTimeController,
                decoration: InputDecoration(
                  labelText: 'Check-in Time',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintText: 'e.g., 14:00',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter check-in time';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _checkoutTimeController,
                decoration: InputDecoration(
                  labelText: 'Check-out Time',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintText: 'e.g., 11:00',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter check-out time';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
