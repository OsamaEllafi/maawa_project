import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../demo/demo_data.dart';
import '../../../demo/models.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final String propertyId;

  const PropertyDetailsScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  PageController? _imageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Get the property data to check if it has multiple images
    final property = DemoData.properties.firstWhere(
      (p) => p.id == widget.propertyId,
      orElse: () => DemoData.properties.first,
    );
    if (property.images.length > 1) {
      _imageController = PageController(    );
  }

  Widget _buildImage(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.2),
            ],
          ),
        ),
      ),
    );
  }
}

  @override
  void dispose() {
    _imageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the property data
    final property = DemoData.properties.firstWhere(
      (p) => p.id == widget.propertyId,
      orElse: () => DemoData.properties.first, // Fallback to first property
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Details'), 
        centerTitle: true,
        backgroundColor: ThemeColors.getAppBarBackground(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Image Slideshow
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    // Image carousel or single image
                    if (property.images.length > 1 && _imageController != null)
                      PageView.builder(
                        controller: _imageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemCount: property.images.length,
                        itemBuilder: (context, index) {
                          return _buildImage(property.images[index]);
                        },
                      )
                    else
                      _buildImage(property.images.first),
                    
                    // Image indicators for carousel
                    if (property.images.length > 1)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            property.images.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentImageIndex == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentImageIndex == index 
                                    ? Colors.white 
                                    : Colors.white.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Property Title
              Text(
                property.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.primaryCoral,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      '${property.location.city}, ${property.location.country}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: AppColors.gray600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Property Details
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bed, color: AppColors.gray600, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${property.bedrooms} Bed',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bathroom, color: AppColors.gray600, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${property.bathrooms} Bath',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people, color: AppColors.gray600, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${property.capacity} Guests',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '\$${property.pricePerNight.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
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
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.warning,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          property.rating.toStringAsFixed(1),
                          style: TextStyle(
                            color: AppColors.warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Book Now Button
              GradientButton(
                text: 'Book Now',
                onPressed: () => context.push('/booking-request/${widget.propertyId}'),
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.2),
            ],
          ),
        ),
      ),
    );
  }
}
