import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatView extends StatelessWidget {
  const WhatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'I thought this was fun to make :)',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 42),
          const ClickableLink(
            text: 'GitHub is always fun',
            link:
                'https://github.com/Robert-Brunhage-Organization/rate_the_shit',
          ),
        ],
      ),
    );
  }
}

class ClickableLink extends StatelessWidget {
  const ClickableLink({
    super.key,
    required this.text,
    required this.link,
  });
  final String text;
  final String link;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri(path: link)),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
      ),
    );
  }
}
