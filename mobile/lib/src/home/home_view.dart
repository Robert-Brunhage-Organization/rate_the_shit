import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/src/home/home_controller.dart';
import 'package:mobile/src/home/leaderboard/leaderboard_view.dart';

import 'vote/vote_view.dart';

class MaxWidthContainer extends StatelessWidget {
  const MaxWidthContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double maxWidth = size.width < 600 ? size.width : 600;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controllerIndex = ref.watch(homeControllerProvider).index;
    const largeBall = Size(273, 273);
    const smallBall = Size(95, 95);
    final size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: MaxWidthContainer(
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                top: -(largeBall.height / (3 + controllerIndex)),
                left: -(largeBall.width / (2 + controllerIndex)),
                child: GradientCircle(
                  size: largeBall,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xffFF3838).withOpacity(.78),
                    const Color(0xffED6B9A),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                top: size.height * 0.2,
                right: -(largeBall.width / (2 + controllerIndex)),
                child: GradientCircle(
                  size: largeBall,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xffED6BE0),
                    const Color(0xffD14FFF).withOpacity(.52),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                top: size.height * 0.6,
                right: smallBall.width / (2 + controllerIndex),
                child: GradientCircle(
                  size: smallBall,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xffED6BE0),
                    const Color(0xffD14FFF).withOpacity(.52),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 50),
                switchInCurve: Curves.easeInOut,
                child: [
                  const VoteView(),
                  const LeaderboardView(),
                  Container(),
                ][controllerIndex],
              ),
            ],
          ),
        ),
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
