# 1. Escopo funcional do produto

## Objetivo principal

Permitir que dois usuários utilizem a mesma aplicação web para criar, visualizar, responder, editar, concluir e excluir tarefas compartilhadas, de forma simples, direta e visualmente agradável.

## Premissas

* A aplicação terá somente uma tela principal.
* Não haverá login, cadastro, sessão ou distinção formal entre usuários.
* Ambos os usuários terão exatamente os mesmos privilégios.
* A aplicação será apenas web.
* Os dados serão armazenados em Firebase.

---

# 2. Requisitos funcionais

## RF01 - Criar tarefa

A aplicação deve permitir inserir um texto de até 500 caracteres e salvar uma nova tarefa.

### Detalhes

* O campo de texto deve aceitar no máximo 500 caracteres.
* O botão “Salvar” deve criar a tarefa no banco.
* Ao salvar com sucesso, a tarefa deve aparecer imediatamente na lista.
* O campo deve ser limpo após o salvamento com sucesso.

---

## RF02 - Listar tarefas

A aplicação deve exibir todas as tarefas salvas em lista única.

### Detalhes

* A listagem deve misturar tarefas concluídas e não concluídas.
* As tarefas concluídas devem aparecer visualmente diferentes das não concluídas.
* Ao carregar a aplicação, deve buscar e exibir os dados persistidos no Firebase.

---

## RF03 - Marcar e desmarcar tarefa

A aplicação deve permitir que qualquer usuário marque ou desmarque uma tarefa como concluída.

### Detalhes

* A marcação deve ser feita por checklist.
* O estado deve ser salvo imediatamente no banco.
* A atualização deve refletir visualmente sem necessidade de recarregar a página.

---

## RF04 - Filtrar tarefas

A aplicação deve permitir filtrar a lista por status.

### Filtros mínimos

* Todas
* Pendentes
* Concluídas

---

## RF05 - Editar tarefa

A aplicação deve permitir editar qualquer tarefa existente.

### Detalhes

* Qualquer usuário pode editar qualquer tarefa.
* O texto editado deve continuar respeitando o limite de 500 caracteres.
* Deve ser possível editar também o prazo, quando existir.

---

## RF06 - Excluir tarefa

A aplicação deve permitir excluir qualquer tarefa.

### Detalhes

* Qualquer usuário pode excluir qualquer tarefa.
* Deve existir confirmação antes da exclusão.
* Ao excluir, a tarefa deve desaparecer da lista e do banco.

---

## RF07 - Comentários por tarefa

Cada tarefa pode receber respostas e tréplicas.

### Interpretação técnica recomendada

Para simplificar a implementação na primeira versão:

* Cada tarefa poderá ter uma lista de comentários.
* Cada comentário poderá ter uma lista de respostas.
* Para evitar complexidade excessiva, a recomendação é limitar a estrutura em:

  * comentário
  * resposta ao comentário

Se você quiser seguir literalmente “resposta e tréplica”, então:

* comentário principal
* resposta
* tréplica

### Detalhes

* Qualquer usuário pode comentar.
* Qualquer usuário pode responder ou replicar.
* Os comentários devem ficar vinculados à tarefa.
* Os comentários devem ser persistidos no banco.

---

## RF08 - Prazo opcional por tarefa

Cada tarefa pode ou não possuir prazo de execução.

### Detalhes

* O prazo é opcional.
* O prazo deve ser salvo junto à tarefa.
* Caso exista prazo e a tarefa ainda não esteja concluída, a aplicação deve destacar visualmente quando faltar:

  * 15 dias
  * 10 dias
  * 5 dias
  * 3 dias
  * 2 dias
  * 1 dia

---

## RF09 - Destaque de vencimento

A aplicação deve destacar tarefas pendentes próximas do vencimento.

### Comportamento esperado

* O destaque só acontece se:

  * a tarefa tiver prazo definido
  * a tarefa não estiver concluída
