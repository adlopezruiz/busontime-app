part of 'image_picker_bloc.dart';

enum ImagePickerStatus {
  unknown,
  picked,
  uploaded,
  error,
}

class ImagePickerState extends Equatable {
  const ImagePickerState({
    required this.imagePickerStatus,
    this.image,
  });

  factory ImagePickerState.unknown() {
    return const ImagePickerState(imagePickerStatus: ImagePickerStatus.unknown);
  }

  final ImagePickerStatus imagePickerStatus;
  final File? image;

  @override
  String toString() =>
      'ImagePickerState(imagePickerStatus: $imagePickerStatus, image: $image)';

  ImagePickerState copyWith({
    ImagePickerStatus? imagePickerStatus,
    File? image,
    String? error,
  }) {
    return ImagePickerState(
      imagePickerStatus: imagePickerStatus ?? this.imagePickerStatus,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [imagePickerStatus, image];
}
