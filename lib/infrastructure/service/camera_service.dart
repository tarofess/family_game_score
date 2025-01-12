import 'package:family_game_score/application/interface/camera_service.dart';
import 'package:image_picker/image_picker.dart';

class CameraService implements ICameraService {
  final ImagePicker picker = ImagePicker();

  @override
  Future<String?> takePicture() async {
    try {
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 80,
      );
      return photo?.path;
    } catch (e) {
      throw Exception('写真の撮影中にエラーが発生しました。');
    }
  }

  @override
  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 80,
      );
      return image?.path;
    } catch (e) {
      throw Exception('写真の選択中にエラーが発生しました。');
    }
  }
}
