import 'package:app/providers/general/theme_state_repository.dart';
import 'package:app/providers/hive_boxes/theme_state_box_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeStateRepositoryProvider = Provider((ref) {
  final box = ref.watch(themeStateBoxProvider);
  return ThemeStateRepository(box);
});
