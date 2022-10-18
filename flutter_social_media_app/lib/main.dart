import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_story.dart';
import 'data/story.dart';
import 'firebase_options.dart';
import 'padding.dart';
import 'providers/stories_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storyteller',
      theme: ThemeData(
        primaryColor: const Color(0xff1A73E9),
        colorScheme: ColorScheme.fromSwatch(
          primaryColorDark: const Color(0xff082a73),
          primarySwatch: const MaterialColor(
            0xff1A73E9,
            {
              50: Color(0xffe8f0fe),
              100: Color(0xffc5d6fd),
              200: Color(0xffa3bbfc),
              300: Color(0xff81a0fb),
              400: Color(0xff5f85fa),
              500: Color(0xff3d6af9),
              600: Color(0xff1a73e9),
              700: Color(0xff145ac7),
              800: Color(0xff0e4295),
              900: Color(0xff082a73)
            },
          ),
        ),
      ),
      home: const ResizeImagesApp(),
    );
  }
}

class ResizeImagesApp extends ConsumerStatefulWidget {
  const ResizeImagesApp({super.key});

  @override
  ConsumerState<ResizeImagesApp> createState() => _ResizeImagesAppState();
}

class _ResizeImagesAppState extends ConsumerState<ResizeImagesApp> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppPadding.large),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Storyteller',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.add_circle_outline_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AddStoryPage(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.account_circle_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.centerStart,
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.large,
                vertical: AppPadding.medium,
              ),
              child: const Text('Latest stories'),
            ),
            Expanded(
              child: ref.watch(stories).when(
                    data: (stories) => stories.isEmpty
                        ? const Center(
                            child: Text('No stories found'),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.74,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: stories.length,
                            itemBuilder: (context, index) => StoryBriefWidget(
                              story: Story(
                                content: stories[index].content,
                                author: stories[index].author,
                                imageUrl: stories[index].imageUrl,
                              ),
                            ),
                          ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Text('Error: $error'),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoryBriefWidget extends StatelessWidget {
  const StoryBriefWidget({
    super.key,
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColorLight.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 9,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      height: 600,
      padding: const EdgeInsets.all(AppPadding.small),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (story.imageUrl != null)
            Container(
              margin: const EdgeInsets.only(bottom: AppPadding.medium),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(story.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
              height: 150,
            ),
          Text(
            story.content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            story.author,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
