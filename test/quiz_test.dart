import '../lib/atomo_mais.dart';
import '../lib/src/console/aplicacao_console.dart';
import '../lib/src/console/quiz_console.dart';
import 'suporte.dart';

class _CronometroFixo extends Stopwatch {
  _CronometroFixo(this.micros);
  final int micros;
  @override
  int get elapsedMicroseconds => micros;
}

MotorQuiz _motor(Categoria categoria, {Stopwatch? cronometro}) => MotorQuiz(
      usuario: Usuario(nickname: 'Ana', categoria: categoria),
      banco: perguntasMock,
      cronometro: cronometro,
    );

String _letra(Pergunta pergunta, bool correta) =>
    pergunta.alternativas.firstWhere((a) => a.correta == correta).letra;

// Saídas e tentativa são observadas separadamente, sem persistência.
TentativaQuiz? _rodarQuiz(List<String> entradas, List<String> saidas) {
  var indice = 0;
  var leituras = 0;
  final resultado = QuizConsole(
    lerLinha: () {
      if (++leituras > entradas.length + 1) throw StateError('Loop após EOF');
      return indice < entradas.length ? entradas[indice++] : null;
    },
    escreverLinha: saidas.add,
  ).executar(Usuario(nickname: 'Ana', categoria: Categoria.CRIANCA));
  verificar(indice == entradas.length);
  return resultado;
}

