Atue como um " Project Rule Builder" para este repositorio Flutter.

Objetivo: criar/atualizar um conjunto de Project Rules(.mdc) em pr-BR de `.codex/rules/`, baseadas:

1) No estado Real do projeto(pastas, dependências, Padrões já usados),

2) no guia de regras do Dart: https://raw.githubusercontent.com/flutter/flutter/refs/heads/master/docs/rules/rules.md
   - Se não conseguir acessar o link, derive as regras a partir do `analysis_options.yaml` e do código existente.
  

**DEVE / NÃO DEVE**
 - Caso tenha alguma dúvida ou algo que não esteja claro, **VOCE DEVE**  pergunte ao usuário para esclarecer antes de continuar. 
 - Caso tenha alguma dúvida ou algo que não esteja claro, **NÃO VOCE DEVE** continuar antes de esclarecer. 

### Entrada opcional
   - É possível fornecer um arquivo complementar com informações/contexto para orientar a geração das rules.
   - Formatos aceitos: `.md`, `.mdc`, `.txt`, `.json`, `.yaml`.
   - Tratamento:
     - Leia o arquivo integralmente e extraia diretrizes úteis (decisões arquiteturais, exceções locais, convenções do time, restrições de segurança, etc.).
     - Em caso de conflito entre o arquivo auxiliar e o estado real do repositório, priorize o repositório e registre a divergência nos TODOS do resumo final.
     - Não copie o conteúdo na íntegra; incorpore como regras objetivas alinhadas ao código e às lints.
     - No resumo final, indique o nome do arquivo usado como “Fonte auxiliar”.
     
### O que analisar no repo
  - `pubspec.yaml` (dependências → detectar state management e libs de DI).
  - `analysis_options.yaml` (lints/formatter).
  - Estrutura `lib/**`, `test/**`, `integration_test/**`, `assets/**`, `l10n/**`.
  - Presença de `core/`, `shared/`, design system, temas, i18n.
  - Monorepo? (múltiplos `pubspec.yaml` → ajustar globs para `apps/*/lib/**` e `packages/*/lib/**`).
  - Arquivo auxiliar (opcional), quando fornecido (ver “Entrada opcional”).

### Saída esperada (arquivos e conteúdo)

Crie/atualize **exatamente** estes arquivos, com front-matter e conteúdo conciso em bullets:

1) `.codex/rules/dart-coding-standards.mdc` (Always)
   - `description`: Padrões de código Dart do projeto.
   - Regras: formatter, imports, naming, null-safety, uso de `const`, async/await, extensions, logs (sem prints em prod).
   - Alinhe às regras do link oficial e ao `analysis_options.yaml`.
   - Seções: Objetivo, Regras, Anti-padrões, Checklist.

2) `.codex/rules/flutter-clean-architecture.mdc` (Auto-attach)
   - `globs`: paths reais do app (ex.: `"lib/**"` ou `"apps/*/lib/**"`).
   - Camadas: presentation / domain / data; direções de dependência; DTOs só em data; use cases; repositórios (contratos vs impl).
   - Seções: Objetivo, Estrutura por feature, Direções de dependência, Anti-padrões, Checklist.
  
3) `.codex/rules/dependency-injection.mdc` (Auto-attach)
   - `globs`: idem acima.
   - Detecte a lib padrão (ex.: GetIt/Riverpod/etc.) via dependências; defina ciclo de vida (singleton/factory), ordem de boot, proibição de instanciar serviços em widgets, estratégia de mocks em teste.
   - Seções: Objetivo, Regras, Mocks/ambientes, Checklist.

4) `.codex/rules/state-management.mdc` (Auto-attach)
   - `globs`: idem.
   - Detecte o padrão (Signals/BLoC/Riverpod/Provider) pelo código e deps; defina imutabilidade, estrutura de estados, loading/error/success, side-effects, selectors para evitar rebuilds, testes de estado.
   - Seções: Objetivo, Regras, Anti-padrões, Checklist.

5) `.codex/rules/project-structure.mdc` (Auto-attach)
   - `globs`: `"lib/**"`, `"test/**"`, `"integration_test/**"`, `"assets/**"`, `"l10n/**"` (ajustar conforme repo).
   - Árvore de pastas por feature; `core/` (theme, routes, errors, utils); `shared/` (widgets); convenções de nomes (`*_page.dart`, `*_cubit.dart`/`*_notifier.dart`); regras de import (relativo/absoluto); onde criar novos arquivos.
   - Seções: Objetivo, Regras, Exemplos curtos, Checklist.
  
6) `.codex/rules/testing-standards.mdc` (Auto-attach)
   - `globs`: `"test/**"`, `"integration_test/**"`, `"packages/*/test/**"` se monorepo.
   - Tipos: unit/widget/integration/golden; estrutura de pastas; quando mockar vs fake; cobertura alvo; execução em CI; fixtures/seeds.
   - Seções: Objetivo, Regras, Anti-padrões, Checklist.

7) `.codex/rules/commits-and-language.mdc` (Always)
   - Commits semânticos em **pt-BR** (feat/fix/chore/docs/refactor/test): título curto + corpo explicando o quê/por quê; referência a issues/PRs; padrão para PRs (título/descrição/labels).
   - Seções: Objetivo, Padrões, Exemplos curtos, Checklist.

### Opcionais (criar somente se o repo indicar necessidade)
   - `.codex/rules/design-system-and-theming.mdc` (Auto-attach se houver `core/theme` ou DS).
   - `.codex/rules/assets-and-i18n.mdc` (Auto-attach se houver `l10n/**` ou ARB).
   - `.codex/rules/security-and-secrets.mdc` (Always: .env/cofre, no-logs sensíveis, permissões).

### Requisitos de formatação
   - Idioma: pt-BR, direto e assertivo.
   - Cada arquivo começa com front-matter YAML: `description`, e **ou** `alwaysApply: true` **ou** `globs: [...]` (para Auto-attach).
   - Texto em bullets, seções curtas: Objetivo, Regras, Anti-padrões, Checklist (e “Exemplos curtos” quando útil).
   - Não copiar o guia do Dart inteiro; **alinhe e referencie** (ex.: “seguir regra X quando aplicável”).
   - Limite: regras objetivas (evitar longos parágrafos).
  
### Passos finais
   - Liste no final um “Resumo do que foi detectado” (state mgmt, DI, monorepo, pastas).
   - Valide os `globs` com base na árvore real do repo e mostre-os no resumo.
   - Se algo estiver ambíguo, proponha defaults sensatos e registre TODOS.
   - Se um arquivo auxiliar foi utilizado, inclua no resumo: `Fonte auxiliar: <caminho/arquivo>` e destaque quaisquer decisões derivadas dele.

