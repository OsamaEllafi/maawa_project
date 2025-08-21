import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../demo/demo_data.dart';
import '../../../demo/models.dart';

class WriteReviewScreen extends StatefulWidget {
  final String propertyId;
  final String? bookingId;

  const WriteReviewScreen({
    super.key,
    required this.propertyId,
    this.bookingId,
  });

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;

  // Rating categories
  final List<Map<String, dynamic>> _ratingCategories = [
    {'name': 'Cleanliness', 'rating': 0, 'icon': Icons.cleaning_services},
    {'name': 'Location', 'rating': 0, 'icon': Icons.location_on},
    {'name': 'Value', 'rating': 0, 'icon': Icons.attach_money},
    {'name': 'Communication', 'rating': 0, 'icon': Icons.message},
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final property = DemoData.getPropertyById(widget.propertyId);

    if (property == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Write Review')),
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
          'Write Review',
          style: TextStyle(
            color: AppColors.gray900,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 400 ? 18 : 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Summary
              _buildPropertySummary(property),
              const SizedBox(height: 24),

              // Overall Rating
              _buildOverallRating(),
              const SizedBox(height: 24),

              // Category Ratings
              _buildCategoryRatings(),
              const SizedBox(height: 24),

              // Review Comment
              _buildCommentSection(),
              const SizedBox(height: 32),

              // Submit Button
              GradientButton(
                text: _isSubmitting ? 'Submitting...' : 'Submit Review',
                onPressed: _isSubmitting ? null : _submitReview,
                width: double.infinity,
              ),
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
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              property.images.first,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60,
                height: 60,
                color: AppColors.gray300,
                child: const Icon(Icons.image, color: AppColors.gray500),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 4),
                                 Text(
                   property.location.city,
                   style: const TextStyle(
                     fontSize: 14,
                     color: AppColors.gray600,
                   ),
                 ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${property.rating} (${property.reviewCount} reviews)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.gray600,
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

  Widget _buildOverallRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overall Rating',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _rating = index + 1;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 40,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            _getRatingText(_rating),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _rating > 0 ? AppColors.gray900 : AppColors.gray500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRatings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rate by Category',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(_ratingCategories.length, (index) {
          final category = _ratingCategories[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      color: AppColors.primaryCoral,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gray900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (starIndex) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          category['rating'] = starIndex + 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Icon(
                          starIndex < (category['rating'] as int) ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 24,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Review',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _commentController,
          maxLines: 6,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: 'Share your experience with this property...',
            hintStyle: const TextStyle(color: AppColors.gray500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.gray300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryCoral),
            ),
            filled: true,
            fillColor: AppColors.gray50,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please write a review comment';
            }
            if (value.trim().length < 10) {
              return 'Review must be at least 10 characters long';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 16,
              color: AppColors.gray500,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Be specific about what you liked or didn\'t like. Your review helps other travelers!',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.gray500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 0:
        return 'Tap to rate';
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  void _submitReview() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide an overall rating'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Mock API call
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Review submitted successfully!')),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.pop(context);
      }
    });
  }
}
