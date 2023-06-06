part of 'image_picker_bloc.dart';

abstract class ImagePickerEvent extends Equatable {
  const ImagePickerEvent();

  @override
  List<Object> get props => [];
}

class PickImageRequestedEvent extends ImagePickerEvent {}

class MakePhotoRequestedEvent extends ImagePickerEvent {}

class UploadImageRequestedEvent extends ImagePickerEvent {}

class RemoveImageFromPickerEvent extends ImagePickerEvent {}