* O destaque deve mudar conforme a proximidade do vencimento.
* Tarefas vencidas também devem possuir destaque específico.

---

## RF10 - Responsividade

A aplicação deve funcionar adequadamente em:

* mobile
* tablet
* web desktop

---

## RF11 - Tema visual

A aplicação deve utilizar um tema leve e romântico.

### Detalhes

* Cores suaves
* Tipografia limpa
* Boa legibilidade
* Estilo acolhedor, simples e delicado

---

## RF12 - Tela única

Toda a experiência da aplicação deve acontecer em uma única tela.

### Componentes esperados nessa tela

* cabeçalho
* campo de nova tarefa
* botão salvar
* filtro
* listagem de tarefas
* edição de tarefa
* ações de exclusão
* comentários/respostas
* informações de prazo

---

# 3. Requisitos não funcionais

## RNF01 - Performance

* A tela inicial deve carregar rapidamente.
* As operações de criar, editar, marcar e excluir devem ter resposta visual imediata.
* A experiência deve permanecer fluida mesmo com dezenas de tarefas e comentários.

## RNF02 - Persistência

* Os dados devem ser persistidos em Firebase.
* Ao atualizar a página, as tarefas devem permanecer visíveis com seus estados corretos.

## RNF03 - Consistência visual

* O layout deve manter padrão visual único em todos os estados.
* Componentes devem seguir o mesmo design system básico.

## RNF04 - Usabilidade

* A interface deve ser simples e intuitiva.
* O usuário deve conseguir entender o fluxo sem treinamento.
* Os botões e estados devem ser claros.

## RNF05 - Responsividade

* A experiência deve se adaptar a diferentes larguras de tela sem quebra de layout.

## RNF06 - Manutenibilidade

* O projeto deve seguir arquitetura Feature First com Provider e ChangeNotifier.
* O código deve ser modular, legível e escalável.

## RNF07 - Confiabilidade

* Falhas de rede e falhas de persistência devem ser tratadas com feedback visual.
* A aplicação não deve perder o estado local visual de forma abrupta.

## RNF08 - Segurança básica

Mesmo sem login:

* regras do Firebase devem ser cuidadosamente pensadas
* evitar escrita inválida
* validar tamanho de campos
* restringir formatos inesperados

Observação importante: sem autenticação real, a segurança será limitada. Como não há distinção de usuários, qualquer pessoa com acesso ao app poderá manipular os dados.

## RNF09 - Compatibilidade

* Compatível com navegadores modernos.
* Foco principal em Chrome, Edge e Safari recente.

---

# 4. Regras de negócio

## RB01

Não existe autenticação, então todos os acessos possuem o mesmo nível de permissão.

## RB02

Toda tarefa deve possuir obrigatoriamente:

* identificador único
* texto
* status de concluída ou pendente
* data de criação

## RB03

O texto da tarefa:

* é obrigatório
* não pode ser vazio
* não pode ultrapassar 500 caracteres

## RB04

Uma tarefa pode possuir prazo, mas esse campo é opcional.

## RB05

Se a tarefa estiver concluída, ela não deve receber destaque de urgência, mesmo que esteja próxima do vencimento ou vencida.

## RB06

Se a tarefa estiver pendente e possuir prazo, deve ser calculada a proximidade do vencimento.

## RB07

Os marcos de alerta devem considerar exatamente:

* 15 dias
* 10 dias
* 5 dias
* 3 dias
* 2 dias
* 1 dia

## RB08

Caso a data do prazo já tenha passado e a tarefa continue pendente, ela deve ser exibida como vencida.

## RB09

Qualquer usuário pode:

* criar
* editar
* excluir
* marcar/desmarcar
* comentar
* responder

## RB10

Comentários e respostas devem sempre estar vinculados a uma tarefa existente.

## RB11

Ao excluir uma tarefa, todos os comentários e respostas vinculados a ela também devem ser removidos.

