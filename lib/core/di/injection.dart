import 'package:get_it/get_it.dart';
import '../../network/api_client.dart';
import '../../network/dio_client.dart';
import '../../services/firebase_service.dart';
import '../../repositories/base_repository.dart';

final sl = GetIt.instance;

Future<void> setupDependencyInjection() async {
  sl.registerLazySingleton<ApiClient>(() => DioClient());
  sl.registerLazySingleton(() => LayananFirebase());
  sl.registerLazySingleton(() => BaseRepository());
}
