import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/cicilan_service.dart';

final layananCicilanProvider = Provider<LayananCicilan>(
  (ref) => LayananCicilan(),
);
