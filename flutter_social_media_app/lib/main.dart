import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/story.dart';
import 'firebase_options.dart';
import 'padding.dart';
import 'pages/add_story.dart';
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
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final scrollController = ScrollController();
  bool showSearchBar = true;

  void _pushAddStory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AddStoryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Stack(
          children: [
            Scaffold(
              body: Column(
                children: [
                  StorytellerAppBar(onNewStoryPressed: _pushAddStory),
                  Container(
                    alignment: AlignmentDirectional.centerStart,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.large,
                      vertical: AppPadding.small,
                    ),
                    child: const Text('Latest stories'),
                  ),
                  Expanded(
                    child: ref.watch(stories).when(
                          data: (stories) => stories.isEmpty
                              ? const Center(
                                  child: Text('No stories found'),
                                )
                              : NotificationListener<UserScrollNotification>(
                                  onNotification: (notification) {
                                    final direction = notification.direction;
                                    setState(() {
                                      if (direction ==
                                          ScrollDirection.forward) {
                                        showSearchBar = true;
                                      } else if (direction ==
                                          ScrollDirection.reverse) {
                                        showSearchBar = false;
                                      }
                                    });
                                    return true;
                                  },
                                  child: GridView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppPadding.large,
                                      vertical: AppPadding.small,
                                    ),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.65,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: stories.length,
                                    itemBuilder: (context, index) =>
                                        StoryBriefWidget(
                                      story: Story(
                                        content: stories[index].content,
                                        author: stories[index].author,
                                        imagePath: stories[index].imagePath,
                                      ),
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
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom: showSearchBar ? 50 : -50,
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Material(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for interesting things',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.1),
                          ),
                        ),
                        prefixIcon: const Icon(Icons.search_rounded),
                        fillColor: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.1),
                        filled: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StorytellerAppBar extends StatelessWidget {
  const StorytellerAppBar({
    super.key,
    required this.onNewStoryPressed,
  });

  final VoidCallback onNewStoryPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.large),
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
                  onPressed: onNewStoryPressed,
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
    );
  }
}

class StoryBriefWidget extends ConsumerWidget {
  const StoryBriefWidget({
    super.key,
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          if (story.imagePath != null)
            ref.watch(storyThumbnail(story.imagePath!)).when(
                  data: (url) => Container(
                    margin: const EdgeInsets.only(bottom: AppPadding.medium),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 150,
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Text('Error: $error'),
                ),
          Text(
            story.content,
            maxLines: 2,
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
