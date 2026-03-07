import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/supabase_client.dart';
import '../../../providers/quiz_providers.dart';
import '../../../repositories/quiz_repository.dart';

class QuizSetFormScreen extends ConsumerStatefulWidget {
  final String? quizSetId;

  const QuizSetFormScreen({super.key, this.quizSetId});

  bool get isEditing => quizSetId != null;

  @override
  ConsumerState<QuizSetFormScreen> createState() => _QuizSetFormScreenState();
}

class _QuizSetFormScreenState extends ConsumerState<QuizSetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _loading = false;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final repo = QuizRepository(ref.read(supabaseClientProvider));
      if (widget.isEditing) {
        await repo.updateQuizSet(
          id: widget.quizSetId!,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );
      } else {
        await repo.createQuizSet(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );
      }
      ref.invalidate(quizSetsProvider);
      if (mounted) context.go('/host/admin/quiz-sets');
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
      final quizSetAsync = ref.watch(quizSetProvider(widget.quizSetId!));
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Quiz Set')),
        body: quizSetAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (qs) {
            _nameController.text = qs.name;
            _descriptionController.text = qs.description ?? '';
            _initialized = true;
            return _buildForm();
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Quiz Set' : 'Create Quiz Set'),
        leading: BackButton(onPressed: () => context.go('/host/admin/quiz-sets')),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
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
