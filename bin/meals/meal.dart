import 'dart:collection';

enum Complexity { simple, challenging, hard }

class Affordability {
  final String _name;

  static const Affordability affordable = Affordability._('affordable');
  static const Affordability luxurious = Affordability._('luxurious');
  static const Affordability pricey = Affordability._('pricey');

  const Affordability._(this._name);

  get name => _name;

  @override
  bool operator ==(Object other) {
    return name == (other as Affordability).name;
  }

  @override
  String toString() => _name;
}

mixin Allergenics on Food {
  bool glutenFree = false;
  bool vegan = false;
  bool vegetarian = false;
  bool lactoseFree = false;
}

abstract class Food {
  final String _id;
  final String _title;
  final String _imageUrl;
  final Affordability _affordability;
  final Complexity _complexity;

  Food(
    this._id,
    this._title,
    this._imageUrl,
    this._affordability,
    this._complexity,
  );

  get id => _id;
  get title => _title;
  get imageUrl => _imageUrl;
  get affordability => _affordability;
  get complexity => _complexity;

  @override
  String toString() {
    return 'id: $id'
        'title: $title';
  }

  bool get isGlutenFree;
  bool get isLactoseFree;
  bool get isVegan;
  bool get isVegetarian;
}

class Meal extends Food with Allergenics {
  final int duration;
  final List<String> categoryIDSBelongTo;
  final List<String> ingredients;
  final List<String> steps;

  Meal({
    required String id,
    required String title,
    required String imageUrl,
    required Affordability affordability,
    required Complexity complexity,
    required this.duration,
    required this.categoryIDSBelongTo,
    required this.ingredients,
    required this.steps,
    required bool isGlutenFree,
    required bool isLactoseFree,
    required bool isVegan,
    required bool isVegetarian,
  }) : super(
          id,
          title,
          imageUrl,
          affordability,
          complexity,
        ) {
    glutenFree = isGlutenFree;
    lactoseFree = isLactoseFree;
    vegan = isVegan;
    vegetarian = isVegetarian;
  }

  UnmodifiableListView<String> get AllIngredients =>
      UnmodifiableListView(ingredients);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Meal && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;

  @override
  String toString() {
    return 'id: $id'
        'title: $title'
        'isGlutenFree: $isGlutenFree'
        'isLactoseFree: $isLactoseFree'
        'isVegan: $isVegan'
        'isVegetarian: $isVegetarian';
  }

  @override
  bool get isGlutenFree => glutenFree;

  @override
  bool get isLactoseFree => lactoseFree;

  @override
  bool get isVegan => vegan;

  @override
  bool get isVegetarian => vegetarian;
}
