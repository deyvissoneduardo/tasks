class TaskReply {
  const TaskReply({
    required this.id,
    required this.text,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String text;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
