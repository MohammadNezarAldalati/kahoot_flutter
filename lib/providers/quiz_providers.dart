import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/supabase_client.dart';
import '../models/quiz_set.dart';
import '../models/question.dart';
import '../repositories/quiz_repository.dart';

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository(ref.watch(supabaseClientProvider));
});

final quizSetsProvider = FutureProvider<List<QuizSet>>((ref) {
  return ref.watch(quizRepositoryProvider).getQuizSets();
});

final quizSetProvider =
    FutureProvider.family<QuizSet, String>((ref, quizSetId) {
  return ref.watch(quizRepositoryProvider).getQuizSet(quizSetId);
});

final questionsProvider =
    FutureProvider.family<List<Question>, String>((ref, quizSetId) {
  return ref.watch(quizRepositoryProvider).getQuestions(quizSetId);
});
