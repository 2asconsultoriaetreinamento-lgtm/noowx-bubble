# Fase 4 - Bubble.io Workflows & CRUD Operations - Estrategia e Arquitetura

## Status: EM PROGRESSO

Esta fase implementa os workflows de backend e operacoes CRUD (Create, Read, Update, Delete) para todas as 23 entidades de dados.

## Arquitetura Geral

```
Bubble.io Frontend
    |
    v
[Workflows]
    |
    +-- CREATE workflows
    +-- READ workflows  
    +-- UPDATE workflows
    +-- DELETE workflows
    |
    v
[Supabase API Connector]
    |
    v
Supabase PostgreSQL
    |
    v
23 Tabelas com RLS Policies
```

## Estructura dos Workflows

Para cada entidade, criar 4 workflows principais:

1. **CREATE Workflow**: criar_<entidade>
   - Trigger: Custom Event
   - Parametros: campos necessarios da entidade
   - Acao: Supabase API - INSERT
   - Retorno: ID do novo registro

2. **READ Workflow**: ler_<entidade>
   - Trigger: Custom Event
   - Parametros: filtros (ID, escritorio_id, etc)
   - Acao: Supabase API - SELECT
   - Retorno: Array de registros

3. **UPDATE Workflow**: atualizar_<entidade>
   - Trigger: Custom Event
   - Parametros: ID e campos a atualizar
   - Acao: Supabase API - UPDATE
   - Retorno: Status de sucesso

4. **DELETE Workflow**: deletar_<entidade>
   - Trigger: Custom Event
   - Parametros: ID do registro
   - Acao: Supabase API - DELETE
   - Retorno: Status de sucesso

## Entidades Prioritarias (Fase 4.1)

Comeca com as 3 entidades principais:
1. Cliente
2. Pedido
3. Orcamento

## Entidades Secundarias (Fase 4.2)

Depois expandir para:
- Comissao
- NotaFiscal
- Produto
- Industria
- E demais 16 tabelas

## Padroes de Implementacao

### Multi-Tenant Safety
```
ALL workflows MUST include:
- escritorio_id validation
- User authentication check
- RLS policy respect
```

### Error Handling
```
Each workflow MUST handle:
- Connection errors
- Validation errors
- Permission errors
- Duplicate key errors
```

### Logging & Monitoring
```
Log all operations:
- User ID
- Timestamp
- Entity type
- Operation type
- Result (success/failure)
```

## Roadmap Fase 4

**Parte 1: Core CRUD (Cliente)**
- criar_cliente workflow
- ler_cliente workflow  
- atualizar_cliente workflow
- deletar_cliente workflow
- Teste completo

**Parte 2: Vendas (Pedido + Orcamento)**
- criar_pedido + relacionados
- criar_orcamento + relacionados
- ler_pedidos (com filtros)
- Teste completo

**Parte 3: Expansao (16 tabelas restantes)**
- Implementar em lote
- Seguir mesmo padrao
- Teste integrado

**Parte 4: Validacao**
- Testes de CRUD end-to-end
- Validacao de RLS
- Teste de performance
- Documentacao final

## Notas de Implementacao

1. **API Supabase ja esta configurada** - Use connector de API existente
2. **Workflows customizados** - Use custom events para CRUD
3. **Parameters** - Passar parametros conforme documentado
4. **Return values** - Sempre retornar resultado da operacao
5. **Error handling** - Tratar erros de forma graceful

## Checkpoint Fase 4

- [ ] 3 entidades principais tem CRUD completo
- [ ] Workflows testad e validados
- [ ] RLS policies respeitadas
- [ ] Documentacao de cada workflow
- [ ] Testes de integracao passando

## Documentos Relacionados

- `04-bubble-configuration.md` - Configuracao de tipos
- `../database/01-schema-completo.md` - Schema do banco
- `../database/03-rls-policies.md` - Politicas de seguranca

## Proximas Fases

**Fase 5:** Criar formularios de entrada de dados
**Fase 6:** Tabelas de visualizacao de dados
**Fase 7:** Autenticacao e autorizacao
**Fase 8:** Testes e ajustes finais
