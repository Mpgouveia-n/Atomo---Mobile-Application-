# Homologação técnica e revisão documental — Sprint 1

Data: 01/11/2026 (America/Sao_Paulo). Base auditada: `a4a6bd94e79efd95c66d8828773d5b4bb07ecc5b`, branch `main`. Ambiente: Windows x64, Dart 3.13.1; [versão capturada](evidencias/ambiente.txt).

## Resultado técnico

Homologação técnica aprovada para o escopo implementado, com 144 testes aprovados e zero falhas. `dart analyze` não encontrou problemas. Isso não constitui aceite acadêmico ou certificação científica.

Foram inspecionados os modelos, dados, console, motor, histórico, testes, entrada do programa, exportações, manifestos e documentação. Não foram identificadas falhas bloqueantes nem necessidade de alterações de código. Os testes existentes cobrem os cenários da solicitação, sem necessidade de testes redundantes.

| Item auditado | Conclusão |
| --- | --- |
| Responsabilidades | Console separado do domínio; seleção, processamento e histórico em componentes próprios |
| Encapsulamento | Modelos com campos privados/finais, getters e construtores validados; listas protegidas |
| Relacionamentos | Referências aos próprios objetos, sem entidades paralelas ou tabelas simuladas |
| Regras | Validação de nickname reaproveita Usuario; pontuação usa TentativaQuiz e Categoria |
| Duplicação | Não há duplicação de regras que justifique refatoração nesta entrega; o número fixo de cinco perguntas é parte do escopo |
| Entrada/EOF | Repetição de entradas inválidas; EOF propagado sem novas leituras ou partida incompleta |
| Dados | Cinco áreas, 15 perguntas, quatro alternativas por pergunta, uma correta e 80 IDs únicos |
| Resultado | Contagens, pontos e tempo positivo; tentativa somente após quinta resposta válida |
| Histórico/ranking | Retém todas as tentativas válidas e deriva melhor tentativa por nickname/categoria; desempates e imutabilidade testados |

Observações preservadas: a validação inicial do nickname cria um Usuario temporário com categoria infantil, antes da categoria final, para reutilizar o construtor; a sessão efetiva usa a escolha manual. Não houve alteração desse fluxo. O histórico recebe tentativas concluídas por contrato, não armazena respostas individuais e não pode comprovar isoladamente uma partida construída fora do motor. No fluxo real, a construção e o registro são protegidos pelo motor e pela navegação.

## Evidências funcionais

- [Testes completos](evidencias/testes.txt): modelos 32, dados 25, console 23, quiz 38, histórico 26; total 144.
- [Análise](evidencias/analise.txt): nenhum problema.
- [Fluxo pelo main](evidencias/fluxo_console.txt): nickname vazio e curto rejeitados, categoria 0 rejeitada, opção 9 rejeitada, cinco áreas exploradas, retorno, resposta x rejeitada sem avanço, partida com três acertos e 30 pontos, outra com cinco e 50 pontos, melhor resultado no ranking e opção 4.
- [EOF no quiz](evidencias/eof_quiz.txt): JOVEM, uma resposta válida, EOF na segunda pergunta, sem resumo concluído. Os testes conferem que o histórico não recebe essa tentativa.
- Desempate por menor tempo, nickname equivalente e categorias separadas: testes em `test/historico_test.dart`.

As evidências são transcrições do stdout de execuções com entradas programadas no stdin real, sem alteração do aplicativo. Não são gravação de vídeo, pesquisa de usabilidade ou dados de participantes.

Comandos usados, com o executável do SDK instalado neste ambiente (equivalentes aos comandos abaixo quando `dart` está no PATH):

```sh
dart --version
dart analyze
dart run test/todos_test.dart
dart run bin/main.dart
```

Entradas do fluxo completo, uma por linha: vazio, `ab`, `Ana`, `0`, `1`, `9`, `1`, `1`, `2`, `3`, `4`, `5`, `0`, `2`, `x`, `b`, `c`, `b`, `d`, `a`, `3`, `2`, `b`, `c`, `a`, `d`, `b`, `3`, `4`. EOF: `Ana`, `2`, `2`, `c`, seguido do fim da entrada. O tempo foi 1 segundo nas partidas concluídas rápidas, segundo a regra de arredondamento; variará em uso humano.

## Revisão pedagógica das cinco áreas e 15 perguntas

Todas as áreas têm resumo e curiosidade coerentes com seus temas. Cada categoria cobre as cinco áreas uma vez. A tabela registra a alternativa correta (mesma ordem no catálogo) e o parecer documental, sem alterar os textos ou fontes existentes.

