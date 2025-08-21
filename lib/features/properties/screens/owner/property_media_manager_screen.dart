import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../demo/demo_data.dart';

class PropertyMediaManagerScreen extends StatefulWidget {
  final String propertyId;

  const PropertyMediaManagerScreen({
    super.key,
    required this.propertyId,
  });

  @override
  State<PropertyMediaManagerScreen> createState() => _PropertyMediaManagerScreenState();
}

class _PropertyMediaManagerScreenState extends State<PropertyMediaManagerScreen> {
  late List<MediaItem> _mediaItems;

  @override
  void initState() {
    super.initState();
    _loadMediaItems();
  }

  void _loadMediaItems() {
    final property = DemoData.getPropertyById(widget.propertyId);
    if (property != null) {
      _mediaItems = property.images.asMap().entries.map((entry) {
        return MediaItem(
          id: 'img_${entry.key}',
          url: entry.value,
          type: MediaType.image,
          order: entry.key,
        );
      }).toList();

      // Add a sample video
      _mediaItems.add(
        MediaItem(
          id: 'video_001',
          url: 'assets/videos/property_tour.mp4',
          type: MediaType.video,
          order: _mediaItems.length,
        ),
      );
    } else {
      _mediaItems = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final property = DemoData.getPropertyById(widget.propertyId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gray700),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Manage Media',
          style: TextStyle(
            color: AppColors.gray900,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 400 ? 18 : 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppColors.primaryCoral),
            onPressed: _addMedia,
          ),
        ],
      ),
      body: Column(
        children: [
          // Property info header
          if (property != null) ...[
            Container(
              padding: EdgeInsets.all(screenWidth * 0.06),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                border: Border(
                  bottom: BorderSide(color: AppColors.gray200, width: 1),
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 60,
                      height: 60,
                      child: Image.network(
                        property.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.gray200,
                            child: const Icon(Icons.home, size: 30),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_mediaItems.length} media files',
                          style: TextStyle(
                            color: AppColors.gray600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Media grid
          Expanded(
            child: _mediaItems.isEmpty ? _buildEmptyState() : _buildMediaGrid(),
          ),

          // Bottom actions
          Container(
            padding: EdgeInsets.all(screenWidth * 0.06),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.gray200, width: 1),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addMedia,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('Add Photos'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryCoral),
                        foregroundColor: AppColors.primaryCoral,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child:                     GradientButton(
                      text: 'Add Video',
                      onPressed: _addVideo,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
                Icons.photo_library_outlined,
                size: 60,
                color: AppColors.gray400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No media files yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.gray700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add photos and videos to showcase your property',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Add First Photo',
              onPressed: _addMedia,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return ReorderableListView.builder(
      padding: EdgeInsets.all(screenWidth * 0.06),
      itemCount: _mediaItems.length,
      onReorder: _reorderMedia,
      itemBuilder: (context, index) {
        final mediaItem = _mediaItems[index];
        return _buildMediaCard(mediaItem, index, key: ValueKey(mediaItem.id));
      },
    );
  }

  Widget _buildMediaCard(MediaItem mediaItem, int index, {required Key key}) {
    return Container(
      key: key,
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
          // Media preview
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  child: mediaItem.type == MediaType.image
                      ? Image.network(
                          mediaItem.url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.gray100,
                              child: const Center(
                                child: Icon(Icons.broken_image, size: 48),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.black,
                          child: Stack(
                            children: [
                              const Center(
                                child: Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.white,
                                  size: 64,
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '2:15',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                
                // Order badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primaryCoral,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                // Media type badge
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
                        Icon(
                          mediaItem.type == MediaType.image
                              ? Icons.photo
                              : Icons.videocam,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          mediaItem.type == MediaType.image ? 'Photo' : 'Video',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Actions
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _editMedia(mediaItem),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                          onPressed: () => _deleteMedia(mediaItem),
                        ),
                      ),
                    ],
                  ),
                ),

                // Drag handle
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.drag_handle,
                      color: AppColors.gray600,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Media info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        mediaItem.type == MediaType.image
                            ? 'Photo ${index + 1}'
                            : 'Property Tour Video',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (index == 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCoral.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Cover Photo',
                          style: TextStyle(
                            color: AppColors.primaryCoral,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  mediaItem.type == MediaType.image
                      ? 'Used in property gallery'
                      : 'Shows property walkthrough',
                  style: TextStyle(
                    color: AppColors.gray600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _reorderMedia(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _mediaItems.removeAt(oldIndex);
      _mediaItems.insert(newIndex, item);
      
      // Update order values
      for (int i = 0; i < _mediaItems.length; i++) {
        _mediaItems[i] = _mediaItems[i].copyWith(order: i);
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Media order updated'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _addMedia() {
    // Mock adding photos
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Photos'),
        content: const Text('This would open a photo picker in a real app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _mockAddPhoto();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCoral,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Sample Photo'),
          ),
        ],
      ),
    );
  }

  void _addVideo() {
    // Mock adding video
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Video'),
        content: const Text('This would open a video picker in a real app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _mockAddVideo();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCoral,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Sample Video'),
          ),
        ],
      ),
    );
  }

  void _mockAddPhoto() {
    setState(() {
      _mediaItems.add(
        MediaItem(
          id: 'img_${DateTime.now().millisecondsSinceEpoch}',
          url: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
          type: MediaType.image,
          order: _mediaItems.length,
        ),
      );
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Photo added successfully'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _mockAddVideo() {
    setState(() {
      _mediaItems.add(
        MediaItem(
          id: 'video_${DateTime.now().millisecondsSinceEpoch}',
          url: 'assets/videos/property_walkthrough.mp4',
          type: MediaType.video,
          order: _mediaItems.length,
        ),
      );
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Video added successfully'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _editMedia(MediaItem mediaItem) {
    // Mock editing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit ${mediaItem.type == MediaType.image ? 'photo' : 'video'}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _deleteMedia(MediaItem mediaItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Media'),
        content: Text(
          'Are you sure you want to delete this ${mediaItem.type == MediaType.image ? 'photo' : 'video'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _mediaItems.removeWhere((item) => item.id == mediaItem.id);
                // Update order values
                for (int i = 0; i < _mediaItems.length; i++) {
                  _mediaItems[i] = _mediaItems[i].copyWith(order: i);
                }
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${mediaItem.type == MediaType.image ? 'Photo' : 'Video'} deleted',
                  ),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

enum MediaType { image, video }

class MediaItem {
  final String id;
  final String url;
  final MediaType type;
  final int order;

  MediaItem({
    required this.id,
    required this.url,
    required this.type,
    required this.order,
  });

  MediaItem copyWith({
    String? id,
    String? url,
    MediaType? type,
    int? order,
  }) {
    return MediaItem(
      id: id ?? this.id,
      url: url ?? this.url,
      type: type ?? this.type,
      order: order ?? this.order,
    );
  }
}
