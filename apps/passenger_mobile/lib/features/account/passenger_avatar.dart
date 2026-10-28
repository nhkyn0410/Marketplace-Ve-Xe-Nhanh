import 'package:flutter/material.dart';

const passengerDefaultAvatarAsset = 'assets/account/default_avatar.png';

class PassengerAvatar extends StatelessWidget {
  const PassengerAvatar({
    required this.size,
    this.imageUrl,
    this.showCameraBadge = false,
    super.key,
  });

  final double size;
  final String? imageUrl;
  final bool showCameraBadge;

  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(
      passengerDefaultAvatarAsset,
      key: const Key('passenger-default-avatar'),
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
    final normalizedUrl = imageUrl?.trim();

    return SizedBox.square(
      dimension: showCameraBadge ? size + 6 : size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: normalizedUrl == null || normalizedUrl.isEmpty
                  ? fallback
                  : Image.network(
                      normalizedUrl,
                      width: size - 8,
                      height: size - 8,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => fallback,
                    ),
            ),
          ),
          if (showCameraBadge)
            Positioned(
              right: 0,
              bottom: 2,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF168FC2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  size: 17,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
