enum Gender {
  male,
  female;

  int get apiCode {
    return switch (this) {
      Gender.male => 1,
      Gender.female => 2,
    };
  }

  static Gender? valueOrNull(String? value) {
    return Gender.values
        .firstWhere((e) => e.name.toUpperCase() == value?.toUpperCase());
  }
}
