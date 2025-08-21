import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../demo/demo_data.dart';
import '../../../demo/models.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  Timer? _countdownTimer;
  Duration? _countdown;

  @override
  void initState() {
    super.initState();
    _initializeCountdown();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _initializeCountdown() {
    final booking = DemoData.getBookingById(widget.bookingId);
    if (booking?.status == BookingStatus.pendingPayment &&
        booking?.paymentDueAt != null) {
      final remaining = booking!.paymentDueAt!.difference(DateTime.now());
      _countdown = remaining.isNegative ? Duration.zero : remaining;
    }
  }

  void _startCountdownTimer() {
    if (_countdown != null) {
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            if (_countdown!.inSeconds > 0) {
              _countdown = Duration(seconds: _countdown!.inSeconds - 1);
            } else {
              _countdown = Duration.zero;
              timer.cancel();
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final booking = DemoData.getBookingById(widget.bookingId);
    final property = booking != null
        ? DemoData.getPropertyById(booking.propertyId)
        : null;

    if (booking == null || property == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking Not Found')),
        body: const Center(child: Text('Booking not found')),
      );
    }

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
          'Booking Details',
          style: TextStyle(
            color: AppColors.gray900,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 400 ? 18 : 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.primaryCoral),
            onPressed: _shareBooking,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Status Card
            _buildStatusCard(booking),
            const SizedBox(height: 24),

            // Countdown Timer (if applicable)
            if (booking.status == BookingStatus.pendingPayment &&
                _countdown != null) ...[
              _buildCountdownCard(),
              const SizedBox(height: 24),
            ],

            // Property Details
            _buildPropertyCard(property, booking),
            const SizedBox(height: 24),

            // Booking Timeline
            _buildTimelineCard(booking),
            const SizedBox(height: 24),

            // Booking Details
            _buildBookingDetailsCard(booking),
            const SizedBox(height: 24),

            // Payment Details
            _buildPaymentCard(booking),
            const SizedBox(height: 32),

            // Action Buttons
            _buildActionButtons(booking),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(DemoBooking booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStatusColor(booking.status).withValues(alpha: 0.1),
            _getStatusColor(booking.status).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(booking.status).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getStatusColor(booking.status).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getStatusIcon(booking.status),
              color: _getStatusColor(booking.status),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusTitle(booking.status),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(booking.status),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusSubtitle(booking.status),
                  style: TextStyle(color: AppColors.gray600, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownCard() {
    final isExpired = _countdown!.inSeconds <= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isExpired
            ? AppColors.error.withValues(alpha: 0.1)
            : AppColors.primaryCoral.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpired
              ? AppColors.error.withValues(alpha: 0.3)
              : AppColors.primaryCoral.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                isExpired ? Icons.warning : Icons.timer,
                color: isExpired ? AppColors.error : AppColors.primaryCoral,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isExpired ? 'Payment Time Expired' : 'Payment Due',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isExpired ? AppColors.error : AppColors.primaryCoral,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!isExpired) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeUnit(_countdown!.inHours.toString(), 'Hours'),
                _buildTimeSeparator(),
                _buildTimeUnit(
                  '${(_countdown!.inMinutes % 60).toString().padLeft(2, '0')}',
                  'Minutes',
                ),
                _buildTimeSeparator(),
                _buildTimeUnit(
                  '${(_countdown!.inSeconds % 60).toString().padLeft(2, '0')}',
                  'Seconds',
                ),
              ],
            ),
            const SizedBox(height: 16),
            GradientButton(
              text: 'Pay Now',
              onPressed: _makePayment,
              width: double.infinity,
            ),
          ] else ...[
            Text(
              'Your payment time has expired. Please contact support.',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryCoral,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: AppColors.gray600, fontSize: 12)),
      ],
    );
  }

  Widget _buildTimeSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        ':',
        style: TextStyle(
          color: AppColors.primaryCoral,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildPropertyCard(DemoProperty property, DemoBooking booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  property.images.first,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: AppColors.gray200,
                    child: const Icon(Icons.home, size: 40),
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
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                          color: AppColors.gray600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${property.location.city}, ${property.location.country}',
                            style: TextStyle(color: AppColors.gray600),
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
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildPropertyDetail(
                Icons.people_outline,
                '${booking.guests} guests',
              ),
              const SizedBox(width: 16),
              _buildPropertyDetail(
                Icons.bed_outlined,
                '${property.bedrooms} beds',
              ),
              const SizedBox(width: 16),
              _buildPropertyDetail(
                Icons.bathtub_outlined,
                '${property.bathrooms} baths',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.gray600),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: AppColors.gray600, fontSize: 14)),
      ],
    );
  }

  Widget _buildTimelineCard(DemoBooking booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Timeline',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildTimelineStep(
            'Booking Requested',
            booking.createdAt,
            true,
            Icons.schedule,
          ),
          if (booking.confirmedAt != null) ...[
            _buildTimelineStep(
              'Booking Confirmed',
              booking.confirmedAt!,
              true,
              Icons.check_circle,
            ),
          ],
          if (booking.status == BookingStatus.completed &&
              booking.completedAt != null) ...[
            _buildTimelineStep(
              'Stay Completed',
              booking.completedAt!,
              true,
              Icons.celebration,
            ),
          ],
          if (booking.status == BookingStatus.cancelled &&
              booking.cancelledAt != null) ...[
            _buildTimelineStep(
              'Booking Cancelled',
              booking.cancelledAt!,
              true,
              Icons.cancel,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineStep(
    String title,
    DateTime date,
    bool isCompleted,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.primaryCoral : AppColors.gray300,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isCompleted ? AppColors.gray900 : AppColors.gray600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                style: TextStyle(color: AppColors.gray500, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingDetailsCard(DemoBooking booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Details',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Booking ID', booking.id),
          _buildDetailRow(
            'Check-in',
            '${booking.checkIn.day}/${booking.checkIn.month}/${booking.checkIn.year}',
          ),
          _buildDetailRow(
            'Check-out',
            '${booking.checkOut.day}/${booking.checkOut.month}/${booking.checkOut.year}',
          ),
          _buildDetailRow('Nights', '${booking.nights}'),
          _buildDetailRow('Guests', '${booking.guests}'),
          if (booking.notes != null && booking.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildDetailRow('Notes', booking.notes!),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.gray600, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(DemoBooking booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Details',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'Total Amount',
            '${booking.totalAmount} ${booking.currency}',
          ),
          _buildDetailRow('Payment Status', _getPaymentStatus(booking.status)),
          if (booking.paymentDueAt != null) ...[
            _buildDetailRow(
              'Payment Due',
              '${booking.paymentDueAt!.day}/${booking.paymentDueAt!.month}/${booking.paymentDueAt!.year}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(DemoBooking booking) {
    return Column(
      children: [
        if (booking.status == BookingStatus.pendingPayment) ...[
          GradientButton(
            text: 'Make Payment',
            onPressed: _makePayment,
            width: double.infinity,
          ),
          const SizedBox(height: 12),
        ],
        if (booking.status == BookingStatus.confirmed) ...[
          GradientButton(
            text: 'View Property Details',
            onPressed: () => context.push('/property/${booking.propertyId}'),
            width: double.infinity,
          ),
          const SizedBox(height: 12),
        ],
        if (booking.status == BookingStatus.completed) ...[
          GradientButton(
            text: 'Write a Review',
            onPressed: _writeReview,
            width: double.infinity,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _bookAgain,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primaryCoral),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Book Again',
              style: TextStyle(
                color: AppColors.primaryCoral,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        if (booking.status == BookingStatus.requested) ...[
          OutlinedButton(
            onPressed: _cancelBooking,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel Booking',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // Helper methods
  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.requested:
        return Colors.orange;
      case BookingStatus.pendingPayment:
        return AppColors.primaryCoral;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.completed:
        return Colors.blue;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.expired:
        return AppColors.gray600;
    }
  }

  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.requested:
        return Icons.schedule;
      case BookingStatus.pendingPayment:
        return Icons.payment;
      case BookingStatus.confirmed:
        return Icons.check_circle;
      case BookingStatus.completed:
        return Icons.celebration;
      case BookingStatus.cancelled:
        return Icons.cancel;
      case BookingStatus.expired:
        return Icons.timer_off;
    }
  }

  String _getStatusTitle(BookingStatus status) {
    switch (status) {
      case BookingStatus.requested:
        return 'Booking Requested';
      case BookingStatus.pendingPayment:
        return 'Payment Pending';
      case BookingStatus.confirmed:
        return 'Booking Confirmed';
      case BookingStatus.completed:
        return 'Stay Completed';
      case BookingStatus.cancelled:
        return 'Booking Cancelled';
      case BookingStatus.expired:
        return 'Booking Expired';
    }
  }

  String _getStatusSubtitle(BookingStatus status) {
    switch (status) {
      case BookingStatus.requested:
        return 'Waiting for host approval';
      case BookingStatus.pendingPayment:
        return 'Complete payment to confirm';
      case BookingStatus.confirmed:
        return 'Your booking is confirmed';
      case BookingStatus.completed:
        return 'Hope you enjoyed your stay!';
      case BookingStatus.cancelled:
        return 'This booking was cancelled';
      case BookingStatus.expired:
        return 'Payment time has expired';
    }
  }

  String _getPaymentStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.requested:
        return 'Pending';
      case BookingStatus.pendingPayment:
        return 'Payment Required';
      case BookingStatus.confirmed:
        return 'Paid';
      case BookingStatus.completed:
        return 'Paid';
      case BookingStatus.cancelled:
        return 'Refunded';
      case BookingStatus.expired:
        return 'Expired';
    }
  }

  // Action methods
  void _makePayment() {
    // Mock payment process
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Payment completed successfully!')),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    });
  }

  void _shareBooking() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing booking details...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _writeReview() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening review form...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _bookAgain() {
    final booking = DemoData.getBookingById(widget.bookingId);
    if (booking != null) {
      context.push('/booking-request/${booking.propertyId}');
    }
  }

  void _cancelBooking() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking cancelled successfully'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
