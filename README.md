
# Átomo+ — Challenge CTMSP 2026 | Sprint 1

**Disciplina:** Mobile Application Development  
**Instituição:** FIAP — Análise e Desenvolvimento de Sistemas  
**Empresa parceira:** Marinha do Brasil — CTMSP  
**Tecnologia:** Dart 3.x (Console)

## Integrantes

| Integrante | RM |
|---|---|
| Gustavo de Jesus | RM567926 |
| Gustavo Siciliano | RM568419 |
| Samuel Keniti | RM567614 |
| Manuel Pedro | RM567458 |
| Vinicius Morrone | RM566884 |

## Sobre o projeto

O **Átomo+** é uma plataforma educativa desenvolvida para o Challenge CTMSP 2026, em parceria com a Marinha do Brasil.

Seu objetivo é aproximar a sociedade da tecnologia nuclear, demonstrando suas aplicações e benefícios em cinco áreas:

- Saúde
- Agricultura
- Indústria
- Pesquisa científica
- Energia

A proposta busca combater a desinformação sobre a tecnologia nuclear utilizando conteúdos educativos e atividades interativas.

Nesta primeira Sprint, foi desenvolvida uma prova de conceito utilizando **Dart em console**, conforme orientação do professor responsável pela turma.

A versão atual demonstra a experiência educativa por meio de menus interativos, conteúdos informativos, quiz e ranking.

## Público-alvo

A aplicação contempla três categorias:

| Categoria | Faixa etária | Pontos por acerto |
|---|---|---|
| CRIANCA | 8 a 12 anos | 10 |
| JOVEM | 13 a 17 anos | 20 |
| ADULTO | 18 anos ou mais | 30 |

Cada categoria possui perguntas adaptadas ao público correspondente.

## Funcionalidades implementadas

### 1. Identificação do usuário

- Entrada de nickname.
- Validação de 3 a 20 caracteres.
- Seleção da categoria do participante.
- Tratamento de entradas inválidas.

### 2. Exploração educativa

O usuário pode explorar as cinco áreas da tecnologia nuclear.

Cada área apresenta:
- Nome e descrição.
- Informações educativas.
- Curiosidades relacionadas ao tema.

### 3. Quiz interativo

- 15 perguntas cadastradas.
- 5 perguntas para cada categoria.
- 4 alternativas por pergunta.
- Apenas uma alternativa correta.
- Validação das respostas.
- Explicação educativa após cada pergunta.

### 4. Sistema de pontuação

A pontuação varia conforme a categoria:

- CRIANCA: 10 pontos por acerto.
- JOVEM: 20 pontos por acerto.
- ADULTO: 30 pontos por acerto.

Ao finalizar o quiz, são apresentados:
- Quantidade de acertos.
- Quantidade de erros.
- Percentual de aproveitamento.
- Tempo de realização.
- Pontuação total.

### 5. Histórico e ranking

- Registro das tentativas concluídas.
- Classificação por categoria.
- Armazenamento da melhor pontuação de cada participante.
- Critério de desempate considerando o tempo.

**Observação:** os dados do histórico e do ranking são mantidos em memória durante a execução do programa, sem persistência em banco de dados.

## Tecnologias utilizadas

- Dart 3.x
- Programação Orientada a Objetos
- Estruturas de dados e coleções
- Validação de entradas
- Tratamento de erros
- Testes automatizados com Dart

## Estrutura do projeto

```text
bin/
  main.dart

lib/
  atomo_mais.dart
  src/
    console/
    data/
    historico/
    models/
    quiz/

test/
  console_test.dart
  dados_mock_test.dart
  historico_test.dart
  modelos_test.dart
  quiz_test.dart
  suporte.dart
  todos_test.dart

docs/
  evidencias/
  homologacao.md
  roteiro_demonstracao.md

pubspec.yaml
pubspec.lock
.gitignore
README.md
```

## Como executar

### Pré-requisitos

Ter o Dart SDK 3.x instalado e configurado no computador.

Documentação oficial:
https://dart.dev/get-dart

### Executar a aplicação

No terminal, acesse a pasta raiz do projeto e execute:

```bash
dart run bin/main.dart
```

### Utilização

1. Informe um nickname válido.
2. Escolha sua categoria.
3. Navegue pelo menu principal.
4. Explore as áreas educativas.
5. Realize o quiz.
6. Consulte seus resultados e o ranking.

O menu principal disponibiliza as opções:

- 1 — Explorar áreas.
- 2 — Iniciar quiz.
- 3 — Ranking.
- 4 — Encerrar.

## Testes e qualidade

O projeto possui testes automatizados para verificar o comportamento das funcionalidades.

Para executar a análise estática:

```bash
dart analyze
```

Para executar os testes:

```bash
dart run test/todos_test.dart
```

Na verificação registrada em 01/11/2026, foram documentados:

- 144 testes aprovados.
- Nenhuma ocorrência reportada pela análise estática.

Esses resultados estão registrados nos arquivos de evidência do projeto e devem ser confirmados novamente antes da entrega.

## Documentação complementar

- [Roteiro de demonstração](docs/roteiro_demonstracao.md)
- [Homologação técnica](docs/homologacao.md)
- [Evidências dos testes](docs/evidencias/testes.txt)
- [Evidências da análise estática](docs/evidencias/analise.txt)
- [Evidências de execução do console](docs/evidencias/fluxo_console.txt)

## Escopo da Sprint 1

Esta entrega apresenta a experiência educativa inicial do Átomo+ utilizando Dart em console.

Estão contemplados:
- Conteúdos educativos.
- Perfis por faixa etária.
- Quiz interativo.
- Pontuação.
- Histórico e ranking em memória.

Para etapas futuras, a proposta geral contempla:
- Interface gráfica para site e aplicativo.
- Assistente de inteligência artificial.
- Integração com APIs.
- Integração com banco de dados.
- Persistência dos resultados.

Essas funcionalidades futuras não são apresentadas como implementadas nesta Sprint.

## Vídeo demonstrativo

O vídeo de apresentação deverá demonstrar a execução real do projeto, incluindo:

**Vídeo da Sprint 1:**
[Assistir à demonstração do Átomo+ no YouTube](https://www.youtube.com/watch?v=pjzzZ6KsuLo)

- Inicialização do programa.
- Identificação do participante.
- Seleção de categoria.
- Exploração das áreas educativas.
- Execução do quiz.
- Apresentação dos resultados.
- Funcionamento do ranking.

**Link do vídeo:** A inserir após publicação no YouTube.

## Considerações finais

O Átomo+ foi idealizado para apresentar a tecnologia nuclear de forma educativa, acessível e interativa.

A implementação em Dart console demonstra as principais regras e funcionalidades da experiência proposta, constituindo uma base para a evolução da solução nas próximas Sprints do Challenge CTMSP 2026.
