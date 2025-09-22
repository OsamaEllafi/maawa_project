import '../../core/errors/error_mapper.dart';
import '../network/dio_client.dart';

class HealthApi {
  final DioClient _dioClient;

  HealthApi(this._dioClient);

  Future<Map<String, dynamic>> checkHealth() async {
    try {
      final response = await _dioClient.get('/health');
      final data = response.data['data'] ?? response.data;
      return Map<String, dynamic>.from(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }
}
