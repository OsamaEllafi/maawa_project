class RouteNames {
  // Auth & Onboarding
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot';
  static const String resetPassword = '/reset';

  // Tenant Routes
  static const String home = '/home';
  static const String propertyDetail = '/properties/:id';
  static const String allProperties = '/properties';

  // Booking Routes
  static const String myBookings = '/bookings/my';
  static const String bookingRequest = '/bookings/request';
  static const String bookingDetail = '/bookings/:id';

  // Owner Routes
  static const String ownerProperties = '/owner/properties';
  static const String ownerPropertyEdit = '/owner/properties/:id/edit';
  static const String ownerPropertyMedia = '/owner/properties/:id/media';
  static const String ownerBookings = '/owner/bookings';

  // Wallet Routes
  static const String wallet = '/wallet';
  static const String walletTopup = '/wallet/topup';
  static const String walletWithdraw = '/wallet/withdraw';
  static const String walletHistory = '/wallet/history';

  // Admin Routes
  static const String admin = '/admin';
  static const String adminProperties = '/admin/properties';
  static const String adminUsers = '/admin/users';
  static const String adminBookings = '/admin/bookings';
  static const String adminWalletAdjust = '/admin/wallet-adjust';
  static const String adminMockEmails = '/admin/mock-emails';
  static const String adminAuditLogs = '/admin/audit-logs';

  // Profile & Settings
  static const String profile = '/profile';
  static const String profileKyc = '/profile/kyc';
  static const String settings = '/settings';
  static const String about = '/about';

  // Reviews
  static const String reviews = '/reviews';
  static const String writeReview = '/reviews/write';

  // Helper methods for route generation
  static String propertyDetailPath(String id) => '/properties/$id';
  static String bookingDetailPath(String id) => '/bookings/$id';
  static String ownerPropertyEditPath(String id) => '/owner/properties/$id/edit';
  static String ownerPropertyMediaPath(String id) => '/owner/properties/$id/media';
  static String bookingRequestPath(String propertyId) => '/bookings/request?propertyId=$propertyId';
}
