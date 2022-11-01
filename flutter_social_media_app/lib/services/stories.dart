import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

import '../data/story.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

class StoryService {
  final storiesRef = _db.collection('stories').withConverter<Story>(
        fromFirestore: (snapshot, _) => Story.fromJson(snapshot.data()!),
        toFirestore: (story, _) => story.toJson(),
      );

  Future<QuerySnapshot<Story>> getStories() {
    return storiesRef.get();
  }

  Future<void> addStory(String content, String author, [File? image]) async {
    final docRef = await storiesRef
        .add(Story.fromJson({'content': content, 'author': author}));

    if (image != null) {
      final imagePath = '${docRef.path}${path.extension(image.path)}';

      await FirebaseStorage.instance.ref(imagePath).putFile(image);

      await docRef.update({'imagePath': imagePath});
    }
  }

  Future<String> getThumbnailUrl(String imagePath) async {
    final name = path.basenameWithoutExtension(imagePath);
    final thumbnailPath = 'stories/stories_thumbnails/${name}_300x300.jpeg';

    final ref = FirebaseStorage.instance.ref(thumbnailPath);

    return ref.getDownloadURL();
  }
}
