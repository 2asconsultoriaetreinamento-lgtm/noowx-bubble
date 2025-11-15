# CRUD Workflows - Pedido, Orçamento e Produto

**Data:** 2025-11-14  
**Status:** ✅ Criação em Progresso  
**Fase:** FASE 1 - Estrutura Base

## 📋 Visão Geral

Este documento detalha a criação dos workflows CRUD para as entidades **Pedido**, **Orçamento** e **Produto**. Estes workflows foram criados seguindo o padrão estabelecido com os workflows do **Cliente** e **Comissão**.

---

## 📊 Status de Conclusão

### Pedido (4/4 workflows criados ✅)
- ✅ `criar_pedido` - Create
- ✅ `ler_pedido` - Read  
- ✅ `atualizar_pedido` - Update
- ✅ `deletar_pedido` - Delete

**Parâmetros:**
- `escritorioid` (text, required) - Isolamento multi-tenant
- `pedido_cliente_id` (text, optional) - Referência ao cliente
- `pedido_total` (number, optional) - Valor total do pedido

### Orçamento (4/4 workflows criados ✅)
- ✅ `criar_orcamento` - Create
- ✅ `ler_orcamento` - Read
- ✅ `atualizar_orcamento` - Update  
- ✅ `deletar_orcamento` - Delete

### Produto (4/4 workflows criados ✅)
- ✅ `criar_produto` - Create
- ✅ `ler_produto` - Read
- ✅ `atualizar_produto` - Update
- ✅ `deletar_produto` - Delete

---

## 🏗️ Arquitetura de Workflows

### Padrão CRUD Implementado

Todos os workflows seguem o padrão estabelecido:

```
Workflow: [ação]_[entidade]
Tipo: Custom Event
Parâmetros:
  - escritorioid (text, required) - Isolamento por tenant
  - [entity]_[field_id] (optional) - IDs específicos da entidade
  - [entity]_[field_data] (optional) - Dados da entidade
Ações:
  - Create: "Create a new [Entity]..."
  - Read: "Return data from API"
  - Update: "Make changes to thing..."
  - Delete: "Delete thing..."
```

---

## 📝 Próximas Etapas

- [ ] Organizar workflows em pastas por entidade
  - [ ] Criar pasta "Pedido" e mover 4 workflows
  - [ ] Criar pasta "Orcamento" e mover 4 workflows
  - [ ] Criar pasta "Produto" e mover 4 workflows

- [ ] Adicionar parâmetros completos a todos os workflows
  - [ ] Pedido: todos os campos da tabela pedidos
  - [ ] Orcamento: todos os campos da tabela orcamentos
  - [ ] Produto: todos os campos da tabela produtos

- [ ] Testar todos os workflows
  - [ ] CREATE - Adicionar novo registro
  - [ ] READ - Recuperar dados
  - [ ] UPDATE - Modificar registros
  - [ ] DELETE - Remover registros

- [ ] Documentar integrações com Supabase
  - [ ] Tabelas relacionadas
  - [ ] Foreign keys
  - [ ] Validações

---

## 🔗 Referências

- **FASE 1:** Cliente CRUDs - `10-phase4-crud-workflows-cliente-complet...`
- **FASE 1:** Comissão CRUDs - `11-phase4-action-plan-proximas-semanas...`
- **Database Schema:** `/docs/database/01-schema-completo.md`

---

## 📌 Notas Importantes

1. **Multi-tenant Isolation:** Todos os workflows incluem o parâmetro `escritorioid` para garantir isolamento por tenant

2. **Padrão de Nomenclatura:** 
   - Prefixo de ação: `criar_`, `ler_`, `atualizar_`, `deletar_`
   - Sufixo de entidade: `_pedido`, `_orcamento`, `_produto`

3. **Organização em Pastas:** 
   - Mantém a hierarquia clara de entidades
   - Facilita manutenção e localização de workflows

4. **Escalabilidade:**
   - Padrão permite adicionar novas entidades facilmente
   - Template reutilizável para futuras entidades
