import '../lib/atomo_mais.dart';
import 'suporte.dart';

final _area = AreaAplicacao(id: 'area', nome: 'Área', resumo: 'Resumo');

List<Alternativa> _alternativas({int corretas = 1}) => List.generate(
      4,
      (i) => Alternativa(
          id: 'a$i',
          letra: 'ABCD'[i],
          texto: 'Texto $i',
          correta: i < corretas),
    );

Pergunta _pergunta(List<Alternativa> alternativas) => Pergunta(
      id: 'p1',
      areaAplicacao: _area,
      enunciado: 'Enunciado',
      categoria: Categoria.CRIANCA,
      explicacao: 'Explicação',
      ativa: true,
      alternativas: alternativas,
    );

TentativaQuiz _tentativa(
        {Categoria categoria = Categoria.CRIANCA,
        int perguntas = 5,
        int acertos = 2,
        int tempo = 1,
        Categoria? categoriaUsuario}) =>
    TentativaQuiz(
      id: 't1',
      usuario:
          Usuario(nickname: 'Ana', categoria: categoriaUsuario ?? categoria),
      categoria: categoria,
      quantidadePerguntas: perguntas,
      quantidadeAcertos: acertos,
      tempoSegundos: tempo,
      dataRealizacao: DateTime.utc(2026, 10, 31),
    );

