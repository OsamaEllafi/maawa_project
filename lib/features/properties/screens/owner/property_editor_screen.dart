import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../demo/demo_data.dart';
import '../../../../demo/models.dart';

class PropertyEditorScreen extends StatefulWidget {
  final String? propertyId;

  const PropertyEditorScreen({
    super.key,
    this.propertyId,
  });

  @override
  State<PropertyEditorScreen> createState() => _PropertyEditorScreenState();
}

class _PropertyEditorScreenState extends State<PropertyEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  final _capacityController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();

  PropertyType _selectedType = PropertyType.apartment;
  String _selectedCity = 'Tripoli';
  TimeOfDay _checkInTime = const TimeOfDay(hour: 15, minute: 0);
  TimeOfDay _checkOutTime = const TimeOfDay(hour: 11, minute: 0);
  
  final List<String> _selectedAmenities = [];
  final List<String> _availableAmenities = [
    'WiFi', 'Air Conditioning', 'Kitchen', 'Balcony', 'Security', 'Parking',
    'Private Pool', 'Garden', 'BBQ', 'Beach Access', 'Rooftop Terrace',
    'City View', 'Concierge', 'Gym', 'Washing Machine', 'Dishwasher', 'TV', 'Heating'
  ];

  final List<String> _libyanCities = [
    'Tripoli', 'Benghazi', 'Misrata', 'Tarhuna', 'Al Bayda', 'Zawiya', 'Zliten',
    'Ajdabiya', 'Tobruk', 'Sirte', 'Sabha', 'Gharyan', 'Derna', 'Marj', 'Bani Walid'
  ];

  bool _isLoading = false;
  DemoProperty? _existingProperty;

  @override
  void initState() {
    super.initState();
    _loadPropertyData();
  }

  void _loadPropertyData() {
    if (widget.propertyId != null) {
      _existingProperty = DemoData.getPropertyById(widget.propertyId!);
      if (_existingProperty != null) {
        _populateForm(_existingProperty!);
      }
    }
  }

  void _populateForm(DemoProperty property) {
    _titleController.text = property.title;
    _descriptionController.text = property.description;
    _addressController.text = property.location.address;
    _priceController.text = property.pricePerNight.toString();
    _capacityController.text = property.capacity.toString();
    _bedroomsController.text = property.bedrooms.toString();
    _bathroomsController.text = property.bathrooms.toString();
    
    _selectedType = property.type;
    _selectedCity = property.location.city;
    _selectedAmenities.addAll(property.amenities);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isEditing = widget.propertyId != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gray700),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEditing ? 'Edit Property' : 'Add Property',
          style: TextStyle(
            color: AppColors.gray900,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 400 ? 18 : 20,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _previewProperty,
            child: Text(
              'Preview',
              style: TextStyle(
                color: AppColors.primaryCoral,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: _saveDraft,
            child: Text(
              'Save Draft',
              style: TextStyle(
                color: AppColors.primaryCoral,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Section
              _buildSectionHeader('Basic Information'),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _titleController,
                label: 'Property Title',
                hint: 'Enter an attractive title for your property',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a property title';
                  }
                  if (value.trim().length < 10) {
                    return 'Title should be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe your property in detail...',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.trim().length < 50) {
                    return 'Description should be at least 50 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Property Type
              _buildDropdown<PropertyType>(
                label: 'Property Type',
                value: _selectedType,
                items: PropertyType.values,
                onChanged: (value) => setState(() => _selectedType = value!),
                itemBuilder: (type) => type.displayName,
              ),
              const SizedBox(height: 24),

              // Location Section
              _buildSectionHeader('Location'),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _addressController,
                label: 'Street Address',
                hint: 'Enter the full address',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildDropdown<String>(
                label: 'City',
                value: _selectedCity,
                items: _libyanCities,
                onChanged: (value) => setState(() => _selectedCity = value!),
                itemBuilder: (city) => city,
              ),
              const SizedBox(height: 24),

              // Property Details Section
              _buildSectionHeader('Property Details'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(
                      controller: _capacityController,
                      label: 'Max Guests',
                      hint: '1-20',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildNumberField(
                      controller: _bedroomsController,
                      label: 'Bedrooms',
                      hint: '0-10',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildNumberField(
                      controller: _bathroomsController,
                      label: 'Bathrooms',
                      hint: '1-10',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Pricing Section
              _buildSectionHeader('Pricing'),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _priceController,
                label: 'Price per Night (LYD)',
                hint: 'Enter price in Libyan Dinars',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the price';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Please enter a valid price';
                  }
                  if (price > 10000) {
                    return 'Price seems too high';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Check-in/Check-out Times
              _buildSectionHeader('Check-in & Check-out'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTimeSelector(
                      label: 'Check-in Time',
                      time: _checkInTime,
                      onTap: () => _selectTime(true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimeSelector(
                      label: 'Check-out Time',
                      time: _checkOutTime,
                      onTap: () => _selectTime(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Amenities Section
              _buildSectionHeader('Amenities'),
              const SizedBox(height: 16),

              _buildAmenitiesSelector(),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saveDraft,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryCoral),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save as Draft',
                        style: TextStyle(
                          color: AppColors.primaryCoral,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GradientButton(
                      text: isEditing ? 'Update Property' : 'Submit for Review',
                      isLoading: _isLoading,
                      onPressed: _submitProperty,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.gray900,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryCoral, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        final num = int.tryParse(value);
        if (num == null || num <= 0) {
          return 'Invalid';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryCoral, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) itemBuilder,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryCoral, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemBuilder(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColors.gray600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time.format(context),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select amenities available in your property:',
          style: TextStyle(
            color: AppColors.gray600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableAmenities.map((amenity) {
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryCoral : AppColors.gray50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryCoral : AppColors.gray300,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      size: 16,
                      color: isSelected ? Colors.white : AppColors.gray600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      amenity,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.gray700,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _selectTime(bool isCheckIn) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: isCheckIn ? _checkInTime : _checkOutTime,
    );
    
    if (selectedTime != null) {
      setState(() {
        if (isCheckIn) {
          _checkInTime = selectedTime;
        } else {
          _checkOutTime = selectedTime;
        }
      });
    }
  }

  Future<void> _previewProperty() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields to preview'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Show preview dialog
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Property Preview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mock property image
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(Icons.image, size: 48, color: AppColors.gray400),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Property title
                      Text(
                        _titleController.text,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Location
                      Row(
                        children: [
                          Icon(Icons.location_on, color: AppColors.gray600, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${_addressController.text}, $_selectedCity',
                            style: TextStyle(color: AppColors.gray600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Property details
                      Row(
                        children: [
                          _buildPreviewDetail(Icons.people_outline, '${_capacityController.text} guests'),
                          const SizedBox(width: 16),
                          _buildPreviewDetail(Icons.bed_outlined, '${_bedroomsController.text} beds'),
                          const SizedBox(width: 16),
                          _buildPreviewDetail(Icons.bathtub_outlined, '${_bathroomsController.text} baths'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Price
                      Text(
                        '${_priceController.text} LYD / night',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryCoral,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(_descriptionController.text),
                      const SizedBox(height: 16),
                      
                      // Amenities
                      if (_selectedAmenities.isNotEmpty) ...[
                        Text(
                          'Amenities',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedAmenities.map((amenity) => 
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.gray100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                amenity,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.gray600),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: AppColors.gray600)),
      ],
    );
  }

  Future<void> _saveDraft() async {
    // Mock saving as draft
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.save_outlined, color: Colors.white),
            SizedBox(width: 8),
            Text('Property saved as draft'),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _submitProperty() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedAmenities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one amenity'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Mock submission
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.propertyId != null 
                      ? 'Property updated successfully' 
                      : 'Property submitted for review',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate back
      context.pop();
    }
  }
}
