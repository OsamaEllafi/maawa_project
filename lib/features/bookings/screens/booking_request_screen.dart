import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/di/service_locator.dart';
import '../../../demo/demo_data.dart';
import '../../../demo/models.dart';

class BookingRequestScreen extends StatefulWidget {
  final String propertyId;

  const BookingRequestScreen({super.key, required this.propertyId});

  @override
  State<BookingRequestScreen> createState() => _BookingRequestScreenState();
}

class _BookingRequestScreenState extends State<BookingRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guests = 1;
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final property = DemoData.getPropertyById(widget.propertyId);
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser!;

    if (property == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Property Not Found')),
        body: const Center(child: Text('Property not found')),
      );
    }

    final nights = _checkInDate != null && _checkOutDate != null
        ? _checkOutDate!.difference(_checkInDate!).inDays
        : 0;
    final totalAmount = nights * property.pricePerNight;

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
          'Book Property',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 400 ? 18 : 20,
          ),
        ),
        centerTitle: true,
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
              // Property summary card
              _buildPropertySummary(property),
              const SizedBox(height: 24),

              // Date selection
              _buildSectionHeader('Select Dates'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildDateSelector(
                      label: 'Check-in',
                      date: _checkInDate,
                      onTap: () => _selectDate(true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateSelector(
                      label: 'Check-out',
                      date: _checkOutDate,
                      onTap: () => _selectDate(false),
                    ),
                  ),
                ],
              ),

              if (nights > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCoral.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.primaryCoral,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$nights night${nights > 1 ? 's' : ''}',
                        style: TextStyle(
                          color: AppColors.primaryCoral,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Guest selection
              _buildSectionHeader('Guests'),
              const SizedBox(height: 16),

              _buildGuestSelector(property.capacity),
              const SizedBox(height: 24),

              // Special requests
              _buildSectionHeader('Special Requests (Optional)'),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                maxLines: 4,
                                 decoration: InputDecoration(
                   hintText: 'Any special requests or notes for the host...',
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(12),
                     borderSide: BorderSide(color: ThemeColors.getBorder(context)),
                   ),
                   enabledBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(12),
                     borderSide: BorderSide(color: ThemeColors.getBorder(context)),
                   ),
                   focusedBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(12),
                     borderSide: BorderSide(
                       color: AppColors.primaryCoral,
                       width: 2,
                     ),
                   ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 32),

              // Booking summary
              if (_checkInDate != null && _checkOutDate != null) ...[
                _buildBookingSummary(property, nights, totalAmount),
                const SizedBox(height: 32),
              ],

              // Submit button
              GradientButton(
                text: 'Request Booking',
                isLoading: _isLoading,
                onPressed: _canSubmit() ? _submitBookingRequest : null,
                width: double.infinity,
              ),

              const SizedBox(height: 16),

              // Terms note
                             Text(
                 'By requesting this booking, you agree to the host\'s house rules and cancellation policy.',
                 style: Theme.of(
                   context,
                 ).textTheme.bodySmall?.copyWith(color: ThemeColors.getGray600(context)),
                 textAlign: TextAlign.center,
               ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertySummary(DemoProperty property) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeColors.getGray50(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.getBorder(context)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              child: Image.network(
                property.images.first,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: ThemeColors.getGray200(context),
                    child: const Icon(Icons.home, size: 40),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: ThemeColors.getGray600(context),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${property.location.city}, ${property.location.country}',
                        style: TextStyle(
                          color: ThemeColors.getGray600(context),
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${property.rating} (${property.reviewCount} reviews)',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: ThemeColors.getTextPrimary(context),
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: ThemeColors.getBorder(context)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: ThemeColors.getGray600(context),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryCoral,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    date != null
                        ? '${date.day}/${date.month}/${date.year}'
                        : 'Select date',
                                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
                       fontWeight: FontWeight.w600,
                       color: date != null
                           ? ThemeColors.getTextPrimary(context)
                           : ThemeColors.getGray500(context),
                     ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestSelector(int maxCapacity) {
    return Container(
      padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
         border: Border.all(color: ThemeColors.getBorder(context)),
         borderRadius: BorderRadius.circular(12),
       ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                                 Text(
                   'Guests',
                   style: TextStyle(
                     color: ThemeColors.getGray600(context),
                     fontSize: 12,
                     fontWeight: FontWeight.w500,
                   ),
                 ),
                const SizedBox(height: 4),
                Text(
                  '$_guests guest${_guests > 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                                 Text(
                   'Max $maxCapacity guests',
                   style: TextStyle(color: ThemeColors.getGray500(context), fontSize: 12),
                 ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                icon: const Icon(Icons.remove_circle_outline),
                                 color: _guests > 1 ? AppColors.primaryCoral : ThemeColors.getGray400(context),
              ),
              const SizedBox(width: 8),
              Text(
                '$_guests',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _guests < maxCapacity
                    ? () => setState(() => _guests++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
                                 color: _guests < maxCapacity
                     ? AppColors.primaryCoral
                     : ThemeColors.getGray400(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSummary(
    DemoProperty property,
    int nights,
    double totalAmount,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
             decoration: BoxDecoration(
         color: ThemeColors.getGray50(context),
         borderRadius: BorderRadius.circular(16),
         border: Border.all(color: ThemeColors.getBorder(context)),
       ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Summary',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _buildSummaryRow(
            'Check-in',
            '${_checkInDate!.day}/${_checkInDate!.month}/${_checkInDate!.year}',
          ),
          _buildSummaryRow(
            'Check-out',
            '${_checkOutDate!.day}/${_checkOutDate!.month}/${_checkOutDate!.year}',
          ),
          _buildSummaryRow('Guests', '$_guests'),
          _buildSummaryRow('Nights', '$nights'),

          const Divider(height: 24),

          _buildSummaryRow(
            '${property.pricePerNight} LYD × $nights night${nights > 1 ? 's' : ''}',
            '${totalAmount.toStringAsFixed(0)} LYD',
          ),
          _buildSummaryRow(
            'Service fee',
            '${(totalAmount * 0.05).toStringAsFixed(0)} LYD',
          ),

          const Divider(height: 24),

          _buildSummaryRow(
            'Total',
            '${(totalAmount * 1.05).toStringAsFixed(0)} LYD',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
               color: isTotal ? ThemeColors.getTextPrimary(context) : ThemeColors.getGray700(context),
             ),
          ),
          Text(
            value,
                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
               fontWeight: FontWeight.bold,
               color: isTotal ? AppColors.primaryCoral : ThemeColors.getTextPrimary(context),
             ),
          ),
        ],
      ),
    );
  }

  bool _canSubmit() {
    return _checkInDate != null &&
        _checkOutDate != null &&
        _checkOutDate!.isAfter(_checkInDate!) &&
        _guests > 0;
  }

  Future<void> _selectDate(bool isCheckIn) async {
    final now = DateTime.now();
    final initialDate = isCheckIn
        ? (_checkInDate ?? now.add(const Duration(days: 1)))
        : (_checkOutDate ??
              (_checkInDate?.add(const Duration(days: 1)) ??
                  now.add(const Duration(days: 2))));

    final firstDate = isCheckIn ? now : (_checkInDate ?? now);
    final lastDate = now.add(const Duration(days: 365));

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
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
    );

    if (selectedDate != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = selectedDate;
          // Reset checkout if it's before or equal to checkin
          if (_checkOutDate != null &&
              _checkOutDate!.isBefore(
                selectedDate.add(const Duration(days: 1)),
              )) {
            _checkOutDate = null;
          }
        } else {
          _checkOutDate = selectedDate;
        }
      });
    }
  }

  Future<void> _submitBookingRequest() async {
    if (!_formKey.currentState!.validate() || !_canSubmit()) {
      return;
    }

    setState(() => _isLoading = true);

    // Mock API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);

      // Create new booking
      final property = DemoData.getPropertyById(widget.propertyId);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.currentUser!;

      if (property != null) {
        final nights = _checkOutDate!.difference(_checkInDate!).inDays;
        final totalAmount =
            nights * property.pricePerNight * 1.05; // Including service fee

        final newBooking = DemoBooking(
          id: 'book-${DateTime.now().millisecondsSinceEpoch}',
          propertyId: widget.propertyId,
          tenantId: currentUser.uuid,
          checkIn: _checkInDate!,
          checkOut: _checkOutDate!,
          guests: _guests,
          totalAmount: totalAmount,
          currency: property.currency,
          status: BookingStatus.requested,
          notes: _notesController.text.isNotEmpty
              ? _notesController.text
              : null,
          createdAt: DateTime.now(),
        );

        // Add booking to demo data
        DemoData.addBooking(newBooking);
      }

             // Show success message
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: const Row(
             children: [
               Icon(Icons.check_circle, color: Colors.white),
               SizedBox(width: 8),
               Expanded(child: Text('Booking request submitted successfully!')),
             ],
           ),
           backgroundColor: ThemeColors.getSnackBarSuccess(context),
           behavior: SnackBarBehavior.floating,
         ),
       );

      // Navigate to bookings screen
      context.go('/bookings/my');
    }
  }
}
