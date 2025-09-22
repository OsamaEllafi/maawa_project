import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/properties/entities/property.dart';
import '../../../domain/properties/entities/media_item.dart';

class OwnerPropertyMediaScreen extends StatefulWidget {
  final String propertyId;

  const OwnerPropertyMediaScreen({super.key, required this.propertyId});

  @override
  State<OwnerPropertyMediaScreen> createState() => _OwnerPropertyMediaScreenState();
}

class _OwnerPropertyMediaScreenState extends State<OwnerPropertyMediaScreen> {
  bool _isLoading = false;
  Property? _property;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProperty();
  }

  Future<void> _loadProperty() async {
    setState(() => _isLoading = true);
    try {
      final property = await ServiceLocator().propertiesRepository.getOwnerProperty(widget.propertyId);
      setState(() => _property = property);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading property: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        await _uploadImages(images);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    }
  }

  Future<void> _uploadImages(List<XFile> images) async {
    setState(() => _isLoading = true);
    try {
      final filePaths = images.map((image) => image.path).toList();
      await ServiceLocator().propertiesRepository.uploadPropertyMedia(widget.propertyId, filePaths);
      await _loadProperty(); // Reload to show new images
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Images uploaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading images: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteMedia(MediaItem media) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Media'),
        content: const Text('Are you sure you want to delete this media item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await ServiceLocator().propertiesRepository.deletePropertyMedia(widget.propertyId, media.id);
        await _loadProperty(); // Reload to update list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Media deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting media: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _reorderMedia(int oldIndex, int newIndex) async {
    if (_property == null) return;

    setState(() => _isLoading = true);
    try {
      final media = List<MediaItem>.from(_property!.media);
      final item = media.removeAt(oldIndex);
      media.insert(newIndex, item);

      final mediaOrder = media.asMap().entries.map((entry) => {
        'media_id': entry.value.id,
        'sort_index': entry.key,
      }).toList();

      await ServiceLocator().propertiesRepository.reorderPropertyMedia(widget.propertyId, mediaOrder);
      await _loadProperty(); // Reload to show new order
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error reordering media: $e')),
      );
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
          'Property Media',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColors.getGray700(context)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: _pickImages,
            icon: Icon(Icons.add_photo_alternate, color: AppColors.primaryCoral),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _property == null
              ? const Center(child: Text('Property not found'))
              : Column(
                  children: [
                    _buildPropertyInfo(),
                    Expanded(
                      child: _property!.media.isEmpty
                          ? _buildEmptyState()
                          : _buildMediaGrid(),
                    ),
                  ],
                ),
    );
  }

  Widget _buildPropertyInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Row(
        children: [
          if (_property!.hasMainImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _property!.mainImageUrl!,
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
                  _property!.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_property!.media.length} media items',
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: AppColors.gray400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Media Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.gray600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add photos and videos to showcase your property',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.gray500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _pickImages,
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Add Media'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCoral,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGrid() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _property!.media.length,
      onReorder: _reorderMedia,
      itemBuilder: (context, index) {
        final media = _property!.media[index];
        return _buildMediaItem(media, index);
      },
    );
  }

  Widget _buildMediaItem(MediaItem media, int index) {
    return Card(
      key: ValueKey(media.id),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: media.isImage
                    ? Image.network(
                        media.displayUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: double.infinity,
                          height: 200,
                          color: AppColors.gray200,
                          child: Icon(Icons.image, color: AppColors.gray400),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 200,
                        color: AppColors.gray200,
                        child: Icon(Icons.video_library, color: AppColors.gray400),
                      ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '#${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: IconButton(
                  onPressed: () => _deleteMedia(media),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(32, 32),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  media.isImage ? Icons.image : Icons.video_library,
                  size: 16,
                  color: AppColors.gray500,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    media.filename ?? 'Media ${media.id}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.gray600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  media.fileSizeDisplay,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
