import 'color.dart';
import 'colors.dart';

class Category {
  final String id;
  final String title;
  final Color color;

  const Category.all({
    required this.id,
    required this.title,
    required this.color,
  });

  const Category({
    required this.id,
    required this.title,
    this.color = Colors.black,
  });

  const Category.white({
    required this.id,
    required this.title,
  }) : color = Colors.white;

  factory Category.fromJSON(Map<String, dynamic> json) {
    final result = json["color"] != null
        ? Category.all(
            id: json["id"],
            title: json["title"],
            color: json["color"],
          )
        : Category(
            id: json["id"],
            title: json["title"],
          );
    return result;
  }

  @override
  String toString() => "id: $id"
      "title: $title "
      "color: $color";
}
