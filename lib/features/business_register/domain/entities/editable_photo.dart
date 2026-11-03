import 'package:equatable/equatable.dart';

/// A business photo in the edit form: either one already stored remotely or
/// one just picked from the device and not uploaded yet.
class EditablePhoto extends Equatable {
  /// A photo that already has a `business_images` row.
  const EditablePhoto.remote({
    required String this.id,
    required String this.url,
    this.storagePath,
  }) : localPath = null;

  /// A freshly picked photo, uploaded on save.
  const EditablePhoto.local(String this.localPath)
    : id = null,
      url = null,
      storagePath = null;

  /// `business_images.id`; null for local photos.
  final String? id;

  /// Displayable public URL; null for local photos.
  final String? url;

  /// Bucket object path, when the image lives in our storage bucket (seeded
  /// rows may point at external URLs, which we never try to delete).
  final String? storagePath;

  /// Device file path; null for remote photos.
  final String? localPath;

  bool get isLocal => localPath != null;

  @override
  List<Object?> get props => [id, url, storagePath, localPath];
}