void testarQuiz() {
  for (final categoria in Categoria.values) {
    teste('Seleção de cinco perguntas distintas de ${categoria.name}', () {
      final motor = _motor(categoria);
      verificar(motor.perguntas.length == 5);
      verificar(
          motor.perguntas.every((p) => p.categoria == categoria && p.ativa));
      verificar(motor.perguntas.map((p) => p.id).toSet().length == 5);
      for (final p in motor.perguntas) {
        verificar(perguntasMock.any((original) => identical(original, p)));
        verificar(areasMock.any((area) => identical(area, p.areaAplicacao)));
      }
      motor.cancelar();
    });
    for (final acertos in [0, 2, 5]) {
      teste('Resultado ${categoria.name} com $acertos acertos', () {
        final motor = _motor(categoria);
        final inicio = DateTime.now();
        verificar(motor.resultado == null);
        for (var i = 0; i < 5; i++) {
          final correta = i < acertos;
          verificar(motor.responder(_letra(motor.perguntaAtual!, correta)) ==
              correta);
          verificar(motor.quantidadeRespondidas == i + 1);
          if (i < 4) verificar(motor.resultado == null);
        }
        final t = motor.resultado!;
        final pontos = switch (categoria) {
          Categoria.CRIANCA => 10,
          Categoria.JOVEM => 20,
          Categoria.ADULTO => 30,
        };
        verificar(t.quantidadePerguntas == 5 && t.quantidadeAcertos == acertos);
        verificar(motor.quantidadeErros == 5 - acertos);
        verificar(t.pontuacao == acertos * pontos);
        verificar(t.usuario.nickname == 'Ana' && t.categoria == categoria);
        verificar(t.tempoSegundos >= 1);
        verificar(!t.dataRealizacao.isBefore(inicio));
        verificar(motor.perguntaAtual == null);
        rejeita<StateError>(() => motor.responder('A'));
        rejeita<StateError>(() => motor.cancelar());
        verificar(identical(t, motor.resultado));
      });
    }
  }
  teste('Seleção ignora IDs repetidos sem duplicar perguntas', () {
    final lista = selecionarPerguntas(
        [...perguntasMock, ...perguntasMock], Categoria.JOVEM);
    verificar(lista.length == 5 && lista.map((p) => p.id).toSet().length == 5);
  });
  teste('Seleção insuficiente não inicia uma partida parcial', () {
    rejeita<StateError>(() => MotorQuiz(
        usuario: Usuario(nickname: 'Ana', categoria: Categoria.CRIANCA),
        banco: perguntasMock.take(4)));
    rejeita<StateError>(() => selecionarPerguntas(
        List.filled(5, perguntasMock.first), Categoria.CRIANCA));
  });
  teste('Seleção desconsidera perguntas inativas', () {
    final p = perguntasMock.first;
    final inativa = Pergunta(
        id: p.id,
        areaAplicacao: p.areaAplicacao,
        enunciado: p.enunciado,
        categoria: p.categoria,
        explicacao: p.explicacao,
        ativa: false,
        alternativas: p.alternativas);
    rejeita<StateError>(() => selecionarPerguntas(
        [inativa, ...perguntasMock.skip(1)], Categoria.CRIANCA));
  });
  teste('Lista selecionada é protegida e independente da lista de origem', () {
    final origem = perguntasMock.toList();
    final motor = MotorQuiz(
        usuario: Usuario(nickname: 'Ana', categoria: Categoria.CRIANCA),
        banco: origem);
    origem.clear();
    verificar(motor.perguntas.length == 5);
    rejeita<UnsupportedError>(() => motor.perguntas.clear());
    motor.cancelar();
  });
  teste('Entradas inválidas não avançam nem contam pontos', () {
    final motor = _motor(Categoria.CRIANCA);
    final atual = motor.perguntaAtual;
    for (final entrada in ['', ' ', 'E', 'AB', '1', 'A B']) {
      verificar(motor.responder(entrada) == null);
      verificar(identical(atual, motor.perguntaAtual));
      verificar(motor.quantidadeRespondidas == 0 &&
          motor.quantidadeAcertos == 0 &&
          motor.quantidadeErros == 0);
      verificar(motor.resultado == null);
    }
    motor.cancelar();
  });
  for (final letra in ['A', 'B', 'C', 'D']) {
    teste('Resposta $letra aceita minúscula e espaços', () {
      final motor = _motor(Categoria.CRIANCA);
      final esperado = motor.perguntaAtual!.alternativas
          .singleWhere((a) => a.letra == letra)
          .correta;
      verificar(motor.responder(' ${letra.toLowerCase()} ') == esperado);
      verificar(motor.quantidadeRespondidas == 1);
      motor.cancelar();
    });
  }
  teste('Cada resposta válida avança exatamente uma pergunta', () {
    final motor = _motor(Categoria.CRIANCA);
    final ids = <String>{};
    while (motor.perguntaAtual != null) {
      verificar(ids.add(motor.perguntaAtual!.id));
      motor.responder('A');
    }
    verificar(ids.length == 5 && motor.quantidadeRespondidas == 5);
    rejeita<StateError>(() => motor.responder('A'));
  });
  teste('Cancelamento não constrói tentativa nem permite novas respostas', () {
    final motor = _motor(Categoria.CRIANCA);
    motor.responder('A');
    motor.cancelar();
    verificar(motor.resultado == null && motor.perguntaAtual == null);
    rejeita<StateError>(() => motor.responder('A'));
  });
  for (final micros in [0, 1, 999999, 1000000, 1000001, 2500000]) {
    teste('Duração de $micros micros respeita arredondamento e mínimo', () {
      final cronometro = _CronometroFixo(micros);
      final motor = _motor(Categoria.CRIANCA, cronometro: cronometro);
      verificar(cronometro.isRunning);
      for (var i = 0; i < 5; i++) {
        motor.responder('A');
      }
      final esperado = micros <= 1000000 ? 1 : (micros <= 2000000 ? 2 : 3);
      verificar(motor.resultado!.tempoSegundos == esperado);
      verificar(!cronometro.isRunning);
    });
  }
  teste('Partidas sucessivas têm estado e IDs independentes', () {
    final primeira = _motor(Categoria.CRIANCA);
    final segunda = _motor(Categoria.CRIANCA);
    for (var i = 0; i < 5; i++) {
      primeira.responder(_letra(primeira.perguntaAtual!, true));
      segunda.responder(_letra(segunda.perguntaAtual!, false));
    }
    verificar(primeira.resultado!.id != segunda.resultado!.id);
    verificar(primeira.resultado!.quantidadeAcertos == 5);
    verificar(segunda.resultado!.quantidadeAcertos == 0);
  });
  teste('Console exibe alternativas, feedback, explicações e resumo completo',
      () {
    final saidas = <String>[];
    final t = _rodarQuiz(['x', '', 'b', 'c', 'b', 'd', 'a'], saidas)!;
    verificar(t.quantidadeAcertos == 3 && t.pontuacao == 30);
    verificar(
        saidas.where((s) => s.startsWith('Alternativa inválida')).length == 2);
    verificar(
        saidas.where((s) => s.startsWith('Resposta correta')).length == 3);
    verificar(
        saidas.where((s) => s.startsWith('Resposta incorreta')).length == 2);
    verificar(saidas.where((s) => s.startsWith('\nPergunta ')).length == 5);
    final perguntas = selecionarPerguntas(perguntasMock, Categoria.CRIANCA);
    for (final p in perguntas) {
      verificar(saidas.contains(p.enunciado));
      verificar(saidas.contains('Explicação: ${p.explicacao}'));
      for (final a in p.alternativas) {
        verificar(saidas.contains('${a.letra}. ${a.texto}'));
      }
    }
    for (final texto in [
      'Participante: Ana',
      'Categoria: CRIANCA',
      'Perguntas: 5',
      'Acertos: 3',
      'Erros: 2',
      'Aproveitamento: 60.0%',
      'Pontuação final: 30'
    ]) {
      verificar(saidas.contains(texto), 'Resumo ausente: $texto');
    }
    verificar(saidas.any((s) => s.startsWith('Tempo da partida: ')));
  });
  for (var respondidas = 0; respondidas < 5; respondidas++) {
    teste('EOF após $respondidas respostas não registra tentativa', () {
      final saidas = <String>[];
      verificar(_rodarQuiz(List.filled(respondidas, 'A'), saidas) == null);
      verificar(!saidas.any((s) => s.contains('Resultado do quiz')));
      verificar(saidas.last.contains('Nenhuma tentativa incompleta'));
    });
  }
  teste('EOF após resposta inválida encerra a sessão inteira', () {
    final entradas = ['Ana', '1', '2', 'x'];
    final saidas = <String>[];
    var indice = 0;
    var leituras = 0;
    AplicacaoConsole(
            lerLinha: () {
              if (++leituras > entradas.length + 1)
                throw StateError('Loop após EOF');
              return indice < entradas.length ? entradas[indice++] : null;
            },
            escreverLinha: saidas.add)
        .executar();
    verificar(saidas.last == 'Sessão encerrada. Até logo!');
    verificar(saidas.where((s) => s.contains('Menu principal')).length == 1);
    verificar(!saidas.any((s) => s.contains('Resultado do quiz')));
  });
  teste('Duas partidas voltam ao menu e preservam exploração e ranking', () {
    final entradas = [
      'Ana',
      '1',
      '2',
      'b',
      'c',
      'a',
      'd',
      'b',
      '1',
      '5',
      '0',
      '2',
      'a',
      'a',
      'b',
      'a',
      'a',
      '3',
      '4'
    ];
    var indice = 0;
    final saidas = <String>[];
    AplicacaoConsole(
            lerLinha: () {
              if (indice >= entradas.length)
                throw StateError('Leitura inesperada');
              return entradas[indice++];
            },
            escreverLinha: saidas.add)
        .executar();
    verificar(indice == entradas.length);
    verificar(saidas.where((s) => s.contains('Resultado do quiz')).length == 2);
    verificar(saidas.contains('Pontuação final: 50') &&
        saidas.contains('Pontuação final: 0'));
    verificar(
        saidas.any((s) => s.contains('Resumo: ${areasMock.last.resumo}')));
    verificar(saidas.any((s) => s.contains('1. Ana | 50 pontos |')));
    verificar(saidas.last == 'Sessão encerrada. Até logo!');
  });
}

void main() {
  testarQuiz();
  concluir();
}
