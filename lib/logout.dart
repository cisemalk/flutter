import 'package:http/http.dart' as http;

Future<void> logout() async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2/logout'),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 200) {
    // TODO: Handle successful logout
  } else {
    // TODO: Handle unsuccessful logout
  }
}
