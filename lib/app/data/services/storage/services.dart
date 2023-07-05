import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/utils/keys.dart';

//이
class StorageService extends GetxService {
  late GetStorage _box;

  Future<StorageService> init() async {
    //초기화 메서드
    _box = GetStorage(); //_box를 getstorage 인스턴스로 초기화
    await _box.writeIfNull(taskKey, []);
    return this;
  }

  T read<T>(String key) {
    return _box.read(key);
  }

  void write(String key, dynamic value) async {
    await _box.write(key, value);
  }
}
