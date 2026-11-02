import '../models/area_aplicacao.dart';

/// Catálogo educativo em memória; as referências são compartilhadas pelas perguntas.
final List<AreaAplicacao> areasMock = List<AreaAplicacao>.unmodifiable([
  AreaAplicacao(
    id: 'saude',
    nome: 'Saúde',
    resumo:
        'Radiações e radioisótopos podem auxiliar diagnósticos e tratamentos, com indicação e controle profissional.',
    curiosidade:
        'Na radioterapia, a dose é planejada para tratar o tumor e limitar a exposição dos tecidos saudáveis.',
  ),
  AreaAplicacao(
    id: 'agricultura',
    nome: 'Agricultura',
    resumo:
        'Técnicas nucleares e isotópicas ajudam a estudar o uso da água e a reduzir perdas de alimentos.',
    curiosidade:
        'A irradiação de alimentos em condições aprovadas não os torna radioativos e não substitui a higiene.',
  ),
  AreaAplicacao(
    id: 'industria',
    nome: 'Indústria',
    resumo:
        'A radiografia industrial permite examinar o interior de peças sem precisar cortá-las.',
    curiosidade:
        'Imagens de soldas podem revelar falhas internas; o trabalho exige controle da exposição à radiação.',
  ),
  AreaAplicacao(
    id: 'pesquisa',
    nome: 'Pesquisa Científica',
    resumo:
        'Isótopos ajudam pesquisadores a investigar a origem e o deslocamento da água no ambiente.',
    curiosidade:
        'Isótopos são átomos do mesmo elemento com diferentes números de nêutrons; alguns são estáveis.',
  ),
  AreaAplicacao(
    id: 'energia',
    nome: 'Energia',
    resumo:
        'Usinas nucleares de fissão utilizam calor liberado na divisão de núcleos atômicos para gerar eletricidade.',
    curiosidade:
        'Em usinas nucleares, o vapor movimenta turbinas ligadas a geradores; a operação exige sistemas de controle e proteção.',
  ),
]);
