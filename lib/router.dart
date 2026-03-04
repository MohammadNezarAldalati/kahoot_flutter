import 'package:go_router/go_router.dart';
import 'features/host/screens/host_dashboard_screen.dart';
import 'features/host/screens/host_game_screen.dart';
import 'features/player/screens/player_game_screen.dart';

final router = GoRouter(
  initialLocation: '/host/dashboard',
  routes: [
    GoRoute(
      path: '/host/dashboard',
      builder: (context, state) => const HostDashboardScreen(),
    ),
    GoRoute(
      path: '/host/game/:id',
      builder: (context, state) =>
          HostGameScreen(gameId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/game/:id',
      builder: (context, state) =>
          PlayerGameScreen(gameId: state.pathParameters['id']!),
    ),
  ],
);
