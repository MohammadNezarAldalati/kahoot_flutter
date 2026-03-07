import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/supabase_client.dart';
import '../../../providers/quiz_providers.dart';
import '../../../repositories/quiz_repository.dart';

class QuestionFormScreen extends ConsumerStatefulWidget {
  final String quizSetId;
  final String? questionId;

  const QuestionFormScreen({
    super.key,
    required this.quizSetId,
    this.questionId,
  });

  bool get isEditing => questionId != null;

  @override
  ConsumerState<QuestionFormScreen> createState() => _QuestionFormScreenState();
}

class _QuestionFormScreenState extends ConsumerState<QuestionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bodyController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _orderController = TextEditingController(text: '0');
  final List<_ChoiceField> _choices = List.generate(
    4,
    (_) => _ChoiceField(),
  );
  bool _loading = false;
  bool _initialized = false;

  @override
  void dispose() {
    _bodyController.dispose();
    _imageUrlController.dispose();
    _orderController.dispose();
    for (final c in _choices) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final nonEmptyChoices = _choices
        .where((c) => c.controller.text.trim().isNotEmpty)
        .toList();

    if (nonEmptyChoices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one choice')),
      );
      return;
    }

    if (!nonEmptyChoices.any((c) => c.isCorrect)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mark at least one choice as correct')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final repo = QuizRepository(ref.read(supabaseClientProvider));
      await repo.saveQuestionWithChoices(
        questionId: widget.questionId,
        quizSetId: widget.quizSetId,
        body: _bodyController.text.trim(),
        order: int.tryParse(_orderController.text.trim()) ?? 0,
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
        choices: nonEmptyChoices
            .map((c) => (body: c.controller.text.trim(), isCorrect: c.isCorrect))
            .toList(),
      );
      ref.invalidate(questionsProvider(widget.quizSetId));
      ref.invalidate(quizSetsProvider);
      if (mounted) {
        context.go('/host/admin/quiz-sets/${widget.quizSetId}/questions');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing && !_initialized) {
      final questionsAsync = ref.watch(questionsProvider(widget.quizSetId));
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Question')),
        body: questionsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (questions) {
            final q = questions.firstWhere((q) => q.id == widget.questionId);
            _bodyController.text = q.body;
            _imageUrlController.text = q.imageUrl ?? '';
            _orderController.text = q.order.toString();
            for (var i = 0; i < _choices.length; i++) {
              if (i < q.choices.length) {
                _choices[i].controller.text = q.choices[i].body;
                _choices[i].isCorrect = q.choices[i].isCorrect;
              }
            }
            _initialized = true;
            return _buildForm();
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Question' : 'Create Question'),
        leading: BackButton(
          onPressed: () => context.go('/host/admin/quiz-sets/${widget.quizSetId}/questions'),
        ),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _bodyController,
                  decoration: const InputDecoration(
                    labelText: 'Question text',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _orderController,
                  decoration: const InputDecoration(
                    labelText: 'Order',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Choices',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                for (var i = 0; i < _choices.length; i++) ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _choices[i].controller,
                          decoration: InputDecoration(
                            labelText: 'Choice ${i + 1}',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          const Text('Correct', style: TextStyle(fontSize: 12)),
                          Checkbox(
                            value: _choices[i].isCorrect,
                            onChanged: (v) {
                              setState(() => _choices[i].isCorrect = v ?? false);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _loading ? null : _save,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.isEditing ? 'Update' : 'Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceField {
  final TextEditingController controller = TextEditingController();
  bool isCorrect = false;

  void dispose() {
    controller.dispose();
  }
}
