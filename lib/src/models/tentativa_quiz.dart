import 'categoria.dart';
import 'usuario.dart';
import 'validacao.dart';

class TentativaQuiz {
  TentativaQuiz({
    required String id,
    required Usuario usuario,
    required Categoria categoria,
    required int quantidadePerguntas,
    required int quantidadeAcertos,
    required int tempoSegundos,
    required DateTime dataRealizacao,
  })  : _id = textoObrigatorio(id, 'id'),
        _usuario = usuario,
        _categoria = categoria,
        _quantidadePerguntas = quantidadePerguntas,
        _quantidadeAcertos = quantidadeAcertos,
        _tempoSegundos = tempoSegundos,
        _dataRealizacao = dataRealizacao {
    if (categoria != usuario.categoria) {
      throw ArgumentError('A categoria deve corresponder à sessão do usuário.');
    }
    if (quantidadePerguntas <= 0) {
      throw ArgumentError.value(
        quantidadePerguntas,
        'quantidadePerguntas',
        'Deve ser maior que zero.',
      );
    }
    if (quantidadeAcertos < 0 || quantidadeAcertos > quantidadePerguntas) {
      throw ArgumentError.value(
        quantidadeAcertos,
        'quantidadeAcertos',
        'Deve estar entre zero e a quantidade de perguntas.',
      );
    }
    if (tempoSegundos <= 0) {
      throw ArgumentError.value(
        tempoSegundos,
        'tempoSegundos',
        'Deve ser maior que zero.',
      );
    }
  }

  final String _id;
  final Usuario _usuario;
  final Categoria _categoria;
  final int _quantidadePerguntas;
  final int _quantidadeAcertos;
  final int _tempoSegundos;
  final DateTime _dataRealizacao;

  String get id => _id;
  Usuario get usuario => _usuario;
  Categoria get categoria => _categoria;
  int get quantidadePerguntas => _quantidadePerguntas;
  int get quantidadeAcertos => _quantidadeAcertos;
  int get tempoSegundos => _tempoSegundos;
  DateTime get dataRealizacao => _dataRealizacao;
  int get pontuacao => quantidadeAcertos * categoria.pontosPorAcerto;
}
