import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNotifier extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;
  bool _isAdmin = true;

  bool get isAdmin => _isAdmin;

  AuthNotifier() {
    _checkAdminStatus();
    _subscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      _checkAdminStatus();
    });
  }

  Future<void> _checkAdminStatus() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null && user.email != null) {
      try {
        final result = await Supabase.instance.client
            .rpc('check_login_type', params: {'p_email': user.email!});
        _isAdmin = result['type'] == 'password';
      } catch (_) {
        _isAdmin = false;
      }
    } else {
      _isAdmin = false;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
