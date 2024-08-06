import 'package:image_picker/image_picker.dart';

class CameraService {
  final ImagePicker picker = ImagePicker();

  Future<String?> takePicture() async {
    try {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      return photo?.path;
    } catch (e) {
      throw Exception('画像の撮影中にエラーが発生しました');
    }
  }

  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image?.path;
    } catch (e) {
      throw Exception('画像の選択中にエラーが発生しました');
    }
  }
}
