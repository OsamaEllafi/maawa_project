import '../../domain/properties/properties_repository.dart';
import '../../domain/properties/entities/property.dart';
import '../../domain/properties/entities/media_item.dart';
import 'properties_api.dart';

class PropertiesRepositoryImpl implements PropertiesRepository {
  final PropertiesApi _propertiesApi;

  PropertiesRepositoryImpl(this._propertiesApi);

  @override
  Future<List<Property>> getPublishedProperties({
    int page = 1,
    int perPage = 15,
    String? search,
    String? type,
    double? priceMin,
    double? priceMax,
  }) async {
    return await _propertiesApi.getPublishedProperties(
      page: page,
      perPage: perPage,
      search: search,
      type: type,
      priceMin: priceMin,
      priceMax: priceMax,
    );
  }

  @override
  Future<Property> getPublishedProperty(String propertyUuid) async {
    return await _propertiesApi.getPublishedProperty(propertyUuid);
  }

  @override
  Future<List<Property>> getOwnerProperties({
    int page = 1,
    int perPage = 20,
    String? status,
  }) async {
    return await _propertiesApi.getOwnerProperties(
      page: page,
      perPage: perPage,
      status: status,
    );
  }

  @override
  Future<Property> getOwnerProperty(String propertyUuid) async {
    return await _propertiesApi.getOwnerProperty(propertyUuid);
  }

  @override
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
  }) async {
    return await _propertiesApi.createProperty(
      title: title,
      description: description,
      type: type,
      address: address,
      pricePerNight: pricePerNight,
      capacity: capacity,
      amenities: amenities,
      checkinTime: checkinTime,
      checkoutTime: checkoutTime,
    );
  }

  @override
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
  }) async {
    return await _propertiesApi.updateProperty(
      propertyUuid,
      title: title,
      description: description,
      type: type,
      address: address,
      pricePerNight: pricePerNight,
      capacity: capacity,
      amenities: amenities,
      checkinTime: checkinTime,
      checkoutTime: checkoutTime,
    );
  }

  @override
  Future<void> submitProperty(String propertyUuid) async {
    await _propertiesApi.submitProperty(propertyUuid);
  }

  @override
  Future<List<MediaItem>> uploadPropertyMedia(
    String propertyUuid,
    List<String> filePaths,
  ) async {
    return await _propertiesApi.uploadPropertyMedia(propertyUuid, filePaths);
  }

  @override
  Future<void> deletePropertyMedia(String propertyUuid, int mediaId) async {
    await _propertiesApi.deletePropertyMedia(propertyUuid, mediaId);
  }

  @override
  Future<void> reorderPropertyMedia(
    String propertyUuid,
    List<Map<String, int>> mediaOrder,
  ) async {
    await _propertiesApi.reorderPropertyMedia(propertyUuid, mediaOrder);
  }

  @override
  Future<List<Property>> getPendingProperties({
    int page = 1,
    int perPage = 20,
  }) async {
    return await _propertiesApi.getPendingProperties(
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<void> approveProperty(String propertyUuid) async {
    await _propertiesApi.approveProperty(propertyUuid);
  }

  @override
  Future<void> rejectProperty(String propertyUuid, String reason) async {
    await _propertiesApi.rejectProperty(propertyUuid, reason);
  }

  @override
  Future<void> unpublishProperty(String propertyUuid) async {
    await _propertiesApi.unpublishProperty(propertyUuid);
  }
}
