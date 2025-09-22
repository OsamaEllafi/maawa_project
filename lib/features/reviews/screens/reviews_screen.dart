import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/reviews/entities/review.dart';

class ReviewsScreen extends StatefulWidget {
  final String propertyUuid;
  final String propertyTitle;

  const ReviewsScreen({
    super.key,
    required this.propertyUuid,
    required this.propertyTitle,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  bool _isLoading = false;
  List<Review> _reviews = [];
  double _averageRating = 0.0;
  int _totalReviews = 0;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoading = true);
    try {
      final reviews = await ServiceLocator().reviewsRepository
          .getPropertyReviews(widget.propertyUuid);

      setState(() {
        _reviews = reviews;
        _totalReviews = reviews.length;
        if (reviews.isNotEmpty) {
          _averageRating =
              reviews.map((r) => r.rating).reduce((a, b) => a + b) /
              reviews.length;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading reviews: $e')));
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
          'Reviews',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadReviews,
            icon: Icon(Icons.refresh, color: AppColors.primaryCoral),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildReviewsHeader(),
                const SizedBox(height: 16),
                Expanded(child: _buildReviewsList()),
              ],
            ),
    );
  }

  Widget _buildReviewsHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            widget.propertyTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 32),
              const SizedBox(width: 8),
              Text(
                _averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryCoral,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$_totalReviews reviews',
            style: TextStyle(color: AppColors.gray600, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildRatingBreakdown(),
        ],
      ),
    );
  }

  Widget _buildRatingBreakdown() {
    final ratingCounts = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      ratingCounts[i] = _reviews.where((r) => r.rating == i).length;
    }

    return Column(
      children: List.generate(5, (index) {
        final rating = 5 - index;
        final count = ratingCounts[rating] ?? 0;
        final percentage = _totalReviews > 0 ? (count / _totalReviews) : 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Text(
                '$rating',
                style: TextStyle(color: AppColors.gray600, fontSize: 14),
              ),
              const SizedBox(width: 8),
              Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: AppColors.gray200,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$count',
                style: TextStyle(color: AppColors.gray600, fontSize: 14),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildReviewsList() {
    if (_reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review, size: 64, color: AppColors.gray400),
            const SizedBox(height: 16),
            Text(
              'No Reviews Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.gray600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to review this property',
              style: TextStyle(color: AppColors.gray500, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReviews,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _reviews.length,
        itemBuilder: (context, index) {
          final review = _reviews[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildReviewCard(review),
          );
        },
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryCoral.withValues(
                    alpha: 0.1,
                  ),
                  child: review.hasReviewerAvatar
                      ? ClipOval(
                          child: Image.network(
                            review.reviewerAvatar!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              color: AppColors.primaryCoral,
                              size: 20,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: AppColors.primaryCoral,
                          size: 20,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.reviewerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            review.createdAt.toString().split(' ')[0],
                            style: TextStyle(
                              color: AppColors.gray500,
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
            if (review.hasText) ...[
              const SizedBox(height: 12),
              Text(
                review.text,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
            ],
            if (review.isRecent) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Recent',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
