---
description: Clonar e adaptar a Landing Page Premium de Mecânica para um novo cliente
---

# 🚗 Workflow: Vibe Clone Mecânica

Este workflow guia o processo de clonar a base de excelência criada para oficinas mecânicas (Estética Dark/Técnica/Esportiva) para um novo cliente no segmento automotivo. A base original possui componentes prontos de Hero interativo com carros de fundo, Bento Box de serviços automotivos, FAQ, Localização com Mapas e Testimonials flutuantes.

## 📝 Regras de Uso
O NOME DO DIRETÓRIO DESTINO deve estar criado como um novo projeto React ou a base clonada vazia. O dev humano fornecerá um JSON ou texto simples com as informações da mecânica nova. A IA deverá seguir os passos abaixo para customizar todos os arquivos.

## 🛠️ Passo a Passo de Edição

**0. Fase Research (RPI-R) — Pesquisa e Contexto Pré-Clone:**
Antes de tocar em qualquer arquivo, o agente DEVE:
- Scrape o **Google Meu Negócio** do cliente: nome oficial, nota, reviews reais, horários, endereço, fotos.
- Scrape o site atual do cliente (se existir) para extrair branding (cores, logo, tom de voz).
- Analise no mínimo **2 concorrentes locais** (oficinas na mesma região) para benchmarking visual.
- Consulte a skill `ux-ui-architect-2026` para selecionar a **paleta de cores** ideal (Dark Technical, Premium Classic, etc.).
- Documente os achados em um comentário no topo do PR ou em um arquivo `RESEARCH_NOTES.md` temporário.
- **Regra de Ouro:** Nunca saia escrevendo código em um único prompt; quebre o trabalho em subplanos.

**1. Levantamento e Ajuste de Configurações Globais:**
Altere as informações estáticas da empresa em todo o repositório.
- **`index.html`**: Alterar `<title>`, `meta description`, e tags de `Open Graph`.
- **Informações Base**: Extraia e substitua nos componentes os seguintes dados:
  - `Nome da Mecânica`
  - `Endereço Completo`
  - `Horários de Funcionamento`
  - `Número de Telefone (WhatsApp)`
  - `Total de Avaliações no Google` e `Nota (ex: 4.9)`

**2. Ajustes de Branding & Design System (`tailwind.config.ts`):**
Adapte as cores primárias dependendo do perfil da oficina (Esportiva = Red/Orange, Luxo = Zinc/Gold, Alta Tecnologia = Blue/Cyan).
- A base é o **Dark Mode Technical**: Mantenha fundos escuros (`zinc-950` ou `slate-950`) e superfícies glassmórficas (`bg-white/5`).
- Altere `colors.primary` e variantes no Tailwind.

**3. Atualização de Componentes React (Substituição de Texto e Ícones):**
Procure por esses arquivos e injete as informações exclusivas da Mecânica Nova.
- **`HeroSection.tsx`**: 
  - Título principal de impacto (Ex: "A Melhor Oficina de [Cidade]").
  - Atualizar link e mensagem do botão de Call To Action (Agendar Agora).
- **`ServicesBentoBox.tsx`**: 
  - Mapear de 4 a 6 serviços essenciais do cliente (Injeção Eletrônica, Suspensão, Revisão Preventiva, Câmbio AT, etc).
  - Alterar ícones Lucide associados (Wrench, Settings, Activity, Gauge).
- **`AboutSection.tsx`**:
  - Ajustar o texto da história, o tempo de mercado (anos de experiência) e estatísticas.
- **`TestimonialsSection.tsx`**:
  - Injetar no mínimo 3 reviews reais do Google Meu Negócio do cliente. Títulos e nome dos clientes.
- **`FAQSection.tsx`**:
  - Adicionar perguntas padrão respondidas (ex: "Vocês buscam o carro?", "Trabalham com qual marca?").
- **`Navbar.tsx` & `Footer.tsx`**:
  - Atualizar links, endereços, logo (se em texto) e redes sociais.

**4. Imagens AI Prompting (`src/assets/`):**
A IA deverá gerar 2 imagens essenciais caso o cliente não as forneça:
- `hero_bg.png`: "dark cinematic lighting, modern auto repair shop, luxury car on a lift, dramatic focus, high quality, 8k resolution"
- `about_bg.png`: "professional mechanic in clean uniform, fixing car engine, garage background blurred, high confidence, realistic cinematic photo"

**5. Quality Gate de Frontend (UX/UI 2026):**
Antes do commit final, invoque mentalmente a skill `ux-ui-architect-2026` e revise TODO o output:
- **Checklist obrigatório:**
  - [ ] Superfícies possuem **Apple Liquid Glass** (backdrop-blur, bordas reflexivas `border-white/10`, sombras multicamadas)
  - [ ] **Maximalismo Tátil** aplicado no Hero (tipografia 4xl-7xl, cores dopamínicas de alto contraste)
  - [ ] **WCAG 2.2** cumprido (`:focus-visible` visível, alvos de clique ≥ 24x24px, contraste ≥ 4.5:1)
  - [ ] **Microinterações** presentes (hover scale/translateY em cards, fade-in-up no scroll, CTA pulse)
  - [ ] Cores são curadas/harmonizadas (HSL, não genéricos como `red-500`)

**6. Build, Lint e Encerramento:**
Execute os comandos de lint e build no terminal.
```bash
npm run lint
npm run build
```
Certifique-se de não haver erros ou lintings quebrados. Encerre com a notificação ao usuário.
