import '../../domain/reviews/reviews_repository.dart';
import '../../domain/reviews/entities/review.dart';
import 'reviews_api.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsApi _reviewsApi;

  ReviewsRepositoryImpl(this._reviewsApi);

  @override
  Future<Review> createReview({
    required String bookingUuid,
    required String revieweeUuid,
    required int rating,
    required String text,
  }) async {
    return await _reviewsApi.createReview(
      bookingUuid: bookingUuid,
      revieweeUuid: revieweeUuid,
      rating: rating,
      text: text,
    );
  }

  @override
  Future<Review> updateReview(
    String reviewUuid, {
    int? rating,
    String? text,
  }) async {
    return await _reviewsApi.updateReview(
      reviewUuid,
      rating: rating,
      text: text,
    );
  }

  @override
  Future<List<Review>> getPropertyReviews(
    String propertyUuid, {
    int page = 1,
    int perPage = 20,
  }) async {
    return await _reviewsApi.getPropertyReviews(
      propertyUuid,
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<List<Review>> getUserReviews(
    String userUuid, {
    int page = 1,
    int perPage = 20,
  }) async {
    return await _reviewsApi.getUserReviews(
      userUuid,
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<void> hideReview(String reviewUuid, String reason) async {
    await _reviewsApi.hideReview(reviewUuid, reason);
  }

  @override
  Future<void> unhideReview(String reviewUuid, String reason) async {
    await _reviewsApi.unhideReview(reviewUuid, reason);
  }
}
