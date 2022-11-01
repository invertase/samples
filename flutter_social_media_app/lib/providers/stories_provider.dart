import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/story.dart';
import '../services/stories.dart';

final storyService = Provider<StoryService>((_) => StoryService());

final stories = FutureProvider<List<Story>>((ref) async {
  final res = await ref.watch(storyService).getStories();

  return res.docs.map<Story>((e) => e.data()).toList();
});

final storyThumbnail = FutureProvider.autoDispose.family<String, String>((ref, path) async {
  final res = await ref.watch(storyService).getThumbnailUrl(path);

  return res;
});