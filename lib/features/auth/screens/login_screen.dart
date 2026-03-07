import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rwg_brainhub/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _showPassword = false;
  bool _magicLinkSent = false;
  int _remainingAttempts = 3;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await Supabase.instance.client
          .rpc('check_login_type', params: {'p_email': email});

      if (result['type'] == 'password') {
        setState(() => _showPassword = true);
      } else {
        await _sendMagicLink();
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _sendMagicLink() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    try {
      await Supabase.instance.client.auth.signInWithOtp(
        email: email,
        shouldCreateUser: true,
      );
      setState(() => _magicLinkSent = true);
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _loginWithPassword() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (password.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await Supabase.instance.client
          .rpc('attempt_admin_login', params: {'p_email': email});

      final allowed = result['allowed'] as bool;
      final remaining = result['remaining_attempts'] as int;

      if (!allowed) {
        setState(() {
          _error = result['message'] ?? 'Account locked. Try again later.';
          _remainingAttempts = 0;
        });
        return;
      }

      _remainingAttempts = remaining;

      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Success - clear attempts
      await Supabase.instance.client
          .rpc('clear_admin_login_attempts', params: {'p_email': email});
    } on AuthException {
      setState(() {
        if (_remainingAttempts > 0) {
          _error =
              'Invalid credentials. $_remainingAttempts attempt${_remainingAttempts == 1 ? '' : 's'} remaining.';
        } else {
          _error = 'Account locked. Try again later.';
        }
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  void _goBack() {
    setState(() {
      _showPassword = false;
      _magicLinkSent = false;
      _error = null;
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(appName)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _magicLinkSent
                ? _buildMagicLinkConfirmation()
                : _showPassword
                    ? _buildPasswordForm()
                    : _buildEmailForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Login',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          onSubmitted: (_) => _onContinue(),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _loading ? null : _onContinue,
          child: _loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Continue'),
        ),
      ],
    );
  }

  Widget _buildPasswordForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Admin Login',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          enabled: false,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          autofocus: true,
          onSubmitted: (_) => _loginWithPassword(),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _loading ? null : _loginWithPassword,
          child: _loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Login'),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _goBack,
          child: const Text('Use a different email'),
        ),
      ],
    );
  }

  Widget _buildMagicLinkConfirmation() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.mark_email_read, size: 64),
        const SizedBox(height: 16),
        const Text(
          'Check your email',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'We sent a magic link to ${_emailController.text.trim()}',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: _goBack,
          child: const Text('Use a different email'),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _loading ? null : _sendMagicLink,
          child: _loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Send Magic Link Again!'),
        ),
      ],
    );
  }
}
