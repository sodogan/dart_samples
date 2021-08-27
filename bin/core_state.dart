import './color.dart';
import './colors.dart';

class CoreState {
  final int counter;
  final Color backgroundColor;

  const CoreState({
    this.counter = 0,
    this.backgroundColor = Colors.white,
  });

  CoreState copyWith({
    int? counter,
    Color? backgroundColor,
  }) =>
      CoreState(
        counter: counter ?? this.counter,
        backgroundColor: backgroundColor ?? this.backgroundColor,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CoreState &&
              runtimeType == other.runtimeType &&
              counter == other.counter &&
              backgroundColor == other.backgroundColor;

  @override
  int get hashCode => counter.hashCode ^ backgroundColor.hashCode;


  @override
  String toString() {
    return "counter: $counter\n"
            "color:$backgroundColor";
  }
}
