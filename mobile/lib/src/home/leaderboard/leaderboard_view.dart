import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/src/home/leaderboard/leaderboard_controller.dart';
import 'package:mobile/src/home/vote/vote_view.dart';

import '../shit.dart';

class LeaderboardView extends ConsumerStatefulWidget {
  const LeaderboardView({super.key});

  @override
  ConsumerState<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends ConsumerState<LeaderboardView> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(leaderboardControllerProvider.notifier).getAll();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final shits = ref.watch(leaderboardControllerProvider).shits;

    return ListView.separated(
      itemCount: shits.length,
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemBuilder: (context, index) {
        final shit = shits[index];
        return Container(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            SvgPicture.asset(shit.path, width: 34),
            const SizedBox(width: 16),
            Text(shit.name, style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            generatePercent(shit, context),
          ]),
        );
      },
    );
  }

  Widget generatePercent(Shit shit, BuildContext context) {
    final sum = shit.positiveRating + shit.negativeRating;

    double value = 0.5;
    if (sum != 0) {
      value = shit.positiveRating / sum;
    }

    return SizedBox(
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '${shit.positiveRating}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              width: 80,
              height: 20,
              child: LinearProgressIndicator(
                backgroundColor: Colors.red.withOpacity(0.3),
                value: value,
                color: Colors.green,
              ),
            ),
          ),
          Text(
            '${shit.negativeRating}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
