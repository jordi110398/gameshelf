import 'package:flutter/material.dart';
import 'package:gameshelf/core/widgets/responsive_center.dart';

/// Estructura comuna per a les pàgines legals/informatives
/// (privacitat, cookies, sobre l'app).
class LegalPageScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const LegalPageScaffold({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ResponsiveCenter(
        maxWidth: 720,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}

class LegalSectionTitle extends StatelessWidget {
  final String text;

  const LegalSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class LegalParagraph extends StatelessWidget {
  final String text;

  const LegalParagraph(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}

class LegalBullet extends StatelessWidget {
  final String text;

  const LegalBullet(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  '),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
