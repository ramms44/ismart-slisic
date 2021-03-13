import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category {
  final int id;
  final String name;
  final dynamic icon;
  Category(
    this.id,
    this.name, {
    this.icon,
  });
}

final List<Category> categories = [
  Category(1, "Test W", icon: FontAwesomeIcons.book),
  Category(2, "Test N", icon: FontAwesomeIcons.pen),
  Category(3, "Test B", icon: FontAwesomeIcons.pencilAlt),
  Category(4, "Test D", icon: FontAwesomeIcons.penFancy),
];
