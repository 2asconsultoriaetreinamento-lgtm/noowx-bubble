# Phase 4.1 - Workflow: criar_cliente

## Data: 2025-11-14
## Status: ✅ COMPLETADO (v1.0)

## Descrição
Primeiro workflow CRUD implementado em Phase 4. Responsável pela criação de novos clientes no sistema com suporte a multi-tenant via `escritorio_id`.

## Trigger
**Nome:** criar_cliente_trigger

### Parâmetros de Entrada
| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|----------|
| escritorio_id | text | Sim | ID do escritório (multi-tenant) |
| cliente_nome | text | Sim | Nome completo do cliente |
| cliente_email | text | Sim | Email do cliente |
| cliente_telefone | text | Não | Telefone do cliente |

### Return Values
| Nome | Tipo | Descrição |
|------|------|----------|
| cliente_id | text | ID do cliente criado (UUID do Bubble) |

## Ações do Workflow

### Step 1: Create a new Cliente
- **Tipo:** Data (Things) - Create a new thing
- **Data Type:** Cliente

#### Mapeamento de Campos
| Campo Bubble | Fonte de Dados | Observações |
|--------------|----------------|-------------|
| escritorioid | escritorio_id | Validação de multi-tenant |
| nome | cliente_nome | Campo obrigatório |
| email | cliente_email | Validação de formato email |
| telefone | cliente_telefone | Campo opcional |

## Fluxo de Execução

```
Trigger: criar_cliente_trigger
  ↓
[Parâmetros validados]
  ↓
Step 1: Create a new Cliente
  • Insere novo registro na tabela Cliente (Bubble)
  • Retorna ID do cliente criado
  ↓
Return: cliente_id
```

## Dados Mapeados
- **escritorioid:** Garante isolamento por escritório (RLS)
- **nome:** Nome do cliente (obrigatório)
- **email:** Email do cliente (obrigatório)
- **telefone:** Telefone do cliente (opcional)

## Melhorias Futuras (Phase 4.2+)

- [ ] Adicionar validação de email duplicado por escritório
- [ ] Implementar error handling completo
- [ ] Adicionar logging de auditoria
- [ ] Validação de permissões do usuário
- [ ] Tratamento de transações
- [ ] Resposta de erro estruturada

## Testes Realizados

- [x] Trigger criado com parâmetros corretos
- [x] Ação de criação mapeada corretamente
- [x] Multi-tenant field (escritorioid) configurado
- [ ] Testes de ponta a ponta (E2E) - Próxima fase
- [ ] Testes de validação - Próxima fase

## Notas Técnicas

- O Bubble gerencia automaticamente o UUID do cliente
- O campo `escritorioid` é crítico para RLS
- Sem tratamento de erro implementado ainda (v1.0)
- Workflow retorna automaticamente o cliente_id criado

## Próximos Workflows (Tier 1 - Cliente)

1. ✅ criar_cliente (CONCLUÍDO)
2. ⏳ ler_cliente (Em andamento)
3. ⏳ atualizar_cliente (Pendente)
4. ⏳ deletar_cliente (Pendente)

## Referências

- [Phase 4 Strategy](./05-phase4-workflows-strategy.md)
- [Data Types](./04-bubble-configuration.md#data-types)
- [Field Mapping Complete](./07-phase3-fields-mapping-complete.md)
