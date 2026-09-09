import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gameshelf/core/strings/profile_strings.dart';
import 'package:gameshelf/core/utils/error_messages.dart';
import 'package:gameshelf/core/utils/hours_format.dart';
import 'package:gameshelf/core/widgets/dither_banner.dart';
import 'package:gameshelf/models/profile.dart';
import 'package:gameshelf/repositories/profile_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Targeta de perfil compartible: una imatge a l'estil "story" (banner +
/// avatar + estadístiques + QR) que es pot descarregar per compartir-la
/// fora de l'app. El QR porta a `${origen}/home?u=<nickname>`; l'app
/// (`app_router.dart`) intercepta aquest paràmetre per obrir la pestanya
/// Social i cercar directament aquest usuari -- no cal cap pàgina de
/// perfil pública ni tocar permisos de la BD.
class ShareProfilePage extends StatefulWidget {
  final Profile profile;
  final ProfileStats stats;
  final List<Color> bannerColors;

  const ShareProfilePage({
    super.key,
    required this.profile,
    required this.stats,
    required this.bannerColors,
  });

  @override
  State<ShareProfilePage> createState() => _ShareProfilePageState();
}

class _ShareProfilePageState extends State<ShareProfilePage> {
  final _boundaryKey = GlobalKey();
  bool _isDownloading = false;
  bool _isLoadingAvatar = true;
  Uint8List? _avatarBytes;

  String get _shareUrl =>
      '${Uri.base.origin}/home?u=${Uri.encodeComponent(widget.profile.nickname)}';

  @override
  void initState() {
    super.initState();
    _loadAvatarBytes();
  }

  /// Baixa l'avatar com a bytes en lloc d'usar `Image.network` directament
  /// a la targeta: a Flutter Web (CanvasKit), capturar amb
  /// `RepaintBoundary.toImage()` un widget que conté una imatge d'un altre
  /// origen sol fallar per "tainted canvas" encara que el servidor
  /// permeti CORS. Descarregant els bytes nosaltres mateixos i pintant-los
  /// amb `Image.memory`, el canvas mai queda "tacat".
  Future<void> _loadAvatarBytes() async {
    final url = widget.profile.avatarUrl;

    if (url == null || url.isEmpty) {
      setState(() => _isLoadingAvatar = false);
      return;
    }

    try {
      final request = await html.HttpRequest.request(
        url,
        responseType: 'arraybuffer',
      );

      final buffer = request.response as ByteBuffer;

      if (!mounted) return;

      setState(() {
        _avatarBytes = buffer.asUint8List();
        _isLoadingAvatar = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _isLoadingAvatar = false);
    }
  }

  Future<void> _download() async {
    setState(() => _isDownloading = true);

    try {
      final boundary =
          _boundaryKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      _triggerBrowserDownload(bytes, widget.profile.nickname);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(ProfileStrings.shareDownloadedMessage)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${ProfileStrings.shareGenerateFailedPrefix}${friendlyError(e)}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  void _triggerBrowserDownload(Uint8List bytes, String nickname) {
    final blob = html.Blob([bytes], 'image/png');
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute('download', 'gameshelf-$nickname.png')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(ProfileStrings.shareAppBarTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isLoadingAvatar)
                  const SizedBox(
                    width: _ShareCard.width,
                    height: _ShareCard.height,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  RepaintBoundary(
                    key: _boundaryKey,
                    child: _ShareCard(
                      profile: widget.profile,
                      stats: widget.stats,
                      bannerColors: widget.bannerColors,
                      shareUrl: _shareUrl,
                      avatarBytes: _avatarBytes,
                    ),
                  ),

                const SizedBox(height: 24),

                FilledButton.icon(
                  onPressed: (_isDownloading || _isLoadingAvatar)
                      ? null
                      : _download,
                  icon: _isDownloading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  label: const Text(ProfileStrings.shareDownloadAction),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShareCard extends StatelessWidget {
  final Profile profile;
  final ProfileStats stats;
  final List<Color> bannerColors;
  final String shareUrl;
  final Uint8List? avatarBytes;

  static const width = 380.0;
  static const height = 680.0;

  const _ShareCard({
    required this.profile,
    required this.stats,
    required this.bannerColors,
    required this.shareUrl,
    required this.avatarBytes,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DitherBanner(colors: bannerColors),

            // Degradat fosc perquè el text sigui llegible sigui quin
            // sigui el color del banner de sota.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black38, Colors.black87],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 28),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: avatarBytes != null
                          ? Image.memory(avatarBytes!, fit: BoxFit.cover)
                          : _avatarPlaceholder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    '@${profile.nickname}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  if (profile.bio != null &&
                      profile.bio!.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      profile.bio!,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Stat(value: '${stats.games}', label: 'Jocs'),
                      _statDivider(),
                      _Stat(value: '${stats.completed}', label: 'Completats'),
                      _statDivider(),
                      _Stat(
                        value: '${formatHours(stats.hours)}h',
                        label: 'Hores',
                      ),
                    ],
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: QrImageView(
                      data: shareUrl,
                      version: QrVersions.auto,
                      size: 120,
                      gapless: true,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    ProfileStrings.shareQrCaption,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sports_esports,
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'GameShelf',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      color: Colors.grey.shade300,
      child: const Icon(Icons.person, size: 48, color: Colors.grey),
    );
  }

  Widget _statDivider() {
    return Container(
      width: 1,
      height: 26,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white24,
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
