/// 通用金额格式化工具（分 → 元）
String formatCents(int cents) {
  final yuan = cents ~/ 100;
  final fen = (cents % 100).toString().padLeft(2, '0');
  return '¥$yuan.$fen';
}
