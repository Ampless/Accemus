// TODO: testing

import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:args/args.dart';
import 'package:dsbuntis/dsbuntis.dart';

void main(List<String> argv) async {
  final parser = ArgParser()
    ..addOption('session',
        abbr: 's',
        help: 'The session to be used instead of logging in',
        valueHelp: 'token')
    ..addOption('endpoint',
        abbr: 'e',
        help: 'The endpoint to use',
        valueHelp: 'backend',
        defaultsTo: Session.defaultEndpoint)
    ..addOption('preview-endpoint',
        abbr: 'p',
        help: 'The endpoint to use for previews',
        valueHelp: 'backend',
        defaultsTo: Session.defaultPreviewEndpoint)
    ..addOption('app-version',
        abbr: 'a',
        help: 'The DSBMobile version to report to the server',
        valueHelp: 'value',
        defaultsTo: Session.defaultAppVersion)
    ..addOption('os-version',
        abbr: 'o',
        help: 'The OS version to report to the server',
        valueHelp: 'value',
        defaultsTo: Session.defaultOsVersion)
    ..addOption('bundle-id',
        abbr: 'b',
        help: 'The bundle id to report to the server',
        valueHelp: 'value',
        defaultsTo: Session.defaultBundleId)
    ..addFlag('login-only',
        abbr: 'l', help: 'Only log in and print the session', negatable: false)
    ..addFlag('help',
        abbr: 'h', help: 'Display available options', negatable: false);

  try {
    final args = parser.parse(argv);
    if (args['help']) {
      stderr.writeln('${Platform.executable} [options] [username] [password]');
      stderr.writeln('${Platform.executable} [options] -s [session]');
      stderr.writeln();
      stderr.writeln(parser.usage);
    } else if (args['login-only']) {
      if (args.wasParsed('session')) {
        throw 'You can\'t log in with a session.';
      }
      if (args.rest.isEmpty) {
        throw 'No username/ID provided.';
      }
      if (args.rest.length < 2) {
        throw 'No password provided.';
      }
      final session = await Session.login(args.rest[0], args.rest[1],
          endpoint: args['endpoint'],
          appVersion: args['app-version'],
          bundleId: args['bundle-id'],
          osVersion: args['os-version'],
          previewEndpoint: args['preview-endpoint']);
      print(session.token);
    } else {
      if (!args.wasParsed('session') && args.rest.length != 2) {
        throw 'No credentials or session provided.';
      }
      final session = args.wasParsed('session')
          ? Session(args['session'],
              endpoint: args['endpoint'],
              previewEndpoint: args['preview-endpoint'])
          : await Session.login(args.rest[0], args.rest[1],
              endpoint: args['endpoint'],
              previewEndpoint: args['preview-endpoint'],
              appVersion: args['app-version'],
              osVersion: args['os-version'],
              bundleId: args['bundle-id']);
      final json = await session.getTimetableJson();
      for (final p in parsePlans(session.downloadPlans(json))) {
        print(await p);
      }
    }
  } catch (e) {
    stderr.writeln('${Platform.executable} [options] [username] [password]');
    stderr.writeln('${Platform.executable} [options] -s [session]');
    stderr.writeln();
    stderr.writeln(parser.usage);
    stderr.writeln();
    stderr.writeln((AnsiPen()..red())(e));
    exitCode = 1;
    return;
  }
}
