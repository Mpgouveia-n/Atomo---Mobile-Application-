import 'validacao.dart';

class Alternativa {
  Alternativa({
    required String id,
    required String letra,
    required String texto,
    required bool correta,
  })  : _id = textoObrigatorio(id, 'id'),
        _letra = _validarLetra(letra),
        _texto = textoObrigatorio(texto, 'texto'),
        _correta = correta;

  final String _id;
  final String _letra;
  final String _texto;
  final bool _correta;

  String get id => _id;
  String get letra => _letra;
  String get texto => _texto;
  bool get correta => _correta;

  static String _validarLetra(String letra) {
    if (!const ['A', 'B', 'C', 'D'].contains(letra)) {
      throw ArgumentError.value(letra, 'letra', 'Use A, B, C ou D.');
    }
    return letra;
  }
}
