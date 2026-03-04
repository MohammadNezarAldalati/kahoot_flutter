import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeDisplay extends StatelessWidget {
  final String gameId;

  const QrCodeDisplay({super.key, required this.gameId});

  String get _joinUrl {
    // Use window location origin for web
    return Uri.base.resolve('/game/$gameId').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: QrImageView(
            data: _joinUrl,
            version: QrVersions.auto,
            size: 200,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectableText(
              _joinUrl,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _joinUrl));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied!')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
