import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/supabase_client.dart';

final currentUserIdProvider = FutureProvider<String>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  if (client.auth.currentSession == null) {
    await client.auth.signInAnonymously();
  }
  return client.auth.currentUser!.id;
});
