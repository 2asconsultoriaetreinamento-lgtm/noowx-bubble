# 🎯 Phase 4.1 - Plano de Ação Executivo

**Data:** 14 de Novembro de 2025
**Responsável:** NOOX Development Team
**Status:** 🟢 PRONTO PARA EXECUÇÃO
**Deadline Tier 1:** 30 de Novembro de 2025

---

## 📌 Situação Atual

✅ **Completado:**
- Documentação completa de 4 workflows CRUD Cliente
- Trigger `ler_cliente_trigger` configurado em Bubble
- Workflow `criar_cliente` 100% implementado
- Especificações de `atualizar_cliente` e `deletar_cliente` prontas
- Todas as decisões arquiteturais documentadas em português BR

⏳ **Em Progresso:**
- Ação READ em `ler_cliente` (query logic pending)
- Testes de integração Cliente ↔ Bubble ↔ Supabase

---

## 🚀 Semana 1: Finalizar Cliente (15-21 Nov)

### Segunda (15 Nov) - Configurar ler_cliente
**Tempo estimado:** 2-3 horas

```bubble
Workflow: ler_cliente
├─ Trigger: ler_cliente_trigger ✅ (já existe)
├─ Action: Search database
│  ├─ Table: Cliente
│  ├─ Filters:
│  │  ├─ escritorioid is [ler_cliente_trigger writorio_id]
│  │  └─ id is [ler_cliente_trigger cliente_id]
│  ├─ Sorting: (nenhum necessário)
│  └─ Constraint: First item only
└─ Return: Result of search (the Cliente)

Testes:
✓ Teste 1: Cliente existe → Retorna objeto completo
✓ Teste 2: Cliente não existe → Retorna erro 404
✓ Teste 3: escritorio_id não coincide → Retorna erro 403
```

**Checklist:**
- [ ] Deletar ação "Return data from API" anterior
- [ ] Adicionar ação "Search database"
- [ ] Configurar filters (2 condições)
- [ ] Testar 3 cenários
- [ ] Validar resposta JSON

---

### Terça (16 Nov) - Criar atualizar_cliente
**Tempo estimado:** 3-4 horas

```bubble
Workflow: atualizar_cliente
├─ Trigger: atualizar_cliente_trigger (criar novo)
│  └─ Parâmetros: cliente_id, escritorio_id + 11 campos opcionais
├─ Action 1: Search database (verificar permissão)
│  └─ Validar: Cliente existe AND pertence ao escritorio
├─ Action 2: Make changes to a thing
│  ├─ Campos condicionais (only if not empty):
│  │  ├─ nome ← cliente_nome
│  │  ├─ email ← cliente_email (validar duplicata ANTES)
│  │  ├─ cnpj ← cliente_cnpj (validar duplicata ANTES)
│  │  ├─ telefone ← cliente_telefone
│  │  ├─ razao_social ← cliente_razao_social
│  │  ├─ endereco ← cliente_endereco
│  │  ├─ cidade ← cliente_cidade
│  │  ├─ cep ← cliente_cep
│  │  ├─ estado ← cliente_estado
│  │  ├─ status ← client_status
│  │  └─ updated_at ← Current date/time
│  └─ Return: Updated cliente
└─ Tratamento de erros: Capturar duplicatas, permissões

Validações críticas:
✓ Se email fornecido → verificar se email já existe EM OUTRO cliente
✓ Se CNPJ fornecido → verificar se CNPJ já existe EM OUTRO cliente
✓ Se nenhum campo fornecido → retornar erro 400
```

**Checklist:**
- [ ] Criar novo workflow `atualizar_cliente`
- [ ] Criar trigger com 13 parâmetros
- [ ] Adicionar ação 1: Search para validação
- [ ] Adicionar ação 2: Make changes com campos condicionais
- [ ] Adicionar validação de duplicatas
- [ ] Testar 5 cenários

---

### Quarta (17 Nov) - Criar deletar_cliente
**Tempo estimado:** 2-3 horas

```bubble
Workflow: deletar_cliente
├─ Trigger: deletar_cliente_trigger
│  ├─ Parâmetro 1: cliente_id (required)
│  ├─ Parâmetro 2: escritorio_id (required)
│  ├─ Parâmetro 3: confirmar_delecao (yes/no, required)
│  └─ Return: text
├─ Action 1: Search related Pedidos (verificar relacionamentos)
├─ Action 2: Conditional - If pedidos encontrados
│  └─ Return erro: "Cliente tem {count} pedidos vinculados"
├─ Action 3: Make changes (SOFT DELETE - recomendado)
│  ├─ status ← 'deletado'
│  ├─ deleted_at ← Current date/time
│  └─ deletado_por_user_id ← [User ID]
└─ Return: Success message com cliente_id

Alternativa (NÃO recomendada): Hard delete
├─ Delete thing (cliente)
└─ Risco: Perder dados históricos
```

**Checklist:**
- [ ] Criar novo workflow `deletar_cliente`
- [ ] Criar trigger com 3 parâmetros
- [ ] Adicionar validação de relacionamentos
- [ ] Implementar soft delete (não hard delete)
- [ ] Testar 4 cenários
- [ ] Verificar logs de deleção

---

### Quinta (18 Nov) - Testes Integrados + Documentação
**Tempo estimado:** 4 horas

