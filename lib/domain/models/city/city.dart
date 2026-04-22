enum City {
  // MECCA,
  // MEDINA,
  makkah,
  madinah,
  tashkent,
  samarkand;

  City? valueOrNull(String value) {
    switch (value.toLowerCase()) {
      case "mecca":
        return City.makkah;
      case "makkah":
        return City.makkah;
      case "madinah":
        return City.madinah;
      case "medina":
        return City.madinah;
      case "tashkent":
        return City.tashkent;
      case "samarkand":
        return City.samarkand;
      default:
        return null;
    }
  }

  String get apiValue {
    switch (this) {
      case City.makkah:
        return "mecca";
      case City.madinah:
        return "madinah";
      case City.tashkent:
        return "tashkent";
      case City.samarkand:
        return "samarkand";
    }
  }
}
