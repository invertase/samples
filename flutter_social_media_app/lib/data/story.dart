import 'package:freezed_annotation/freezed_annotation.dart';

part 'story.freezed.dart';
part 'story.g.dart';

@freezed
class Story with _$Story {
  const factory Story({
    required String content,
    required String author,
    String? imagePath,
  }) = _Story;

  factory Story.fromJson(Map<String, Object?> json) => _$StoryFromJson(json);
}
