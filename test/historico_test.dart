import '../lib/atomo_mais.dart';
import '../lib/src/console/aplicacao_console.dart';
import 'suporte.dart';

TentativaQuiz _tentativa(String id,
        {String nome = 'Ana',
        Categoria categoria = Categoria.CRIANCA,
        int acertos = 3,
        int tempo = 10,
        int perguntas = 5,
        DateTime? data}) =>
    TentativaQuiz(
      id: id,
      usuario: Usuario(nickname: nome, categoria: categoria),
      categoria: categoria,
      quantidadePerguntas: perguntas,
      quantidadeAcertos: acertos,
      tempoSegundos: tempo,
      dataRealizacao: data ?? DateTime.utc(2026, 11, 1),
    );

List<String> _sessao(List<String> entradas, HistoricoTentativas historico) {
  var indice = 0;
  var leituras = 0;
  final saidas = <String>[];
  AplicacaoConsole(
    historico: historico,
    lerLinha: () {
      if (++leituras > entradas.length + 1) throw StateError('Loop após EOF');
      return indice < entradas.length ? entradas[indice++] : null;
    },
    escreverLinha: saidas.add,
  ).executar();
  verificar(indice == entradas.length);
  verificar(saidas.last == 'Sessão encerrada. Até logo!');
  return saidas;
}

