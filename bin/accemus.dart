import 'dart:io';

import 'package:dsbuntis/dsbuntis.dart';

Future<int> main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Usage: accemus [username] [password]');
    return 1;
  }
  final plans = await getAllSubs(args[0], args[1]);
  if (plans == null) {
    stderr.writeln('Please check your internet connection and credentials.');
    return 2;
  }
  print(Plan.plansToJsonString(plans));
  return 0;
}
