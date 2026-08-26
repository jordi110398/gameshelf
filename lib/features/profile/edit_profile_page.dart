import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/core/services/auth_service.dart';

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
  late final TextEditingController bioController;

  XFile? selectedImage;
  Uint8List? selectedImageBytes;

  bool isSaving = false;
  bool isDeletingAccount = false;

  final authService = AuthService();

  // ─────────────────────────────────────────────
  // INIT / DISPOSE
  // ─────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    repository = ProfileRepository(
      Supabase.instance.client,
    );

    bioController = TextEditingController(
      text: widget.profile.bio ?? '',
    );
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

        avatarUrl = client.storage
            .from('avatars')
            .getPublicUrl(path);

        // Evitem problemes de caché
        avatarUrl =
            '$avatarUrl?t=${DateTime.now().millisecondsSinceEpoch}';
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

      Navigator.pop(context, updatedProfile);
    } catch (e) {
      if (!mounted) return;

      debugPrint('ERROR COMPLET: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );

      setState(() {
        isSaving = false;
      });
    }
  }

  // ─────────────────────────────────────────────
  // ELIMINAR COMPTE
  // ─────────────────────────────────────────────

  Future<void> deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar compte?'),
          content: const Text(
            'Aquesta acció és permanent. '
            'S\'eliminaran el teu perfil, biblioteca, reviews, '
            'amistats i activitat.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel·lar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Eliminar compte'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      isDeletingAccount = true;
    });

    try {
      await repository.deleteAccount();

      if (!mounted) return;

      // Tornem al login.
      Navigator.of(context).popUntil(
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isDeletingAccount = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No s\'ha pogut eliminar el compte: $e',
          ),
        ),
      );
    }
  }

  // ─────────────────────────────────────────────
  // REQUISITS DE CONTRASENYA
  // ─────────────────────────────────────────────

  bool _hasMinLength(String password) {
    return password.length >= 8;
  }

  bool _hasUppercase(String password) {
    return RegExp(r'[A-Z]').hasMatch(password);
  }

  bool _hasLowercase(String password) {
    return RegExp(r'[a-z]').hasMatch(password);
  }

  bool _hasNumber(String password) {
    return RegExp(r'[0-9]').hasMatch(password);
  }

  bool _hasSymbol(String password) {
    return RegExp(
      r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\]+=]',
    ).hasMatch(password);
  }

  bool _isPasswordValid(String password) {
    return _hasMinLength(password) &&
        _hasUppercase(password) &&
        _hasLowercase(password) &&
        _hasNumber(password) &&
        _hasSymbol(password);
  }

  // ─────────────────────────────────────────────
  // INDICADOR DE REQUISIT
  // ─────────────────────────────────────────────

  Widget _buildPasswordRequirement({
    required bool fulfilled,
    required String text,
    required bool hasStartedTyping,
  }) {
    final color = !hasStartedTyping
        ? Colors.grey.shade500
        : fulfilled
            ? Colors.green
            : Colors.grey.shade500;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(
            fulfilled
                ? Icons.check_circle
                : Icons.circle_outlined,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CANVIAR CONTRASENYA
  // ─────────────────────────────────────────────

  Future<void> _showChangePasswordDialog() async {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    bool isChanging = false;

    await showDialog(
      context: context,
      barrierDismissible: !isChanging,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final password = newPasswordController.text;
            final confirmPassword =
                confirmPasswordController.text;

            final hasStartedTyping = password.isNotEmpty;

            final hasMinLength = _hasMinLength(password);
            final hasUppercase = _hasUppercase(password);
            final hasLowercase = _hasLowercase(password);
            final hasNumber = _hasNumber(password);
            final hasSymbol = _hasSymbol(password);

            final passwordValid =
                _isPasswordValid(password);

            final passwordsMatch =
                password.isNotEmpty &&
                password == confirmPassword;

            final canChange =
                passwordValid &&
                passwordsMatch &&
                !isChanging;

            return AlertDialog(
              title: const Text('Canviar contrasenya'),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ─────────────────────────
                    // NOVA CONTRASENYA
                    // ─────────────────────────

                    TextField(
                      controller: newPasswordController,
                      obscureText: true,
                      enabled: !isChanging,
                      onChanged: (_) {
                        setDialogState(() {});
                      },
                      decoration: const InputDecoration(
                        labelText: 'Nova contrasenya',
                        prefixIcon: Icon(
                          Icons.lock_outline,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ─────────────────────────
                    // REQUISITS
                    // ─────────────────────────

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'La contrasenya ha de tenir:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 8),

                          _buildPasswordRequirement(
                            fulfilled: hasMinLength,
                            hasStartedTyping:
                                hasStartedTyping,
                            text: 'Almenys 8 caràcters',
                          ),

                          _buildPasswordRequirement(
                            fulfilled: hasUppercase,
                            hasStartedTyping:
                                hasStartedTyping,
                            text: 'Una lletra majúscula',
                          ),

                          _buildPasswordRequirement(
                            fulfilled: hasLowercase,
                            hasStartedTyping:
                                hasStartedTyping,
                            text: 'Una lletra minúscula',
                          ),

                          _buildPasswordRequirement(
                            fulfilled: hasNumber,
                            hasStartedTyping:
                                hasStartedTyping,
                            text: 'Un número',
                          ),

                          _buildPasswordRequirement(
                            fulfilled: hasSymbol,
                            hasStartedTyping:
                                hasStartedTyping,
                            text: 'Un símbol',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ─────────────────────────
                    // CONFIRMAR CONTRASENYA
                    // ─────────────────────────

                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      enabled: !isChanging,
                      onChanged: (_) {
                        setDialogState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Repeteix la contrasenya',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                        ),
                        border: const OutlineInputBorder(),
                        suffixIcon:
                            confirmPassword.isEmpty
                                ? null
                                : Icon(
                                    passwordsMatch
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: passwordsMatch
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                      ),
                    ),

                    if (confirmPassword.isNotEmpty &&
                        !passwordsMatch) ...[
                      const SizedBox(height: 6),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Les contrasenyes no coincideixen.',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: isChanging
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
                        },
                  child: const Text('Cancel·lar'),
                ),

                FilledButton(
                  onPressed: canChange
                      ? () async {
                          setDialogState(() {
                            isChanging = true;
                          });

                          try {
                            await authService.updatePassword(
                              newPasswordController.text,
                            );

                            if (!mounted) return;

                            Navigator.pop(dialogContext);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Contrasenya canviada correctament.',
                                ),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;

                            setDialogState(() {
                              isChanging = false;
                            });

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                  'No s\'ha pogut canviar la '
                                  'contrasenya: $e',
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                  child: isChanging
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Canviar'),
                ),
              ],
            );
          },
        );
      },
    );

    newPasswordController.dispose();
    confirmPasswordController.dispose();
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
          return const Icon(
            Icons.person,
            size: 65,
          );
        },
      );
    }

    // Sense avatar
    else {
      avatarContent = const Icon(
        Icons.person,
        size: 65,
      );
    }

    return Center(
      child: GestureDetector(
        onTap: isSaving || isDeletingAccount
            ? null
            : pickAvatar,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 65,
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,
              child: ClipOval(
                child: avatarContent,
              ),
            ),

            // Icona de càmera
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
    );
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

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
            // ───────────────────────────────────
            // AVATAR
            // ───────────────────────────────────

            _buildAvatar(),

            const SizedBox(height: 12),

            Center(
              child: TextButton(
                onPressed:
                    isSaving || isDeletingAccount
                        ? null
                        : pickAvatar,
                child: const Text('Canviar foto'),
              ),
            ),

            const SizedBox(height: 28),

            // ───────────────────────────────────
            // NICKNAME
            // ───────────────────────────────────

            const Text(
              'Nickname',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextFormField(
              initialValue: widget.profile.nickname,
              readOnly: true,
              decoration: const InputDecoration(
                prefixText: '@ ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.person_outline,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ───────────────────────────────────
            // BIO
            // ───────────────────────────────────

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
                hintText:
                    'Explica alguna cosa sobre tu...',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 28),

            // ───────────────────────────────────
            // EMAIL
            // ───────────────────────────────────

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

            // ───────────────────────────────────
            // GUARDAR
            // ───────────────────────────────────

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed:
                    isSaving || isDeletingAccount
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
                    : const Icon(Icons.save),
                label: Text(
                  isSaving
                      ? 'Guardant...'
                      : 'Guardar canvis',
                ),
              ),
            ),

            const SizedBox(height: 36),

            // ───────────────────────────────────
            // SEGURETAT
            // ───────────────────────────────────

            const Text(
              'Seguretat',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Material(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),

              child: ListTile(
                leading: const Icon(
                  Icons.lock_outline,
                ),

                title: const Text(
                  'Canviar contrasenya',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                subtitle: const Text(
                  'Actualitza la contrasenya del teu compte',
                ),

                trailing: const Icon(
                  Icons.chevron_right,
                ),

                onTap:
                    isSaving || isDeletingAccount
                        ? null
                        : _showChangePasswordDialog,
              ),
            ),

            const SizedBox(height: 32),

            // ───────────────────────────────────
            // ZONA DE PERILL
            // ───────────────────────────────────

            const Text(
              'Zona de perill',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 10),

            Material(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),

              child: ListTile(
                leading: isDeletingAccount
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),

                title: const Text(
                  'Eliminar compte',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: const Text(
                  'Elimina permanentment el teu compte i '
                  'les teves dades',
                ),

                onTap:
                    isSaving || isDeletingAccount
                        ? null
                        : deleteAccount,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}