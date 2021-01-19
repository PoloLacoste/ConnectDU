class Event {
  final String username;
  double collected;

  Event({
    this.username,
    this.collected,
  });

  bool get isCollected => collected != null && collected != -1;
  bool get canCollect => collected == -1;
  bool get noInformation => collected == null;

  Map<String, dynamic> toJson() => {
    "username": username,
    "collected": collected
  };

  factory Event.fromJson(Map<String, dynamic> map) => Event(
    username: map["username"] as String,
    collected: map["collected"] as double,
  );
}