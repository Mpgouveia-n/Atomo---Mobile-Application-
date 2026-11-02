import '../models/categoria.dart';
import '../models/pergunta.dart';

/// Mantém as referências e a ordem do catálogo, sem repetir IDs.
List<Pergunta> selecionarPerguntas(
  Iterable<Pergunta> banco,
  Categoria categoria,
) {
  final ids = <String>{};
  final selecionadas = <Pergunta>[];
  for (final pergunta in banco) {
    if (pergunta.ativa &&
        pergunta.categoria == categoria &&
        ids.add(pergunta.id)) {
      selecionadas.add(pergunta);
      if (selecionadas.length == 5) break;
    }
  }
  if (selecionadas.length != 5) {
    throw StateError(
        'São necessárias cinco perguntas ativas e distintas para a categoria.');
  }
  return List<Pergunta>.unmodifiable(selecionadas);
}
