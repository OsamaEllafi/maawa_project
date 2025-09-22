import 'entities/property.dart';
import 'entities/media_item.dart';

abstract class PropertiesRepository {
  // Public property operations
  Future<List<Property>> getPublishedProperties({
    int page = 1,
    int perPage = 15,
    String? search,
    String? type,
    double? priceMin,
    double? priceMax,
  });

  Future<Property> getPublishedProperty(String propertyUuid);

  // Owner property operations
  Future<List<Property>> getOwnerProperties({
    int page = 1,
    int perPage = 20,
    String? status,
  });

  Future<Property> getOwnerProperty(String propertyUuid);

  Future<Property> createProperty({
    required String title,
    required String description,
    required String type,
    required String address,
    required double pricePerNight,
    required int capacity,
    required List<String> amenities,
    required String checkinTime,
    required String checkoutTime,
  });

  Future<Property> updateProperty(
    String propertyUuid, {
    String? title,
    String? description,
    String? type,
    String? address,
    double? pricePerNight,
    int? capacity,
    List<String>? amenities,
    String? checkinTime,
    String? checkoutTime,
  });

  Future<void> submitProperty(String propertyUuid);

  // Media operations
  Future<List<MediaItem>> uploadPropertyMedia(
    String propertyUuid,
    List<String> filePaths,
  );

  Future<void> deletePropertyMedia(String propertyUuid, int mediaId);

  Future<void> reorderPropertyMedia(
    String propertyUuid,
    List<Map<String, int>> mediaOrder,
  );

  // Admin operations
  Future<List<Property>> getPendingProperties({
    int page = 1,
    int perPage = 20,
  });

  Future<void> approveProperty(String propertyUuid);

  Future<void> rejectProperty(String propertyUuid, String reason);

  Future<void> unpublishProperty(String propertyUuid);
}
