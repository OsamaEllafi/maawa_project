import 'entities/review.dart';

abstract class ReviewsRepository {
  // Create and update reviews
  Future<Review> createReview({
    required String bookingUuid,
    required String revieweeUuid,
    required int rating,
    required String text,
  });

  Future<Review> updateReview(
    String reviewUuid, {
    int? rating,
    String? text,
  });

  // Get reviews
  Future<List<Review>> getPropertyReviews(
    String propertyUuid, {
    int page = 1,
    int perPage = 20,
  });

  Future<List<Review>> getUserReviews(
    String userUuid, {
    int page = 1,
    int perPage = 20,
  });

  // Admin operations
  Future<void> hideReview(String reviewUuid, String reason);

  Future<void> unhideReview(String reviewUuid, String reason);
}
