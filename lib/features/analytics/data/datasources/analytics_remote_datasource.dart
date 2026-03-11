import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/analytics_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<AnalyticsModel> getEventAnalytics(int eventId);
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final ApiClient apiClient;

  AnalyticsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AnalyticsModel> getEventAnalytics(int eventId) async {
    try {
      final response = await apiClient.get(ApiConstants.eventAnalytics(eventId));
      if (response.statusCode == 200) {
        return AnalyticsModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch analytics');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown analytics error');
    }
  }
}
