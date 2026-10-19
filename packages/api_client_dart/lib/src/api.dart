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
import 'package:api_client_dart/src/api/admin_operator_applications_api.dart';
import 'package:api_client_dart/src/api/admin_operators_api.dart';
import 'package:api_client_dart/src/api/admin_policies_api.dart';
import 'package:api_client_dart/src/api/admin_stop_points_api.dart';
import 'package:api_client_dart/src/api/admin_system_api.dart';
import 'package:api_client_dart/src/api/admin_users_api.dart';
import 'package:api_client_dart/src/api/admin_vehicle_images_api.dart';
import 'package:api_client_dart/src/api/articles_api.dart';
import 'package:api_client_dart/src/api/auth_api.dart';
import 'package:api_client_dart/src/api/catalog_api.dart';
import 'package:api_client_dart/src/api/content_pages_api.dart';
import 'package:api_client_dart/src/api/health_api.dart';
import 'package:api_client_dart/src/api/operator_applications_api.dart';
import 'package:api_client_dart/src/api/operator_employees_api.dart';
import 'package:api_client_dart/src/api/operator_fares_api.dart';
import 'package:api_client_dart/src/api/operator_profile_api.dart';
import 'package:api_client_dart/src/api/operator_routes_api.dart';
import 'package:api_client_dart/src/api/operator_seat_maps_api.dart';
import 'package:api_client_dart/src/api/operator_stop_point_proposals_api.dart';
import 'package:api_client_dart/src/api/operator_stop_points_api.dart';
import 'package:api_client_dart/src/api/operator_trip_assignments_api.dart';
import 'package:api_client_dart/src/api/operator_trip_schedules_api.dart';
import 'package:api_client_dart/src/api/operator_trips_api.dart';
import 'package:api_client_dart/src/api/operator_vehicles_api.dart';

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

  /// Get AdminPoliciesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminPoliciesApi getAdminPoliciesApi() {
    return AdminPoliciesApi(dio, serializers);
  }

  /// Get AdminStopPointsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminStopPointsApi getAdminStopPointsApi() {
    return AdminStopPointsApi(dio, serializers);
  }

  /// Get AdminSystemApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminSystemApi getAdminSystemApi() {
    return AdminSystemApi(dio, serializers);
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

  /// Get HealthApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  HealthApi getHealthApi() {
    return HealthApi(dio, serializers);
  }

  /// Get OperatorApplicationsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorApplicationsApi getOperatorApplicationsApi() {
    return OperatorApplicationsApi(dio, serializers);
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

  /// Get OperatorProfileApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OperatorProfileApi getOperatorProfileApi() {
    return OperatorProfileApi(dio, serializers);
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
}
