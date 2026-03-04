import 'package:flutter/material.dart';

class NicknameForm extends StatefulWidget {
  final Future<void> Function(String nickname) onSubmit;

  const NicknameForm({super.key, required this.onSubmit});

  @override
  State<NicknameForm> createState() => _NicknameFormState();
}

class _NicknameFormState extends State<NicknameForm> {
  final _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final nickname = _controller.text.trim();
    if (nickname.isEmpty) return;
    setState(() => _submitting = true);
    try {
      await widget.onSubmit(nickname);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter your nickname',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Nickname',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _submit(),
                  enabled: !_submitting,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Join Game'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
