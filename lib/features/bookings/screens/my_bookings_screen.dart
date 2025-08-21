import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../demo/demo_data.dart';
import '../../../demo/models.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Timer? _countdownTimer;
  final Map<String, Duration> _countdowns = {};

  final List<BookingStatus> _statusTabs = [
    BookingStatus.requested,
    BookingStatus.pendingPayment,
    BookingStatus.confirmed,
    BookingStatus.completed,
    BookingStatus.cancelled,
    BookingStatus.expired,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
    _initializeCountdowns();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _initializeCountdowns() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUser = authService.currentUser!;
    final bookings = DemoData.getBookingsForUser(currentUser.id);

    for (final booking in bookings) {
      if (booking.status == BookingStatus.pendingPayment &&
          booking.paymentDueAt != null) {
        final remaining = booking.paymentDueAt!.difference(DateTime.now());
        if (remaining.isNegative) {
          _countdowns[booking.id] = Duration.zero;
        } else {
          _countdowns[booking.id] = remaining;
        }
      }
    }
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdowns.updateAll((key, value) {
          if (value.inSeconds > 0) {
            return Duration(seconds: value.inSeconds - 1);
          }
          return Duration.zero;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.currentUser!;
    final allBookings = DemoData.getBookingsForUser(currentUser.id);

    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: ThemeColors.getAppBarBackground(context),
        elevation: 0,
        title: Text(
          'My Bookings',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 400 ? 18 : 20,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primaryCoral,
          unselectedLabelColor: AppColors.gray600,
          indicatorColor: AppColors.primaryCoral,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          tabs: _statusTabs.map((status) {
            final count = allBookings.where((b) => b.status == status).length;
            return Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_getStatusDisplayName(status)),
                  if (count > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: _getStatusColor(status),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _statusTabs.map((status) {
          final bookings = allBookings
              .where((b) => b.status == status)
              .toList();
          return _buildBookingsList(bookings, status);
        }).toList(),
      ),
    );
  }

  Widget _buildBookingsList(List<DemoBooking> bookings, BookingStatus status) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (bookings.isEmpty) {
      return _buildEmptyState(status);
    }

    return ListView.builder(
      padding: EdgeInsets.all(screenWidth * 0.06),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildEmptyState(BookingStatus status) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getStatusIcon(status),
                size: 60,
                color: AppColors.gray400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _getEmptyStateTitle(status),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.gray700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _getEmptyStateSubtitle(status),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.gray500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(DemoBooking booking) {
    final screenWidth = MediaQuery.of(context).size.width;
    final property = DemoData.getPropertyById(booking.propertyId);

    if (property == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property image and status
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  child: Image.network(
                    property.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.gray100,
                        child: const Center(child: Icon(Icons.home, size: 48)),
                      );
                    },
                  ),
                ),
                // Status badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      booking.status.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Countdown timer for pending payment
                if (booking.status == BookingStatus.pendingPayment) ...[
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _buildCountdownTimer(booking),
                  ),
                ],
              ],
            ),
          ),

          // Booking details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property title
                Text(
                  property.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth < 400 ? 16 : 18,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Location
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
                const SizedBox(height: 12),

                // Timeline
                _buildBookingTimeline(booking),
                const SizedBox(height: 16),

                // Booking info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        'Check-in',
                        '${booking.checkIn.day}/${booking.checkIn.month}',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Check-out',
                        '${booking.checkOut.day}/${booking.checkOut.month}',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('Guests', '${booking.guests}'),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Total',
                        '${booking.totalAmount} ${booking.currency}',
                      ),
                    ],
                  ),
                ),

                if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryCoral.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.note_outlined,
                          color: AppColors.primaryCoral,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            booking.notes!,
                            style: TextStyle(
                              color: AppColors.gray700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Action buttons
                const SizedBox(height: 16),
                _buildActionButtons(booking),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownTimer(DemoBooking booking) {
    final countdown = _countdowns[booking.id] ?? Duration.zero;
    final isExpired = countdown.inSeconds <= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isExpired ? AppColors.error : Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExpired ? Icons.timer_off : Icons.timer,
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            isExpired
                ? 'Expired'
                : '${countdown.inMinutes}:${(countdown.inSeconds % 60).toString().padLeft(2, '0')}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingTimeline(DemoBooking booking) {
    final steps = _getTimelineSteps(booking);

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: step.isCompleted
                        ? AppColors.primaryCoral
                        : AppColors.gray300,
                    shape: BoxShape.circle,
                  ),
                  child: step.isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 12)
                      : Container(),
                ),
                if (!isLast) ...[
                  Container(width: 2, height: 24, color: AppColors.gray200),
                ],
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: step.isCompleted
                          ? AppColors.gray900
                          : AppColors.gray600,
                      fontSize: 14,
                    ),
                  ),
                  if (step.subtitle != null) ...[
                    Text(
                      step.subtitle!,
                      style: TextStyle(color: AppColors.gray500, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.gray600, fontSize: 14)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActionButtons(DemoBooking booking) {
    switch (booking.status) {
      case BookingStatus.requested:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _cancelBooking(booking),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.error),
                  foregroundColor: AppColors.error,
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _viewBookingDetails(booking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCoral,
                  foregroundColor: Colors.white,
                ),
                child: const Text('View Details'),
              ),
            ),
          ],
        );
      case BookingStatus.pendingPayment:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _cancelBooking(booking),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.error),
                  foregroundColor: AppColors.error,
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _makePayment(booking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.getSnackBarSuccess(context),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Pay Now'),
              ),
            ),
          ],
        );
      case BookingStatus.confirmed:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _viewBookingDetails(booking),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCoral,
              foregroundColor: Colors.white,
            ),
            child: const Text('View Details'),
          ),
        );
      case BookingStatus.completed:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _writeReview(booking),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryCoral),
                  foregroundColor: AppColors.primaryCoral,
                ),
                child: const Text('Write Review'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _bookAgain(booking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCoral,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Book Again'),
              ),
            ),
          ],
        );
      default:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _viewBookingDetails(booking),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.gray400),
              foregroundColor: AppColors.gray600,
            ),
            child: const Text('View Details'),
          ),
        );
    }
  }

  List<TimelineStep> _getTimelineSteps(DemoBooking booking) {
    final steps = <TimelineStep>[
      TimelineStep(
        title: 'Booking Requested',
        subtitle: 'Waiting for host approval',
        isCompleted: true,
      ),
    ];

    if (booking.status == BookingStatus.pendingPayment ||
        booking.status == BookingStatus.confirmed ||
        booking.status == BookingStatus.completed) {
      steps.add(
        TimelineStep(
          title: 'Approved by Host',
          subtitle: 'Payment required within 30 minutes',
          isCompleted: true,
        ),
      );
    }

    if (booking.status == BookingStatus.confirmed ||
        booking.status == BookingStatus.completed) {
      steps.add(
        TimelineStep(
          title: 'Payment Completed',
          subtitle: 'Booking confirmed',
          isCompleted: true,
        ),
      );
    }

    if (booking.status == BookingStatus.completed) {
      steps.add(
        TimelineStep(
          title: 'Stay Completed',
          subtitle: 'Hope you enjoyed your stay!',
          isCompleted: true,
        ),
      );
    }

    return steps;
  }

  String _getStatusDisplayName(BookingStatus status) {
    switch (status) {
      case BookingStatus.requested:
        return 'Requested';
      case BookingStatus.pendingPayment:
        return 'Payment';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.expired:
        return 'Expired';
    }
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.requested:
        return Colors.blue;
      case BookingStatus.pendingPayment:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.completed:
        return AppColors.primaryCoral;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.expired:
        return AppColors.gray500;
    }
  }

  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.requested:
        return Icons.pending_actions;
      case BookingStatus.pendingPayment:
        return Icons.payment;
      case BookingStatus.confirmed:
        return Icons.check_circle;
      case BookingStatus.completed:
        return Icons.verified;
      case BookingStatus.cancelled:
        return Icons.cancel;
      case BookingStatus.expired:
        return Icons.timer_off;
    }
  }

  String _getEmptyStateTitle(BookingStatus status) {
    switch (status) {
      case BookingStatus.requested:
        return 'No pending requests';
      case BookingStatus.pendingPayment:
        return 'No payments due';
      case BookingStatus.confirmed:
        return 'No confirmed bookings';
      case BookingStatus.completed:
        return 'No completed stays';
      case BookingStatus.cancelled:
        return 'No cancelled bookings';
      case BookingStatus.expired:
        return 'No expired bookings';
    }
  }

  String _getEmptyStateSubtitle(BookingStatus status) {
    switch (status) {
      case BookingStatus.requested:
        return 'Your booking requests will appear here';
      case BookingStatus.pendingPayment:
        return 'Approved bookings requiring payment will appear here';
      case BookingStatus.confirmed:
        return 'Your confirmed bookings will appear here';
      case BookingStatus.completed:
        return 'Your past stays will appear here';
      case BookingStatus.cancelled:
        return 'Cancelled bookings will appear here';
      case BookingStatus.expired:
        return 'Expired payment bookings will appear here';
    }
  }

  void _cancelBooking(DemoBooking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking cancelled'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  void _makePayment(DemoBooking booking) {
          ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Payment processed successfully'),
          backgroundColor: ThemeColors.getSnackBarSuccess(context),
        ),
      );
  }

  void _viewBookingDetails(DemoBooking booking) {
    context.push('/booking-details/${booking.id}');
  }

  void _writeReview(DemoBooking booking) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Opening review form...')));
  }

  void _bookAgain(DemoBooking booking) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Creating new booking...')));
  }
}

class TimelineStep {
  final String title;
  final String? subtitle;
  final bool isCompleted;

  TimelineStep({required this.title, this.subtitle, required this.isCompleted});
}
