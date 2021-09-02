import 'package:logger/logger.dart';

const logColor = false;

class Log {
  final d = Logger(printer: SimplePrinter(colors: logColor)).d;
  final e = Logger(printer: SimplePrinter(colors: logColor)).e;
  final i = Logger(printer: SimplePrinter(colors: logColor)).i;
  final log = Logger(printer: SimplePrinter(colors: logColor)).log;
  final v = Logger(printer: SimplePrinter(colors: logColor)).v;
  final w = Logger(printer: SimplePrinter(colors: logColor)).w;
  final wtf = Logger(printer: SimplePrinter(colors: logColor)).wtf;
  final ld = Logger(printer: PrettyPrinter(methodCount: 3, colors: logColor)).d;
  final le = Logger(printer: PrettyPrinter(methodCount: 3, colors: logColor)).e;
  final li = Logger(printer: PrettyPrinter(methodCount: 3, colors: logColor)).i;
  final llog = Logger(printer: PrettyPrinter(methodCount: 3, colors: logColor)).log;
  final lv = Logger(printer: PrettyPrinter(methodCount: 3, colors: logColor)).v;
  final lw = Logger(printer: PrettyPrinter(methodCount: 3, colors: logColor)).w;
  final lwtf = Logger(printer: PrettyPrinter(methodCount: 3, colors: logColor)).wtf;
}
