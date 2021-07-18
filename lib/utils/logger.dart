import 'package:logger/logger.dart';

class Log {
  final d = Logger(printer: SimplePrinter(colors: false)).d;
  final e = Logger(printer: SimplePrinter(colors: false)).e;
  final i = Logger(printer: SimplePrinter(colors: false)).i;
  final log = Logger(printer: SimplePrinter(colors: false)).log;
  final v = Logger(printer: SimplePrinter(colors: false)).v;
  final w = Logger(printer: SimplePrinter(colors: false)).w;
  final wtf = Logger(printer: SimplePrinter(colors: false)).wtf;
  final ld = Logger(printer: PrettyPrinter(methodCount: 3, colors: false)).d;
  final le = Logger(printer: PrettyPrinter(methodCount: 3, colors: false)).e;
  final li = Logger(printer: PrettyPrinter(methodCount: 3, colors: false)).i;
  final llog = Logger(printer: PrettyPrinter(methodCount: 3, colors: false)).log;
  final lv = Logger(printer: PrettyPrinter(methodCount: 3, colors: false)).v;
  final lw = Logger(printer: PrettyPrinter(methodCount: 3, colors: false)).w;
  final lwtf = Logger(printer: PrettyPrinter(methodCount: 3, colors: false)).wtf;
}
