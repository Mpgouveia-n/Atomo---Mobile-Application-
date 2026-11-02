import 'dart:io';

import '../lib/src/console/aplicacao_console.dart';

void main() {
  AplicacaoConsole(
    lerLinha: () => stdin.readLineSync(),
    escreverLinha: (linha) => stdout.writeln(linha),
  ).executar();
}
