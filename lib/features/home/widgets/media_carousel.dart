import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MediaCarousel extends StatefulWidget {
  const MediaCarousel({super.key});

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<MediaItem> _mediaItems = [
    MediaItem(
      imageUrl: 'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=800',
      title: 'Tripoli Marina',
      subtitle: 'Historic waterfront with modern amenities',
      type: MediaType.destination,
    ),
    MediaItem(
      imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
      title: 'Benghazi Cultural Heritage',
      subtitle: 'Rich history meets contemporary living',
      type: MediaType.destination,
    ),
    MediaItem(
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      title: 'Coastal Properties',
      subtitle: 'Wake up to Mediterranean views',
      type: MediaType.category,
    ),
    MediaItem(
      imageUrl: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
      title: 'Luxury Villas',
      subtitle: 'Private retreats for discerning guests',
      type: MediaType.category,
    ),
    MediaItem(
      imageUrl: 'https://images.unsplash.com/photo-1520637836862-4d197d17c50a?w=800',
      title: 'City Center Apartments',
      subtitle: 'Urban living at its finest',
      type: MediaType.category,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Column(
      children: [
        // Carousel
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _mediaItems.length,
            itemBuilder: (context, index) {
              final item = _mediaItems[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: _MediaCard(
                  item: item,
                  onTap: () {
                    // Handle media item tap
                  },
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _mediaItems.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index 
                    ? AppColors.primaryCoral 
                    : AppColors.gray300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MediaCard extends StatelessWidget {
  final MediaItem item;
  final VoidCallback? onTap;

  const _MediaCard({
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.gray200,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: AppColors.gray400,
                    size: 48,
                  ),
                ),
              ),
              
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              
              // Content
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(item.type).withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _getTypeLabel(item.type),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Title
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Subtitle
                    Text(
                      item.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(MediaType type) {
    switch (type) {
      case MediaType.destination:
        return AppColors.primaryTurquoise;
      case MediaType.category:
        return AppColors.primaryCoral;
      case MediaType.experience:
        return AppColors.warning;
    }
  }

  String _getTypeLabel(MediaType type) {
    switch (type) {
      case MediaType.destination:
        return 'DESTINATION';
      case MediaType.category:
        return 'CATEGORY';
      case MediaType.experience:
        return 'EXPERIENCE';
    }
  }
}

class MediaItem {
  final String imageUrl;
  final String title;
  final String subtitle;
  final MediaType type;

  const MediaItem({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.type,
  });
}

enum MediaType {
  destination,
  category,
  experience,
}
