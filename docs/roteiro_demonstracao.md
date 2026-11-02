# Roteiro de demonstração — Átomo+

Duração prevista: 4min30s, com margem entre 3 e 5 minutos. Ensaiar antes da gravação. Executar na raiz: `dart run bin/main.dart`. Deixar a janela legível e evitar leitura integral de todas as alternativas.

## 0:00–0:30 — Problema e proposta

“O Átomo+ é uma proposta educativa do Challenge CTMSP/FIAP para apresentar aplicações benéficas da tecnologia nuclear. Organizamos conteúdos em cinco áreas e usamos um quiz com explicações para apoiar a aprendizagem. A Sprint 1 valida as regras em Dart puro no console, seguindo a orientação verbal recebida do professor.”

Não dizer que o edital foi alterado ou que houve aceite formal da entrega.

## 0:30–1:00 — Arquitetura

Mostrar brevemente as pastas `lib/src/models`, `data`, `console`, `quiz` e `historico`.

“Os modelos encapsulam os dados e validam as regras. O console cuida da interação, o motor controla cinco perguntas e o histórico deriva o ranking. Perguntas referenciam as áreas, e tentativas referenciam o usuário. A pontuação é calculada, não armazenada separadamente. Temos 144 testes nativos aprovados e análise estática sem problemas.”

## 1:00–1:25 — Identificação

Informar `Ana`, depois categoria `1` (CRIANCA). Explicar que é uma sessão temporária, sem login, senha ou data de nascimento. Usamos a categoria infantil para uma demonstração breve; JOVEM e ADULTO possuem perguntas próprias.

## 1:25–1:55 — Exploração

No menu, escolher `1`, depois `1` (Saúde). Mostrar resumo e curiosidade; destacar planejamento profissional e controle da exposição. Escolher `0` para retornar.

“São as mesmas áreas usadas nas perguntas, sem duplicação de dados.”

## 1:55–3:25 — Quiz completo

Escolher `2`. Na primeira pergunta digitar `x`, mostrar a mensagem de erro e depois `b`. A entrada inválida não avança. Responder às demais conforme a tabela:

| Pergunta infantil, na ordem atual | Entrada | Resultado |
| --- | --- | --- |
| Saúde | `x`, depois `b` | Inválida, depois correta |
| Agricultura | `c` | Correta |
| Indústria | `b` | Incorreta; correta é A |
| Pesquisa Científica | `d` | Correta |
| Energia | `a` | Incorreta; correta é B |

“A aplicação aceita maiúsculas e minúsculas, mostra uma pergunta por vez e apresenta a explicação após cada resposta. Os erros foram intencionais para demonstrar o feedback.”

Pausar em uma explicação para mostrar a finalidade educativa, sem ler todas integralmente.

## 3:25–3:50 — Resultado e ranking

Conferir: Ana, CRIANCA, cinco perguntas, três acertos, dois erros, 60.0% e 30 pontos. O tempo varia na demonstração ao vivo; não prometer 1 segundo. O cronômetro inclui a interação e registra segundos arredondados para cima, com mínimo de 1.

Escolher `3`: Ana aparece na posição 1 com 30 pontos. Explicar que todas as tentativas concluídas ficam em memória, mas só a melhor por nickname e categoria aparece no ranking. Empate: menor tempo, depois nickname. O menu atual tem um usuário por execução; testes verificam múltiplos participantes e os desempates.

## 3:50–4:30 — Limitações e encerramento

“Esta Sprint não possui interface Flutter, API, banco de dados ou IA. Os dados são fixos, e o histórico desaparece ao fechar o programa. EOF também encerra com segurança e não registra partidas incompletas. Nas próximas sprints, as evoluções dependem dos requisitos acadêmicos e da validação pedagógica.”

Escolher `4`. Mostrar a mensagem de encerramento e indicar o README, os testes e o repositório como materiais de apoio.

## Sequência de apoio para ensaio

Uma entrada por linha: `Ana`, `1`, `1`, `1`, `0`, `2`, `x`, `b`, `c`, `b`, `d`, `a`, `3`, `4`.

Antes da apresentação, executar `dart analyze` e `dart run test/todos_test.dart`. Se o vídeo for exigido, conferir formato, duração, integrantes, permissões do link e regras no enunciado oficial. Este roteiro não comprova gravação ou envio.
