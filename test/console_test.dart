import '../lib/src/console/aplicacao_console.dart';
import '../lib/src/data/areas_mock.dart';
import 'suporte.dart';

List<String> _executar(List<String> entradas) {
  var indice = 0;
  var leituras = 0;
  final saidas = <String>[];
  AplicacaoConsole(
    lerLinha: () {
      // Falha rapidamente se houver loop após EOF.
      if (++leituras > entradas.length + 1) {
        throw StateError('Leitura repetida após EOF.');
      }
      return indice < entradas.length ? entradas[indice++] : null;
    },
    escreverLinha: saidas.add,
  ).executar();
  verificar(saidas.last == 'Sessão encerrada. Até logo!');
  verificar(saidas.where((s) => s.contains('Sessão encerrada.')).length == 1);
  verificar(indice == entradas.length, 'Entradas não consumidas.');
  return saidas;
}

bool _contem(List<String> saidas, String trecho) =>
    saidas.any((s) => s.contains(trecho));

void testarConsole() {
  teste('Console aceita nickname e remove espaços externos', () {
    verificar(_contem(_executar(['  Ana  ', '1', '4']), 'Olá, Ana!'));
  });
  for (final tamanho in [3, 20]) {
    teste('Console aceita nickname no limite $tamanho', () {
      final nome = 'a' * tamanho;
      verificar(_contem(_executar([nome, '1', '4']), 'Olá, $nome!'));
    });
  }
  teste('Console repete nickname vazio, espaços, curto e longo', () {
    final saidas = _executar(['', '   ', 'ab', 'a' * 21, 'Ana', '1', '4']);
    verificar(
        saidas.where((s) => s.startsWith('Nickname inválido')).length == 4);
    verificar(_contem(saidas, 'Olá, Ana!'));
  });
  for (var i = 0; i < 3; i++) {
    final categoria = ['CRIANCA', 'JOVEM', 'ADULTO'][i];
    teste('Console seleciona categoria $categoria', () {
      verificar(_contem(
          _executar(['Ana', ' ${i + 1} ', '4']), 'Categoria: $categoria.'));
    });
  }
  teste('Console repete categoria inválida', () {
    final saidas = _executar(['Ana', '', '0', '4', 'texto', '2', '4']);
    verificar(
        saidas.where((s) => s.startsWith('Categoria inválida')).length == 4);
    verificar(_contem(saidas, 'Categoria: JOVEM.'));
  });
  teste('Console mantém menu após opções inválidas', () {
    final saidas = _executar(['Ana', '1', '', '0', '5', 'abc', '4']);
    verificar(saidas.where((s) => s.startsWith('Opção inválida')).length == 4);
    verificar(saidas.where((s) => s.contains('Menu principal')).length == 5);
  });
  teste('Console exibe todas as áreas e seus conteúdos originais', () {
    final saidas =
        _executar(['Ana', '1', '1', '1', '2', '3', '4', '5', '0', '4']);
    for (final area in areasMock) {
      verificar(_contem(saidas, area.nome));
      verificar(_contem(saidas, 'Resumo: ${area.resumo}'));
      verificar(_contem(saidas, 'Curiosidade: ${area.curiosidade}'));
    }
    verificar(saidas.where((s) => s.contains('Menu principal')).length == 2);
  });
  teste('Console trata área inválida e permite voltar', () {
    final saidas = _executar(['Ana', '1', '1', '', '-1', '6', 'abc', '0', '4']);
    verificar(saidas.where((s) => s.startsWith('Área inválida')).length == 4);
    verificar(saidas.where((s) => s.contains('Menu principal')).length == 2);
  });
  teste('Quiz e ranking funcionam, retornando ao menu', () {
    final saidas =
        _executar(['Ana', '3', '2', 'a', 'd', 'b', 'c', 'a', '3', '4']);
    verificar(_contem(saidas, 'Resultado do quiz'));
    verificar(_contem(saidas, 'Pontuação final: 150'));
    verificar(_contem(saidas, 'Ranking — ADULTO'));
    verificar(_contem(saidas, '1. Ana | 150 pontos |'));
    verificar(saidas.where((s) => s.contains('Menu principal')).length == 3);
  });
  teste('Console encerra pela opção 4', () {
    final saidas = _executar(['Ana', '1', '4']);
    verificar(saidas.where((s) => s.contains('Menu principal')).length == 1);
  });
  final cenariosEof = <String, List<String>>{
    'nickname': [],
    'nickname inválido': [''],
    'categoria': ['Ana'],
    'categoria inválida': ['Ana', 'x'],
    'menu principal': ['Ana', '1'],
    'menu inválido': ['Ana', '1', 'x'],
    'áreas': ['Ana', '1', '1'],
    'área inválida': ['Ana', '1', '1', 'x'],
    'após conteúdo': ['Ana', '1', '1', '1'],
    'após retorno': ['Ana', '1', '1', '0'],
  };
  for (final cenario in cenariosEof.entries) {
    teste('Console encerra sem loop em EOF: ${cenario.key}', () {
      final saidas = _executar(cenario.value);
      if (cenario.key == 'nickname' ||
          cenario.key.startsWith('categoria') ||
          cenario.key == 'nickname inválido') {
        verificar(!_contem(saidas, 'Menu principal'));
      }
    });
  }
}

void main() {
  testarConsole();
  concluir();
}
