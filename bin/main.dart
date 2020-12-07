import 'package:dsbuntis/dsbuntis.dart';
import 'package:schttp/schttp.dart';

Future<int> main(List<String> args) async {
  if (args.length < 2) {
    print('Usage: accemus [username] [password]');
    return 1;
  }
  final http = ScHttpClient();
  print(
    Plan.plansToJson(await getAllSubs(args[0], args[1], http.get, http.post)),
  );
  return 0;
}
