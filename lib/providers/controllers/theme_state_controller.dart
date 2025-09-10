import 'package:app/controllers/theme_state_controller.dart';
import 'package:app/models/theme_state_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/theme_state_repository_provider.dart';

final themeStateControllerProvider =
    StateNotifierProvider<ThemeStateController, ThemeStateModel>((ref) {
      final repository = ref.watch(themeStateRepositoryProvider);
      return ThemeStateController(repository);
    });
