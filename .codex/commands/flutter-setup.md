# 🧩 Flutter App Architecture — Setup Wizard (Pergunta a Pergunta)

Siga a **App Architecture oficial do Flutter**:

* [https://docs.flutter.dev/app-architecture/concepts](https://docs.flutter.dev/app-architecture/concepts)
* [https://docs.flutter.dev/app-architecture/guide](https://docs.flutter.dev/app-architecture/guide)
* [https://docs.flutter.dev/app-architecture/recommendations](https://docs.flutter.dev/app-architecture/recommendations)

---

## 🧠 Modo de Execução (instruções à LLM)

> Faça **uma pergunta por vez**.
> Espere minha resposta antes de prosseguir para a próxima.
> Quando todas as respostas forem dadas, mostre um **resumo final** das escolhas e só então gere o esqueleto do projeto conforme as diretrizes acima.

---

### 🪜 Etapas do Wizard

#### **Pergunta 0 – Arquitetura do Projeto**

> Pergunte:
> “Qual arquitetura você deseja usar no projeto?
>
> Opções:
>
> 1. **Arquitetura recomendada pelo Flutter** (**App Architecture + MVVM**: `View` + `ViewModel` na UI, `Repositories` + `Services` na camada de dados)
> 2. Clean Architecture
> 3. Feature-first modular
> 4. MVC
> 5. Outra (descreva)
>
> Se quiser seguir a recomendação oficial do Flutter, escolha a opção 1.”
>
> Após resposta:
>
> * Guarde a escolha como `architecture_strategy`.
> * Se a escolha for a opção 1, registre também:
>   * `architecture_reference = flutter_app_architecture_mvvm`
> * Explique brevemente a arquitetura escolhida.
> * Se for a arquitetura recomendada pelo Flutter, explique que:
>   * a UI será organizada em **View** e **ViewModel**
>   * a camada de dados usará **Repositories** e **Services**
>   * a separação de responsabilidades será a base da estrutura
> * Avance para a etapa 1.

---

#### **Etapa 1 – Gerenciamento de Estado**

> Pergunte:
> “Qual gerenciador de estado você deseja usar (ex: ChangeNotifier, Provider + ChangeNotifier, Riverpod, Bloc, outro)?”
>
> Após resposta:
>
> * Guarde a escolha como `state_manager`.
> * Explique brevemente como será aplicado na camada `ui/view_model`.
> * Avance para a etapa 2.

---

#### **Etapa 2 – Dependency Injection**

> Pergunte:
> “Como deseja fazer a injeção de dependência (Provider, get_it, injectable + get_it, manual por construtor, outro)?”
>
> Após resposta:
>
> * Guarde a escolha como `dependency_injection`.
> * Explique onde as dependências serão inicializadas (ex: `core/di/providers.dart`).
> * Avance para a etapa 3.

---

#### **Etapa 3 – Cliente HTTP**

> Pergunte:
> “Qual biblioteca deseja usar para requisições HTTP (Dio, http, Retrofit + Dio, outro)?”
>
> Após resposta:
>
> * Guarde a escolha como `http_client`.
> * Explique onde o cliente será configurado (ex: `core/network/dio_client.dart`).
> * Avance para a etapa 4.

---

#### **Etapa 4 – Routing**

> Pergunte:
> “Você confirma que deseja usar **rotas nomeadas nativas do Flutter** (Navigator + routes/onGenerateRoute)? Quer adicionar guards simples (ex: login obrigatório)?”
>
> Após resposta:
>
> * Guarde a confirmação como `routing_strategy = native_named_routes`.
> * Descreva brevemente a estrutura esperada (`routing/route_names.dart`, `routing/app_router.dart`).
> * Avance para a etapa 5.

---

#### **Etapa 5 – Temas e Design System**

> Pergunte:
> “Quer gerar um tema inicial (claro/escuro completo, tema base simples ou nenhum)?”
>
> Após resposta:
>
> * Guarde como `theme_setup`.
> * Informe onde será configurado (`ui/core/themes`).
> * Avance para a etapa 6.

---

#### **Etapa 6 – Ambientes e Entrypoints**

> Pergunte:
> “Quer manter múltiplos entrypoints (main.dart, main_development.dart, main_staging.dart) ou usar apenas main.dart?”
>
> Após resposta:
>
> * Guarde como `entrypoints_strategy`.
> * Explique diferença de uso entre ambientes (logs, baseUrl etc.).
> * Avance para a etapa 7.

---

#### **Etapa 7 – Padrões e Qualidade**

> Pergunte:
> “Quais ferramentas de qualidade deseja incluir (analysis_options.yaml, very_good_analysis, flutter format, README base)?”
>
> Após resposta:
>
> * Guarde como `quality_tools`.
> * Informe que `dart_code_metrics` e `git hooks` **não** serão incluídos.
> * Avance para a etapa 8.

---

#### **Etapa 8 – Testes**

> Pergunte:
> “Deseja incluir exemplos de testes (unitários, widget, golden, mocks/fakes)?”
>
> Após resposta:
>
> * Guarde como `test_setup`.
> * Explique a estrutura dos diretórios `test/` e `testing/`.
> * Avance para a etapa 9.

---

#### **Etapa 9 – Extras**

> Pergunte:
> “Deseja incluir recursos adicionais (internacionalização, logger, tratamento de erros, cache, monitoramento)?”
>
> Após resposta:
>
> * Guarde como `extras`.
> * Avance para a etapa final.

---

### ✅ **Etapa Final – Resumo e Geração**

> Após todas as respostas:
>
> * Mostre o **resumo consolidado** das escolhas:
>
>   ```
>   Arquitetura: ...
>   State Manager: ...
>   Dependency Injection: ...
>   HTTP Client: ...
>   Routing: Rotas nomeadas nativas
>   Tema: ...
>   Entrypoints: ...
>   Qualidade: ...
>   Testes: ...
>   Extras: ...
>   ```
> * Peça uma confirmação final: “Posso gerar a estrutura do projeto com essas configurações?”
> * Após confirmação:
>
>   * Insira comentários explicando o papel de cada camada e arquivo.
>   * Não adicione nenhuma lib ou arquivo não confirmado.

---

### 📌 Persistir memória das decisões e arquitetura

> Após gerar o projeto, crie um arquivo de memória com as decisões e detalhes arquiteturais para uso futuro na geração de rules.
>
> • Caminho do arquivo: `@.ia/memories/flutter_architecture.memory.json`
>
> • Conteúdo (preencha com os valores coletados ao longo das etapas):
>
> ```json
> {
>   "kind": "flutter_setup",
>   "version": 1,
>   "architecture_strategy": "<architecture_strategy>",
>   "architecture_reference": "<flutter_app_architecture_mvvm|custom>",
>   "state_manager": "<state_manager>",
>   "dependency_injection": "<dependency_injection>",
>   "http_client": "<http_client>",
>   "routing_strategy": "native_named_routes",
>   "theme_setup": "<theme_setup>",
>   "entrypoints_strategy": "<entrypoints_strategy>",
>   "quality_tools": "<quality_tools>",
>   "test_setup": "<test_setup>",
>   "extras": "<extras>",
>   "architecture": {
>     "layers": ["ui", "domain", "data", "config", "utils", "routing"],
>     "ui": {
>       "pattern": "<ex: MVVM>",
>       "view_model_pattern": "<ex: ChangeNotifier + Provider>",
>       "themes_path": "lib/ui/core/themes"
>     },
>     "di": {
>       "init_path": "lib/core/di/providers.dart",
>       "strategy": "<dependency_injection>"
>     },
>     "network": {
>       "client": "<http_client>",
>       "config_path": "lib/core/network/dio_client.dart"
>     },
>     "routing": {
>       "strategy": "native_named_routes",
>       "files": ["lib/routing/route_names.dart", "lib/routing/app_router.dart"]
>     },
>     "config": {
>       "app_config_path": "lib/config/app_config.dart",
>       "environments": ["main.dart", "main_development.dart", "main_staging.dart"]
>     }
>   },
>   "notes": "<adicione aqui decisões relevantes, trade-offs e convenções importantes>",
>   "generated_at": "<ISO-8601 datetime>"
> }
> ```
>
> Observação: este arquivo em `@.ia/memories` será utilizado posteriormente para gerar e atualizar as rules do projeto de forma automática.