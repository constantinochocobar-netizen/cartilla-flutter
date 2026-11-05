import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 48, backgroundColor: cs.primaryContainer, child: const Icon(Icons.person, size: 48)),
          const SizedBox(height: 16),
          Text(user?.email ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('UID: ${user?.uid ?? ''}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
