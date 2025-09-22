import '../../core/errors/error_mapper.dart';
import '../../domain/reviews/entities/review.dart';
import '../network/dio_client.dart';

class ReviewsApi {
  final DioClient _dioClient;

  ReviewsApi(this._dioClient);

  // Create and update reviews
  Future<Review> createReview({
    required String bookingUuid,
    required String revieweeUuid,
    required int rating,
    required String text,
  }) async {
    try {
      final response = await _dioClient.post(
        '/reviews',
        data: {
          'booking_uuid': bookingUuid,
          'reviewee_uuid': revieweeUuid,
          'rating': rating,
          'text': text,
        },
      );

      final data = response.data['data'] ?? response.data;
      return Review.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<Review> updateReview(
    String reviewUuid, {
    int? rating,
    String? text,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (rating != null) updateData['rating'] = rating;
      if (text != null) updateData['text'] = text;

      final response = await _dioClient.put(
        '/reviews/$reviewUuid',
        data: updateData,
      );
      final data = response.data['data'] ?? response.data;
      return Review.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Get reviews
  Future<List<Review>> getPropertyReviews(
    String propertyUuid, {
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dioClient.get(
        '/properties/$propertyUuid/reviews',
        queryParameters: {'page': page, 'per_page': perPage},
      );

      final data = response.data['data'] ?? response.data;
      if (data is List) {
        return data.map((json) => Review.fromJson(json)).toList();
      } else if (data['reviews'] is List) {
        return (data['reviews'] as List)
            .map((json) => Review.fromJson(json))
            .toList();
      }

      return [];
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<List<Review>> getUserReviews(
    String userUuid, {
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dioClient.get(
        '/users/$userUuid/reviews',
        queryParameters: {'page': page, 'per_page': perPage},
      );

      final data = response.data['data'] ?? response.data;
      if (data is List) {
        return data.map((json) => Review.fromJson(json)).toList();
      } else if (data['reviews'] is List) {
        return (data['reviews'] as List)
            .map((json) => Review.fromJson(json))
            .toList();
      }

      return [];
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Admin operations
  Future<void> hideReview(String reviewUuid, String reason) async {
    try {
      await _dioClient.post(
        '/admin/reviews/$reviewUuid/hide',
        data: {'reason': reason},
      );
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> unhideReview(String reviewUuid, String reason) async {
    try {
      await _dioClient.post(
        '/admin/reviews/$reviewUuid/unhide',
        data: {'reason': reason},
      );
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }
}
