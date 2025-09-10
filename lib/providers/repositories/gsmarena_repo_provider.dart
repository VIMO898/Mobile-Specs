import 'package:app/repositories/gsmarena_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gsmarenRepoProvider = Provider((ref) => GsmarenaRepository());
