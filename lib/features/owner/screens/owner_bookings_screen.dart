import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/bookings/entities/booking.dart';

class OwnerBookingsScreen extends StatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends State<OwnerBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  List<Booking> _pendingBookings = [];
  List<Booking> _activeBookings = [];
  List<Booking> _completedBookings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    try {
      final pending = await ServiceLocator().bookingsRepository.getOwnerBookings(status: 'pending');
      final active = await ServiceLocator().bookingsRepository.getOwnerBookings(status: 'accepted');
      final completed = await ServiceLocator().bookingsRepository.getOwnerBookings(status: 'completed');

      setState(() {
        _pendingBookings = pending;
        _activeBookings = active;
        _completedBookings = completed;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading bookings: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _acceptBooking(Booking booking) async {
    final notes = await _showNotesDialog('Accept Booking');
    if (notes == null) return;

    setState(() => _isLoading = true);
    try {
      await ServiceLocator().bookingsRepository.acceptBooking(booking.uuid, notes);
      await _loadBookings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking accepted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accepting booking: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _rejectBooking(Booking booking) async {
    final notes = await _showNotesDialog('Reject Booking');
    if (notes == null) return;

    setState(() => _isLoading = true);
    try {
      await ServiceLocator().bookingsRepository.rejectBooking(booking.uuid, notes);
      await _loadBookings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking rejected successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting booking: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _completeBooking(Booking booking) async {
    final notes = await _showNotesDialog('Complete Booking');
    if (notes == null) return;

    setState(() => _isLoading = true);
    try {
      await ServiceLocator().bookingsRepository.completeBooking(booking.uuid, notes);
      await _loadBookings();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking completed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error completing booking: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<String?> _showNotesDialog(String title) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            hintText: 'Add any notes about this action...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryCoral,
          labelColor: AppColors.primaryCoral,
          unselectedLabelColor: AppColors.gray500,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _loadBookings,
            icon: Icon(Icons.refresh, color: AppColors.primaryCoral),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildBookingsList(_pendingBookings, _buildPendingBookingCard),
                _buildBookingsList(_activeBookings, _buildActiveBookingCard),
                _buildBookingsList(_completedBookings, _buildCompletedBookingCard),
              ],
            ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, Widget Function(Booking) cardBuilder) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_online_outlined,
              size: 64,
              color: AppColors.gray400,
            ),
            const SizedBox(height: 16),
            Text(
              'No Bookings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.gray600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You don\'t have any bookings in this category',
              style: TextStyle(
                color: AppColors.gray500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: cardBuilder(booking),
          );
        },
      ),
    );
  }

  Widget _buildPendingBookingCard(Booking booking) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (booking.propertyImageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      booking.propertyImageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: AppColors.gray200,
                        child: Icon(Icons.image, color: AppColors.gray400),
                      ),
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.propertyTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.propertyAddress,
                        style: TextStyle(
                          color: AppColors.gray600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${booking.nights} nights • ${booking.totalAmountDisplay}',
                        style: TextStyle(
                          color: AppColors.gray500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: AppColors.gray500),
                const SizedBox(width: 8),
                Text(
                  booking.tenantName,
                  style: TextStyle(
                    color: AppColors.gray600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppColors.gray500),
                const SizedBox(width: 8),
                Text(
                  '${booking.checkinDate.toString().split(' ')[0]} - ${booking.checkoutDate.toString().split(' ')[0]}',
                  style: TextStyle(
                    color: AppColors.gray600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _rejectBooking(booking),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _acceptBooking(booking),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCoral,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveBookingCard(Booking booking) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (booking.propertyImageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      booking.propertyImageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: AppColors.gray200,
                        child: Icon(Icons.image, color: AppColors.gray400),
                      ),
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.propertyTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.propertyAddress,
                        style: TextStyle(
                          color: AppColors.gray600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${booking.nights} nights • ${booking.totalAmountDisplay}',
                        style: TextStyle(
                          color: AppColors.gray500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: AppColors.gray500),
                const SizedBox(width: 8),
                Text(
                  booking.tenantName,
                  style: TextStyle(
                    color: AppColors.gray600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppColors.gray500),
                const SizedBox(width: 8),
                Text(
                  '${booking.checkinDate.toString().split(' ')[0]} - ${booking.checkoutDate.toString().split(' ')[0]}',
                  style: TextStyle(
                    color: AppColors.gray600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _completeBooking(booking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Mark as Completed'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedBookingCard(Booking booking) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (booking.propertyImageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      booking.propertyImageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: AppColors.gray200,
                        child: Icon(Icons.image, color: AppColors.gray400),
                      ),
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.propertyTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.propertyAddress,
                        style: TextStyle(
                          color: AppColors.gray600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${booking.nights} nights • ${booking.totalAmountDisplay}',
                        style: TextStyle(
                          color: AppColors.gray500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Completed',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: AppColors.gray500),
                const SizedBox(width: 8),
                Text(
                  booking.tenantName,
                  style: TextStyle(
                    color: AppColors.gray600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppColors.gray500),
                const SizedBox(width: 8),
                Text(
                  '${booking.checkinDate.toString().split(' ')[0]} - ${booking.checkoutDate.toString().split(' ')[0]}',
                  style: TextStyle(
                    color: AppColors.gray600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            if (booking.completedAt != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.check_circle, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Completed on ${booking.completedAt!.toString().split(' ')[0]}',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
