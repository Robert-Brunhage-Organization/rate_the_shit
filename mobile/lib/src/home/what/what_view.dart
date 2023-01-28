import 'package:flutter/material.dart';
import 'package:mobile/src/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
            style: $styles.text.h3,
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrlString(link),
        child: Text(
          text,
          style: $styles.text.body.copyWith(
            color: $styles.colors.link,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
