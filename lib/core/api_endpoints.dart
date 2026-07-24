class ApiEndpoints {
  ApiEndpoints._();

  static const String applications = '/api/applications';
  static String application(String id) => '/api/applications/$id';

  static const String authCallbackFayda = '/api/auth/callback/fayda';

  static String certificateDownload(String id) =>
      '/api/certificates/$id/download';
  static String certificateDownloadAlt(String id) =>
      '/api/certificates/download/$id';
  static const String certificateGeneratePdf = '/api/certificates/generate-pdf';

  static const String cronCheckExpirations = '/api/cron/check-expirations';

  static const String ecosystemApplication =
      '/api/ecosystem-builder/application';
  static String ecosystemApplicationId(String id) =>
      '/api/ecosystem-builder/application/$id';
  static const String ecosystemApply = '/api/ecosystem-builder/apply';
  static const String ecosystemBookings = '/api/ecosystem-builder/bookings';
  static String ecosystemBooking(String id) =>
      '/api/ecosystem-builder/bookings/$id';
  static const String ecosystemEvents = '/api/ecosystem-builder/events';
  static String ecosystemEvent(String id) =>
      '/api/ecosystem-builder/events/$id';
  static String ecosystemEventAttendees(String id) =>
      '/api/ecosystem-builder/events/$id/attendees';
  static String ecosystemEventAttendee(String id, String attendeeId) =>
      '/api/ecosystem-builder/events/$id/attendees/$attendeeId';
  static const String ecosystemFunding = '/api/ecosystem-builder/funding';
  static String ecosystemFundingId(String id) =>
      '/api/ecosystem-builder/funding/$id';
  static const String ecosystemFundingApplications =
      '/api/ecosystem-builder/funding/applications';
  static String ecosystemFundingApplication(String id) =>
      '/api/ecosystem-builder/funding/applications/$id';
  static const String ecosystemInvestmentsPitches =
      '/api/ecosystem-builder/investments/pitches';
  static const String ecosystemInvestmentsProfile =
      '/api/ecosystem-builder/investments/profile';
  static const String ecosystemNews = '/api/ecosystem-builder/news';
  static String ecosystemNewsId(String id) => '/api/ecosystem-builder/news/$id';
  static const String ecosystemSpaces = '/api/ecosystem-builder/spaces';
  static String ecosystemSpace(String id) =>
      '/api/ecosystem-builder/spaces/$id';

  static const String events = '/api/events';
  static String event(String id) => '/api/events/$id';
  static String eventRegister(String id) => '/api/events/$id/register';
  static const String eventMyRegistrations = '/api/events/my-registrations';

  static String file(String id) => '/api/files/$id';
  static String fileDownload(String id) => '/api/files/$id/download';
  static const String fileUpload = '/api/files/upload';

  static const String funding = '/api/funding';
  static String fundingId(String id) => '/api/funding/$id';
  static String fundingApply(String id) => '/api/funding/$id/apply';
  static const String fundingMyApplications = '/api/funding/my-applications';
  static const String fundingSave = '/api/funding/save';

  static const String notificationsStream = '/api/notifications/stream';

  static const String pitches = '/api/pitches';

  static const String protected = '/api/protected';

  static const String startupMyStatus = '/api/startups/my-status';
  static const String startupRenew = '/api/startups/renew';

  static const String verifyNationalId = '/api/verify-national-id';
  static const String verifyTin = '/api/verify-tin';
}
