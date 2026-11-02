import '../models/categoria.dart';
import '../models/tentativa_quiz.dart';

/// Histórico temporário e consultas derivadas, sem persistência.
class HistoricoTentativas {
  final List<TentativaQuiz> _tentativas = [];

  List<TentativaQuiz> get tentativas => List.unmodifiable(_tentativas);

  void registrar(TentativaQuiz tentativa) {
    if (tentativa.quantidadePerguntas != 5) {
      throw ArgumentError(
          'Somente tentativas concluídas de cinco perguntas podem ser registradas.');
    }
    if (_tentativas.any((existente) => existente.id == tentativa.id)) {
      throw ArgumentError('Esta tentativa já foi registrada.');
    }
    _tentativas.add(tentativa);
  }

  /// Sem categoria, retorna a melhor tentativa de cada nickname por categoria.
  /// A consulta geral fica disponível para uso futuro, sem novo menu.
  List<TentativaQuiz> ranking({Categoria? categoria}) {
    final melhores = <(Categoria, String), TentativaQuiz>{};
    for (final tentativa in _tentativas) {
      if (categoria != null && tentativa.categoria != categoria) continue;
      final chave = (tentativa.categoria, _nickname(tentativa));
      final anterior = melhores[chave];
      if (anterior == null || _comparar(tentativa, anterior) < 0) {
        melhores[chave] = tentativa;
      }
    }
    final classificadas = melhores.values.toList()..sort(_comparar);
    return List.unmodifiable(classificadas);
  }

  static String _nickname(TentativaQuiz tentativa) =>
      tentativa.usuario.nickname.trim().toLowerCase();

  static int _comparar(TentativaQuiz a, TentativaQuiz b) {
    var ordem = b.pontuacao.compareTo(a.pontuacao);
    if (ordem != 0) return ordem;
    ordem = a.tempoSegundos.compareTo(b.tempoSegundos);
    if (ordem != 0) return ordem;
    ordem = _nickname(a).compareTo(_nickname(b));
    if (ordem != 0) return ordem;
    ordem = a.categoria.index.compareTo(b.categoria.index);
    if (ordem != 0) return ordem;
    ordem = a.dataRealizacao.compareTo(b.dataRealizacao);
    return ordem != 0 ? ordem : a.id.compareTo(b.id);
  }
}
