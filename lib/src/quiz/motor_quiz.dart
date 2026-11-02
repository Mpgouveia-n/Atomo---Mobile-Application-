import '../models/pergunta.dart';
import '../models/tentativa_quiz.dart';
import '../models/usuario.dart';
import 'selecao_perguntas.dart';

/// Controla uma partida, sem leitura, escrita ou persistência.
class MotorQuiz {
  MotorQuiz(
      {required Usuario usuario,
      required Iterable<Pergunta> banco,
      Stopwatch? cronometro})
      : _usuario = usuario,
        _perguntas = selecionarPerguntas(banco, usuario.categoria),
        _cronometro = cronometro ?? Stopwatch() {
    _cronometro.reset();
    _cronometro.start();
  }

  static int _sequencia = 0;
  final Usuario _usuario;
  final List<Pergunta> _perguntas;
  final Stopwatch _cronometro;
  int _respondidas = 0;
  int _acertos = 0;
  bool _cancelada = false;
  TentativaQuiz? _resultado;

  List<Pergunta> get perguntas => _perguntas;
  int get quantidadeRespondidas => _respondidas;
  int get quantidadeAcertos => _acertos;
  int get quantidadeErros => _respondidas - _acertos;
  TentativaQuiz? get resultado => _resultado;
  Pergunta? get perguntaAtual =>
      _cancelada || _resultado != null ? null : _perguntas[_respondidas];

  /// null indica entrada inválida e não altera o estado; bool indica o acerto.
  bool? responder(String entrada) {
    final pergunta = perguntaAtual;
    if (pergunta == null) throw StateError('A partida já foi encerrada.');
    final letra = entrada.trim().toUpperCase();
    final alternativas = pergunta.alternativas.where((a) => a.letra == letra);
    if (alternativas.isEmpty) return null;
    final correta = alternativas.single.correta;
    if (correta) _acertos++;
    _respondidas++;
    if (_respondidas == _perguntas.length) _concluir();
    return correta;
  }

  void cancelar() {
    if (_resultado != null) throw StateError('A partida já foi concluída.');
    _cronometro.stop();
    _cancelada = true;
  }

  void _concluir() {
    _cronometro.stop();
    // Arredonda para cima, com mínimo de um segundo para respeitar o modelo.
    final micros = _cronometro.elapsedMicroseconds;
    final segundos = (micros + Duration.microsecondsPerSecond - 1) ~/
        Duration.microsecondsPerSecond;
    final data = DateTime.now();
    _resultado = TentativaQuiz(
      id: 'tentativa-${data.microsecondsSinceEpoch}-${++_sequencia}',
      usuario: _usuario,
      categoria: _usuario.categoria,
      quantidadePerguntas: _perguntas.length,
      quantidadeAcertos: _acertos,
      tempoSegundos: segundos < 1 ? 1 : segundos,
      dataRealizacao: data,
    );
  }
}
