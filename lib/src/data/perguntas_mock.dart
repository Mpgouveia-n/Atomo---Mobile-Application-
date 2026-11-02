import '../models/alternativa.dart';
import '../models/area_aplicacao.dart';
import '../models/categoria.dart';
import '../models/pergunta.dart';
import 'areas_mock.dart';

AreaAplicacao _area(String id) =>
    areasMock.singleWhere((area) => area.id == id);

// Os índices corretos são internos à construção; o domínio mantém o booleano.
Pergunta _pergunta({
  required String id,
  required String area,
  required Categoria categoria,
  required String enunciado,
  required List<String> opcoes,
  required int correta,
  required String explicacao,
}) =>
    Pergunta(
      id: id,
      areaAplicacao: _area(area),
      categoria: categoria,
      enunciado: enunciado,
      explicacao: explicacao,
      ativa: true,
      alternativas: List<Alternativa>.generate(
          opcoes.length,
          (i) => Alternativa(
                id: '$id-${'ABCD'[i]}',
                letra: 'ABCD'[i],
                texto: opcoes[i],
                correta: i == correta,
              )),
    );

/// Quinze perguntas: uma por área em cada categoria, sem execução de quiz.
final List<Pergunta> perguntasMock = List<Pergunta>.unmodifiable([
  _pergunta(
    id: 'crianca-saude',
    area: 'saude',
    categoria: Categoria.CRIANCA,
    enunciado:
        'Como a radiação pode ajudar no cuidado de uma pessoa com câncer?',
    opcoes: [
      'Substituindo todas as vacinas.',
      'Tratando alguns tumores com acompanhamento de especialistas.',
      'Trocando todos os remédios por luz comum.',
      'Curando qualquer doença sem exames.'
    ],
    correta: 1,
    explicacao:
        'A radioterapia usa radiação para tratar alguns tipos de câncer. A equipe de saúde planeja o tratamento e os cuidados para cada pessoa.',
  ),
  _pergunta(
    id: 'crianca-agricultura',
    area: 'agricultura',
    categoria: Categoria.CRIANCA,
    enunciado:
        'Para que alguns alimentos recebem um tratamento chamado irradiação?',
    opcoes: [
      'Para virar uma fonte de eletricidade.',
      'Para nunca mais precisar de higiene.',
      'Para ajudar a reduzir microrganismos e perdas.',
      'Para mudar todos os alimentos para a cor azul.'
    ],
    correta: 2,
    explicacao:
        'A irradiação pode reduzir microrganismos que estragam alimentos. Mesmo assim, é preciso cuidar da limpeza e do armazenamento.',
  ),
  _pergunta(
    id: 'crianca-industria',
    area: 'industria',
    categoria: Categoria.CRIANCA,
    enunciado: 'Como uma radiografia pode ajudar a examinar uma peça de metal?',
    opcoes: [
      'Mostrando possíveis falhas por dentro sem cortar a peça.',
      'Transformando metal em madeira.',
      'Colando qualquer rachadura na hora.',
      'Trocando a peça por uma fotografia de papel.'
    ],
    correta: 0,
    explicacao:
        'A radiografia industrial produz imagens do interior de peças. Profissionais treinados usam proteção e controlam o acesso ao local.',
  ),
  _pergunta(
    id: 'crianca-pesquisa',
    area: 'pesquisa',
    categoria: Categoria.CRIANCA,
    enunciado:
        'Cientistas estudam pequenas diferenças entre os átomos da água. O que isso pode ajudar a descobrir?',
    opcoes: [
      'Qual é a música favorita da água.',
      'Como fazer água aparecer do nada.',
      'Como impedir toda chuva.',
      'De onde a água veio e por onde passou.'
    ],
    correta: 3,
    explicacao:
        'Diferenças entre isótopos funcionam como pistas sobre a água. Elas ajudam cientistas a estudar seu caminho na natureza.',
  ),
  _pergunta(
    id: 'crianca-energia',
    area: 'energia',
    categoria: Categoria.CRIANCA,
    enunciado:
        'Em uma usina nuclear, o calor ajuda a produzir vapor. O que esse vapor faz?',
    opcoes: [
      'Vira uma pilha de carvão.',
      'Movimenta turbinas ligadas a geradores de eletricidade.',
      'Apaga a energia das casas.',
      'Elimina a necessidade de equipamentos.'
    ],
    correta: 1,
    explicacao:
        'O vapor faz girar turbinas ligadas a geradores. Assim, parte da energia do calor é transformada em eletricidade.',
  ),
  _pergunta(
    id: 'jovem-saude',
    area: 'saude',
    categoria: Categoria.JOVEM,
    enunciado:
        'Por que a dose e a região de aplicação são planejadas na radioterapia?',
    opcoes: [
      'Para irradiar o corpo inteiro em todos os casos.',
      'Para dispensar o acompanhamento médico.',
      'Para tratar o tumor e limitar a exposição de tecidos saudáveis.',
      'Para garantir ausência de efeitos adversos.'
    ],
    correta: 2,
    explicacao:
        'O planejamento busca atingir o alvo do tratamento e poupar tecidos saudáveis. Benefícios e possíveis efeitos adversos são avaliados pela equipe de saúde.',
  ),
  _pergunta(
    id: 'jovem-agricultura',
    area: 'agricultura',
    categoria: Categoria.JOVEM,
    enunciado:
        'O que acontece com um alimento irradiado nas condições aprovadas para esse processo?',
    opcoes: [
      'Ele não se torna radioativo e ainda precisa de higiene e conservação.',
      'Ele passa a emitir radiação como um combustível nuclear.',
      'Ele fica protegido de qualquer contaminação futura.',
      'Ele deixa de precisar de embalagem adequada.'
    ],
    correta: 0,
    explicacao:
        'As fontes e energias aprovadas para a irradiação de alimentos não os tornam radioativos. O processo complementa as boas práticas de higiene e conservação.',
  ),
  _pergunta(
    id: 'jovem-industria',
    area: 'industria',
    categoria: Categoria.JOVEM,
    enunciado:
        'Por que a radiografia industrial é chamada de ensaio não destrutivo?',
    opcoes: [
      'Porque dispensa profissionais qualificados.',
      'Porque impede qualquer falha futura.',
      'Porque a radiação não exige controle.',
      'Porque permite inspecionar o interior sem cortar a peça.'
    ],
    correta: 3,
    explicacao:
        'O ensaio pode revelar descontinuidades internas sem destruir a peça examinada. A interpretação da imagem e a proteção radiológica continuam necessárias.',
  ),
  _pergunta(
    id: 'jovem-pesquisa',
    area: 'pesquisa',
    categoria: Categoria.JOVEM,
    enunciado: 'O que diferencia dois isótopos do mesmo elemento químico?',
    opcoes: [
      'O número de prótons, mantendo sempre a mesma massa.',
      'O número de nêutrons, mantendo o mesmo número de prótons.',
      'A obrigatoriedade de ambos serem radioativos.',
      'A presença de células no núcleo.'
    ],
    correta: 1,
    explicacao:
        'Isótopos têm o mesmo número de prótons e diferentes números de nêutrons. Há isótopos estáveis e radioativos, usados em diferentes pesquisas.',
  ),
  _pergunta(
    id: 'jovem-energia',
    area: 'energia',
    categoria: Categoria.JOVEM,
    enunciado:
        'Qual processo libera calor no combustível das usinas nucleares de fissão?',
    opcoes: [
      'A queima de carvão dentro do núcleo.',
      'A fotossíntese do urânio.',
      'A divisão de núcleos atômicos em uma reação controlada.',
      'A transformação de vapor em luz solar.'
    ],
    correta: 2,
    explicacao:
        'A fissão divide núcleos e libera energia. Em uma usina, a reação em cadeia é controlada e o calor é utilizado na geração de eletricidade.',
  ),
  _pergunta(
    id: 'adulto-saude',
    area: 'saude',
    categoria: Categoria.ADULTO,
    enunciado:
        'Qual princípio orienta o planejamento de um tratamento radioterápico?',
    opcoes: [
      'Adequar a dose ao alvo e limitar a exposição dos órgãos saudáveis, avaliando benefícios e riscos.',
      'Aplicar a mesma dose em qualquer tumor e paciente.',
      'Eliminar a necessidade de avaliação clínica após a primeira sessão.',
      'Considerar que toda exposição à radiação é isenta de efeitos adversos.'
    ],
    correta: 0,
    explicacao:
        'O planejamento individualizado considera o alvo, os tecidos próximos e a situação clínica. A radioterapia pode trazer benefícios, mas requer avaliação e acompanhamento dos riscos.',
  ),
  _pergunta(
    id: 'adulto-agricultura',
    area: 'agricultura',
    categoria: Categoria.ADULTO,
    enunciado:
        'Qual é o papel da irradiação em uma cadeia de conservação de alimentos?',
    opcoes: [
      'Substituir toda a fiscalização sanitária.',
      'Restaurar qualquer alimento já deteriorado.',
      'Dispensar o controle das condições de armazenamento.',
      'Complementar boas práticas, reduzindo microrganismos ou pragas conforme o produto e a dose.'
    ],
    correta: 3,
    explicacao:
        'Os efeitos dependem do alimento, da dose e do objetivo do processo. A irradiação é uma ferramenta complementar e não corrige todas as falhas de higiene ou deterioração.',
  ),
  _pergunta(
    id: 'adulto-industria',
    area: 'industria',
    categoria: Categoria.ADULTO,
    enunciado:
        'Ao usar radiografia industrial em uma solda, qual combinação descreve uma prática adequada?',
    opcoes: [
      'Usar a imagem como garantia de ausência de qualquer defeito.',
      'Avaliar descontinuidades internas com pessoal qualificado e controle da exposição.',
      'Manter pessoas próximas à fonte para melhorar a imagem.',
      'Dispensar a interpretação técnica quando houver imagem digital.'
    ],
    correta: 1,
    explicacao:
        'A técnica auxilia a avaliação de soldas dentro dos limites do método. Qualificação, interpretação e medidas de proteção radiológica são essenciais.',
  ),
  _pergunta(
    id: 'adulto-pesquisa',
    area: 'pesquisa',
    categoria: Categoria.ADULTO,
    enunciado:
        'Como a análise isotópica pode contribuir para a gestão de recursos hídricos?',
    opcoes: [
      'Garantindo que toda água subterrânea seja potável.',
      'Substituindo qualquer análise química ou microbiológica.',
      'Fornecendo evidências sobre origem e circulação da água, em conjunto com outros dados.',
      'Determinando a origem de qualquer amostra sem contexto ambiental.'
    ],
    correta: 2,
    explicacao:
        'A composição isotópica oferece pistas sobre processos do ciclo da água. Sua interpretação depende do contexto e complementa outras medições; não comprova potabilidade sozinha.',
  ),
  _pergunta(
    id: 'adulto-energia',
    area: 'energia',
    categoria: Categoria.ADULTO,
    enunciado:
        'Qual sequência representa a conversão de energia em uma usina nuclear de fissão com turbina a vapor?',
    opcoes: [
      'Fissão libera calor; o vapor movimenta a turbina, que aciona o gerador.',
      'Urânio produz corrente elétrica diretamente nos cabos, sem conversão térmica.',
      'O gerador cria urânio, que transforma eletricidade em vapor.',
      'A turbina divide núcleos atômicos usando energia do vento.'
    ],
    correta: 0,
    explicacao:
        'A energia da fissão é convertida em calor e depois em energia mecânica e elétrica. A geração requer controle da reação, resfriamento e gestão dos rejeitos.',
  ),
]);
