part of 'image_picker_bloc.dart';

enum ImagePickerStatus {
  unknown,
  picked,
  uploading,
  uploaded,
  error,
}

class ImagePickerState extends Equatable {
  const ImagePickerState({
    required this.imagePickerStatus,
    this.image,
    this.imgName,
  });

  factory ImagePickerState.unknown() {
    return const ImagePickerState(imagePickerStatus: ImagePickerStatus.unknown);
  }

  final ImagePickerStatus imagePickerStatus;
  final File? image;
  final String? imgName;

  @override
  String toString() =>
      'ImagePickerState(imagePickerStatus: $imagePickerStatus, image: $image, imgName: $imgName)';

  ImagePickerState copyWith({
    ImagePickerStatus? imagePickerStatus,
    File? image,
    String? imgName,
  }) {
    return ImagePickerState(
      imagePickerStatus: imagePickerStatus ?? this.imagePickerStatus,
      image: image,
      imgName: imgName ?? this.imgName,
    );
  }

  @override
  List<Object?> get props => [imagePickerStatus, image, imgName];
}
