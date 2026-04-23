import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/task.dart';
import '../../../../domain/models/task_comment.dart';
import '../../view_model/home_view_model.dart';

class TaskCommentsSection extends StatefulWidget {
  const TaskCommentsSection({required this.task, super.key});

  final Task task;

  @override
  State<TaskCommentsSection> createState() => _TaskCommentsSectionState();
}

class _TaskCommentsSectionState extends State<TaskCommentsSection> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final comment in widget.task.comments) ...[
              _CommentTile(taskId: widget.task.id, comment: comment),
              const SizedBox(height: 8),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    maxLength: 500,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Novo comentário',
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: 'Comentar',
                  onPressed: _addComment,
                  icon: const Icon(Icons.favorite_border),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addComment() async {
    final saved = await context.read<HomeViewModel>().addComment(
      taskId: widget.task.id,
      text: _commentController.text,
    );

    if (mounted && saved) {
      _commentController.clear();
    }
  }
}

class _CommentTile extends StatefulWidget {
  const _CommentTile({required this.taskId, required this.comment});

  final String taskId;
  final TaskComment comment;

  @override
  State<_CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<_CommentTile> {
  final _replyController = TextEditingController();
  bool _isReplying = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.comment.text, style: theme.textTheme.bodyMedium),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _isReplying = !_isReplying),
              icon: const Icon(Icons.favorite_border),
              label: const Text('Responder'),
            ),
          ),
          for (final reply in widget.comment.replies)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 6),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: theme.colorScheme.primary),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(reply.text),
                ),
              ),
            ),
          if (_isReplying) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    maxLength: 500,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Resposta',
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: 'Responder',
                  onPressed: _addReply,
                  icon: const Icon(Icons.favorite_border),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _addReply() async {
    final saved = await context.read<HomeViewModel>().addReply(
      taskId: widget.taskId,
      commentId: widget.comment.id,
      text: _replyController.text,
    );

    if (mounted && saved) {
      _replyController.clear();
      setState(() => _isReplying = false);
    }
  }
}
