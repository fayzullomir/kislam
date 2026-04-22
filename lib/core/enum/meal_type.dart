enum MealType {
  lunch(0),
  breakfast(1),
  dinner(2);

  final int type;

  const MealType(this.type);
}

extension MealTypeHelper on DateTime {
  MealType get currentMealType {
    final hour = this.hour;

    if (hour >= 6 && hour < 11) {
      return MealType.breakfast;
    } else if (hour >= 11 && hour < 16) {
      return MealType.lunch;
    } else {
      return MealType.dinner;
    }
  }
}