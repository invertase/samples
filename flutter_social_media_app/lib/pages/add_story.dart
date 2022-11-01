import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../padding.dart';
import '../providers/stories_provider.dart';

class AddStoryPage extends ConsumerStatefulWidget {
  const AddStoryPage({super.key});

  @override
  ConsumerState<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends ConsumerState<AddStoryPage> {
  final formKey = GlobalKey<FormState>();
  final contentController = TextEditingController();
  final authorController = TextEditingController();
  final picker = ImagePicker();
  bool loading = false;

  XFile? imageFile;

  void _addNewStory() async {
    final nav = Navigator.of(context);
    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        loading = true;
      });
      try {
        await ref.watch(storyService).addStory(
              contentController.text,
              authorController.text,
              imageFile != null ? File(imageFile!.path) : null,
            );

        nav.pop();
        return ref.refresh(storyService);
      } catch (e) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void _selectImage() async {
    if (imageFile != null) {
      setState(() {
        imageFile = null;
      });
    } else {
      final image = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        imageFile = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
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
                child: Form(
                  key: formKey,
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
                          onPressed: _selectImage,
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
                          onPressed: loading ? null : _addNewStory,
                          child: const Text('Submit story'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: !loading
              ? const SizedBox()
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black12,
                  child: const CircularProgressIndicator.adaptive(),
                ),
        )
      ],
    );
  }
}