## RB12

A lista exibida deve refletir o estado mais recente persistido no banco.

## RB13

Os filtros não devem alterar os dados, apenas a visualização.

---

# 5. Regras de validação

## Entrada de tarefa

* obrigatório
* mínimo prático: 1 caractere útil
* máximo: 500 caracteres
* remover espaços excedentes nas extremidades antes de validar

## Prazo

* opcional
* se informado, deve ser uma data válida
* pode ser permitido prazo no passado apenas se você quiser registrar tarefas já vencidas; para uma UX melhor, a recomendação é bloquear prazo passado na criação e permitir apenas exibição de vencida quando a data expirar com o tempo

## Comentários

* recomendação: obrigatório ao menos 1 caractere útil
* recomendação de limite: 300 ou 500 caracteres para manter consistência

---

# 6. Fluxos principais

## Fluxo 1 - Criar tarefa

1. Usuário digita o texto.
2. Opcionalmente define prazo.
3. Clica em salvar.
4. Sistema valida os dados.
5. Sistema salva no Firebase.
6. Sistema atualiza a lista.
7. Sistema limpa o formulário.

## Fluxo 2 - Concluir tarefa

1. Usuário marca checklist.
2. Sistema atualiza status para concluída.
3. Sistema persiste no Firebase.
4. Tarefa muda visualmente.

## Fluxo 3 - Editar tarefa

1. Usuário aciona editar.
2. Sistema abre modo edição inline ou modal.
3. Usuário altera texto e/ou prazo.
4. Sistema valida.
5. Sistema salva no Firebase.
6. Lista é atualizada.

## Fluxo 4 - Excluir tarefa

1. Usuário aciona excluir.
2. Sistema pede confirmação.
3. Usuário confirma.
4. Sistema remove tarefa e dados associados.
5. Lista é atualizada.

## Fluxo 5 - Comentar tarefa

1. Usuário abre área de comentários.
2. Digita comentário.
3. Sistema valida.
4. Sistema salva no Firebase.
5. Comentário aparece na tarefa.

---

# 7. Tratamento de erros

## Erros de validação

### Cenários

* texto vazio
* texto acima de 500 caracteres
* comentário vazio
* data inválida

### Comportamento esperado

* exibir mensagem clara próxima ao campo ou em snackbar
* não enviar ao banco enquanto houver erro

---

## Erros de persistência

### Cenários

* falha de conexão
* timeout
* falha ao salvar no Firebase
* falha ao carregar lista
* falha ao atualizar checklist
* falha ao excluir
* falha ao editar

### Comportamento esperado

* mostrar mensagem amigável
* manter consistência visual
* evitar sumiço indevido de dados
* permitir nova tentativa

### Mensagens sugeridas

* “Não foi possível carregar as tarefas.”
* “Não foi possível salvar a tarefa.”
* “Não foi possível atualizar o status.”
* “Não foi possível excluir a tarefa.”
* “Verifique sua conexão e tente novamente.”

---

## Erros de estado

### Cenários

* tarefa removida enquanto outro usuário visualizava
* comentário vinculado a tarefa inexistente
* atualização concorrente

### Comportamento esperado

* recarregar estado atual da tarefa
* informar que o item foi alterado/removido
* impedir quebra da UI

---

# 8. Layout funcional da tela única

## Estrutura sugerida

### 1. Cabeçalho

* nome da aplicação
* subtítulo curto e acolhedor

Exemplo:

* “Nossas Metas”
* “Organizando a vida a dois”

---

### 2. Card de criação de tarefa

* campo de texto
* contador de caracteres
* seletor opcional de prazo
* botão salvar

---

### 3. Barra de filtros

* Todas
* Pendentes
* Concluídas

Opcional:

* Próximas do vencimento
* Vencidas

---

### 4. Lista principal de tarefas

Cada item deve exibir:

* checkbox
* texto da tarefa
* prazo, se existir
* status visual
* ações de editar e excluir
* botão/expansão para comentários

