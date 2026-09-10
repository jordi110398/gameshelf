import 'package:gameshelf/core/localization/app_localizations_x.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gameshelf/core/navigation/page_transitions.dart';
import 'package:gameshelf/features/profile/crop_avatar_page.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gameshelf/core/services/auth_service.dart';
import 'package:gameshelf/core/utils/error_messages.dart';

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
  bool isDeletingAccount = false;

  final authService = AuthService();

  // ─────────────────────────────────────────────
  // INIT / DISPOSE
  // ─────────────────────────────────────────────

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

    if (!mounted) return;

    final croppedBytes = await pushFade<Uint8List>(
      context,
      (_) => CropAvatarPage(imageBytes: bytes),
    );

    if (croppedBytes == null || !mounted) return;

    setState(() {
      selectedImage = image;
      selectedImageBytes = croppedBytes;
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

        // Evitem problemes de caché
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

      Navigator.pop(context, updatedProfile);
    } catch (e) {
      if (!mounted) return;

      debugPrint('ERROR COMPLET: $e');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyError(context, e))));

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
          title: Text(context.l10n.deleteAccountDialogTitle),
          content: Text(context.l10n.deleteAccountDialogBody),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(context.l10n.actionCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(context.l10n.deleteAccountTitle),
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
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isDeletingAccount = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.l10n.deleteAccountFailedPrefix}${friendlyError(context, e)}',
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
    return RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\/\[\]+=]').hasMatch(password);
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
            fulfilled ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 12, color: color)),
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
            final confirmPassword = confirmPasswordController.text;

            final hasStartedTyping = password.isNotEmpty;

            final hasMinLength = _hasMinLength(password);
            final hasUppercase = _hasUppercase(password);
            final hasLowercase = _hasLowercase(password);
            final hasNumber = _hasNumber(password);
            final hasSymbol = _hasSymbol(password);

            final passwordValid = _isPasswordValid(password);

            final passwordsMatch =
                password.isNotEmpty && password == confirmPassword;

            final canChange = passwordValid && passwordsMatch && !isChanging;

            return AlertDialog(
              title: Text(context.l10n.changePasswordDialogTitle),

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
                      decoration: InputDecoration(
                        labelText: context.l10n.newPasswordLabel,
                        prefixIcon: Icon(Icons.lock_outline),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.passwordRequirementsIntro,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 8),

                          _buildPasswordRequirement(
                            fulfilled: hasMinLength,
                            hasStartedTyping: hasStartedTyping,
                            text: context.l10n.reqMinLength,
                          ),

                          _buildPasswordRequirement(
                            fulfilled: hasUppercase,
                            hasStartedTyping: hasStartedTyping,
                            text: context.l10n.reqUppercase,
                          ),

                          _buildPasswordRequirement(
                            fulfilled: hasLowercase,
                            hasStartedTyping: hasStartedTyping,
                            text: context.l10n.reqLowercase,
                          ),

                          _buildPasswordRequirement(
                            fulfilled: hasNumber,
                            hasStartedTyping: hasStartedTyping,
                            text: context.l10n.reqNumber,
                          ),

                          _buildPasswordRequirement(
                            fulfilled: hasSymbol,
                            hasStartedTyping: hasStartedTyping,
                            text: context.l10n.reqSymbol,
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
                        labelText: context.l10n.repeatPasswordLabel,
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: confirmPassword.isEmpty
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

                    if (confirmPassword.isNotEmpty && !passwordsMatch) ...[
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          context.l10n.passwordsDontMatch,
                          style: TextStyle(color: Colors.red, fontSize: 12),
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
                  child: Text(context.l10n.actionCancel),
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

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.l10n.changePasswordSuccess,
                                ),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;

                            setDialogState(() {
                              isChanging = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${context.l10n.changePasswordFailedPrefix}'
                                  '${friendlyError(context, e)}',
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
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(context.l10n.changeAction),
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
        cacheWidth: 260,
        errorBuilder: (_, _, _) {
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
        onTap: isSaving || isDeletingAccount ? null : pickAvatar,
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
      appBar: AppBar(title: Text(context.l10n.editAppBarTitle)),

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
                onPressed: isSaving || isDeletingAccount ? null : pickAvatar,
                child: Text(context.l10n.changePhoto),
              ),
            ),

            const SizedBox(height: 28),

            // ───────────────────────────────────
            // NICKNAME
            // ───────────────────────────────────
            Text(
              context.l10n.nicknameLabel,
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
            Text(
              context.l10n.bioLabel,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: bioController,
              maxLength: 150,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: context.l10n.bioHint,
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 28),

            // ───────────────────────────────────
            // EMAIL
            // ───────────────────────────────────
            Text(
              context.l10n.emailLabel,
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
                onPressed: isSaving || isDeletingAccount ? null : saveProfile,
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  isSaving ? context.l10n.saving : context.l10n.saveChanges,
                ),
              ),
            ),

            const SizedBox(height: 36),

            // ───────────────────────────────────
            // SEGURETAT
            // ───────────────────────────────────
            Text(
              context.l10n.securityTitle,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Material(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),

              child: ListTile(
                leading: const Icon(Icons.lock_outline),

                title: Text(
                  context.l10n.changePasswordTitle,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                subtitle: Text(context.l10n.changePasswordSubtitle),

                trailing: const Icon(Icons.chevron_right),

                onTap: isSaving || isDeletingAccount
                    ? null
                    : _showChangePasswordDialog,
              ),
            ),

            const SizedBox(height: 32),

            // ───────────────────────────────────
            // INFORMACIÓ
            // ───────────────────────────────────
            Text(
              context.l10n.informationTitle,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Material(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),

              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(
                  context.l10n.aboutTitle,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/about'),
              ),
            ),

            const SizedBox(height: 32),

            // ───────────────────────────────────
            // TANCAR SESSIÓ
            // Secció apartada de la resta (abans dins de Configuració,
            // massa a prop d'altres controls i fàcil de tocar sense
            // voler).
            // ───────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await authService.signOut();
                },
                icon: const Icon(Icons.logout),
                label: Text(context.l10n.actionLogout),
              ),
            ),

            const SizedBox(height: 32),

            // ───────────────────────────────────
            // ZONA DE PERILL
            // ───────────────────────────────────
            Text(
              context.l10n.dangerZoneTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 10),

            Material(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),

              child: ListTile(
                leading: isDeletingAccount
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_outline, color: Colors.red),

                title: Text(
                  context.l10n.deleteAccountTitle,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Text(context.l10n.deleteAccountSubtitle),

                onTap: isSaving || isDeletingAccount ? null : deleteAccount,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
