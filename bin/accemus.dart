import 'dart:io';

import 'package:args/args.dart';
import 'package:dsbuntis/dsbuntis.dart';

void main(List<String> argv) async {
  final parser = ArgParser()
    ..addOption('session', abbr: 's', help: 'skips the login')
    ..addOption('endpoint',
        abbr: 'e',
        help: 'the endpoint to use',
        defaultsTo: Session.defaultEndpoint)
    ..addFlag('login-only',
        abbr: 'l', help: 'only logs in and prints the session');
  final args = parser.parse(argv);
  if (args['login-only']) {
    if (args.wasParsed('session') || args.rest.length != 2) {
      stderr.writeln(parser.usage);
      exitCode = 1;
      return;
    }
    final session = await Session.login(args.rest[0], args.rest[1],
        endpoint: args['endpoint']);
    print(session.token);
    return;
  } else {
    if (!args.wasParsed('session') && args.rest.length != 2) {
      stderr.writeln(parser.usage);
      exitCode = 1;
      return;
    }
    final session = args.wasParsed('session')
        ? Session(args['session'], endpoint: args['endpoint'])
        : await Session.login(args.rest[0], args.rest[1],
            endpoint: args['endpoint']);
    final json = await session.getTimetableJson();
    for (final p in parsePlans(session.downloadPlans(json))) {
      print(await p);
    }
  }
}
