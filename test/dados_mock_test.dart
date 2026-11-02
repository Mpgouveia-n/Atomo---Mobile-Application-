import '../lib/atomo_mais.dart';
import 'suporte.dart';

void testarDadosMock() {
  teste('Catálogo contém as cinco áreas previstas e conteúdo educativo', () {
    verificar(areasMock.length == 5);
    verificar(areasMock.map((a) => a.nome).toSet().containsAll([
      'Saúde',
      'Agricultura',
      'Indústria',
      'Pesquisa Científica',
      'Energia',
    ]));
    for (final area in areasMock) {
      verificar(
          area.resumo.isNotEmpty && (area.curiosidade?.isNotEmpty ?? false));
    }
  });
  teste(
      'Banco contém 15 perguntas', () => verificar(perguntasMock.length == 15));
  for (final categoria in Categoria.values) {
    teste('Cinco perguntas e uma por área em ${categoria.name}', () {
      final perguntas =
          perguntasMock.where((p) => p.categoria == categoria).toList();
      verificar(perguntas.length == 5);
      for (final area in areasMock) {
        verificar(
            perguntas.where((p) => identical(p.areaAplicacao, area)).length ==
                1);
      }
    });
  }
  for (final pergunta in perguntasMock) {
    teste('Integridade da pergunta ${pergunta.id}', () {
      verificar(pergunta.alternativas.length == 4);
      verificar(pergunta.alternativas.map((a) => a.letra).join() == 'ABCD');
      verificar(pergunta.alternativas.where((a) => a.correta).length == 1);
      verificar(
          areasMock.any((area) => identical(area, pergunta.areaAplicacao)));
      verificar(pergunta.ativa &&
          pergunta.enunciado.isNotEmpty &&
          pergunta.explicacao.isNotEmpty);
      verificar(pergunta.alternativas
          .every((a) => a.texto.isNotEmpty && a.id.isNotEmpty));
    });
  }
  teste('IDs de áreas, perguntas e alternativas não se repetem', () {
    final ids = [
      ...areasMock.map((a) => a.id),
      ...perguntasMock.map((p) => p.id),
      ...perguntasMock.expand((p) => p.alternativas).map((a) => a.id),
    ];
    verificar(ids.length == 80);
    verificar(ids.toSet().length == ids.length);
  });
  teste('Catálogos e alternativas dos mocks não permitem alteração externa',
      () {
    rejeita<UnsupportedError>(() => areasMock.clear());
    rejeita<UnsupportedError>(() => areasMock[0] = areasMock[1]);
    rejeita<UnsupportedError>(() => perguntasMock.clear());
    rejeita<UnsupportedError>(() => perguntasMock[0] = perguntasMock[1]);
    for (final p in perguntasMock) {
      rejeita<UnsupportedError>(() => p.alternativas.clear());
    }
  });
  for (final categoria in Categoria.values) {
    teste('Pontuação de uma tentativa com dados de ${categoria.name}', () {
      final total = perguntasMock.where((p) => p.categoria == categoria).length;
      final tentativa = TentativaQuiz(
        id: 'teste-${categoria.name}',
        usuario: Usuario(nickname: 'Teste', categoria: categoria),
        categoria: categoria,
        quantidadePerguntas: total,
        quantidadeAcertos: total,
        tempoSegundos: 60,
        dataRealizacao: DateTime.utc(2026, 10, 31),
      );
      final esperado = switch (categoria) {
        Categoria.CRIANCA => 50,
        Categoria.JOVEM => 100,
        Categoria.ADULTO => 150,
      };
      verificar(tentativa.pontuacao == esperado);
    });
  }
}

void main() {
  testarDadosMock();
  concluir();
}
