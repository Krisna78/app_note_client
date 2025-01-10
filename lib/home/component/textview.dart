import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart'; // Import link_text package
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'dart:core';

import 'package:url_launcher/url_launcher_string.dart';

class Textview extends StatelessWidget {
  final String textView;
  final String titleTextView;
  // final bool isLink;

  Textview({
    super.key,
    required this.textView,
    required this.titleTextView,
    // required this.isLink,
  });

  // Function to detect URLs in the text and split them
  List<InlineSpan> _getTextWithLinks(String text) {
    final urlRegex = RegExp(r'http[s]?://\S+'); // Regex for URLs

    List<InlineSpan> spans = [];
    int lastIndex = 0;

    // Find all matches in the text
    Iterable<RegExpMatch> matches = urlRegex.allMatches(text);

    for (var match in matches) {
      // Add normal text before the URL
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: TextStyle(color: Colors.black, fontSize: 18),
        ));
      }

      // Add the clickable URL
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _launchURL(text.substring(match.start, match.end));
          },
      ));

      lastIndex = match.end;
    }

    // Add remaining normal text after the last URL
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: TextStyle(color: Colors.black, fontSize: 18),
      ));
    }

    return spans;
  }

  Future<void> _launchURL(String text) async {
    // Regex untuk mengekstrak URL yang valid
    RegExp urlPattern = RegExp(r'https?://[^\s]+');
    Iterable<RegExpMatch> matches = urlPattern.allMatches(text);

    if (matches.isNotEmpty) {
      String url = matches.first.group(0)!;

      if (!url.startsWith("http://") && !url.startsWith("https://")) {
        url = "https://$url";
      }

      final Uri uri = Uri.parse(url);

      // Cek apakah URL dapat diluncurkan
      if (await canLaunchUrlString(uri.toString())) {
        await launchUrlString(uri.toString());
      } else {
        throw 'Tidak bisa membuka URL: $url';
      }
    } else {
      throw 'Tidak ada URL yang valid ditemukan dalam teks.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleTextView,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF80AF81),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: LinkText(
              textView,
              linkStyle: const TextStyle(
                color: Colors.blue,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              onLinkTap: (url) {
                _launchURL(textView);
              },
            ),
          ),
        ],
      ),
    );
  }
}
