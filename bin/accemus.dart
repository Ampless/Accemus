import 'dart:io';

import 'package:args/args.dart';
import 'package:dsbuntis/dsbuntis.dart';

void main(List<String> argv) async {
  final parser = ArgParser()
    ..addOption('session', abbr: 's', help: 'skips the login')
    ..addFlag('login-only',
        abbr: 'l', help: 'only logs in and prints the session');
  final args = parser.parse(argv);
  if (args['login-only']) {
    if (args.wasParsed('session') || args.rest.length != 2) {
      stderr.writeln(parser.usage);
      exitCode = 1;
      return;
    }
    final session = await Session.login(args.rest[0], args.rest[1]);
    print(session.token);
    return;
  } else {
    if (!args.wasParsed('session') && args.rest.length != 2) {
      stderr.writeln(parser.usage);
      exitCode = 1;
      return;
    }
    final session = args.wasParsed('session')
        ? Session.fromToken(args['session'])
        : await Session.login(args.rest[0], args.rest[1]);
    final json = await session.getTimetableJson();
    for (final p in session.parsePlans(session.downloadPlans(json))) {
      print(await p);
    }
  }
}
