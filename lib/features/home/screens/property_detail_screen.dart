import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../demo/demo_data.dart';
import '../../../demo/models.dart';
import '../../../ui/widgets/media/media_carousel.dart';

class PropertyDetailScreen extends StatefulWidget {
  final String propertyId;

  const PropertyDetailScreen({
    super.key,
    required this.propertyId,
  });

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final property = DemoData.getPropertyById(widget.propertyId);
    final owner = DemoData.getUserById(property?.ownerId ?? '');
    final reviews = DemoData.getReviewsByProperty(widget.propertyId);

    if (property == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Property Not Found'),
        ),
        body: const Center(
          child: Text('Property not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Media carousel
          SliverToBoxAdapter(
            child: Stack(
              children: [
                MediaCarousel(
                  images: property.images,
                  height: 300,
                  showIndicators: true,
                ),
                // Back button
                Positioned(
                  top: 50,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 50,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : AppColors.gray600,
                      ),
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Property details
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Title and rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth < 400 ? 22 : 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                property.rating.toString(),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${property.reviewCount} reviews',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.gray600,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${property.location.city}, ${property.location.country}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Property type and capacity
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCoral.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          property.type.displayName,
                          style: TextStyle(
                            color: AppColors.primaryCoral,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${property.capacity} guests',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${property.bedrooms} bedrooms',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${property.bathrooms} bathrooms',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Price
                  Row(
                    children: [
                      Text(
                        '${property.pricePerNight} ${property.currency}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryCoral,
                        ),
                      ),
                      Text(
                        ' / night',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'About this place',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    property.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.gray700,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Amenities
                  Text(
                    'What this place offers',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: property.amenities.map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.gray50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.gray200),
                        ),
                        child: Text(
                          amenity,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.gray700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Reviews section
                  if (reviews.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reviews',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to all reviews
                          },
                          child: Text(
                            'See all ${reviews.length} reviews',
                            style: TextStyle(
                              color: AppColors.primaryCoral,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...reviews.take(3).map((review) {
                      final reviewer = DemoData.getUserById(review.userId);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.gray50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: reviewer?.avatar != null
                                      ? NetworkImage(reviewer!.avatar!)
                                      : null,
                                  child: reviewer?.avatar == null
                                      ? Text(
                                          reviewer?.name.substring(0, 1).toUpperCase() ?? 'U',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reviewer?.name ?? 'Anonymous',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
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
                                            '${review.rating}.0',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                            const SizedBox(height: 12),
                            Text(
                              review.comment,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.gray700,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],

                  const SizedBox(height: 32),

                  // Owner information
                  if (owner != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: owner.avatar != null
                                ? NetworkImage(owner.avatar!)
                                : null,
                            child: owner.avatar == null
                                ? Text(
                                    owner.name.substring(0, 1).toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hosted by ${owner.name}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Member since ${owner.joinDate.year}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.gray600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.message_outlined),
                            onPressed: () {
                              // Open chat with owner
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Bottom spacing for floating button
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(screenWidth * 0.06),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.gray200, width: 1),
          ),
        ),
        child: SafeArea(
          child: GradientButton(
            text: 'Request Booking',
            isLoading: _isLoading,
            onPressed: () {
              // Navigate to booking request
            },
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
