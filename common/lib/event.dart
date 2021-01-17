class Event {
  final String username;
  bool collected;
  int collectDate;

  Event({
    this.username,
    this.collected,
    this.collectDate
  });

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(collectDate);

  Map<String, dynamic> toJson() => {
    "username": username,
    "collected": collected,
    "collectDate": collectDate
  };

  factory Event.fromJson(Map<String, dynamic> map) => Event(
    username: map["username"] as String,
    collected: map["collected"] as bool,
    collectDate: map["collectDate"] as int
  );
}