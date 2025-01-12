abstract class ICameraService {
  Future<String?> takePicture();
  Future<String?> pickImageFromGallery();
}
