import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/src/home/vote/vote_controller.dart';

import '../shit.dart';

class VoteView extends ConsumerWidget {
  const VoteView({super.key});

  static final shits = [
    Shit(name: "react", path: 'assets/images/shit/react.svg'),
    Shit(name: "vue", path: 'assets/images/shit/vue.svg'),
    Shit(name: "angular", path: 'assets/images/shit/angular.svg'),
    Shit(name: "lit", path: 'assets/images/shit/lit.svg'),
    Shit(name: "nextjs", path: 'assets/images/shit/nextjs.svg'),
    Shit(name: "nuxt", path: 'assets/images/shit/nuxt.svg'),
    Shit(name: "react native", path: 'assets/images/shit/react_native.svg'),
    Shit(name: "svelte", path: 'assets/images/shit/svelte.svg'),
    Shit(name: "xamarin", path: 'assets/images/shit/xamarin.svg'),
    Shit(name: "flutter", path: 'assets/images/shit/flutter.svg'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeInOut,
      child: ref.watch(voteControllerProvider).noMoreShits
          ? Text(
              'See leaderboard',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            )
          : const VoteBody(),
    );
  }
}

class VoteBody extends ConsumerWidget {
  const VoteBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final currentShit = ref.watch(voteControllerProvider).currentShit;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            AppLocalizations.of(context)!.voteViewTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        const SizedBox(height: 58),
        SizedBox(
          height: 300,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            height: size.width * .9,
            child: GlassMorphism(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: VoteView.shits.map((e) {
                  return Center(
                    key: ValueKey(e),
                    child: SvgPicture.asset(
                      e.path,
                      width: double.infinity,
                    ),
                  );
                }).toList()[currentShit],
              ),
            ),
          ),
        ),
        const SizedBox(height: 58),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RoundButton(
                onPressed: () => onVoteTap(ref, -1),
                text: '-1',
                color: Colors.red,
              ),
              RoundButton(
                onPressed: () => onVoteTap(ref, 0),
                text: '0',
                color: Colors.grey,
              ),
              RoundButton(
                onPressed: () => onVoteTap(ref, 1),
                text: '+1',
                color: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onVoteTap(WidgetRef ref, int value) {
    final controllerNotifier = ref.read(voteControllerProvider.notifier);
    final controller = ref.read(voteControllerProvider);
    final shitIndex = controller.currentShit;

    if (!ref.read(voteControllerProvider).isBusy) {
      controllerNotifier.vote(
        value,
        VoteView.shits[shitIndex].name,
      );
    }
  }
}

/// Thanks https://medium.com/@felipe_santos75/glassmorphism-in-flutter-56e9dc040c54
class GradientCircle extends StatelessWidget {
  const GradientCircle({
    super.key,
    required this.size,
    required this.begin,
    required this.end,
    required this.colors,
  });

  final Size size;
  final Alignment begin;
  final Alignment end;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
        ),
      ),
    );
  }
}

class GlassMorphism extends StatelessWidget {
  final Widget child;
  const GlassMorphism({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xffFF6868),
                const Color(0xff3D74A7).withOpacity(.54),
                const Color(0xffFF1E8A).withOpacity(.1)
              ],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              width: 1.5,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color,
  });

  final VoidCallback onPressed;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 75,
      child: FloatingActionButton(
        backgroundColor: color,
        onPressed: onPressed,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
    );
  }
}