void testarModelos() {
  for (final tamanho in [3, 20]) {
    teste('Nickname aceita limite $tamanho', () {
      final nome = 'a' * tamanho;
      verificar(
          Usuario(nickname: nome, categoria: Categoria.JOVEM).nickname == nome);
    });
  }
  for (final nome in ['', '   ', 'ab', 'a' * 21]) {
    teste('Nickname rejeita tamanho ${nome.length} / espaços', () {
      rejeita<ArgumentError>(
          () => Usuario(nickname: nome, categoria: Categoria.ADULTO));
    });
  }
  teste('Nickname remove espaços externos e conta Unicode', () {
    verificar(
        Usuario(nickname: '  Ana  ', categoria: Categoria.CRIANCA).nickname ==
            'Ana');
    verificar(Usuario(nickname: '😀😀😀', categoria: Categoria.CRIANCA)
            .nickname
            .runes
            .length ==
        3);
  });
  teste('Categoria inválida é rejeitada pelo tipo', () {
    dynamic invalida = 'JOVEM';
    rejeita<TypeError>(() => Usuario(nickname: 'Ana', categoria: invalida));
    dynamic nula;
    rejeita<TypeError>(() => Usuario(nickname: 'Ana', categoria: nula));
  });
  for (final categoria in Categoria.values) {
    teste('Valor e pontuação de ${categoria.name}', () {
      final esperado = switch (categoria) {
        Categoria.CRIANCA => 10,
        Categoria.JOVEM => 20,
        Categoria.ADULTO => 30,
      };
      verificar(categoria.pontosPorAcerto == esperado);
      verificar(_tentativa(categoria: categoria, acertos: 3).pontuacao ==
          3 * esperado);
      verificar(_tentativa(categoria: categoria, acertos: 0).pontuacao == 0);
      verificar(_tentativa(categoria: categoria, acertos: 5).pontuacao ==
          5 * esperado);
    });
  }
  teste('Área valida campos obrigatórios e curiosidade opcional', () {
    verificar(_area.curiosidade == null);
    rejeita<ArgumentError>(
        () => AreaAplicacao(id: '', nome: 'Nome', resumo: 'Resumo'));
    rejeita<ArgumentError>(
        () => AreaAplicacao(id: '1', nome: ' ', resumo: 'Resumo'));
    rejeita<ArgumentError>(
        () => AreaAplicacao(id: '1', nome: 'Nome', resumo: ''));
    rejeita<ArgumentError>(() => AreaAplicacao(
        id: '1', nome: 'Nome', resumo: 'Resumo', curiosidade: ' '));
  });
  teste('Alternativa valida ID, texto, letra e indicador booleano', () {
    rejeita<ArgumentError>(
        () => Alternativa(id: '', letra: 'A', texto: 'Texto', correta: true));
    rejeita<ArgumentError>(
        () => Alternativa(id: '1', letra: 'A', texto: ' ', correta: false));
    for (final letra in ['', 'E', 'a', 'AB']) {
      rejeita<ArgumentError>(() =>
          Alternativa(id: '1', letra: letra, texto: 'Texto', correta: false));
    }
    for (final dynamic incorreta in [null, 'true', 1]) {
      rejeita<TypeError>(() =>
          Alternativa(id: '1', letra: 'A', texto: 'Texto', correta: incorreta));
    }
    verificar(_alternativas()[0].correta);
    verificar(!_alternativas()[1].correta);
  });
  teste('Pergunta preserva referência da área e getters', () {
    final p = _pergunta(_alternativas());
    verificar(identical(p.areaAplicacao, _area));
    verificar(p.id == 'p1' &&
        p.enunciado == 'Enunciado' &&
        p.explicacao == 'Explicação' &&
        p.ativa);
    verificar(p.categoria == Categoria.CRIANCA);
  });
  teste('Pergunta rejeita área nula', () {
    dynamic nula;
    rejeita<TypeError>(() => Pergunta(
        id: '1',
        areaAplicacao: nula,
        enunciado: 'E',
        categoria: Categoria.JOVEM,
        explicacao: 'X',
        ativa: true,
        alternativas: _alternativas()));
  });
  for (final tamanho in [0, 3, 5]) {
    teste('Pergunta rejeita $tamanho alternativas', () {
      rejeita<ArgumentError>(() =>
          _pergunta(List.generate(tamanho, (i) => _alternativas()[i % 4])));
    });
  }
  for (final corretas in [0, 2, 4]) {
    teste('Pergunta rejeita $corretas corretas', () {
      rejeita<ArgumentError>(
          () => _pergunta(_alternativas(corretas: corretas)));
    });
  }
  teste('Pergunta rejeita letras repetidas', () {
    final lista = _alternativas();
    lista[3] =
        Alternativa(id: 'a3', letra: 'A', texto: 'Texto', correta: false);
    rejeita<ArgumentError>(() => _pergunta(lista));
  });
  teste('Pergunta rejeita IDs repetidos', () {
    final lista = _alternativas();
    lista[3] =
        Alternativa(id: 'a0', letra: 'D', texto: 'Texto', correta: false);
    rejeita<ArgumentError>(() => _pergunta(lista));
  });
  teste('Pergunta copia lista e protege coleção', () {
    final origem = _alternativas();
    final p = _pergunta(origem);
    origem.clear();
    verificar(p.alternativas.length == 4);
    rejeita<UnsupportedError>(() => p.alternativas.clear());
    rejeita<UnsupportedError>(() => p.alternativas[0] = p.alternativas[1]);
  });
  for (final acertos in [-1, 6]) {
    teste('Tentativa rejeita $acertos acertos',
        () => rejeita<ArgumentError>(() => _tentativa(acertos: acertos)));
  }
  for (final total in [0, -1]) {
    teste('Tentativa rejeita total $total',
        () => rejeita<ArgumentError>(() => _tentativa(perguntas: total)));
  }
  for (final tempo in [-1, 0]) {
    teste('Tentativa rejeita tempo $tempo',
        () => rejeita<ArgumentError>(() => _tentativa(tempo: tempo)));
  }
  teste('Tentativa rejeita categoria diferente da sessão', () {
    rejeita<ArgumentError>(
        () => _tentativa(categoriaUsuario: Categoria.ADULTO));
  });
  teste('Tentativa preserva referência e campos', () {
    final t = _tentativa();
    verificar(t.id == 't1' && t.usuario.nickname == 'Ana');
    verificar(t.categoria == t.usuario.categoria);
    verificar(t.quantidadePerguntas == 5 &&
        t.quantidadeAcertos == 2 &&
        t.tempoSegundos == 1);
    verificar(t.dataRealizacao == DateTime.utc(2026, 10, 31));
  });
}

void main() {
  testarModelos();
  concluir();
}
