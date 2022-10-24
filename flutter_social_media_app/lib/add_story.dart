import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'padding.dart';
import 'providers/stories_provider.dart';

class AddStoryPage extends ConsumerStatefulWidget {
  const AddStoryPage({super.key});

  @override
  ConsumerState<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends ConsumerState<AddStoryPage> {
  final contentController = TextEditingController();
  final authorController = TextEditingController();
  final picker = ImagePicker();
  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text(
          'Add Story',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.large),
            child: Column(
              children: [
                if (imageFile != null) ...[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(File(imageFile!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 200,
                  ),
                  const SizedBox(height: AppPadding.large),
                ],
                TextFormField(
                  controller: contentController,
                  decoration: InputDecoration(
                    hintText: 'Start writing...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.1),
                    filled: true,
                  ),
                  minLines: 10,
                  maxLines: 40,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: authorController,
                  decoration: InputDecoration(
                    hintText: 'Your name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.1),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () async {
                      if (imageFile != null) {
                        setState(() {
                          imageFile = null;
                        });
                      } else {
                        final image =
                            await picker.pickImage(source: ImageSource.gallery);

                        setState(() {
                          imageFile = image;
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(imageFile != null
                            ? Icons.delete_forever_rounded
                            : Icons.camera_alt_rounded),
                        const SizedBox(width: 10),
                        Text(imageFile != null
                            ? 'Delete image'
                            : 'Pick an image'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () async {
                      await ref.watch(storyService).addStory(
                            contentController.text,
                            authorController.text,
                            imageFile != null ? File(imageFile!.path) : null,
                          );
                    },
                    child: const Text('Submit story'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
