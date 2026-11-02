import '../data/areas_mock.dart';
import '../historico/historico_tentativas.dart';
import '../models/categoria.dart';
import '../models/usuario.dart';
import 'quiz_console.dart';

/// A navegação depende de funções de entrada/saída, sem acoplar domínio a I/O.
class AplicacaoConsole {
  AplicacaoConsole({
    required String? Function() lerLinha,
    required void Function(String) escreverLinha,
    HistoricoTentativas? historico,
  })  : _lerLinha = lerLinha,
        _escreverLinha = escreverLinha,
        _historico = historico ?? HistoricoTentativas();

  final String? Function() _lerLinha;
  final void Function(String) _escreverLinha;
  final HistoricoTentativas _historico;

  void executar() {
    _escreverLinha('Bem-vindo ao Átomo+!');
    final usuario = _identificarUsuario();
    if (usuario != null) {
      _escreverLinha(
          'Olá, ${usuario.nickname}! Categoria: ${usuario.categoria.name}.');
      _navegarMenu(usuario);
    }
    _escreverLinha('Sessão encerrada. Até logo!');
  }

  Usuario? _identificarUsuario() {
    final nickname = _solicitarNickname();
    if (nickname == null) return null;
    final categoria = _solicitarCategoria();
    if (categoria == null) return null;
    return Usuario(nickname: nickname, categoria: categoria);
  }

  String? _solicitarNickname() {
    while (true) {
      _escreverLinha('Digite seu nickname (3 a 20 caracteres):');
      final entrada = _lerLinha();
      if (entrada == null) return null;
      try {
        // Valida pelo domínio antes da seleção. A sessão só é criada depois,
        // com a categoria efetivamente escolhida pelo usuário.
        return Usuario(nickname: entrada, categoria: Categoria.CRIANCA)
            .nickname;
      } on ArgumentError {
        _escreverLinha('Nickname inválido. Use de 3 a 20 caracteres.');
      }
    }
  }

  Categoria? _solicitarCategoria() {
    while (true) {
      _escreverLinha(
          'Selecione sua categoria:\n1. CRIANCA\n2. JOVEM\n3. ADULTO');
      final entrada = _lerLinha()?.trim();
      if (entrada == null) return null;
      switch (entrada) {
        case '1':
          return Categoria.CRIANCA;
        case '2':
          return Categoria.JOVEM;
        case '3':
          return Categoria.ADULTO;
        default:
          _escreverLinha('Categoria inválida. Escolha 1, 2 ou 3.');
      }
    }
  }

  void _navegarMenu(Usuario usuario) {
    while (true) {
      _escreverLinha(
          '\nMenu principal\n1. Explorar áreas de aplicação\n2. Iniciar quiz\n3. Visualizar ranking\n4. Encerrar sessão');
      final entrada = _lerLinha()?.trim();
      if (entrada == null) return;
      switch (entrada) {
        case '1':
          if (!_explorarAreas()) return;
          break;
        case '2':
          final resultado = QuizConsole(
            lerLinha: _lerLinha,
            escreverLinha: _escreverLinha,
          ).executar(usuario);
          if (resultado == null) return;
          _historico.registrar(resultado);
          break;
        case '3':
          _exibirRanking(usuario.categoria);
          break;
        case '4':
          return;
        default:
          _escreverLinha('Opção inválida. Escolha de 1 a 4.');
      }
    }
  }

  void _exibirRanking(Categoria categoria) {
    final ranking = _historico.ranking(categoria: categoria);
    _escreverLinha('\nRanking — ${categoria.name}');
    if (ranking.isEmpty) {
      _escreverLinha('Ainda não existem partidas concluídas nesta categoria.');
      return;
    }
    _escreverLinha('Posição | Nickname | Pontos | Tempo');
    for (var i = 0; i < ranking.length; i++) {
      final tentativa = ranking[i];
      _escreverLinha(
          '${i + 1}. ${tentativa.usuario.nickname} | ${tentativa.pontuacao} pontos | ${tentativa.tempoSegundos} s');
    }
  }

  /// Retorna false em EOF para propagar o encerramento ao menu principal.
  bool _explorarAreas() {
    while (true) {
      _escreverLinha('\nÁreas de aplicação');
      for (var i = 0; i < areasMock.length; i++) {
        _escreverLinha('${i + 1}. ${areasMock[i].nome}');
      }
      _escreverLinha('0. Voltar ao menu principal');
      final entrada = _lerLinha()?.trim();
      if (entrada == null) return false;
      if (entrada == '0') return true;
      final opcao = int.tryParse(entrada);
      if (opcao == null || opcao < 1 || opcao > areasMock.length) {
        _escreverLinha(
            'Área inválida. Escolha de 1 a ${areasMock.length}, ou 0 para voltar.');
        continue;
      }
      final area = areasMock[opcao - 1];
      _escreverLinha('\n${area.nome}\nResumo: ${area.resumo}');
      final curiosidade = area.curiosidade;
      if (curiosidade != null) _escreverLinha('Curiosidade: $curiosidade');
    }
  }
}
