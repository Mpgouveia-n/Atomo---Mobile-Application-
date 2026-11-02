import 'alternativa.dart';
import 'area_aplicacao.dart';
import 'categoria.dart';
import 'validacao.dart';

class Pergunta {
  Pergunta({
    required String id,
    required AreaAplicacao areaAplicacao,
    required String enunciado,
    required Categoria categoria,
    required String explicacao,
    required bool ativa,
    required List<Alternativa> alternativas,
  })  : _id = textoObrigatorio(id, 'id'),
        _areaAplicacao = areaAplicacao,
        _enunciado = textoObrigatorio(enunciado, 'enunciado'),
        _categoria = categoria,
        _explicacao = textoObrigatorio(explicacao, 'explicacao'),
        _ativa = ativa,
        _alternativas = _validarAlternativas(alternativas);

  final String _id;
  final AreaAplicacao _areaAplicacao;
  final String _enunciado;
  final Categoria _categoria;
  final String _explicacao;
  final bool _ativa;
  final List<Alternativa> _alternativas;

  String get id => _id;
  AreaAplicacao get areaAplicacao => _areaAplicacao;
  String get enunciado => _enunciado;
  Categoria get categoria => _categoria;
  String get explicacao => _explicacao;
  bool get ativa => _ativa;
  List<Alternativa> get alternativas => _alternativas;

  static List<Alternativa> _validarAlternativas(List<Alternativa> valores) {
    if (valores.length != 4 ||
        valores.where((alternativa) => alternativa.correta).length != 1 ||
        valores.map((alternativa) => alternativa.letra).toSet().length != 4 ||
        valores.map((alternativa) => alternativa.id).toSet().length != 4) {
      throw ArgumentError(
        'A pergunta deve ter quatro alternativas com IDs distintos, '
        'letras A a D sem repetição e exatamente uma correta.',
      );
    }
    return List<Alternativa>.unmodifiable(valores);
  }
}