---

### 5. Área expansível de comentários

Dentro de cada tarefa:

* lista de comentários
* botão para responder
* campo para novo comentário
* exibição hierárquica simples

---

# 9. Tema visual

## Direção estética

Tema leve e romântico, sem exagero visual.

## Paleta sugerida

* rosa claro
* lilás suave
* creme/off-white
* tons neutros quentes
* vermelho suave para urgência
* verde suave para concluídas

## Sensação desejada

* delicado
* limpo
* agradável
* acolhedor
* fácil de ler

## Elementos visuais

* bordas arredondadas
* espaçamento confortável
* ícones suaves
* sombras discretas
* tipografia moderna e leve

## Cuidados

* não exagerar em ornamentos
* manter contraste suficiente para acessibilidade
* urgência não pode conflitar com estética

---

# 10. Estados visuais importantes

## Tarefa pendente

* checkbox desmarcado
* texto normal

## Tarefa concluída

* checkbox marcado
* texto com menor destaque
* opcional: riscado

## Próxima do vencimento

* selo ou badge visual
* mudança de borda/fundo suave

## Vencida

* destaque mais forte
* label “Vencida”

## Editando

* campos habilitados
* ações de salvar/cancelar

## Carregando

* skeleton ou loading discreto

## Erro

* mensagem visível e amigável

## Lista vazia

* mensagem acolhedora
* incentivo para criar a primeira tarefa

Exemplo:
“Vocês ainda não adicionaram nenhuma tarefa 💕”

---

# 11. Arquitetura técnica solicitada

## Padrão

* Feature First
* Provider
* ChangeNotifier

## Estrutura sugerida

```text
lib/
 ├─ app/
 │   ├─ app_widget.dart
 │   ├─ routes/
 │   ├─ theme/
 │   └─ core/
 │       ├─ errors/
 │       ├─ utils/
 │       ├─ constants/
 │       └─ widgets/
 │
 ├─ features/
 │   └─ tasks/
 │       ├─ data/
 │       │   ├─ datasources/
 │       │   ├─ models/
 │       │   ├─ repositories/
 │       │   └─ mappers/
 │       │
 │       ├─ domain/
 │       │   ├─ entities/
 │       │   ├─ repositories/
 │       │   └─ usecases/   // opcional
 │       │
 │       └─ presentation/
 │           ├─ providers/
 │           ├─ pages/
 │           ├─ widgets/
 │           └─ controllers/ // opcional
 │
 └─ main.dart
```

## Observação importante

Como a aplicação tem uma única feature principal, a feature `tasks` pode concentrar:

* tarefa
* comentários
* filtros
* destaque de vencimento

---

# 12. Modelo de dados sugerido

## Entidade Task

```text
id: String
text: String
isDone: bool
createdAt: DateTime
updatedAt: DateTime?
dueDate: DateTime?
commentsCount: int?        // opcional
```

## Entidade Comment

```text
id: String
taskId: String
parentCommentId: String?   // null para comentário principal
text: String
createdAt: DateTime
updatedAt: DateTime?
```

## Observação

Se quiser simplificar muito a V1:

* armazenar comentários como subcoleção da tarefa
* usar `parentCommentId` para resposta/tréplica

---

# 13. Firebase - escopo técnico

## Serviços recomendados

* Firebase Hosting para publicação web
* Cloud Firestore para persistência
* opcional: Firebase Analytics futuramente

## Estrutura recomendada no Firestore

### Coleção principal

`tasks`

### Documento da tarefa

```text
tasks/{taskId}
```

Campos:

* text
* isDone
* createdAt
* updatedAt
* dueDate

### Subcoleção de comentários

```text
tasks/{taskId}/comments/{commentId}
```

Campos:

* text
* parentCommentId
* createdAt
* updatedAt

---

# 14. Regras de ordenação recomendadas