#### Teste Suite Completo
```javascript
// Teste 1: Ciclo completo CRUD
1. CREATE cliente ("João Silva", "joão@example.com")
   └─ Validar: cliente_id retornado
   
2. READ cliente (cliente_id)
   └─ Validar: Todos os 10+ campos presentes
   
3. UPDATE cliente (novo_email="joao.silva@example.com")
   └─ Validar: email atualizado, created_at inalterado, updated_at alterado
   
4. DELETE cliente (soft delete)
   └─ Validar: status='deletado', deleted_at preenchido
   
5. READ cliente deletado
   └─ Validar: Ainda retorna dados (soft delete), status='deletado'

// Teste 2: Validações de Segurança
6. Tentar ler cliente com escritorio_id incorreto
   └─ Validar: Erro 403 Forbidden
   
7. Tentar criar com email duplicado
   └─ Validar: Erro "Email já existe"
   
8. Tentar deletar cliente com pedidos
   └─ Validar: Erro "Cliente tem {N} pedidos"
```

#### Documentar Testes
- [ ] Criar arquivo `11-phase4-cliente-test-results.md`
- [ ] Registrar 8 testes (passou/falhou)
- [ ] Anotar bugs encontrados
- [ ] Screenshots das respostas JSON
- [ ] Commit: "test(phase4): Adicionar testes integrados Cliente"

---

### Sexta (19 Nov) - Buffer & Refinamento
**Tempo estimado:** 2-3 horas (reserva)

- [ ] Corrigir bugs encontrados na quinta
- [ ] Otimizar queries lentas
- [ ] Revisar documentação
- [ ] Preparar para Tier 2 (Pedido)
- [ ] Status meeting com equipe

---

## 🏗️ Semana 2: Começar Tier 1 (22-28 Nov)

### Segunda (22 Nov) - Criar workflows Pedido
**Incrementar complexidade:**
- Pedido tem relacionamento com Cliente
- Validar cliente_id existe e pertence ao escritorio
- Itens de pedido (sub-tabela ou array de objetos)
- Total de 15+ campos

```bubble
Workflows a criar:
1. criar_pedido
   ├─ Parâmetros: cliente_id, vendedor_id, data, total, itens[]
   ├─ Validar: Cliente existe
   └─ Criar e retornar pedido

2. ler_pedido
   ├─ Retornar pedido com itens relacionados
   
3. atualizar_pedido
   ├─ Atualizar status (pendente → aprovado → entregue)
   
4. deletar_pedido
   ├─ Soft delete com motivo
```

---

### Terça-Quinta (23-25 Nov)
**Criar workflows Orçamento** (mesmo padrão que Pedido)

```bubble
4 workflows:
1. criar_orcamento
2. ler_orcamento
3. atualizar_orcamento
4. deletar_orcamento
```

**Total Tier 1: 12 workflows** (3 entidades × 4 operações)

---

### Sexta (26 Nov) - Testes Tier 1
- Testes integrados: Cliente → Pedido → Orçamento
- Validar isolamento por escritorio_id
- Teste de permissões
- Performance testing

---

## 📊 Métricas de Sucesso

### Semana 1 (Cliente)
- ✅ 4 workflows CRUD operacionais
- ✅ 100% testes passando
- ✅ 0 bugs críticos
- ✅ Documentação completa

### Semana 2 (Pedido + Orçamento)
- ✅ 8 workflows adicionais
- ✅ Relacionamentos Client → Pedido → Orçamento
- ✅ Tier 1 completo = 12 workflows

---

## 🔗 Dependências & Riscos

### Dependências
- ✅ Bubble app disponível (já está)
- ✅ Supabase database criado (já está)
- ✅ RLS policies configuradas (VERIFICAR)
- ✅ Data Types com fields (já está)

### Riscos Identificados
1. **Query timeout em busca com muitos filtros**
   - Mitigação: Criar índices no Supabase
   
2. **Validação de duplicatas lenta**
   - Mitigação: Usar constraint de database + validação Bubble
   
3. **Soft delete sem índice em status**
   - Mitigação: Criar índice em campo `deleted_at`

---

## 📋 Checklist Final

### Antes de Começar (Hoje)
- [ ] Ler documentação `10-phase4-crud-workflows-cliente-completo.md`
- [ ] Verificar RLS policies no Supabase
- [ ] Ter Bubble editor aberto e pronto
- [ ] Ter Postman/Insomnia aberto para testes de API
- [ ] Criar pasta `/tests` no repositório para test results

### Commit Final Esta Semana
```bash
git commit -m "feat(phase4): Implementar 4 workflows CRUD Cliente completo

- criar_cliente: 100% funcional
- ler_cliente: 100% funcional com Search database
- atualizar_cliente: 100% funcional com validações
- deletar_cliente: 100% funcional com soft delete

Testes: 8/8 cenários passando
Documentação: Completa em PT-BR
Proto para Tier 2 (Pedido/Orçamento)"
```

---

## 📞 Suporte & Escalação

**Se preso em:**
- Bubble query: Consultar docs → https://manual.bubble.io/
- Supabase RLS: Verificar policies → Dashboard Supabase
- JSON validation: Testar em Postman/Insomnia
- GitHub: Documentar com screenshots

---

**Próxima revisão deste plano:** 22 de Novembro (final da Semana 1)
