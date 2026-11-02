import 'validacao.dart';

class AreaAplicacao {
  AreaAplicacao({
    required String id,
    required String nome,
    required String resumo,
    String? curiosidade,
  })  : _id = textoObrigatorio(id, 'id'),
        _nome = textoObrigatorio(nome, 'nome'),
        _resumo = textoObrigatorio(resumo, 'resumo'),
        _curiosidade = curiosidade == null
            ? null
            : textoObrigatorio(curiosidade, 'curiosidade');

  final String _id;
  final String _nome;
  final String _resumo;
  final String? _curiosidade;

  String get id => _id;
  String get nome => _nome;
  String get resumo => _resumo;
  String? get curiosidade => _curiosidade;
}
