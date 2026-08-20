# Hana

App iOS de cuidado de plantas domésticas: o usuário fotografa uma planta, o app
identifica a espécie e gera as instruções de cuidado correspondentes. A partir
daí ele registra rega e banho de sol, recebe notificações locais nos horários
configurados e acompanha o estado das plantas por um widget na tela de início.

Publicado na App Store como **Hana**. O alvo do Xcode ainda se chama `PlanTio`,
que era o nome do projeto antes do rebranding — os dois nomes convivem no
código.

---

## Pipeline de IA

São duas chamadas de rede encadeadas por um único dado: o nome científico da
espécie. A primeira é um classificador de imagem; a segunda é um LLM.

```
foto (UIImage)
   │
   │  POST https://api.plant.id/v2/identify   ← plant.id
   ▼
suggestions[0].plant_details.scientific_name
   │
   │  grava em  @Binding var plantType  ==  $plant.type
   ▼
campo "Species" (editável pelo usuário)
   │
   │  interpolado no prompt → model.run() via aiXplainKit
   ▼
7 linhas de texto → PlantInfo → 7 campos da planta
```

### Etapa 1 — foto → espécie

[`PlanTio/Telas/Components/FrameImage.swift`](PlanTio/Telas/Components/FrameImage.swift)

`FrameImage` é o componente da foto. Ao escolher uma imagem (câmera ou galeria),
o `onChange` na [linha 55](PlanTio/Telas/Components/FrameImage.swift#L55) chama
`analyzeImage(_:)` ([linha 67](PlanTio/Telas/Components/FrameImage.swift#L67)),
que comprime para JPEG, codifica em base64 e faz um POST para
`https://api.plant.id/v2/identify` com o payload `{"images": [...], "organs": ["leaf"]}`.

A resposta é lida na [linha 106](PlanTio/Telas/Components/FrameImage.swift#L106):
o app pega `suggestions[0].plant_details.scientific_name` — a primeira sugestão,
sem olhar score de confiança — e escreve esse nome no binding `plantType`.

### Etapa 2 — espécie → instruções de cuidado

[`PlanTio/Telas/PlantDetailView.swift`](PlanTio/Telas/PlantDetailView.swift)

O binding `plantType` é `$plant.type` ([linha 19](PlanTio/Telas/PlantDetailView.swift#L19)).
Quando o usuário toca em "Save" ([linha 208](PlanTio/Telas/PlantDetailView.swift#L208)),
o valor atual de `plant.type` vai para
`PlantInfoManager.getPlantInfo(for:)`.

`PlantInfoManager` ([linha 302](PlanTio/Telas/PlantDetailView.swift#L302)) usa o
`aiXplainKit`: configura a chave, resolve um modelo por ID
([linha 345](PlanTio/Telas/PlantDetailView.swift#L345)) e monta o prompt em
`createPlantInfo(for:)` ([linha 348](PlanTio/Telas/PlantDetailView.swift#L348)).

O prompt pede sete informações — *Safe for Pets, Best Soil, Watering,
Sunbathing, Weather, Pot Size, Poison* — e instrui o modelo a devolver só os
valores, um por linha, sem os rótulos, com exemplos de formato certo e errado.
A espécie entra na última linha: `Plant type: \(plantType)`.

A saída é parseada em `PlantInfo.init(from:)`
([linha 400](PlanTio/Telas/PlantDetailView.swift#L400)): `split(separator: "\n")`
e as sete linhas são atribuídas **por posição** aos sete campos. Depois
`updatePlantInfo(with:)` ([linha 256](PlanTio/Telas/PlantDetailView.swift#L256))
copia os valores para a `Plant`, que é persistida como JSON.

---

## Uma decisão de produto: a espécie é um campo editável

O classificador de imagem erra — troca espécies parecidas, e erra mais ainda com
foto ruim ou planta fora do catálogo. Em vez de tratar a saída do modelo como
verdade, o app a trata como **um valor inicial de formulário**.

O mesmo `$plant.type` que a API preenche está ligado a um `TextField`:

```swift
// PlantDetailView.swift:19
FrameImage(imageData: $plant.imageData, plantType: $plant.type, aspectRatio: 10)

// PlantDetailView.swift:30
TextField("Species", text: $plant.type)
```

Como a segunda etapa lê `plant.type` só no momento do "Save"
([linha 208](PlanTio/Telas/PlantDetailView.swift#L208)), qualquer correção que o
usuário digite antes de salvar é o que chega ao prompt do LLM. Não existe
caminho de código separado para "espécie corrigida pelo usuário" — é o mesmo
binding do começo ao fim.

Isso resolve o modo de falha mais comum do pipeline sem nenhum código de
tratamento de erro: quando o modelo erra, o usuário corrige, e o resto segue
igual. Também permite usar o app sem foto nenhuma, digitando a espécie na mão.

O custo é que o app não mostra a confiança da identificação nem sinaliza quando
o palpite é fraco. O usuário só descobre o erro se souber reconhecer a planta.

---

## Limitações

Lista honesta do que quebra hoje e do que eu faria diferente.

### Chaves de API

**Onde a chave mora.** As chaves saíram do código-fonte e passaram a ser
declaradas em `Config/Secrets.xcconfig`, que está no `.gitignore`. O build as
injeta no `Info.plist` do alvo e o app as lê em
[`PlanTio/Classes/Secrets.swift`](PlanTio/Classes/Secrets.swift).

**Isso tira as chaves do repositório, não do aplicativo.** No binário
distribuído elas continuam sendo texto dentro do bundle. Dá para conferir no
próprio produto de build:

```console
$ plutil -extract PLANT_ID_API_KEY raw PlanTio.app/Info.plist
<a chave configurada no build, em texto puro>
```

Qualquer pessoa que baixe o app da App Store consegue extrair a chave com
`strings` ou um editor de plist. **Chave embarcada em app distribuído é chave
pública** — não existe lugar no bundle que o usuário final não possa ler, e
ofuscar só aumenta o trabalho de quem procura. Isso vale para as três chaves
deste projeto.

O jeito certo é o app nunca ver a chave: um backend próprio guarda as
credenciais, o app chama esse backend autenticado por sessão de usuário, e o
backend fala com plant.id e com o provedor de LLM. Isso também permite impor
limite de uso por usuário e trocar a chave sem publicar versão nova. O projeto
não fez isso porque foi construído num prazo de challenge da Academy, sem
infraestrutura de servidor.

**Histórico.** Este repositório preserva o histórico completo de commits, então
as chaves que já estiveram no código continuam recuperáveis com `git log`.
Tirar uma chave do HEAD não a tira do histórico: a única correção real é
revogá-la no provedor. É o que vale para qualquer credencial que já tenha
passado por um repositório.

### Parsing da resposta do LLM

`PlantInfo.init(from:)` divide o texto por `\n` e atribui as sete linhas por
posição. Se o modelo devolver um cabeçalho, uma linha em branco a mais, um
campo com quebra de linha interna ou uma frase de cortesia, tudo desloca e os
campos ficam trocados. O único tratamento é `guard lines.count >= 7`, que
detecta "veio pouco" mas não "veio na ordem errada".

Hoje eu pediria saída estruturada em JSON e decodificaria com `Codable`,
validando os campos. O prompt já gasta várias linhas ensinando o formato por
exemplo, que é exatamente o problema que saída estruturada resolve.

### Tratamento de erro

Os erros de rede e de parsing terminam em `print`
([FrameImage.swift:96](PlanTio/Telas/Components/FrameImage.swift#L96),
[:115](PlanTio/Telas/Components/FrameImage.swift#L115),
[PlantDetailView.swift:215](PlanTio/Telas/PlantDetailView.swift#L215)). A
interface não mostra nada. Se a identificação falhar, o campo de espécie
simplesmente não é preenchido; se o LLM falhar, a planta é salva com os campos
de cuidado vazios. Não há timeout, retry nem estado de erro visível.

### Identificação

- O payload fixa `"organs": ["leaf"]`, ou seja, assume foto de folha. Foto de
  flor ou da planta inteira é enviada com a dica errada.
- Só a primeira sugestão é usada, e o score de confiança que a API devolve é
  ignorado.
- O endpoint está fixado na v2 da plant.id.

### Dependências

`aiXplainKit` está preso ao branch `main`, não a uma versão
([Package.resolved](PlanTio.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved)).
Um commit no upstream pode quebrar o build sem nenhuma mudança aqui. O ID do
modelo (`640b517694bf816d35a59125`) também está fixo no código.

### Estado do repositório

Este é o repositório como ele terminou o challenge, não um projeto arrumado
depois:

- 42 arquivos duplicados com sufixo ` 2` (`Store 2.swift`, `Info 2.plist`, …),
  resultado de merges resolvidos na mão pelo Xcode.
- Os diretórios `HanaWidget copy/` e `HanaWidgetNew/` não são referenciados por
  nenhum alvo — são código morto.
- `PlanTioTests` e `PlanTioUITests` só têm o `testExample` do template. Não há
  testes.
- [`SearchPlantTypeView.swift`](PlanTio/Telas/SearchPlantTypeView.swift) é um
  stub com `Text("Hello, World!")`.
- Mensagens de commit em português informal e sem padrão.

Deixei tudo como estava de propósito: mexer nisso agora reescreveria a autoria
de quem fez cada parte.

---

## Como rodar

**Requisitos**

| | |
|---|---|
| Xcode | 15.3+ para abrir (`objectVersion = 56`). Verificado com **Xcode 26.6** |
| iOS mínimo | **17.2** no app, **17.5** no widget |
| Swift | 5.0 |
| Dispositivo | iPhone (`TARGETED_DEVICE_FAMILY = 1`) |

**Dependências** (Swift Package Manager, resolvidas automaticamente)

| Pacote | Versão | Uso |
|---|---|---|
| [aiXplainKit](https://github.com/aixplain/aiXplainKit) | branch `main` | acesso ao LLM |
| [posthog-ios](https://github.com/PostHog/posthog-ios) | 3.4.0 | analytics |
| [rive-ios](https://github.com/rive-app/rive-ios) | 5.11.6 | animações |
| [VMNotificationHandler](https://github.com/Visckmart/VMNotificationHandler) | 1.2.3 | notificações locais |

**Configurar as chaves**

```sh
cp Config/Secrets.example.xcconfig Config/Secrets.xcconfig
```

Preencha as três chaves:

| Variável | Onde obter | Sem ela |
|---|---|---|
| `PLANT_ID_API_KEY` | [plant.id](https://web.plant.id) | a identificação por foto não preenche a espécie |
| `AIXPLAIN_TEAM_API_KEY` | [platform.aixplain.com](https://platform.aixplain.com) | as instruções de cuidado vêm vazias |
| `POSTHOG_API_KEY` | [posthog.com](https://us.posthog.com) | os eventos de analytics não são enviados |

`Config/Secrets.xcconfig` está no `.gitignore`. O `Config/Base.xcconfig` define
as três variáveis vazias e faz `#include?` do arquivo de segredos, então **o
projeto compila sem nenhuma chave configurada** — as chamadas de rede que
dependem delas é que falham.

Depois disso, abra `PlanTio.xcodeproj`, selecione o esquema `PlanTio` e rode.
Para rodar em device é preciso trocar `DEVELOPMENT_TEAM` e o bundle identifier
(`challenge2.PlanTio`) pelos seus.

A compra dentro do app ("Hana Plus", produto `hanaplus`) precisa de configuração
de StoreKit própria para funcionar em ambiente de teste.

---

## Créditos

Feito em equipe na **Apple Developer Academy — PUC-Rio**, turma de 2024, como
projeto de challenge.

Contribuidores, por volume de commits no histórico:

| | commits |
|---|---|
| Lucas Santhiago ([@Lucasanthiago](https://github.com/Lucasanthiago)) | 86 |
| Gabriela Lewin | 64 |
| Kauã Trindade | 48 |
| Izabour Azevedo | 20 |
| Ricardo Venieris (mentor) | 1 |

Números de `git shortlog -sne --all`, somando as identidades duplicadas de cada
pessoa (219 commits no total).

## Licença

Código sob licença MIT — veja [LICENSE](LICENSE).

A licença cobre o código-fonte. Fontes, animações e dados de terceiros mantêm
suas próprias licenças; veja [CREDITS.md](CREDITS.md).