void testarHistorico() {
  teste('Histórico e rankings começam vazios', () {
    final h = HistoricoTentativas();
    verificar(h.tentativas.isEmpty && h.ranking().isEmpty);
    for (final c in Categoria.values) {
      verificar(h.ranking(categoria: c).isEmpty);
    }
  });
  teste('Registro preserva referência ao resultado e usuário', () {
    final h = HistoricoTentativas();
    final t = _tentativa('1');
    h.registrar(t);
    verificar(h.tentativas.length == 1);
    verificar(identical(h.tentativas.single, t));
    verificar(identical(
        h.ranking(categoria: Categoria.CRIANCA).single.usuario, t.usuario));
  });
  for (final perguntas in [1, 4, 6]) {
    teste('Histórico rejeita tentativa com $perguntas perguntas', () {
      final h = HistoricoTentativas();
      rejeita<ArgumentError>(
          () => h.registrar(_tentativa('1', perguntas: perguntas, acertos: 0)));
      verificar(h.tentativas.isEmpty);
    });
  }
  teste('Mesmo ID não é registrado duas vezes', () {
    final h = HistoricoTentativas();
    final t = _tentativa('1');
    h.registrar(t);
    rejeita<ArgumentError>(() => h.registrar(t));
    rejeita<ArgumentError>(() => h.registrar(_tentativa('1', nome: 'Bia')));
    verificar(h.tentativas.length == 1);
  });
  teste('Histórico guarda todas as tentativas e ranking só a maior pontuação',
      () {
    final h = HistoricoTentativas();
    h.registrar(_tentativa('1', acertos: 2, tempo: 1));
    h.registrar(_tentativa('2', acertos: 5, tempo: 20));
    h.registrar(_tentativa('3', acertos: 1, tempo: 1));
    verificar(h.tentativas.length == 3);
    verificar(h.ranking().single.id == '2');
    verificar(h.ranking().single.pontuacao == 50);
  });
  teste('Melhor tentativa desempata pelo menor tempo', () {
    final h = HistoricoTentativas();
    h.registrar(_tentativa('1', tempo: 15));
    h.registrar(_tentativa('2', tempo: 5));
    h.registrar(_tentativa('3', tempo: 20));
    verificar(h.tentativas.length == 3 && h.ranking().single.id == '2');
  });
  teste('Nicknames equivalentes compartilham posição sem alterar os modelos',
      () {
    final h = HistoricoTentativas();
    h.registrar(_tentativa('1', nome: 'Ana', acertos: 1));
    h.registrar(_tentativa('2', nome: ' aNA ', acertos: 5));
    h.registrar(_tentativa('3', nome: 'ANA', acertos: 2));
    verificar(h.tentativas.length == 3);
    verificar(h.ranking().length == 1 && h.ranking().single.id == '2');
    verificar(h.ranking().single.usuario.nickname == 'aNA');
  });
  teste('Normalização também funciona com letras acentuadas', () {
    final h = HistoricoTentativas();
    h.registrar(_tentativa('1', nome: 'ÁGATA'));
    h.registrar(_tentativa('2', nome: 'ágata', acertos: 5));
    verificar(h.ranking().length == 1 && h.ranking().single.id == '2');
  });
  teste('Ordenação prioriza pontos, depois tempo, depois nickname', () {
    final h = HistoricoTentativas();
    h.registrar(_tentativa('1', nome: 'Zoe', acertos: 5, tempo: 100));
    h.registrar(_tentativa('2', nome: 'bia', acertos: 4, tempo: 10));
    h.registrar(_tentativa('3', nome: 'Ana', acertos: 4, tempo: 10));
    h.registrar(_tentativa('4', nome: 'Leo', acertos: 4, tempo: 5));
    verificar(h.ranking().map((t) => t.id).join(',') == '1,4,3,2');
  });
  teste('Empate absoluto seleciona data e ID deterministicamente', () {
    final tentativas = [
      _tentativa('z', data: DateTime.utc(2026, 11, 2)),
      _tentativa('b'),
      _tentativa('a'),
    ];
    for (final ordem in [tentativas, tentativas.reversed]) {
      final h = HistoricoTentativas();
      for (final t in ordem) {
        h.registrar(t);
      }
      verificar(h.ranking().single.id == 'a');
    }
  });
  teste('Mesmo nickname tem melhor tentativa independente por categoria', () {
    final h = HistoricoTentativas();
    for (final c in Categoria.values) {
      h.registrar(_tentativa('${c.name}-1', categoria: c, acertos: 1));
      h.registrar(_tentativa('${c.name}-2', categoria: c, acertos: 5));
    }
    verificar(h.tentativas.length == 6 && h.ranking().length == 3);
    for (final c in Categoria.values) {
      final ranking = h.ranking(categoria: c);
      verificar(ranking.length == 1 && ranking.single.categoria == c);
      verificar(ranking.single.id == '${c.name}-2');
    }
    verificar(h.ranking().map((t) => t.pontuacao).join(',') == '150,100,50');
  });
  teste('Histórico e ranking fornecem cópias imutáveis', () {
    final h = HistoricoTentativas();
    h.registrar(_tentativa('1'));
    final historico = h.tentativas;
    final ranking = h.ranking();
    rejeita<UnsupportedError>(() => historico.clear());
    rejeita<UnsupportedError>(() => ranking.clear());
    rejeita<UnsupportedError>(() => historico[0] = _tentativa('2'));
    rejeita<UnsupportedError>(() => ranking[0] = _tentativa('2'));
    h.registrar(_tentativa('2', nome: 'Bia'));
    verificar(historico.length == 1 && ranking.length == 1);
    verificar(h.tentativas.length == 2 && h.ranking().length == 2);
  });
  teste('Consulta não reordena nem remove tentativas do histórico', () {
    final h = HistoricoTentativas();
    h.registrar(_tentativa('1', acertos: 0));
    h.registrar(_tentativa('2', nome: 'Bia', acertos: 5));
    h.registrar(_tentativa('3', acertos: 4));
    h.ranking();
    h.ranking(categoria: Categoria.CRIANCA);
    verificar(h.tentativas.map((t) => t.id).join(',') == '1,2,3');
  });
  teste('Console informa ranking vazio e retorna ao menu', () {
    final h = HistoricoTentativas();
    final saidas = _sessao(['Ana', '1', '3', '4'], h);
    verificar(saidas
        .contains('Ainda não existem partidas concluídas nesta categoria.'));
    verificar(saidas.where((s) => s.contains('Menu principal')).length == 2);
    verificar(h.tentativas.isEmpty);
  });
  teste('Console registra automaticamente e mostra posição da sessão', () {
    final h = HistoricoTentativas();
    final saidas =
        _sessao(['Ana', '1', '2', 'b', 'c', 'a', 'd', 'b', '3', '4'], h);
    verificar(h.tentativas.length == 1 && h.tentativas.single.pontuacao == 50);
    verificar(saidas.any((s) => s.startsWith('1. Ana | 50 pontos |')));
  });
  teste('Console mantém duas partidas mas classifica só a melhor', () {
    final h = HistoricoTentativas();
    final saidas = _sessao([
      'Ana',
      '1',
      '2',
      'b',
      'c',
      'a',
      'd',
      'b',
      '2',
      'a',
      'a',
      'b',
      'a',
      'a',
      '3',
      '4'
    ], h);
    verificar(h.tentativas.length == 2);
    verificar(h.ranking().length == 1 && h.ranking().single.pontuacao == 50);
    verificar(saidas.where((s) => s.startsWith('1. Ana |')).length == 1);
  });
  teste('Console mostra apenas ranking da categoria atual', () {
    final h = HistoricoTentativas();
    h.registrar(
        _tentativa('1', nome: 'Bia', categoria: Categoria.ADULTO, acertos: 5));
    final saidas = _sessao(['Ana', '1', '3', '4'], h);
    verificar(saidas
        .contains('Ainda não existem partidas concluídas nesta categoria.'));
    verificar(!saidas.any((s) => s.contains('Bia')));
  });
  for (var respostas = 0; respostas < 5; respostas++) {
    teste('EOF após $respostas respostas não insere tentativa', () {
      final h = HistoricoTentativas();
      final anterior = _tentativa('anterior');
      h.registrar(anterior);
      final saidas =
          _sessao(['Ana', '1', '2', ...List.filled(respostas, 'a')], h);
      verificar(
          h.tentativas.length == 1 && identical(h.tentativas.single, anterior));
      verificar(!saidas.any((s) => s.contains('Resultado do quiz')));
    });
  }
  teste('EOF no menu após conclusão mantém a tentativa concluída', () {
    final h = HistoricoTentativas();
    _sessao(['Ana', '1', '2', 'b', 'c', 'a', 'd', 'b'], h);
    verificar(h.tentativas.length == 1);
  });
  teste('Nova instância de histórico começa sem dados anteriores', () {
    final h = HistoricoTentativas()..registrar(_tentativa('1'));
    verificar(h.tentativas.length == 1);
    verificar(HistoricoTentativas().tentativas.isEmpty);
  });
}

void main() {
  testarHistorico();
  concluir();
}
