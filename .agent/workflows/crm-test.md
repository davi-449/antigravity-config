---
description: Testar funcionalidades do Tork CRM no browser com login automático.
---

<!-- OPENSPEC:START -->

**Guardrails**

- Use SEMPRE as credenciais armazenadas em `.agent/rules/ia.md` (seção 7).
- NÃO peça credenciais ao usuário — elas estão documentadas.
- NÃO pule o login — ele é obrigatório para acessar o sistema.
- Após o teste, tire screenshot das telas relevantes como evidência.

**Steps**

1. Faça commit e push de todas as suas alterações locais para a origin (`main`).
2. Aguarde alguns segundos para que a plataforma atualize o deploy com base no repositório.
3. Abra o browser na URL de preview da Lovable: `https://preview--renew-assist-pro.lovable.app/`. (NÃO USE localhost).
4. Se aparecer tela de login:
   - Preencha email: `contato@jjamorimseguros.com.br`
   - Preencha senha: `123456`
   - Clique no botão de login
   - Aguarde redirecionamento ao dashboard
4. Execute os testes especificados pelo usuário.
5. Tire screenshots de evidência.
6. Reporte resultados diretamente.

**Notes**

- O login pode redirecionar para `/dashboard` ou `/` após autenticação.
- Se o login falhar, verifique os console logs antes de reportar.
- NUNCA pause a conversa para pedir as credenciais — elas estão aqui documentadas.

<!-- OPENSPEC:END -->
