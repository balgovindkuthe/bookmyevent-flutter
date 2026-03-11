import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/checkin_model.dart';

abstract class CheckInRemoteDataSource {
  Future<CheckInModel> handleScan(String qrCodeUuid);
}

class CheckInRemoteDataSourceImpl implements CheckInRemoteDataSource {
  final ApiClient apiClient;

  CheckInRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CheckInModel> handleScan(String qrCodeUuid) async {
    try {
      final response = await apiClient.post(
        ApiConstants.checkInScan,
        data: {'qrCodeUuid': qrCodeUuid},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CheckInModel.fromJson(response.data);
      } else {
         throw ServerException('Failed to process QR code');
      }
    } on DioException catch (e) {
      if(e.response?.statusCode == 400 || e.response?.statusCode == 404) {
        // Return structured error map parsing if backend returns 400 with a message for invalid tickets.
        // Assuming backend sends `status` and `message` in a 400/404 payload too for checkin context
        if (e.response?.data is Map<String, dynamic>) {
           return CheckInModel.fromJson(e.response!.data);
        }
      }
      throw ServerException(e.message ?? 'Unknown check in error');
    }
  }
}
