import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/src/home/home_controller.dart';

import 'vote/vote_view.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controllerIndex = ref.watch(homeControllerProvider).index;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: [
          const VoteView(),
          Container(),
          Container(),
        ][controllerIndex],
        bottomNavigationBar: _BottomNavigationBar(
          controllerIndex: controllerIndex,
          onTap: (index) =>
              ref.read(homeControllerProvider.notifier).setIndex(index),
        ),
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    required this.controllerIndex,
    required this.onTap,
  });

  final int controllerIndex;
  final Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: controllerIndex,
      onTap: onTap,
      selectedItemColor: Colors.blue[700],
      selectedFontSize: 13,
      unselectedFontSize: 13,
      iconSize: 30,
      items: const [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "Leaderboard",
          icon: Icon(Icons.list),
        ),
        BottomNavigationBarItem(
          label: "WHAT?",
          icon: Icon(Icons.question_mark),
        ),
      ],
    );
  }
}
