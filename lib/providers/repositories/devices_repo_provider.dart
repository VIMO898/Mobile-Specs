import 'package:app/providers/controllers/auth_controller_provider.dart';
import 'package:app/providers/general/firestore_provider.dart';
import 'package:app/repositories/devices_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final devicesRepositoryProvider = Provider<BaseDevicesRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final user = ref.watch(authControllerProvider);
  return DevicesRepository(firestore: firestore, user: user);
});