| Área | CRIANCA | JOVEM | ADULTO | Parecer |
| --- | --- | --- | --- | --- |
| Saúde | B: tratamento com especialistas | C: alvo e tecidos saudáveis | A: planejamento individualizado | Coerente; não promete cura universal nem ausência de efeitos adversos |
| Agricultura | C: reduzir microrganismos/perdas | A: não torna radioativo nas condições aprovadas | D: complementar boas práticas | Coerente; higiene e conservação continuam necessárias |
| Indústria | A: examinar sem cortar | D: ensaio não destrutivo | B: avaliação com proteção | Coerente; imagens ajudam a detectar falhas, sem garantia absoluta |
| Pesquisa Científica | D: origem/caminho da água | B: diferença de nêutrons | C: evidências em conjunto com outros dados | Coerente em nível introdutório; análise isotópica não comprova potabilidade |
| Energia | B: vapor/turbinas | C: fissão controlada | A: calor/turbina/gerador | Coerente; geração exige controle e proteção |

As perguntas infantis usam exemplos concretos e distratores muito evidentes: adequados a uma introdução demonstrativa, mas insuficientes para medir domínio aprofundado. JOVEM introduz termos como isótopos e ensaio não destrutivo; ADULTO aborda limites dos métodos e avaliação de riscos. Há uma resposta pretendida inequívoca em cada pergunta; as explicações sustentam a escolha e evitam afirmações absolutas de segurança.

O resumo de Pesquisa e a pergunta infantil usam uma simplificação (“pistas” dos átomos) que deve ser mediada pelo educador. O termo “descontinuidades” nas explicações de indústria pode exigir apoio. Não há evidência de teste de leitura com crianças ou adolescentes; adequação etária é um parecer documental, não validação com público-alvo.

## Conferência das referências existentes

Consultadas em 01/11/2026. Não se acrescentaram fontes científicas ao catálogo.

- [NCI — radioterapia](https://www.cancer.gov/about-cancer/treatment/types/radiation-therapy): tratamento e planejamento em função do tumor e tecidos próximos; leitura direta realizada.
- [FDA — irradiação](https://www.fda.gov/food/buy-store-serve-safe-food/food-irradiation-what-you-need-know): redução de microrganismos e ausência de radioatividade induzida nas condições aprovadas; leitura direta realizada.
- [Comissão Europeia](https://food.ec.europa.eu/food-safety/biological-safety/food-irradiation_en): uso complementar, sem substituir higiene; leitura direta realizada.
- [IAEA GSG-7](https://nucleus.iaea.org/sites/committees/Policy%20Documents/Complete%20Collections%20of%20Safety%20Standards/Complete%20collection%20English/GSG-7%20Occupational%20Radiation%20Protection.pdf): seção 6.45 descreve inspeção radiográfica de componentes e precauções; texto consultado. Não se afirma atendimento a todos os requisitos dessa publicação pela aplicação educativa.
- [DOE — reator nuclear](https://www.energy.gov/ne/articles/nuclear-101-how-does-nuclear-reactor-work): cadeia fissão/calor/vapor/turbina; leitura direta realizada.
- [USGS — Groundwater Age](https://www.usgs.gov/mission-areas/water-resources/science/groundwater-age) e [Eawag — 3H-3He](https://www.eawag.ch/en/department/wut/main-focus/environmental-isotopes/3h-3he-water-age/): consulta direta indisponível por timeout e bloqueio 403, respectivamente. Trechos indexados das mesmas páginas confirmaram o uso de traçadores isotópicos em águas, mas não substituem revisão integral. Conferência integral e validação especializada da redação sobre origem/circulação permanecem pendentes.
- [ISO 17636-1](https://www.iso.org/obp/ui/?iso:std:iso:17636:-1:ed-2:v1:en): visualizador direto indisponível; a identificação da norma foi confirmada no índice oficial ISO. Não foi realizada leitura integral da norma.

Não foi identificada inconsistência científica bloqueante no nível introdutório. A aprovação pedagógica formal e a conferência especializada dos conteúdos, sobretudo hidrologia isotópica e terminologia técnica, continuam pendentes. Este material não orienta procedimentos médicos, industriais ou operação de instalações.

## Entrega e limites

Orientação verbal sobre uso do console foi informada pela equipe. Não há edital nem comprovação de alteração oficial nesta auditoria. Conferir formalmente os critérios de avaliação, integrantes, prazo, vídeo se exigido e envio/recebimento no portal.

Alterações desta tarefa limitam-se ao README e à documentação de entrega/evidências. Não foram implementados recursos futuros. A publicação final deve usar commit na main sem force push, após nova validação; o hash definitivo é consultável em `git log -1 --oneline` e no histórico do GitHub.
