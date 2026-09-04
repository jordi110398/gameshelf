import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:gameshelf/core/strings/app_strings.dart';
import 'package:gameshelf/core/strings/profile_strings.dart';

/// Pantalla per centrar/retallar la foto de perfil abans de pujar-la:
/// l'usuari pot desplaçar i fer zoom a la imatge dins d'un marc fix
/// (quadrat, com l'avatar es mostra a la resta de l'app), en lloc de
/// pujar-la directament tal com surt de la galeria.
class CropAvatarPage extends StatefulWidget {
  final Uint8List imageBytes;

  const CropAvatarPage({super.key, required this.imageBytes});

  @override
  State<CropAvatarPage> createState() => _CropAvatarPageState();
}

class _CropAvatarPageState extends State<CropAvatarPage> {
  final _controller = CropController();
  bool _isCropping = false;

  void _handleCropped(CropResult result) {
    switch (result) {
      case CropSuccess(:final croppedImage):
        Navigator.pop(context, croppedImage);
      case CropFailure():
        setState(() => _isCropping = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(ProfileStrings.cropFailedMessage)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(ProfileStrings.cropAvatarTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isCropping
                ? null
                : () {
                    setState(() => _isCropping = true);
                    _controller.crop();
                  },
            child: Text(
              AppStrings.actionSave,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Crop(
            image: widget.imageBytes,
            controller: _controller,
            onCropped: _handleCropped,
            aspectRatio: 1,
            interactive: true,
            fixCropRect: true,
            baseColor: Colors.black,
            maskColor: Colors.black.withValues(alpha: 0.65),
            radius: 16,
          ),
          if (_isCropping)
            const ColoredBox(
              color: Colors.black45,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
