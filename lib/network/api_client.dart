abstract class ApiClient {
  Future<dynamic> get(String url, {Map<String, dynamic>? param});
  Future<dynamic> post(String url, {dynamic data});
  Future<dynamic> put(String url, {dynamic data});
  Future<dynamic> delete(String url);
}
