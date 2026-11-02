import 'categoria.dart';
import 'validacao.dart';

/// Identificação temporária do usuário durante a sessão.
class Usuario {
  Usuario({required String nickname, required Categoria categoria})
      : _nickname = _validarNickname(nickname),
        _categoria = categoria;

  final String _nickname;
  final Categoria _categoria;

  String get nickname => _nickname;
  Categoria get categoria => _categoria;

  static String _validarNickname(String valor) {
    final nickname = textoObrigatorio(valor, 'nickname');
    final tamanho = nickname.runes.length;
    if (tamanho < 3 || tamanho > 20) {
      throw ArgumentError.value(valor, 'nickname', 'Use de 3 a 20 caracteres.');
    }
    return nickname;
  }
}
