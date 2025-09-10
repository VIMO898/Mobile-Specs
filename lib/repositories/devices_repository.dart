import 'package:app/models/device_overview_model.dart';
import 'package:app/models/user_activity_entry_model.dart';
import 'package:app/models/user_activity_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../exceptions/custom_exception.dart';

// Do not change the enum values, as they are used to access firestore db collections
enum DeviceType { wishlist, comparedDevices, history }

final defaultUserActivity = UserActivityModel(
  wishlist: [],
  comparedDevices: [],
  history: [],
  news: [],
);

abstract class BaseDevicesRepository {
  Stream<UserActivityModel> getUserDeviceActivityStream();
  Future<List<DeviceOverviewModel>> getDevices(List<String> deviceIds);
  Stream<Future<List<DeviceOverviewModel>>> getDevicesStream(
    DeviceType deviceType,
  );
  Future<void> addDevice(
    DeviceType deviceType,
    UserActivityEntryModel deviceEntry,
    DeviceOverviewModel device,
  );
  Future<void> removeDevice(
    DeviceType deviceType,
    UserActivityEntryModel entry,
  );
}

class DevicesRepository implements BaseDevicesRepository {
  final User? user;
  final FirebaseFirestore firestore;
  const DevicesRepository({required this.user, required this.firestore});

  CollectionReference<Map<String, dynamic>> get userActivityCollection =>
      firestore.collection('userActivity');
  CollectionReference<Map<String, dynamic>> get collection =>
      firestore.collection('devices');

  @override
  Stream<UserActivityModel> getUserDeviceActivityStream() {
    try {
      final uid = user?.uid;
      if (uid == null) return Stream.value(defaultUserActivity);

      final streamDocSnapshot = userActivityCollection.doc(uid).snapshots();
      final userDeviceActivityStream = streamDocSnapshot.map((docSnapshot) {
        final userActivityExists = docSnapshot.exists;
        if (!userActivityExists) return defaultUserActivity;
        final userDeviceActivityMap = docSnapshot.data()!;
        final userDevicesActivity = UserActivityModel.fromMap(
          userDeviceActivityMap,
        );
        return userDevicesActivity;
      });
      return userDeviceActivityStream;
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message ?? 'Oops! Something went wrong. Please try again.',
      );
    } catch (e) {
      throw CustomException(
        code: '500',
        message:
            'An unknown error has occurred. Please check your internet connection.',
      );
    }
  }

  Future<DeviceOverviewModel?> _getDeviceOverview(String id) async {
    try {
      final docSnapshot = await collection.doc(id).get();
      final data = docSnapshot.data();
      return data != null ? DeviceOverviewModel.fromMap(data) : null;
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message ?? 'Oops! Something went wrong. Please try again.',
      );
    } catch (e) {
      throw CustomException(
        code: '500',
        message:
            'An unknown error has occurred. Please check your internet connection.',
      );
    }
  }

  @override
  Future<List<DeviceOverviewModel>> getDevices(List<String> deviceIds) async {
    final deviceOverviewFutures = deviceIds
        .map((id) => _getDeviceOverview(id))
        .toList();
    final devices = await Future.wait<DeviceOverviewModel?>(
      deviceOverviewFutures,
    );
    return devices.whereType<DeviceOverviewModel>().toList();
  }

  @override
  Stream<Future<List<DeviceOverviewModel>>> getDevicesStream(DeviceType type) {
    return getUserDeviceActivityStream().map((userDeviceActivity) {
      final deviceIds = List<String>.from(
        userDeviceActivity.toMap()[type.name].map((e) => e['id']).toList(),
      );
      return getDevices(deviceIds);
    });
  }

  @override
  Future<void> addDevice(
    DeviceType deviceType,
    UserActivityEntryModel deviceEntry,
    DeviceOverviewModel device,
  ) async {
    try {
      final fieldName = deviceType.name;
      final uid = user?.uid;
      if (uid == null) return;
      await userActivityCollection.doc(uid).set({
        fieldName: FieldValue.arrayUnion([deviceEntry.toMap()]),
      }, SetOptions(merge: true));
      final docSnapshot = await collection.doc(device.id).get();
      final deviceExists = docSnapshot.exists;
      final collectionDoc = collection.doc(device.id);
      if (!deviceExists) {
        final deviceOvervieMap = device.toMap();
        deviceOvervieMap.addAll({
          'usedBy': [uid],
        });
        await collectionDoc.set(deviceOvervieMap);
      } else {
        await collectionDoc.update({
          'usedBy': FieldValue.arrayUnion([uid]),
        });
      }
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message ?? 'Unable to add this device',
      );
    } catch (e) {
      throw CustomException(
        code: '500',
        message:
            'An unknown error has occurred. Please check your internet connection.',
      );
    }
  }

  @override
  Future<void> removeDevice(
    DeviceType deviceType,
    UserActivityEntryModel entry,
  ) async {
    try {
      final uid = user?.uid;
      final fieldName = deviceType.name;

      if (uid == null) return;
      await userActivityCollection.doc(uid).set({
        fieldName: FieldValue.arrayRemove([entry.toMap()]),
      }, SetOptions(merge: true));
      final docSnapshot = await collection.doc(entry.id).get();

      if (docSnapshot.exists) {
        final collectionDoc = collection.doc(entry.id);
        final dataMap = docSnapshot.data()!;
        final usersUsingThisData = List<String>.from(dataMap['usedBy']);
        final containsThisUser = usersUsingThisData.contains(uid);
        if (usersUsingThisData.length == 1 && containsThisUser) {
          await collectionDoc.delete();
        }
      }
    } on FirebaseException catch (e) {
      throw CustomException(
        code: e.code,
        message: e.message ?? 'Unable to remove this device',
      );
    } catch (e) {
      throw CustomException(
        code: '500',
        message:
            'An unknown error has occurred. Please check your internet connection.',
      );
    }
  }
}
