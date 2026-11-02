# Átomo+

Plataforma educativa do Challenge CTMSP da FIAP, Sprint 1. Dart puro no console, sem Flutter, API, banco ou dependências externas.

O Átomo+ propõe aproximar o público das aplicações benéficas da tecnologia nuclear em Saúde, Agricultura, Indústria, Pesquisa Científica e Energia por meio de conteúdos educativos e quiz com explicações.

Segundo orientação verbal do professor, relatada pela equipe, esta entrega foi desenvolvida em Dart console. Esse registro documenta a orientação recebida e **não afirma alteração do edital oficial**. A equipe ainda deve conferir os critérios formais e obter confirmação acadêmica quando necessário.

[Repositório GitHub](https://github.com/Mpgouveia-n/Atomo---Mobile-Application-) · [Roteiro de 3–5 minutos](docs/roteiro_demonstracao.md) · [Checklist de entrega](docs/checklist_entrega.md) · [Relatório de homologação](docs/homologacao.md)

## Progresso real

- TASK 01: modelos revisados, 32 testes nativos aprovados.
- Correção necessária: TentativaQuiz agora rejeita tempo zero e negativo, exigindo tempo estritamente positivo.
- TASK 02: cinco áreas, 15 perguntas e 60 alternativas; 25 testes de integridade aprovados.
- TASK 03: identificação da sessão e navegação interativa pelo console, com 23 novos testes aprovados.
- TASK 04: motor do quiz integrado ao console, com cinco perguntas por categoria, feedback educativo e resultado usando TentativaQuiz.
- TASK 05: histórico temporário de tentativas e ranking da categoria integrado ao menu.
- Verificação final: 144 testes aprovados, zero falhas; dart analyze sem problemas; ranking vazio e após quiz verificados pela entrada real do main.
- TASK 06: auditoria técnica, revisão pedagógica documental, homologação e preparação da demonstração concluídas em 01/11/2026. A entrega acadêmica e o aceite do professor continuam pendentes de confirmação externa.

## Escopo funcional da Sprint 1

Identificação temporária, seleção manual de categoria, exploração de cinco áreas, quiz completo com feedback, resultado, histórico em memória e ranking da categoria. Não há funcionalidades de próximas sprints nesta entrega.

## Homologação final

Executada em Windows x64, Dart SDK 3.13.1. Resultado: **144 testes aprovados, zero falhas**, e análise estática sem problemas. Não foram necessárias correções no código ou novos testes: os cenários solicitados já estavam cobertos.

- [Saída integral dos testes](docs/evidencias/testes.txt) e [análise estática](docs/evidencias/analise.txt).
- [Simulação pelo main](docs/evidencias/fluxo_console.txt): nickname e categoria inválidos, exploração das cinco áreas, quiz com resposta inválida, três acertos (30 pontos), nova partida com cinco acertos (50 pontos), ranking atualizado e encerramento.
- [EOF durante o quiz](docs/evidencias/eof_quiz.txt): encerramento sem tentativa incompleta. Os testes também verificam ausência de registro e preservação das tentativas anteriores.
- Melhores resultados e desempate por tempo foram verificados nos testes de histórico; não se apresentam dados de teste como participantes reais.

As simulações usaram entradas programadas no stdin real do aplicativo. Não são vídeo nem comprovação de usabilidade com participantes. O tempo de 1 segundo nesses registros decorre da execução rápida e do arredondamento existente. Veja os comandos e a avaliação pedagógica no [relatório](docs/homologacao.md).

## Execução e testes

Requer Dart SDK 3.x. Na raiz do projeto:

```sh
dart analyze
dart run test/todos_test.dart
dart run bin/main.dart
```

Conjuntos separados:

```sh
dart run test/modelos_test.dart
dart run test/dados_mock_test.dart
dart run test/console_test.dart
dart run test/quiz_test.dart
dart run test/historico_test.dart
```

Os testes usam somente recursos nativos e verificações explícitas, independentes de assert. Falhas produzem mensagem e código de saída 1. Não se usa dart test, pois exigiria um pacote externo.
O main conecta stdin.readLineSync() e stdout à camada de navegação. Para usar a aplicação, execute dart run bin/main.dart em um terminal interativo.

## Navegação no console — TASK 03

1. Informe um nickname de 3 a 20 caracteres. Entradas inválidas permitem nova tentativa usando a validação de Usuario.
2. Selecione manualmente a categoria: 1 para CRIANCA, 2 para JOVEM ou 3 para ADULTO. A aplicação cria o Usuario da sessão com essa escolha.
3. No menu principal, escolha 1 para explorar, 2 para iniciar o quiz, 3 para consultar o ranking da categoria da sessão ou 4 para encerrar.
4. Na exploração, selecione uma área de 1 a 5 para ver resumo e curiosidade. A lista é apresentada novamente para consultar outra área; use 0 para voltar ao menu principal.

Opções inválidas reapresentam o menu correspondente. EOF em qualquer etapa encerra a sessão sem novas leituras ou loops infinitos. Não há login, senha ou cadastro persistente.
A interface reutiliza diretamente as áreas mockadas. Leitura e escrita são funções injetadas no construtor de AplicacaoConsole; os testes simulam o terminal sem alterar os modelos ou depender de pacotes externos.

## Quiz educativo — TASK 04

- A categoria da sessão seleciona cinco perguntas ativas com IDs distintos. A ordem do catálogo é preservada, sem sorteio. Nesta Sprint há exatamente cinco por categoria, uma por área.
- A seleção mantém os objetos originais e suas referências às áreas. A lista selecionada é protegida contra alteração. Um catálogo sem cinco perguntas válidas é rejeitado pelo motor antes do início.
- Cada pergunta mostra sua área, enunciado e alternativas A-D. Letras minúsculas são aceitas e espaços externos são removidos.
- Entrada inválida não avança nem altera contagens. Uma resposta válida encerra a pergunta atual, informa acerto ou erro e apresenta a explicação existente.
- O motor impede novas respostas após conclusão ou cancelamento e só constrói TentativaQuiz depois das cinco respostas válidas.
- A pontuação vem exclusivamente do getter existente de TentativaQuiz. Erros e percentual são derivados das contagens, sem novo modelo de resultado.
- O resumo exibe nickname, categoria, perguntas, acertos, erros, percentual, pontos e duração; depois retorna ao menu principal. É possível iniciar outra partida independente na mesma sessão.
- Stopwatch mede desde a criação da partida, após a seleção, até a quinta resposta válida. Inclui a interação e os intervalos entre perguntas. Os segundos são arredondados para cima, com mínimo de 1, preservando a validação do modelo. O cronômetro pode ser substituído nos testes para verificar limites sem esperas.
- A data representa a conclusão. O ID combina o instante com uma sequência do processo, sem pretensão de unicidade distribuída ou persistência.
- EOF durante a partida cancela o motor e encerra a sessão. Não há tentativa incompleta nem resumo de conclusão. A tentativa concluída é retornada à navegação após a exibição e registrada automaticamente no histórico da TASK 05.

Simulação executada pela entrada real do console: nickname Ana, categoria 1 (CRIANCA), menu 2, entradas x, b, c, b, d, a, menu 4. A entrada x foi rejeitada sem avanço; resultado: cinco perguntas, três acertos, dois erros, 60.0%, 30 pontos e 1 segundo (arredondado), seguido de retorno ao menu e encerramento. Outra simulação com EOF após a primeira resposta de JOVEM encerrou sem tentativa concluída.

## Histórico e ranking — TASK 05

- HistoricoTentativas mantém as referências às tentativas concluídas durante a execução da aplicação. Só aceita tentativas com exatamente cinco perguntas; os demais campos já são validados por TentativaQuiz.
- O contrato de entrada é uma tentativa concluída: o motor só a constrói após cinco respostas válidas. O modelo não armazena respostas individuais; o histórico valida o total, sem criar um segundo modelo ou tentar reconstruir a partida.
- EOF durante o quiz retorna null e não chama o registro. Partidas já concluídas permanecem no histórico, mesmo se ocorrer EOF posteriormente. IDs repetidos são rejeitados para impedir o registro da mesma tentativa duas vezes.
- Todas as partidas válidas com IDs distintos são mantidas, inclusive resultados inferiores do mesmo participante. O ranking é uma consulta derivada e não remove ou reordena o histórico.
- Cada nickname tem uma única posição por categoria, representada por sua melhor tentativa. A identidade temporária usa trim e toLowerCase: Ana, ANA e ana são equivalentes. A grafia original da tentativa vencedora é preservada na apresentação. Não se removem acentos nem se aplica normalização Unicode avançada.
- A ordem é maior pontuação (getter existente), menor tempo em segundos e nickname normalizado em ordem lexicográfica. Não há ordenação linguística específica de português; acentos seguem a comparação nativa de strings.
- Persistindo empate, categoria, data mais antiga e ID em ordem lexicográfica completam o critério determinístico. Isso também define qual tentativa equivalente será exibida, independentemente da ordem de registro.
- tentativas e ranking retornam cópias tipadas e imutáveis. Consultas anteriores não mudam após novos registros.
- ranking(categoria: Categoria.JOVEM), por exemplo, consulta qualquer categoria. ranking() prepara a consulta geral: melhor tentativa por nickname e categoria, mantendo categorias distintas do mesmo nickname. Essa consulta não ganhou opção adicional no menu.
- O console mostra posição, nickname, pontos e tempo somente da categoria da sessão. Na ausência de partidas, informa que ainda não existem partidas concluídas e retorna ao menu.
- Cada instância da aplicação cria seu histórico em memória. É possível injetar o componente para testes ou compartilhamento na mesma execução. O menu mantém uma identificação por execução; não foi adicionada troca de usuário. Nenhum dado é salvo em arquivos, JSON ou banco; ao fechar o processo, os dados são perdidos.

Simulação da TASK 05 pelo main: Ana, CRIANCA, consulta vazia, quiz com cinco acertos e nova consulta. Resultado exibido: posição 1, Ana, 50 pontos e 1 segundo. Depois, encerramento normal.

## Organização

O ponto de entrada liga o terminal à interface. A interface chama o motor do quiz e o histórico; essas camadas reutilizam os modelos de domínio. Modelos não importam código de console. Os dados são objetos em memória, sem tabelas ou simulação de SQL.

Relacionamentos: Usuario possui Categoria; Pergunta referencia AreaAplicacao e contém quatro Alternativa; TentativaQuiz referencia Usuario e Categoria. HistoricoTentativas armazena as próprias TentativaQuiz. A pontuação permanece calculada no modelo, sem valor redundante.

- bin/main.dart: ligação da entrada e saída reais do terminal à aplicação.
- lib/src/console/aplicacao_console.dart: identificação, menus, exploração e encerramento da sessão.
- lib/src/console/quiz_console.dart: interação das perguntas, feedback e apresentação do resultado.
- lib/src/quiz/selecao_perguntas.dart: seleção tipada de cinco perguntas ativas da categoria, sem IDs repetidos.
- lib/src/quiz/motor_quiz.dart: estado da partida, processamento das respostas, cronômetro e construção da tentativa concluída.
- lib/src/historico/historico_tentativas.dart: registro em memória e consultas de ranking por categoria ou geral.
- lib/atomo_mais.dart: exportações públicas de modelos e dados.
- lib/src/models/: cinco modelos, Categoria e validação textual.
- lib/src/data/areas_mock.dart: catálogo tipado e imutável das áreas.
- lib/src/data/perguntas_mock.dart: catálogo tipado e imutável das perguntas.
- test/suporte.dart: executor nativo e verificações compartilhadas.
- test/modelos_test.dart: 32 testes dos modelos.
- test/dados_mock_test.dart: 25 testes de integridade e pontuação.
- test/console_test.dart: 23 testes de nickname, categorias, opções inválidas, exploração, retorno, integração do quiz e ranking e encerramento, incluindo dez cenários de EOF. Os testes dos antigos avisos foram adaptados aos fluxos funcionais.
- test/quiz_test.dart: 38 testes do motor e interação, incluindo resultados com zero, dois e cinco acertos nas três categorias, cancelamento, repetição de partidas, tempo mínimo e EOF.
- test/historico_test.dart: 26 testes de registro, rejeições, múltiplas tentativas, critérios de classificação, identidade temporária, proteção das listas, integração e EOF.
- test/todos_test.dart: execução conjunta dos 144 testes.
- docs/: roteiro acadêmico, checklist, relatório técnico e evidências textuais de execução.

## Decisões dos modelos

- Campos privados e finais, getters e construtores validados, sem setters.
- Nickname obrigatório: 3 a 20 pontos de código Unicode após aparar espaços externos. Não se contam grafemas visuais compostos.
- Enum não anulável: CRIANCA vale 10 pontos, JOVEM 20 e ADULTO 30 por acerto.
- Tipos não anuláveis garantem a presença da área, usuário, categoria e indicador booleano. Não há conversão de strings para categorias ou booleanos.
- Textos obrigatórios aparados e não vazios. Curiosidade opcional no modelo, preenchida em todos os mocks.
- IDs são strings obrigatórias, sem geração automática ou persistência. A unicidade do catálogo é verificada nos testes, sem simular SQL.
- Pergunta mantém referência à AreaAplicacao e exige quatro alternativas A-D, sem letras ou IDs repetidos e com uma única correta.
- A lista de alternativas é copiada e protegida contra alteração externa.
- Tentativa mantém referência a Usuario, categoria igual à sessão, total de perguntas positivo, acertos entre zero e o total e tempo estritamente positivo. A data é fornecida pelo chamador.
- A pontuação é calculada no getter pontuacao, sem atributo independente armazenado.

## Dados mockados

| Categoria | Público de referência | Perguntas |
| --- | --- | --- |
| CRIANCA | 8 a 12 anos | 5 |
| JOVEM | 13 a 17 anos | 5 |
| ADULTO | 18 anos ou mais | 5 |

Cada categoria possui uma pergunta por área: Saúde, Agricultura, Indústria, Pesquisa Científica e Energia. Todas as áreas têm ID, resumo e curiosidade educativa.
As 15 perguntas estão ativas e possuem explicação, quatro alternativas A-D e exatamente uma correta. As posições corretas variam. Os 80 IDs de áreas, perguntas e alternativas são únicos no catálogo.
As perguntas referenciam as mesmas instâncias das áreas. As listas públicas são tipadas e imutáveis; os modelos são preservados.
As faixas etárias orientam o texto, sem adicionar idade ou data de nascimento ao usuário. A sessão cria um usuário com os dados informados; não há usuários ou tentativas mockados na aplicação. Os testes criam casos isolados.

## Referências científicas

Paráfrases educativas, sem consultas à rede pela aplicação:

- Saúde: [National Cancer Institute — radioterapia](https://www.cancer.gov/about-cancer/treatment/types/radiation-therapy).
- Agricultura: [FDA — irradiação de alimentos](https://www.fda.gov/food/buy-store-serve-safe-food/food-irradiation-what-you-need-know) e [Comissão Europeia — Food irradiation](https://food.ec.europa.eu/food-safety/biological-safety/food-irradiation_en).
- Indústria: [ISO — ensaio radiográfico de soldas](https://www.iso.org/obp/ui/?iso:std:iso:17636:-1:ed-2:v1:en) e [IAEA — proteção radiológica ocupacional](https://nucleus.iaea.org/sites/committees/Policy%20Documents/Complete%20Collections%20of%20Safety%20Standards/Complete%20collection%20English/GSG-7%20Occupational%20Radiation%20Protection.pdf).
- Pesquisa: [USGS — Groundwater Age](https://www.usgs.gov/mission-areas/water-resources/science/groundwater-age) e [Eawag — isótopos como traçadores da água](https://www.eawag.ch/en/department/wut/main-focus/environmental-isotopes/3h-3he-water-age/).
- Energia: [Departamento de Energia dos EUA — funcionamento de um reator](https://www.energy.gov/ne/articles/nuclear-101-how-does-nuclear-reactor-work).

## Pendências e validação manual

Não há falhas técnicas conhecidas nos cenários executados. A revisão documental das cinco áreas e 15 perguntas consta no relatório; validação por especialista e avaliação da linguagem com o público-alvo ainda dependem da equipe acadêmica. O aceite acadêmico, vídeo se exigido, prazo, identificação dos integrantes e envio no portal devem ser conferidos no checklist.

Limitações: sem Flutter UI, API, banco, Oracle ou IA; sem cadastro, autenticação ou histórico persistente. Há cinco perguntas fixas por categoria, sem sorteio. O console mantém um nickname por execução; reiniciar apaga os resultados. O ranking geral e de outras categorias existe como consulta do componente, sem menu adicional. O desempate usa segundos arredondados e comparação lexicográfica nativa de nicknames, sem ordenação linguística avançada.

## Evoluções previstas, sujeitas às próximas sprints

Avaliar interface Flutter, ampliação e validação pedagógica do conteúdo, persistência e serviços de backend conforme os requisitos acadêmicos futuros. Integrações de API, banco ou IA precisam de escopo e autorização próprios. Nenhuma dessas evoluções foi implementada nesta homologação.
