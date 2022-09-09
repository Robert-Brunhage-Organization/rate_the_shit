import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/src/home/vote/vote_controller.dart';

class Shit {
  Shit(this.name, this.path);
  final String name;
  final String path;
}

class VoteView extends ConsumerWidget {
  VoteView({super.key});

  final shits = [
    Shit("react", 'assets/images/shit/react.svg'),
    Shit("vue", 'assets/images/shit/vue.svg'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const largeBall = Size(273, 273);
    const smallBall = Size(95, 95);
    final size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: -(largeBall.height / 3),
          left: -(largeBall.width / 2),
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
        Positioned(
          top: size.height * 0.2,
          right: -(largeBall.width / 2),
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
        Positioned(
          top: size.height * 0.6,
          right: smallBall.width / 2,
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
        // padding: const EdgeInsets.symmetric(horizontal: 32),
        Column(
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
              child: PageView.builder(
                controller: ref.watch(voteController).pageController,
                itemCount: shits.length,
                itemBuilder: ((context, index) {
                  final shit = shits[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    height: size.width * .9,
                    child: GlassMorphism(
                      child: Center(
                        child: SvgPicture.asset(shit.path),
                      ),
                    ),
                  );
                }),
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
        ),
      ],
    );
  }

  void onVoteTap(WidgetRef ref, int value) {
    final controllerNotifier = ref.read(voteController.notifier);
    final controller = ref.read(voteController);
    final shitIndex = controller.pageController.page!.round();

    controllerNotifier.vote(
      value,
      shits[shitIndex].name,
    );
    controllerNotifier.nextPage();
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
