enum StatsType {
  view,
  like,
  saved,
  share;

  String get apiCode {
    return switch (this) {
      view => "VIEW",
      like => "LIKE",
      saved => "SAVED",
      share => "SHARE",
    };
  }
}
