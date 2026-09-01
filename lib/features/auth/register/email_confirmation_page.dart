import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailConfirmationPage extends StatelessWidget {
  final String email;

  const EmailConfirmationPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mark_email_unread_outlined, size: 80),

                  const SizedBox(height: 24),

                  const Text(
                    'Confirma el teu email',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'T\'hem enviat un correu de confirmació a:',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Obre el correu i fes clic a l\'enllaç per activar el teu compte.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Tornar a iniciar sessió'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
