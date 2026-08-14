import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  final Profile profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final ProfileRepository repository;
  late final TextEditingController bioController;

  XFile? selectedImage;
  Uint8List? selectedImageBytes;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    repository = ProfileRepository(Supabase.instance.client);

    bioController = TextEditingController(text: widget.profile.bio ?? '');
  }

  @override
  void dispose() {
    bioController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // SELECCIONAR AVATAR
  // ─────────────────────────────────────────────

  Future<void> pickAvatar() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (image == null || !mounted) return;

    final bytes = await image.readAsBytes();

    setState(() {
      selectedImage = image;
      selectedImageBytes = bytes;
    });
  }

  // ─────────────────────────────────────────────
  // GUARDAR PERFIL
  // ─────────────────────────────────────────────

  Future<void> saveProfile() async {
    final bio = bioController.text.trim();

    setState(() {
      isSaving = true;
    });

    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;

      if (user == null) {
        throw Exception('Usuari no autenticat');
      }

      String? avatarUrl = widget.profile.avatarUrl;

      // ─────────────────────────────────────────
      // PUJAR AVATAR
      // ─────────────────────────────────────────

      if (selectedImageBytes != null) {
        final path = '${user.id}/avatar.jpg';

        await client.storage
            .from('avatars')
            .uploadBinary(
              path,
              selectedImageBytes!,
              fileOptions: const FileOptions(
                upsert: true,
                contentType: 'image/jpeg',
                cacheControl: '3600',
              ),
            );

        avatarUrl = client.storage.from('avatars').getPublicUrl(path);

        // Evitem que es mostri l'avatar anterior
        // per culpa de la caché.
        avatarUrl = '$avatarUrl?t=${DateTime.now().millisecondsSinceEpoch}';
      }

      // ─────────────────────────────────────────
      // ACTUALITZAR PERFIL
      // ─────────────────────────────────────────

      final updatedProfile = Profile(
        id: widget.profile.id,

        // El nickname de moment NO es pot modificar.
        nickname: widget.profile.nickname,

        avatarUrl: avatarUrl,

        bio: bio.isEmpty ? null : bio,

        createdAt: widget.profile.createdAt,

        // L'email de moment NO es pot modificar.
        email: widget.profile.email,
      );

      await repository.updateMyProfile(updatedProfile);

      if (!mounted) return;

      // Retornem el perfil actualitzat a UserProfilePage.
      Navigator.pop(context, updatedProfile);
    } catch (e) {
      if (!mounted) return;

      debugPrint('ERROR COMPLET: $e');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));

      setState(() {
        isSaving = false;
      });
    }
  }

  // ─────────────────────────────────────────────
  // AVATAR
  // ─────────────────────────────────────────────

  Widget _buildAvatar() {
    Widget avatarContent;

    // Nova imatge seleccionada
    if (selectedImageBytes != null) {
      avatarContent = Image.memory(
        selectedImageBytes!,
        width: 130,
        height: 130,
        fit: BoxFit.cover,
      );
    }
    // Avatar actual
    else if (widget.profile.avatarUrl != null &&
        widget.profile.avatarUrl!.isNotEmpty) {
      avatarContent = Image.network(
        widget.profile.avatarUrl!,
        width: 130,
        height: 130,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Icon(Icons.person, size: 65);
        },
      );
    }
    // Sense avatar
    else {
      avatarContent = const Icon(Icons.person, size: 65);
    }

    return Center(
      child: GestureDetector(
        onTap: isSaving ? null : pickAvatar,

        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 65,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,

              child: ClipOval(child: avatarContent),
            ),

            // Icona de càmera
            Container(
              padding: const EdgeInsets.all(9),

              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───────────────────────────────────
            // AVATAR
            // ───────────────────────────────────
            _buildAvatar(),

            const SizedBox(height: 12),

            Center(
              child: TextButton(
                onPressed: isSaving ? null : pickAvatar,
                child: const Text('Canviar foto'),
              ),
            ),

            const SizedBox(height: 28),

            // ───────────────────────────────────
            // NICKNAME
            // ───────────────────────────────────
            const Text(
              'Nickname',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextFormField(
              initialValue: widget.profile.nickname,
              readOnly: true,

              decoration: const InputDecoration(
                prefixText: '@ ',
                border: OutlineInputBorder(),

                prefixIcon: Icon(Icons.person_outline),
              ),
            ),

            const SizedBox(height: 20),

            // ───────────────────────────────────
            // BIO
            // ───────────────────────────────────
            const Text(
              'Bio',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: bioController,

              maxLength: 150,
              minLines: 3,
              maxLines: 5,

              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Explica alguna cosa sobre tu...',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 28),

            // ───────────────────────────────────
            // EMAIL
            // ───────────────────────────────────
            const Text(
              'Email',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextFormField(
              initialValue: widget.profile.email,
              readOnly: true,

              decoration: const InputDecoration(
                border: OutlineInputBorder(),

                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),

            const SizedBox(height: 36),

            // ───────────────────────────────────
            // GUARDAR
            // ───────────────────────────────────
            SizedBox(
              width: double.infinity,

              child: FilledButton.icon(
                onPressed: isSaving ? null : saveProfile,

                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,

                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),

                label: Text(isSaving ? 'Guardant...' : 'Guardar canvis'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
