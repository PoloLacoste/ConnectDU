class Event {
  final String username;
  int collected;

  Event({
    this.username,
    this.collected,
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "collected": collected
  };

  factory Event.fromJson(Map<String, dynamic> map) => Event(
    username: map["username"] as String,
    collected: map["collected"] as int,
  );
}