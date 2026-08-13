import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  final Profile profile;

  const EditProfilePage({
    super.key,
    required this.profile,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final ProfileRepository repository;

  late final TextEditingController nicknameController;
  late final TextEditingController bioController;

  File? selectedImage;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    repository = ProfileRepository(
      Supabase.instance.client,
    );

    nicknameController = TextEditingController(
      text: widget.profile.nickname,
    );

    bioController = TextEditingController(
      text: widget.profile.bio ?? '',
    );
  }

  @override
  void dispose() {
    nicknameController.dispose();
    bioController.dispose();

    super.dispose();
  }

  Future<void> pickAvatar() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (image == null) return;

    setState(() {
      selectedImage = File(image.path);
    });
  }

  Future<void> saveProfile() async {
    final nickname = nicknameController.text.trim();
    final bio = bioController.text.trim();

    if (nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El nickname no pot estar buit.',
          ),
        ),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      String? avatarUrl = widget.profile.avatarUrl;

      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw Exception('Usuari no autenticat');
      }

      // ─────────────────────────────
      // PUJAR AVATAR
      // ─────────────────────────────

      if (selectedImage != null) {
        final path = '${user.id}/avatar.jpg';

        await Supabase.instance.client.storage
            .from('avatars')
            .upload(
              path,
              selectedImage!,
              fileOptions: const FileOptions(
                upsert: true,
                contentType: 'image/jpeg',
                cacheControl: '3600',
              ),
            );

        avatarUrl = Supabase.instance.client.storage
            .from('avatars')
            .getPublicUrl(path);

        // Evitem que el navegador/app mantingui
        // una versió antiga de la imatge.
        avatarUrl = '$avatarUrl?t=${DateTime.now().millisecondsSinceEpoch}';
      }

      // ─────────────────────────────
      // ACTUALITZAR PERFIL
      // ─────────────────────────────

      final updatedProfile = Profile(
        id: widget.profile.id,
        nickname: nickname,
        avatarUrl: avatarUrl,
        bio: bio.isEmpty ? null : bio,
        createdAt: widget.profile.createdAt,
        email: widget.profile.email,
      );

      await repository.updateMyProfile(
        updatedProfile,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No s\'ha pogut guardar el perfil: $e',
          ),
        ),
      );

      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────
            // AVATAR
            // ─────────────────────────────

            Center(
              child: GestureDetector(
                onTap: isSaving ? null : pickAvatar,

                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 65,

                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : widget.profile.avatarUrl != null &&
                                  widget.profile.avatarUrl!.isNotEmpty
                              ? NetworkImage(
                                  widget.profile.avatarUrl!,
                                )
                              : null,

                      child: selectedImage == null &&
                              (widget.profile.avatarUrl == null ||
                                  widget.profile.avatarUrl!.isEmpty)
                          ? const Icon(
                              Icons.person,
                              size: 65,
                            )
                          : null,
                    ),

                    Container(
                      padding: const EdgeInsets.all(9),

                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
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
            ),

            const SizedBox(height: 12),

            Center(
              child: TextButton(
                onPressed: isSaving ? null : pickAvatar,
                child: const Text(
                  'Canviar foto',
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ─────────────────────────────
            // NICKNAME
            // ─────────────────────────────

            const Text(
              'Nickname',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: nicknameController,
              maxLength: 20,

              decoration: const InputDecoration(
                prefixText: '@ ',
                border: OutlineInputBorder(),
                hintText: 'El teu nickname',
              ),
            ),

            const SizedBox(height: 20),

            // ─────────────────────────────
            // BIO
            // ─────────────────────────────

            const Text(
              'Bio',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
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

            // ─────────────────────────────
            // EMAIL
            // ─────────────────────────────

            const Text(
              'Email',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextFormField(
              initialValue: widget.profile.email,
              readOnly: true,

              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.email_outlined,
                ),
              ),
            ),

            const SizedBox(height: 36),

            // ─────────────────────────────
            // GUARDAR
            // ─────────────────────────────

            SizedBox(
              width: double.infinity,

              child: FilledButton.icon(
                onPressed: isSaving
                    ? null
                    : saveProfile,

                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.save,
                      ),

                label: Text(
                  isSaving
                      ? 'Guardant...'
                      : 'Guardar canvis',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}