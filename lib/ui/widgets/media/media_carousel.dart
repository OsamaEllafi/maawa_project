import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/app_colors.dart';

class MediaCarousel extends StatefulWidget {
  final List<String> images;
  final String? videoUrl;
  final double height;
  final bool showIndicators;
  final bool autoPlay;

  const MediaCarousel({
    super.key,
    required this.images,
    this.videoUrl,
    this.height = 300,
    this.showIndicators = true,
    this.autoPlay = false,
  });

  @override
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;
  VideoPlayerController? _videoController;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeVideo();
  }

  void _initializeVideo() {
    if (widget.videoUrl != null) {
      _videoController = VideoPlayerController.asset(widget.videoUrl!)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
            if (widget.autoPlay) {
              _videoController!.play();
              _isVideoPlaying = true;
            }
          }
        });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleVideo() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      setState(() {
        if (_isVideoPlaying) {
          _videoController!.pause();
        } else {
          _videoController!.play();
        }
        _isVideoPlaying = !_isVideoPlaying;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final allMedia = <Widget>[];

    // Add images
    for (final imageUrl in widget.images) {
      allMedia.add(
        Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.gray100,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.primaryCoral,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.gray100,
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: AppColors.gray400,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    // Add video if available
    if (widget.videoUrl != null && _videoController != null && _videoController!.value.isInitialized) {
      allMedia.add(
        Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
                // Video controls overlay
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _toggleVideo,
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: _isVideoPlaying ? 0.0 : 0.8,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isVideoPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Video badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Video',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Media carousel
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: allMedia.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                ),
                child: allMedia[index],
              );
            },
          ),
        ),

        // Page indicators
        if (widget.showIndicators && allMedia.length > 1) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              allMedia.length,
              (index) => Container(
                width: _currentIndex == index ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
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

        // Image counter
        if (allMedia.length > 1) ...[
          const SizedBox(height: 8),
          Text(
            '${_currentIndex + 1} of ${allMedia.length}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
