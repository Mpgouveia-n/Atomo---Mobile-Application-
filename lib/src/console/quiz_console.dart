import '../data/perguntas_mock.dart';
import '../models/pergunta.dart';
import '../models/tentativa_quiz.dart';
import '../models/usuario.dart';
import '../quiz/motor_quiz.dart';

class QuizConsole {
  QuizConsole({
    required String? Function() lerLinha,
    required void Function(String) escreverLinha,
  })  : _lerLinha = lerLinha,
        _escreverLinha = escreverLinha;

  final String? Function() _lerLinha;
  final void Function(String) _escreverLinha;

  /// EOF retorna null, sem construir tentativa para uma partida incompleta.
  TentativaQuiz? executar(Usuario usuario) {
    final motor = MotorQuiz(usuario: usuario, banco: perguntasMock);
    while (motor.perguntaAtual != null) {
      final pergunta = motor.perguntaAtual!;
      _exibirPergunta(pergunta, motor.quantidadeRespondidas + 1);
      bool? correta;
      do {
        _escreverLinha('Escolha uma alternativa (A, B, C ou D):');
        final entrada = _lerLinha();
        if (entrada == null) {
          motor.cancelar();
          _escreverLinha(
              'Quiz interrompido. Nenhuma tentativa incompleta foi registrada.');
          return null;
        }
        correta = motor.responder(entrada);
        if (correta == null) {
          _escreverLinha('Alternativa inválida. Digite A, B, C ou D.');
        }
      } while (correta == null);
      _escreverLinha(correta ? 'Resposta correta!' : 'Resposta incorreta.');
      _escreverLinha('Explicação: ${pergunta.explicacao}');
    }
    final resultado = motor.resultado!;
    _exibirResultado(resultado);
    return resultado;
  }

  void _exibirPergunta(Pergunta pergunta, int numero) {
    _escreverLinha('\nPergunta $numero/5 — ${pergunta.areaAplicacao.nome}');
    _escreverLinha(pergunta.enunciado);
    for (final alternativa in pergunta.alternativas) {
      _escreverLinha('${alternativa.letra}. ${alternativa.texto}');
    }
  }

  void _exibirResultado(TentativaQuiz tentativa) {
    final erros = tentativa.quantidadePerguntas - tentativa.quantidadeAcertos;
    final percentual =
        tentativa.quantidadeAcertos / tentativa.quantidadePerguntas * 100;
    _escreverLinha('\nResultado do quiz');
    _escreverLinha('Participante: ${tentativa.usuario.nickname}');
    _escreverLinha('Categoria: ${tentativa.categoria.name}');
    _escreverLinha('Perguntas: ${tentativa.quantidadePerguntas}');
    _escreverLinha('Acertos: ${tentativa.quantidadeAcertos}');
    _escreverLinha('Erros: $erros');
    _escreverLinha('Aproveitamento: ${percentual.toStringAsFixed(1)}%');
    _escreverLinha('Pontuação final: ${tentativa.pontuacao}');
    _escreverLinha(
        'Tempo da partida: ${tentativa.tempoSegundos} s (arredondado para cima, mínimo 1 s).');
  }
}
