# 🎯 NOOX Phase 4.1 - Quick Start Guide

> Tudo que você precisa para retomar o desenvolvimento imediatamente

## 📋 Estado Atual (14 Nov, 15h)

✅ **Completado:**
- [x] Documentação CRUD Cliente (arquivo `10-*`)
- [x] Trigger `criar_cliente` - 100% funcional
- [x] Workflow `ler_cliente` - trigger configurado, ação ready
- [x] Especificações `atualizar_cliente` e `deletar_cliente`
- [x] Plano de ação 2 semanas (arquivo `11-*`)

## 🚀 Primeiros Passos (Sábado 15 Nov)

### 1. Configurar ler_cliente (2-3 horas)
```
Bubble > Backend Workflows > ler_cliente
├─ DELETE: Ação "Return data from API" existente
├─ ADD: Novo action "Search database"
│  ├─ Table: Cliente
│  ├─ Filters: escritorioid = trigger.escritorio_id AND id = trigger.cliente_id
│  └─ Constraint: First item only
└─ RETURN: Resultado da busca

Testes: 3 cenários (sucesso, 404, 403)
```

### 2. Criar atualizar_cliente (3-4 horas)
```
Bubble > Backend Workflows > NEW: atualizar_cliente
├─ Trigger: atualizar_cliente_trigger (13 parâmetros)
├─ Action 1: Search para validar permissão
├─ Action 2: Make changes (campos condicionais)
└─ Action 3: Return updated cliente

Validação: email/CNPJ únicosTestes: 5 cenários
```

### 3. Criar deletar_cliente (2-3 horas)
```
Bubble > Backend Workflows > NEW: deletar_cliente
├─ Trigger: deletar_cliente_trigger (3 parâmetros)
├─ Action 1: Search related Pedidos
├─ Action 2: IF pedidos found → return erro
├─ Action 3: Make changes (SOFT DELETE)
│  ├─ status = 'deletado'
│  └─ deleted_at = now()
└─ Return: Success message

Testes: 4 cenários
```

## 🚧 Referências

### Documentação Principal
- **`10-phase4-crud-workflows-cliente-completo.md`** → Especificações detalhadas
- **`11-phase4-action-plan-proximas-semanas.md`** → Roadmap completo 2 semanas

### Referencial de Workflows
```
cRIAR_CLIENTE: ✅ Completo + implementado
  └─ Trigger: crear_cliente_trigger
  └─ Action: Create a new Cliente
  └─ Return: cliente_id

LER_CLIENTE: 🚫 Em Progresso (ação precisa de query logic)
  └─ Trigger: ler_cliente_trigger ✅
  └─ Action: [CONFIGURAR: Search database]
  └─ Return: Full Cliente object

ATUALIZAR_CLIENTE: 📃 Especificado (pronto para criar)
DELETAR_CLIENTE: 📃 Especificado (pronto para criar)
```

## ✅ Checklist Esta Semana

- [ ] Sábado (15): Configurar `ler_cliente` + testes
- [ ] Domingo (16): Criar `atualizar_cliente` + validações
- [ ] Segunda (17): Criar `deletar_cliente` + soft delete
- [ ] Terça (18): Testes integrados 8 cenários
- [ ] Quarta (19): Buffer & refinamento
- [ ] Quinta (20): Preparar para Tier 2

## 💲 Ferramentas Necessárias

- **Bubble:** https://bubble.io/page?id=noox-sistema-de-gesto
- **Supabase:** Dashboard para verificar RLS + índices
- **Postman/Insomnia:** Para testar endpoints
- **GitHub:** Para commits finais

## 💡 Dicas Importantes

1. **Multi-tenant:** SEMPRE incluir `escritorio_id` nas queries
2. **Soft Delete:** Não usar hard delete, preserva dados
3. **Validação:** Duplicatas ANTES de atualizar
4. **Testes:** 3 cenários mínimos por workflow
5. **Commits:** Depois de cada dia completado

## 🗑️ Série de Trabalho Recomendada

```
✅ Phase 4.1 - Cliente (12 Nov - 26 Nov) ← Atual
✅ Phase 4.2 - Pedido (26 Nov - 3 Dez)
✅ Phase 4.3 - Orçamento (3 Dez - 10 Dez)
✅ Phase 4.4+ - Tier 2 (10 Dez em diante)
```

## 🔰 Suporte Rápido

| Problema | Solução |
|----------|----------|
| Query lenta | Criar índice no Supabase em escritorioid |
| Validação falha | Adicionar condição "only if not empty" |
| Soft delete não funciona | Verificar se campo `deleted_at` existe em Data Types |
| Trigger sem parâmetros | Recarregar página do Bubble |

---

**Versão:** 1.0  
**Atualizado:** 14 Nov 2025, 15h  
**Próxima revisão:** 22 Nov (se necessário)
