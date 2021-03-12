import 'package:dsbuntis/dsbuntis.dart';

Future<int> main(List<String> args) async {
  if (args.length < 2) {
    print('Usage: accemus [username] [password]');
    return 1;
  }
  print(Plan.plansToJson(await getAllSubs(args[0], args[1])));
  return 0;
}
