import 'package:dio/dio.dart';
import '../../core/errors/error_mapper.dart';
import '../../domain/properties/entities/property.dart';
import '../../domain/properties/entities/media_item.dart';
import '../network/dio_client.dart';

class PropertiesApi {
  final DioClient _dioClient;

  PropertiesApi(this._dioClient);

  // Public property operations
  Future<List<Property>> getPublishedProperties({
    int page = 1,
    int perPage = 15,
    String? search,
    String? type,
    double? priceMin,
    double? priceMax,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'per_page': perPage};

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (type != null && type.isNotEmpty) {
        queryParams['type'] = type;
      }
      if (priceMin != null) {
        queryParams['price_min'] = priceMin;
      }
      if (priceMax != null) {
        queryParams['price_max'] = priceMax;
      }

      final response = await _dioClient.get(
        '/properties',
        queryParameters: queryParams,
      );
      final data = response.data['data'] ?? response.data;

      if (data is List) {
        return data.map((json) => Property.fromJson(json)).toList();
      } else if (data['properties'] is List) {
        return (data['properties'] as List)
            .map((json) => Property.fromJson(json))
            .toList();
      }

      return [];
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<Property> getPublishedProperty(String propertyUuid) async {
    try {
      final response = await _dioClient.get('/properties/$propertyUuid');
      final data = response.data['data'] ?? response.data;
      return Property.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Owner property operations
  Future<List<Property>> getOwnerProperties({
    int page = 1,
    int perPage = 20,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'per_page': perPage};

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await _dioClient.get(
        '/owner/properties',
        queryParameters: queryParams,
      );
      final data = response.data['data'] ?? response.data;

      if (data is List) {
        return data.map((json) => Property.fromJson(json)).toList();
      } else if (data['properties'] is List) {
        return (data['properties'] as List)
            .map((json) => Property.fromJson(json))
            .toList();
      }

      return [];
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<Property> getOwnerProperty(String propertyUuid) async {
    try {
      final response = await _dioClient.get('/owner/properties/$propertyUuid');
      final data = response.data['data'] ?? response.data;
      return Property.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

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
    try {
      final response = await _dioClient.post(
        '/owner/properties',
        data: {
          'title': title,
          'description': description,
          'type': type,
          'address': address,
          'price_per_night': pricePerNight,
          'capacity': capacity,
          'amenities': amenities,
          'checkin_time': checkinTime,
          'checkout_time': checkoutTime,
        },
      );

      final data = response.data['data'] ?? response.data;
      return Property.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

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
    try {
      final updateData = <String, dynamic>{};

      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (type != null) updateData['type'] = type;
      if (address != null) updateData['address'] = address;
      if (pricePerNight != null) updateData['price_per_night'] = pricePerNight;
      if (capacity != null) updateData['capacity'] = capacity;
      if (amenities != null) updateData['amenities'] = amenities;
      if (checkinTime != null) updateData['checkin_time'] = checkinTime;
      if (checkoutTime != null) updateData['checkout_time'] = checkoutTime;

      final response = await _dioClient.put(
        '/owner/properties/$propertyUuid',
        data: updateData,
      );
      final data = response.data['data'] ?? response.data;
      return Property.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> submitProperty(String propertyUuid) async {
    try {
      await _dioClient.post('/owner/properties/$propertyUuid/submit');
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Media operations
  Future<List<MediaItem>> uploadPropertyMedia(
    String propertyUuid,
    List<String> filePaths,
  ) async {
    try {
      final formData = FormData();

      for (int i = 0; i < filePaths.length; i++) {
        formData.files.add(
          MapEntry('media[$i]', await MultipartFile.fromFile(filePaths[i])),
        );
      }

      final response = await _dioClient.upload(
        '/owner/properties/$propertyUuid/media',
        formData: formData,
      );

      final data = response.data['data'] ?? response.data;
      if (data is List) {
        return data.map((json) => MediaItem.fromJson(json)).toList();
      }
      return [];
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> deletePropertyMedia(String propertyUuid, int mediaId) async {
    try {
      await _dioClient.delete('/owner/properties/$propertyUuid/media/$mediaId');
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> reorderPropertyMedia(
    String propertyUuid,
    List<Map<String, int>> mediaOrder,
  ) async {
    try {
      await _dioClient.put(
        '/owner/properties/$propertyUuid/media/reorder',
        data: {'media_order': mediaOrder},
      );
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Admin operations
  Future<List<Property>> getPendingProperties({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dioClient.get(
        '/admin/properties/pending',
        queryParameters: {'page': page, 'per_page': perPage},
      );

      final data = response.data['data'] ?? response.data;
      if (data is List) {
        return data.map((json) => Property.fromJson(json)).toList();
      } else if (data['properties'] is List) {
        return (data['properties'] as List)
            .map((json) => Property.fromJson(json))
            .toList();
      }

      return [];
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> approveProperty(String propertyUuid) async {
    try {
      await _dioClient.post('/admin/properties/$propertyUuid/approve');
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> rejectProperty(String propertyUuid, String reason) async {
    try {
      await _dioClient.post(
        '/admin/properties/$propertyUuid/reject',
        data: {'reason': reason},
      );
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> unpublishProperty(String propertyUuid) async {
    try {
      await _dioClient.post('/admin/properties/$propertyUuid/unpublish');
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }
}
