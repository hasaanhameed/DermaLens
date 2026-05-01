import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'api_base.dart';

class ScanService extends ApiBase {
  Future<Map<String, dynamic>> analyzeScan(XFile imageFile) async {
    final url = Uri.parse('${ApiBase.baseUrl}/scans/analyze');
    final request = http.MultipartRequest('POST', url);
    
    // Use centralized headers
    final headers = await getHeaders();
    request.headers.addAll(headers);

    final bytes = await imageFile.readAsBytes();
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: imageFile.name,
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return handleResponse(response);
  }

  Future<List<dynamic>> getScanHistory() async {
    final response = await get('/scans');
    return handleResponse(response);
  }
}
