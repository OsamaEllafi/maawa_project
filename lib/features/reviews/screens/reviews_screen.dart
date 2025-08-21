import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../demo/demo_data.dart';
import '../../../demo/models.dart';
import 'write_review_screen.dart';

class ReviewsScreen extends StatefulWidget {
  final String propertyId;

  const ReviewsScreen({
    super.key,
    required this.propertyId,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _selectedRating = 0; // 0 means all ratings
  String _sortBy = 'newest'; // newest, oldest, highest, lowest
  final List<String> _sortOptions = ['newest', 'oldest', 'highest', 'lowest'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final property = DemoData.getPropertyById(widget.propertyId);
    final allReviews = DemoData.getReviewsByProperty(widget.propertyId);
    final filteredReviews = _getFilteredReviews(allReviews);

    if (property == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reviews')),
        body: const Center(child: Text('Property not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gray700),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Reviews',
          style: TextStyle(
            color: AppColors.gray900,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 400 ? 18 : 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.primaryCoral),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Reviews Summary Card
          _buildReviewsSummary(property, allReviews, screenWidth),
          
          // Filter Chips
          _buildFilterChips(),
          
          // Reviews List
          Expanded(
            child: filteredReviews.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredReviews.length,
                    itemBuilder: (context, index) {
                      final review = filteredReviews[index];
                      final user = DemoData.getUserById(review.userId);
                      return _buildReviewCard(review, user, screenWidth);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSummary(DemoProperty property, List<DemoReview> reviews, double screenWidth) {
    final averageRating = reviews.isEmpty ? 0.0 : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
    final ratingCounts = _getRatingCounts(reviews);

    return Container(
      margin: const EdgeInsets.all(20),
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
        children: [
          Row(
            children: [
              // Average Rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: screenWidth < 400 ? 32 : 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${reviews.length} reviews',
                    style: TextStyle(
                      color: AppColors.gray600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Rating Breakdown
              Expanded(
                child: Column(
                  children: List.generate(5, (index) {
                    final rating = 5 - index;
                    final count = ratingCounts[rating] ?? 0;
                    final percentage = reviews.isEmpty ? 0.0 : (count / reviews.length) * 100;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            '$rating',
                            style: TextStyle(
                              color: AppColors.gray600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              backgroundColor: AppColors.gray200,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$count',
                            style: TextStyle(
                              color: AppColors.gray600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Write Review Button
          GradientButton(
            text: 'Write a Review',
            onPressed: _writeReview,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All', 0),
          _buildFilterChip('5★', 5),
          _buildFilterChip('4★', 4),
          _buildFilterChip('3★', 3),
          _buildFilterChip('2★', 2),
          _buildFilterChip('1★', 1),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int rating) {
    final isSelected = _selectedRating == rating;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRating = rating;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryCoral : AppColors.gray100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryCoral : AppColors.gray300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.gray700,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(DemoReview review, DemoUser? user, double screenWidth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info and Rating
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryCoral.withValues(alpha: 0.1),
                child: Text(
                  user?.name.substring(0, 1).toUpperCase() ?? 'U',
                  style: TextStyle(
                    color: AppColors.primaryCoral,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Anonymous User',
                      style: TextStyle(
                        color: AppColors.gray900,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < review.rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(review.createdAt),
                          style: TextStyle(
                            color: AppColors.gray600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Review Comment
          Text(
            review.comment,
            style: TextStyle(
              color: AppColors.gray800,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          // Helpful Button
          Row(
            children: [
              GestureDetector(
                onTap: () => _markHelpful(review.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.thumb_up_outlined,
                        size: 16,
                        color: AppColors.gray600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Helpful',
                        style: TextStyle(
                          color: AppColors.gray600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_vert, color: AppColors.gray500),
                onPressed: () => _showReviewOptions(review),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review,
            size: 64,
            color: AppColors.gray400,
          ),
          const SizedBox(height: 16),
          Text(
            'No reviews yet',
            style: TextStyle(
              color: AppColors.gray600,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share your experience!',
            style: TextStyle(
              color: AppColors.gray500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GradientButton(
            text: 'Write First Review',
            onPressed: _writeReview,
            width: 200,
          ),
        ],
      ),
    );
  }

  Map<int, int> _getRatingCounts(List<DemoReview> reviews) {
    final counts = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      counts[i] = reviews.where((r) => r.rating == i).length;
    }
    return counts;
  }

  List<DemoReview> _getFilteredReviews(List<DemoReview> reviews) {
    var filtered = reviews;
    
    // Filter by rating
    if (_selectedRating > 0) {
      filtered = filtered.where((r) => r.rating == _selectedRating).toList();
    }
    
    // Sort reviews
    switch (_sortBy) {
      case 'newest':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'highest':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'lowest':
        filtered.sort((a, b) => a.rating.compareTo(b.rating));
        break;
    }
    
    return filtered;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Action Methods
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Reviews'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _sortOptions.map((option) {
            return RadioListTile<String>(
              title: Text(option.capitalize()),
              value: option,
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _writeReview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteReviewScreen(
          propertyId: widget.propertyId,
        ),
      ),
    );
  }

  void _markHelpful(String reviewId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Marked as helpful!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showReviewOptions(DemoReview review) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Report Review'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Review reported'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Review'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sharing review...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
