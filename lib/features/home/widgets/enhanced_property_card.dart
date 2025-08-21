import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../demo/models.dart';

class EnhancedPropertyCard extends StatefulWidget {
  final DemoProperty property;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool useFixedHeight;

  const EnhancedPropertyCard({
    super.key,
    required this.property,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteToggle,
    this.useFixedHeight = false,
  });

  @override
  State<EnhancedPropertyCard> createState() => _EnhancedPropertyCardState();
}

class _EnhancedPropertyCardState extends State<EnhancedPropertyCard> {
  PageController? _imageController;
  int _currentImageIndex = 0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    if (widget.property.images.length > 1) {
      _imageController = PageController();
    }
  }

  @override
  void dispose() {
    _imageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: ThemeColors.getSurface(context),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.shadowMedium
                    : AppColors.shadowLight,
                blurRadius: _isHovered ? 16 : 8,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced image section with carousel
              _buildImageSection(),

              // Content section
              widget.useFixedHeight
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: _buildContentChildren(),
                      ),
                    )
                  : Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: _buildContentChildren(),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContentChildren() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return [
      // Property type badge and status
      Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: _getTypeColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.property.type.displayName,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: _getTypeColor(),
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
          const Spacer(),
          if (widget.property.status == PropertyStatus.published)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),

      const SizedBox(height: 6),

      // Title
      Text(
        widget.property.title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: screenWidth < 400 ? 13 : 15,
          height: 1.2,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),

      const SizedBox(height: 4),

      // Location with enhanced styling
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primaryCoral.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.location_on,
              size: 14,
              color: AppColors.primaryCoral,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${widget.property.location.city}, ${widget.property.location.country}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ThemeColors.getGray600(context),
                fontSize: screenWidth < 400 ? 12 : 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),

      const SizedBox(height: 6),

      // Property details
      Row(
        children: [
          _buildDetailChip(
            Icons.bed_outlined,
            '${widget.property.bedrooms}',
          ),
          const SizedBox(width: 6),
          _buildDetailChip(
            Icons.bathtub_outlined,
            '${widget.property.bathrooms}',
          ),
          const SizedBox(width: 6),
          _buildDetailChip(
            Icons.people_outline,
            '${widget.property.capacity}',
          ),
        ],
      ),

      const SizedBox(height: 4),

      // Rating and price section
      Row(
        children: [
          // Rating
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
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
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.property.rating.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    '\$${widget.property.pricePerNight.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth < 400 ? 14 : 16,
                      color: ThemeColors.getTextPrimary(context),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '/${widget.property.currency}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ThemeColors.getGray500(context),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Text(
                'per night',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ThemeColors.getGray600(context),
                  fontSize: screenWidth < 400 ? 10 : 11,
                ),
              ),
            ],
          ),
        ],
      ),
    ];
  }

  Widget _buildImageSection() {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          // Image carousel or single image
          if (widget.property.images.length > 1 && _imageController != null)
            PageView.builder(
              controller: _imageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: widget.property.images.length,
              itemBuilder: (context, index) {
                return _buildImage(widget.property.images[index]);
              },
            )
          else
            _buildImage(widget.property.images.first),

          // Favorite button
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: widget.onFavoriteToggle,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: widget.isFavorite
                      ? AppColors.error
                      : AppColors.gray600,
                  size: 18,
                ),
              ),
            ),
          ),

          // Image indicators for carousel
          if (widget.property.images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.property.images.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: _currentImageIndex == index ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.1)],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: ThemeColors.getGray50(context),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ThemeColors.getBorder(context), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: ThemeColors.getGray600(context)),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: ThemeColors.getGray700(context),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor() {
    switch (widget.property.type) {
      case PropertyType.apartment:
        return AppColors.primaryCoral;
      case PropertyType.villa:
        return AppColors.primaryTurquoise;
      case PropertyType.studio:
        return AppColors.warning;
      case PropertyType.penthouse:
        return AppColors.success;
      case PropertyType.townhouse:
        return AppColors.info;
    }
  }
}