Para melhorar a UX, sugiro ordenar assim:

1. tarefas pendentes primeiro
2. dentro das pendentes:

   * vencidas
   * mais próximas do vencimento
   * sem prazo
3. concluídas por último

Isso não foi exigido explicitamente, mas melhora bastante a experiência.

---

# 15. Casos de erro e bordas que precisam ser considerados

## Casos de borda

* usuário tenta salvar somente espaços
* tarefa sem prazo
* tarefa com prazo no mesmo dia
* tarefa vencida
* tarefa excluída enquanto está aberta para edição
* dois usuários editam a mesma tarefa quase ao mesmo tempo
* usuário filtra concluídas e depois marca uma como pendente
* comentário em tarefa já removida
* falha ao buscar dados na primeira carga

---

# 16. Critérios de aceite

## Criar tarefa

* dado que o usuário digitou texto válido
* quando clicar em salvar
* então a tarefa deve ser salva e exibida na lista

## Marcar tarefa

* dado que existe uma tarefa pendente
* quando o usuário marcar o checkbox
* então a tarefa deve ficar concluída e persistida no banco

## Filtrar tarefas

* dado que existem tarefas pendentes e concluídas
* quando o usuário selecionar um filtro
* então a lista deve exibir apenas os itens compatíveis

## Editar tarefa

* dado que existe uma tarefa
* quando o usuário alterar seu conteúdo e salvar
* então a alteração deve persistir e ser refletida na tela

## Excluir tarefa

* dado que existe uma tarefa
* quando o usuário confirmar a exclusão
* então ela deve ser removida da lista e do banco

## Prazo

* dado que uma tarefa pendente possui prazo
* quando ela estiver a 15, 10, 5, 3, 2 ou 1 dias do vencimento
* então deve receber destaque visual correspondente

---

# 17. Riscos e pontos de atenção

## Sem autenticação

Esse é o principal risco técnico e funcional.

### Impactos

* qualquer pessoa com o link pode acessar e alterar os dados
* não há rastreabilidade por usuário
* não há como saber quem criou, editou ou concluiu

### Consequência

Para uso privado do casal, isso pode ser aceitável, mas tecnicamente é uma limitação importante.

## Concorrência

Como os dois usuários podem alterar os mesmos dados:

* pode haver sobrescrita de edição
* deve existir estratégia simples de atualização por último salvamento

---

# 18. Sugestões técnicas adicionais

## Recomendação 1

Usar `StreamBuilder` ou escuta reativa do Firestore no repositório/provider para refletir alterações em tempo real na web.

## Recomendação 2

Criar um enum para filtro:

```dart
enum TaskFilter { all, pending, done }
```

## Recomendação 3

Criar um enum para urgência:

```dart
enum TaskDueStatus {
  none,
  dueIn15Days,
  dueIn10Days,
  dueIn5Days,
  dueIn3Days,
  dueIn2Days,
  dueIn1Day,
  overdue,
}
```

## Recomendação 4

Centralizar mensagens de erro em constantes para manter consistência.

---

# 19. Resumo executivo dos módulos

## Módulo de tarefas

* criar
* listar
* editar
* excluir
* concluir/desmarcar
* prazo opcional
* destaque por vencimento

## Módulo de comentários

* comentar
* responder
* tréplica
* listar comentários por tarefa

## Módulo de filtros

* todas
* pendentes
* concluídas

## Módulo visual

* responsividade
* tema romântico
* tela única
* estados visuais

## Módulo de persistência

* Firebase CLI
* Firestore
* Hosting web

---

# 20. Definição funcional consolidada

A aplicação será uma web app em Flutter, de tela única, sem autenticação, para dois usuários compartilharem uma lista de tarefas com checklist, comentários, edição e exclusão livres, persistida no Firebase, com filtros, prazo opcional e destaque visual inteligente para vencimentos próximos, usando arquitetura Feature First com Provider e ChangeNotifier.
