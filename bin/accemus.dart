import 'dart:io';

import 'package:dsbuntis/dsbuntis.dart';

void main(List<String> args) async {
  if (args.length < 2) {
    stderr.writeln('Usage: accemus [username] [password]');
    exitCode = 1;
    return;
  }
  final plans = await getAllSubs(args[0], args[1]);
  print(Plan.plansToJsonString(plans));
}
