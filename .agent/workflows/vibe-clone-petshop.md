---
description: Clonar e adaptar a Landing Page Tema "Petshop Wonderland" para Clínicas Veterinárias
---

# 🐾 Workflow: Vibe Clone Petshop

Este workflow guia o processo de clonar a base estética "Petshop Wonderland", criada para transmitir acolhimento, fofura e um ambiente super limpo e seguro focado nos tutores de pets. A base possui cores pastéis vibrantes, componentes bento box sofisticados e background CSS abstrato para alta performance e leiturabilidade.

## 📝 Regras de Uso
O NOME DO DIRETÓRIO DESTINO deve estar criado como um novo projeto. O user passará as informações da clínica nova e a IA executará os seguintes passos para refatorar o conteúdo.

## 🛠️ Passo a Passo de Edição

**0. Fase Research (RPI-R) — Pesquisa e Contexto Pré-Clone:**
Antes de tocar em qualquer arquivo, o agente DEVE:
- Scrape o **Google Meu Negócio** do cliente: nome oficial, nota, reviews reais, horários, endereço, fotos, serviços.
- Scrape o site atual do cliente (se existir) para extrair branding (cores, logo, tom de voz, mascote se houver).
- Analise no mínimo **2 concorrentes locais** (clínicas vet/petshops na mesma região) para benchmarking visual.
- Consulte a skill `ux-ui-architect-2026` para selecionar a **paleta de cores** ideal (Warm Organic, Soft Pastel, etc.).
- Documente os achados em um comentário no topo do PR ou em um arquivo `RESEARCH_NOTES.md` temporário.
- **Regra de Ouro:** Nunca saia escrevendo código em um único prompt; quebre o trabalho em subplanos.

**1. Atualização dos Metadados Corporativos:**
- Atualize no **`index.html`**: O título da clínica, favicons (se houver) e decrições SEO.
- Identifique globalmente e troque os dados mestres:
  - `Nome da Clínica Vet / Petshop`
  - `Endereço e Bairro`
  - `Links de WhatsApp`
  - `Avaliações Reais do Google e Score (ex: 4.8, 5.0)`
  - `Dias de Funcionamento` (ex: Plantão 24h, Seg a Sáb)

**2. Branding & Design System (`tailwind.config.ts` | `index.css`):**
O template Wonderland utiliza "formas fluidas" e cores super brilhantes que parecem "doces" (pastéis).
- **Cores**: Verifique a paleta do cliente. Ajuste o Sky, Rose, Mint ou Amber para as cores de logo do cliente mantendo a vibe "soft" e claro (`bg-surface-base` como creme leve ou super branco).
- Mantenha os utilitários CSS do index (efeitos `puffy-glass`).

**3. Adaptação Dinâmica do Conteúdo dos Componentes:**
Você deve escanear estas pastas e injetar os novos textos:
- **`HeroSection.tsx`**: 
  - O Background CSS deve ser ajustado para matizar as cores primárias do cliente. 
  - Títulos amorosos para donos de pet ("Tecnologia e muito carinho para o seu filho de 4 patas").
  - Métricas fluídas via framer motion (clientes satisfeitos, avaliações lindas).
- **`ServicesBentoBox.tsx`**: 
  - Substituir os textos do BentoCard para a realidade do local. 
  - Mantenha os 4 layouts de cartões mágicos (bg solid com decorativo, pastel com icone, white card com tags).
  - Preencha com os serviços (ex: Banho e Tosa, Especialidades, Ultrassom, Internação, Vacinas).
- **`AboutSection.tsx`**:
  - Trocar as métricas numéricas ("X pets atendidos", "Y anos de mercado").
- **`TestimonialsSection.tsx` & `FAQSection.tsx`**:
  - Injetar feedback verídico. Responder dúvidas tipo "Tem raio X de emergência?".

**4. Geração de Midia Padrão:**
O Hero desse template não usa imagem foto, usa formas CSS abstratas. Mas precisamos para o componente About ou outros destaques:
- Gere via IA `about_bg.png`: "happy clean interior of professional veterinary clinic, smiling golden retriever looking at camera, pastel tone, photography high quality 8k".

**5. Quality Gate de Frontend (UX/UI 2026):**
Antes do commit final, invoque mentalmente a skill `ux-ui-architect-2026` e revise TODO o output:
- **Checklist obrigatório:**
  - [ ] Superfícies possuem efeitos **Liquid Glass / Puffy Glass** (backdrop-blur, bordas reflexivas, sombras multicamadas)
  - [ ] **Maximalismo Tátil** aplicado no Hero (tipografia expressiva, cores pastéis vibrantes, alto contraste)
  - [ ] **WCAG 2.2** cumprido (`:focus-visible` visível, alvos de clique ≥ 24x24px, contraste ≥ 4.5:1)
  - [ ] **Microinterações** presentes (Framer Motion, hover effects, fade-in-up no scroll)
  - [ ] Cores são curadas/harmonizadas (paleta Warm Organic ou Soft Pastel, não genéricos)

**6. Padrão Final:**
Execute a verificação de código.
```bash
npm run lint
npm run build
```
Certifique-se de que nenhum componente do framer motion tenha erros visuais e comunique o usuário na finalização.
