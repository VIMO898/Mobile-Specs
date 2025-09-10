import 'package:app/constants/hive_box_names.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final deviceComparisonBoxProvider =
    Provider((ref) => Hive.box(HiveBoxNames.selectedDevicesForComparison));
