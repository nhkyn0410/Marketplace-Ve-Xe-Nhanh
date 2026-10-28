//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:built_value/serializer.dart';
import 'package:api_client_dart/src/serializers.dart';
import 'package:api_client_dart/src/auth/api_key_auth.dart';
import 'package:api_client_dart/src/auth/basic_auth.dart';
import 'package:api_client_dart/src/auth/bearer_auth.dart';
import 'package:api_client_dart/src/auth/oauth.dart';
import 'package:api_client_dart/src/api/admin_articles_api.dart';
import 'package:api_client_dart/src/api/admin_audit_logs_api.dart';
import 'package:api_client_dart/src/api/admin_catalog_api.dart';
import 'package:api_client_dart/src/api/admin_commission_api.dart';
import 'package:api_client_dart/src/api/admin_content_pages_api.dart';
import 'package:api_client_dart/src/api/admin_counter_commissions_api.dart';
import 'package:api_client_dart/src/api/admin_disputes_api.dart';
import 'package:api_client_dart/src/api/admin_loyalty_api.dart';
import 'package:api_client_dart/src/api/admin_notification_api.dart';
import 'package:api_client_dart/src/api/admin_operator_applications_api.dart';
import 'package:api_client_dart/src/api/admin_operators_api.dart';
import 'package:api_client_dart/src/api/admin_payments_api.dart';
import 'package:api_client_dart/src/api/admin_payouts_api.dart';
import 'package:api_client_dart/src/api/admin_policies_api.dart';
import 'package:api_client_dart/src/api/admin_promotions_api.dart';
import 'package:api_client_dart/src/api/admin_refunds_api.dart';
import 'package:api_client_dart/src/api/admin_reports_api.dart';
import 'package:api_client_dart/src/api/admin_reviews_api.dart';
import 'package:api_client_dart/src/api/admin_routes_api.dart';
import 'package:api_client_dart/src/api/admin_stop_points_api.dart';
import 'package:api_client_dart/src/api/admin_support_api.dart';
import 'package:api_client_dart/src/api/admin_system_api.dart';
import 'package:api_client_dart/src/api/admin_trips_api.dart';
import 'package:api_client_dart/src/api/admin_users_api.dart';
import 'package:api_client_dart/src/api/admin_vehicle_images_api.dart';
import 'package:api_client_dart/src/api/articles_api.dart';
import 'package:api_client_dart/src/api/auth_api.dart';
import 'package:api_client_dart/src/api/bookings_api.dart';
import 'package:api_client_dart/src/api/cancellations_api.dart';
import 'package:api_client_dart/src/api/catalog_api.dart';
import 'package:api_client_dart/src/api/content_pages_api.dart';
import 'package:api_client_dart/src/api/counter_sales_api.dart';
import 'package:api_client_dart/src/api/disputes_api.dart';
import 'package:api_client_dart/src/api/employee_operations_api.dart';
import 'package:api_client_dart/src/api/health_api.dart';
import 'package:api_client_dart/src/api/incidents_api.dart';
import 'package:api_client_dart/src/api/journey_logs_api.dart';
import 'package:api_client_dart/src/api/notification_api.dart';
import 'package:api_client_dart/src/api/operator_applications_api.dart';
import 'package:api_client_dart/src/api/operator_bookings_api.dart';
import 'package:api_client_dart/src/api/operator_disputes_api.dart';
import 'package:api_client_dart/src/api/operator_employees_api.dart';
import 'package:api_client_dart/src/api/operator_fares_api.dart';
import 'package:api_client_dart/src/api/operator_finance_api.dart';
import 'package:api_client_dart/src/api/operator_managers_api.dart';
import 'package:api_client_dart/src/api/operator_offices_api.dart';
import 'package:api_client_dart/src/api/operator_profile_api.dart';
import 'package:api_client_dart/src/api/operator_promotions_api.dart';
import 'package:api_client_dart/src/api/operator_reports_api.dart';
import 'package:api_client_dart/src/api/operator_reviews_api.dart';
import 'package:api_client_dart/src/api/operator_routes_api.dart';
import 'package:api_client_dart/src/api/operator_seat_maps_api.dart';
import 'package:api_client_dart/src/api/operator_stop_point_proposals_api.dart';
import 'package:api_client_dart/src/api/operator_stop_points_api.dart';
import 'package:api_client_dart/src/api/operator_support_api.dart';
import 'package:api_client_dart/src/api/operator_trip_assignments_api.dart';
import 'package:api_client_dart/src/api/operator_trip_schedules_api.dart';
import 'package:api_client_dart/src/api/operator_trips_api.dart';
import 'package:api_client_dart/src/api/operator_vehicles_api.dart';
import 'package:api_client_dart/src/api/passenger_loyalty_api.dart';
import 'package:api_client_dart/src/api/passenger_profile_api.dart';
import 'package:api_client_dart/src/api/payments_api.dart';
import 'package:api_client_dart/src/api/promotions_api.dart';
import 'package:api_client_dart/src/api/public_operators_api.dart';
import 'package:api_client_dart/src/api/reviews_api.dart';
import 'package:api_client_dart/src/api/seat_holds_api.dart';
import 'package:api_client_dart/src/api/support_api.dart';
import 'package:api_client_dart/src/api/tickets_api.dart';
import 'package:api_client_dart/src/api/trips_api.dart';

