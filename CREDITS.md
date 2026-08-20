# Créditos e licenças de terceiros

O código deste repositório está sob MIT ([LICENSE](LICENSE)). Os itens abaixo
não são nossos e mantêm as licenças dos respectivos donos.

## Fonte

**Quicksand** — `PlanTio/Fontes/Quicksand-VariableFont_wght.ttf`

- Versão 3.006, variable font
- Copyright 2019 The Quicksand Project Authors, com Reserved Font Name "Quicksand"
- Licença: **SIL Open Font License 1.1** — https://scripts.sil.org/OFL
- Origem: https://github.com/andrew-paglinawan/QuicksandFamily

Metadados extraídos da tabela `name` do próprio arquivo. A OFL permite uso e
redistribuição, inclusive embarcada em aplicativo. O texto da licença deveria
acompanhar a fonte — hoje ele não está no repositório.

## Dependências (Swift Package Manager)

Não são vendorizadas: o SPM baixa cada uma no build. Versões em
[`Package.resolved`](PlanTio.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved).

| Pacote | Versão | Licença |
|---|---|---|
| [aiXplainKit](https://github.com/aixplain/aiXplainKit) | branch `main` | ver repositório |
| [posthog-ios](https://github.com/PostHog/posthog-ios) | 3.4.0 | MIT |
| [rive-ios](https://github.com/rive-app/rive-ios) | 5.11.6 | ver repositório |
| [VMNotificationHandler](https://github.com/Visckmart/VMNotificationHandler) | 1.2.3 | ver repositório |

## Serviços externos

| Serviço | Uso | Termos |
|---|---|---|
| [plant.id](https://web.plant.id) | identificação de espécie por foto | termos da Kindwise |
| [aiXplain](https://aixplain.com) | execução do LLM | termos da aiXplain |
| [PostHog](https://posthog.com) | analytics de produto | termos do PostHog |

## Assets produzidos pela equipe

Cobertos pela licença do repositório.

- **42 animações Rive** (`.riv`) em `PlanTio/hana/`, `PlanTio/hana-mix/`,
  `PlanTio/NightDay/`, `PlanTio/dayNight/`, `PlanTio/Telas/Opening/` —
  personagem Hana e fundos por período do dia.
- **51 SVGs** em `PlanTio/Assets.xcassets/` — ícones, gradientes e ilustrações
  de interface.
- **Ícone do app** — `PlanTio/Assets.xcassets/AppIcon.appiconset/HanaIcon.png`.

Autoria verificada pelo histórico do git: os SVGs vieram majoritariamente de
Gabriela Lewin, as animações de Izabour Azevedo e Lucas Santhiago.

## Ícones do sistema

O app usa **SF Symbols** da Apple (`drop.fill`, `sun.max.fill`, `tree.fill`,
`pawprint.fill`, `leaf.circle.fill`, `plus.circle.fill`, entre outros),
renderizados em tempo de execução pelo sistema. Nenhum arquivo de SF Symbol é
redistribuído aqui.

SF Symbols são licenciados pela Apple e o uso é restrito a apps para
plataformas Apple, conforme o acordo de licença dos SF Symbols. Não podem ser
usados fora desse contexto nem ter a forma alterada.

## Dataset de plantas

`PlanTio/InfoPlantas` — 209 registros em JSON com os campos `latin`, `family`,
`common`, `category`, `origin`, `climate`, `tempmax`, `tempmin`, `ideallight`,
`toleratedlight`, `watering`, `insects`, `diseases`, `use`. Adicionado no
commit `fa32ab2`.

A mensagem do commit que o adicionou é *"add api copiada"*, e o conjunto de
campos é o mesmo usado por APIs públicas de house plants. A origem exata não
ficou registrada no repositório.

## Marcas

- "Apple", "Apple Developer Academy", "App Store", "Xcode", "Swift", "SwiftUI"
  e "SF Symbols" são marcas da Apple Inc. Este projeto não é afiliado nem
  endossado pela Apple.
- A menção à Apple Developer Academy — PUC-Rio descreve o contexto acadêmico em
  que o projeto foi feito. Nenhum logotipo da Apple, da Academy ou da PUC-Rio é
  distribuído neste repositório.
