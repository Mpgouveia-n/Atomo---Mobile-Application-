import 'dart:io';

int _executados = 0;
int _falhas = 0;

void teste(String nome, void Function() corpo) {
  _executados++;
  try {
    corpo();
    print('OK: $nome');
  } catch (erro, pilha) {
    _falhas++;
    stderr.writeln('FALHA: $nome\n$erro\n$pilha');
  }
}

void verificar(bool condicao, [String mensagem = 'Condição não atendida']) {
  if (!condicao) throw StateError(mensagem);
}

void rejeita<T extends Object>(void Function() acao) {
  try {
    acao();
  } catch (erro) {
    if (erro is T) return;
    throw StateError('Esperado $T, recebido ${erro.runtimeType}: $erro');
  }
  throw StateError('Esperada exceção $T.');
}

void concluir() {
  print(
      'Testes: $_executados; aprovados: ${_executados - _falhas}; falhas: $_falhas.');
  if (_falhas > 0) exitCode = 1;
}