class ApiClientDart {
  static const String basePath = r'http://localhost';

  final Dio dio;
  final Serializers serializers;

  ApiClientDart({
    Dio? dio,
    Serializers? serializers,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  })  : this.serializers = serializers ?? standardSerializers,
        this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens[name] = token;
    }
  }

  /// Removes the OAuth token associated with the given [name].
  ///
  /// If no [OAuthInterceptor] is registered or no token exists for the given
  /// [name], this method has no effect.
  void removeOAuthToken(String name) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens.remove(name);
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens[name] = token;
    }
  }

  /// Removes the bearer authentication token associated with the given [name].
  ///
  /// If no [BearerAuthInterceptor] is registered or no token exists for the
  /// given [name], this method has no effect.
  void removeBearerAuth(String name) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens.remove(name);
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo[name] = BasicAuthInfo(username, password);
    }
  }

  /// Removes the basic authentication credentials associated with the given [name].
  ///
  /// If no [BasicAuthInterceptor] is registered or no credentials exist for the
  /// given [name], this method has no effect.
  void removeBasicAuth(String name) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo.remove(name);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys[name] = apiKey;
    }
  }

  /// Removes the API key associated with the given [name].
  ///
  /// If no [ApiKeyAuthInterceptor] is registered or no API key exists for the
  /// given [name], this method has no effect.
  void removeApiKey(String name) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys.remove(name);
    }
  }

  /// Get AdminArticlesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminArticlesApi getAdminArticlesApi() {
    return AdminArticlesApi(dio, serializers);
  }

  /// Get AdminAuditLogsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminAuditLogsApi getAdminAuditLogsApi() {
    return AdminAuditLogsApi(dio, serializers);
  }

  /// Get AdminCatalogApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminCatalogApi getAdminCatalogApi() {
    return AdminCatalogApi(dio, serializers);
  }

  /// Get AdminCommissionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminCommissionApi getAdminCommissionApi() {
    return AdminCommissionApi(dio, serializers);
  }

  /// Get AdminContentPagesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminContentPagesApi getAdminContentPagesApi() {
    return AdminContentPagesApi(dio, serializers);
  }

  /// Get AdminCounterCommissionsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminCounterCommissionsApi getAdminCounterCommissionsApi() {
    return AdminCounterCommissionsApi(dio, serializers);
  }

  /// Get AdminDisputesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminDisputesApi getAdminDisputesApi() {
    return AdminDisputesApi(dio, serializers);
  }

  /// Get AdminLoyaltyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminLoyaltyApi getAdminLoyaltyApi() {
    return AdminLoyaltyApi(dio, serializers);
  }

  /// Get AdminNotificationApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminNotificationApi getAdminNotificationApi() {
    return AdminNotificationApi(dio, serializers);
  }

  /// Get AdminOperatorApplicationsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminOperatorApplicationsApi getAdminOperatorApplicationsApi() {
    return AdminOperatorApplicationsApi(dio, serializers);
  }

  /// Get AdminOperatorsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminOperatorsApi getAdminOperatorsApi() {
    return AdminOperatorsApi(dio, serializers);
  }

  /// Get AdminPaymentsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminPaymentsApi getAdminPaymentsApi() {
    return AdminPaymentsApi(dio, serializers);
  }

  /// Get AdminPayoutsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminPayoutsApi getAdminPayoutsApi() {
    return AdminPayoutsApi(dio, serializers);
  }

  /// Get AdminPoliciesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminPoliciesApi getAdminPoliciesApi() {
    return AdminPoliciesApi(dio, serializers);
  }

  /// Get AdminPromotionsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminPromotionsApi getAdminPromotionsApi() {
    return AdminPromotionsApi(dio, serializers);
  }

  /// Get AdminRefundsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminRefundsApi getAdminRefundsApi() {
    return AdminRefundsApi(dio, serializers);
  }

  /// Get AdminReportsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminReportsApi getAdminReportsApi() {
    return AdminReportsApi(dio, serializers);
  }

  /// Get AdminReviewsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminReviewsApi getAdminReviewsApi() {
    return AdminReviewsApi(dio, serializers);
  }

  /// Get AdminRoutesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminRoutesApi getAdminRoutesApi() {
    return AdminRoutesApi(dio, serializers);
  }

  /// Get AdminStopPointsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminStopPointsApi getAdminStopPointsApi() {
    return AdminStopPointsApi(dio, serializers);
  }

  /// Get AdminSupportApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminSupportApi getAdminSupportApi() {
    return AdminSupportApi(dio, serializers);
  }

  /// Get AdminSystemApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminSystemApi getAdminSystemApi() {
    return AdminSystemApi(dio, serializers);
  }

  /// Get AdminTripsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminTripsApi getAdminTripsApi() {
    return AdminTripsApi(dio, serializers);
  }

  /// Get AdminUsersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminUsersApi getAdminUsersApi() {
    return AdminUsersApi(dio, serializers);
  }

  /// Get AdminVehicleImagesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminVehicleImagesApi getAdminVehicleImagesApi() {
    return AdminVehicleImagesApi(dio, serializers);
  }

  /// Get ArticlesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ArticlesApi getArticlesApi() {
    return ArticlesApi(dio, serializers);
  }

  /// Get AuthApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AuthApi getAuthApi() {
    return AuthApi(dio, serializers);
  }

  /// Get BookingsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BookingsApi getBookingsApi() {
    return BookingsApi(dio, serializers);
  }

  /// Get CancellationsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  CancellationsApi getCancellationsApi() {
    return CancellationsApi(dio, serializers);
  }

  /// Get CatalogApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  CatalogApi getCatalogApi() {
    return CatalogApi(dio, serializers);
  }

  /// Get ContentPagesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ContentPagesApi getContentPagesApi() {
    return ContentPagesApi(dio, serializers);
  }

  /// Get CounterSalesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  CounterSalesApi getCounterSalesApi() {
    return CounterSalesApi(dio, serializers);
  }

  /// Get DisputesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DisputesApi getDisputesApi() {
    return DisputesApi(dio, serializers);
  }

  /// Get EmployeeOperationsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  EmployeeOperationsApi getEmployeeOperationsApi() {
    return EmployeeOperationsApi(dio, serializers);
  }

  /// Get HealthApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  HealthApi getHealthApi() {
    return HealthApi(dio, serializers);
  }

  /// Get IncidentsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  IncidentsApi getIncidentsApi() {
    return IncidentsApi(dio, serializers);
  }

  /// Get JourneyLogsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  JourneyLogsApi getJourneyLogsApi() {
    return JourneyLogsApi(dio, serializers);
  }

  /// Get NotificationApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  NotificationApi getNotificationApi() {
    return NotificationApi(dio, serializers);
  }

  /// Get OperatorApplicationsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorApplicationsApi getOperatorApplicationsApi() {
    return OperatorApplicationsApi(dio, serializers);
  }

  /// Get OperatorBookingsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorBookingsApi getOperatorBookingsApi() {
    return OperatorBookingsApi(dio, serializers);
  }

  /// Get OperatorDisputesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorDisputesApi getOperatorDisputesApi() {
    return OperatorDisputesApi(dio, serializers);
  }

  /// Get OperatorEmployeesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorEmployeesApi getOperatorEmployeesApi() {
    return OperatorEmployeesApi(dio, serializers);
  }

  /// Get OperatorFaresApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorFaresApi getOperatorFaresApi() {
    return OperatorFaresApi(dio, serializers);
  }

  /// Get OperatorFinanceApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorFinanceApi getOperatorFinanceApi() {
    return OperatorFinanceApi(dio, serializers);
  }

  /// Get OperatorManagersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorManagersApi getOperatorManagersApi() {
    return OperatorManagersApi(dio, serializers);
  }

  /// Get OperatorOfficesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorOfficesApi getOperatorOfficesApi() {
    return OperatorOfficesApi(dio, serializers);
  }

  /// Get OperatorProfileApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorProfileApi getOperatorProfileApi() {
    return OperatorProfileApi(dio, serializers);
  }

  /// Get OperatorPromotionsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorPromotionsApi getOperatorPromotionsApi() {
    return OperatorPromotionsApi(dio, serializers);
  }

  /// Get OperatorReportsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorReportsApi getOperatorReportsApi() {
    return OperatorReportsApi(dio, serializers);
  }

  /// Get OperatorReviewsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorReviewsApi getOperatorReviewsApi() {
    return OperatorReviewsApi(dio, serializers);
  }

  /// Get OperatorRoutesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorRoutesApi getOperatorRoutesApi() {
    return OperatorRoutesApi(dio, serializers);
  }

  /// Get OperatorSeatMapsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorSeatMapsApi getOperatorSeatMapsApi() {
    return OperatorSeatMapsApi(dio, serializers);
  }

  /// Get OperatorStopPointProposalsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorStopPointProposalsApi getOperatorStopPointProposalsApi() {
    return OperatorStopPointProposalsApi(dio, serializers);
  }

  /// Get OperatorStopPointsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorStopPointsApi getOperatorStopPointsApi() {
    return OperatorStopPointsApi(dio, serializers);
  }

  /// Get OperatorSupportApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorSupportApi getOperatorSupportApi() {
    return OperatorSupportApi(dio, serializers);
  }

  /// Get OperatorTripAssignmentsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorTripAssignmentsApi getOperatorTripAssignmentsApi() {
    return OperatorTripAssignmentsApi(dio, serializers);
  }

  /// Get OperatorTripSchedulesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorTripSchedulesApi getOperatorTripSchedulesApi() {
    return OperatorTripSchedulesApi(dio, serializers);
  }

  /// Get OperatorTripsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorTripsApi getOperatorTripsApi() {
    return OperatorTripsApi(dio, serializers);
  }

  /// Get OperatorVehiclesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorVehiclesApi getOperatorVehiclesApi() {
    return OperatorVehiclesApi(dio, serializers);
  }

  /// Get PassengerLoyaltyApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  PassengerLoyaltyApi getPassengerLoyaltyApi() {
    return PassengerLoyaltyApi(dio, serializers);
  }

  /// Get PassengerProfileApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  PassengerProfileApi getPassengerProfileApi() {
    return PassengerProfileApi(dio, serializers);
  }

  /// Get PaymentsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  PaymentsApi getPaymentsApi() {
    return PaymentsApi(dio, serializers);
  }

  /// Get PromotionsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  PromotionsApi getPromotionsApi() {
    return PromotionsApi(dio, serializers);
  }

  /// Get PublicOperatorsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  PublicOperatorsApi getPublicOperatorsApi() {
    return PublicOperatorsApi(dio, serializers);
  }

  /// Get ReviewsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ReviewsApi getReviewsApi() {
    return ReviewsApi(dio, serializers);
  }

  /// Get SeatHoldsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SeatHoldsApi getSeatHoldsApi() {
    return SeatHoldsApi(dio, serializers);
  }

  /// Get SupportApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SupportApi getSupportApi() {
    return SupportApi(dio, serializers);
  }

  /// Get TicketsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TicketsApi getTicketsApi() {
    return TicketsApi(dio, serializers);
  }

  /// Get TripsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TripsApi getTripsApi() {
    return TripsApi(dio, serializers);
  }
}
