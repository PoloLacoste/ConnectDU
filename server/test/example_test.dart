import 'harness/app.dart';

void main() async {
  final harness = Harness()..install();

  test("GET / returns 404", () async {
    expectResponse(await harness.agent.get("/"), 404);
  });

  test("POST /register returns 400", () async {
    expectResponse(await harness.agent.post("/register"), 400);
  });

  test("POST /login returns 400", () async {
    expectResponse(await harness.agent.post("/login"), 400);
  });
}
