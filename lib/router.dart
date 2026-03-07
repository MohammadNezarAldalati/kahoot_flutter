import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/auth_notifier.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/admin/screens/answer_list_screen.dart';
import 'features/admin/screens/game_list_screen.dart';
import 'features/admin/screens/participant_list_screen.dart';
import 'features/admin/screens/question_form_screen.dart';
import 'features/admin/screens/question_list_screen.dart';
import 'features/admin/screens/quiz_set_form_screen.dart';
import 'features/admin/screens/quiz_set_list_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/host/screens/host_dashboard_screen.dart';
import 'features/host/screens/host_game_screen.dart';
import 'features/player/screens/player_game_screen.dart';

final authNotifier = AuthNotifier();

bool _isLoggedIn(User? user) =>
    user != null && user.isAnonymous != true && user.email != null;

final router = GoRouter(
  initialLocation: '/host/dashboard',
  refreshListenable: authNotifier,
  redirect: (context, state) {
    final user = Supabase.instance.client.auth.currentUser;
    final isGoingToLogin = state.matchedLocation == '/login';
    final isHostRoute = state.matchedLocation.startsWith('/host');
    final isAdminRoute = state.matchedLocation.startsWith('/host/admin');

    if (isHostRoute && !_isLoggedIn(user)) {
      return '/login';
    }

    if (isAdminRoute && !authNotifier.isAdmin) {
      return '/host/dashboard';
    }

    if (isGoingToLogin && _isLoggedIn(user)) {
      return '/host/dashboard';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
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
      path: '/host/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/host/admin/quiz-sets',
      builder: (context, state) => const QuizSetListScreen(),
    ),
    GoRoute(
      path: '/host/admin/quiz-sets/create',
      builder: (context, state) => const QuizSetFormScreen(),
    ),
    GoRoute(
      path: '/host/admin/quiz-sets/:id',
      builder: (context, state) =>
          QuizSetFormScreen(quizSetId: state.pathParameters['id']),
    ),
    GoRoute(
      path: '/host/admin/quiz-sets/:id/questions',
      builder: (context, state) =>
          QuestionListScreen(quizSetId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/host/admin/quiz-sets/:id/questions/create',
      builder: (context, state) =>
          QuestionFormScreen(quizSetId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/host/admin/quiz-sets/:id/questions/:qid',
      builder: (context, state) => QuestionFormScreen(
        quizSetId: state.pathParameters['id']!,
        questionId: state.pathParameters['qid'],
      ),
    ),
    GoRoute(
      path: '/host/admin/games',
      builder: (context, state) => const GameListScreen(),
    ),
    GoRoute(
      path: '/host/admin/participants',
      builder: (context, state) => const ParticipantListScreen(),
    ),
    GoRoute(
      path: '/host/admin/answers',
      builder: (context, state) => const AnswerListScreen(),
    ),
    GoRoute(
      path: '/game/:id',
      builder: (context, state) =>
          PlayerGameScreen(gameId: state.pathParameters['id']!),
    ),
  ],
);
