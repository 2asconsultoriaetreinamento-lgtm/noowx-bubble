# Phase 4.1 - Workflows CRUD Completo: Cliente

**Data:** 2025-11-14
**Status:** 📋 DOCUMENTAÇÃO COMPLETA (Pronto para Implementação)
**Versão:** 1.0

## Descrição Geral

Este documento especifica a implementação completa dos 4 workflows CRUD para a entidade **Cliente** em Bubble Backend Workflows. Estes workflows fornecem as operações fundamentais (CREATE, READ, UPDATE, DELETE) necessárias para gerenciar clientes no sistema NOOX com suporte a multi-tenant via `escritorio_id`.

---

## Arquitetura & Padrões

### Estrutura de Workflow
Cada workflow segue o padrão:
```
Custom Event Trigger (com parâmetros)
        ↓
  Validação de Entrada
        ↓
  Operação no Banco de Dados
        ↓
  Tratamento de Erros
        ↓
  Retorno de Dados
```

### Multi-Tenant & Segurança
- **CRÍTICO:** Todos os workflows DEVEM incluir `escritorio_id` nas operações
- Campo obrigatório em TODAS as queries para garantir isolamento de dados
- RLS (Row Level Security) do Supabase deve ser respeitado
- Validação de autenticação do usuário em cada workflow

---

## 1. WORKFLOW: criar_cliente (CREATE)

### ✅ Status: COMPLETO E IMPLEMENTADO

### Trigger
**Nome:** `criar_cliente_trigger`
**Tipo:** Custom Event (Backend)
**Descrição:** Triggered quando um novo cliente precisa ser criado

### Parâmetros de Entrada

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|----------|
| escritorio_id | text | SIM | ID do Escritório (multi-tenant) |
| cliente_nome | text | SIM | Nome completo do cliente |
| cliente_email | text | SIM | Email do cliente |
| cliente_telefone | text | NÃO | Telefone para contato |
| cliente_cnpj | text | SIM | CNPJ/CPF do cliente |
| cliente_razao_social | text | SIM | Razão Social |
| cliente_endereco | text | SIM | Endereço completo |
| cliente_cidade | text | SIM | Cidade |
| cliente_cep | text | SIM | CEP |
| cliente_estado | text | SIM | Estado (UF) |

### Ação - Data (Things): Create a new Cliente

**Campo Mapeado** → **Valor da Fonte**
```
escritorioid          ← escritorio_id (trigger parameter)
nome                  ← cliente_nome
email                 ← cliente_email
telefone              ← cliente_telefone
cnpj                  ← cliente_cnpj
razao_social          ← cliente_razao_social
endereco              ← cliente_endereco
cidade                ← cliente_cidade
cep                   ← cliente_cep
estado                ← cliente_estado
created_at            ← Current date/time
status                ← 'ativo' (default)
```

### Valor de Retorno
**Tipo:** Cliente
**Campo:** clienteId (retorna o ID do novo cliente criado)

### Tratamento de Erros
- ✓ Validar se email já existe (duplicate key error)
- ✓ Validar se CNPJ já existe
- ✓ Validar se escritorio_id é válido
- ✓ Retornar mensagem de erro descritiva em português

---

## 2. WORKFLOW: ler_cliente (READ)

### ⏳ Status: EM DESENVOLVIMENTO (Trigger criado, ação pendente)

### Trigger
**Nome:** `ler_cliente_trigger`
**Tipo:** Custom Event (Backend)
**Descrição:** Consulta e retorna dados de um cliente específico

### Parâmetros de Entrada

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|----------|
| escritorio_id | text | SIM | ID do Escritório (multi-tenant) |
| cliente_id | text | SIM | ID único do cliente a ser consultado |

### Ação - Search Database / Get Thing

**Approach A (Recomendado):** Usar "Search database > first item"
```
Table: Cliente
Filters:
  - escritorioid is escritorio_id
  - id is cliente_id
Result: Return first item (the full Cliente object)
```

**Alternative:** Return Data from API com query builder

### Valor de Retorno
**Tipo:** Cliente (objeto completo com todos os campos)
**Estrutura JSON:**
```json
{
  "cliente": {
    "id": "...",
    "escritorioid": "...",
    "nome": "...",
    "email": "...",
    "telefone": "...",
    "cnpj": "...",
    "razao_social": "...",
    "endereco": "...",
    "cidade": "...",
    "cep": "...",
    "estado": "...",
    "status": "...",
    "created_at": "...",
    "updated_at": "..."
  }
}
```

### Tratamento de Erros
- ✓ Validar permissões: cliente pertence ao escritório do usuário
- ✓ Retornar 404 se cliente não encontrado
- ✓ Retornar erro se writings_id não coincide (segurança multi-tenant)

---

## 3. WORKFLOW: atualizar_cliente (UPDATE)

### ⏳ Status: NÃO INICIADO (Documentação de especificação)

### Trigger
**Nome:** `atualizar_cliente_trigger`
**Tipo:** Custom Event (Backend)
**Descrição:** Atualiza dados de um cliente existente

### Parâmetros de Entrada

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|----------|
| escritorio_id | text | SIM | ID do Escritório (multi-tenant) |
| cliente_id | text | SIM | ID do cliente a atualizar |
| cliente_nome | text | NÃO | Novo nome (se alterar) |
| cliente_email | text | NÃO | Novo email (se alterar) |
| cliente_telefone | text | NÃO | Novo telefone |
| cliente_cnpj | text | NÃO | Novo CNPJ (validar duplicata) |
| cliente_razao_social | text | NÃO | Nova razão social |
| cliente_endereco | text | NÃO | Novo endereço |
| cliente_cidade | text | NÃO | Nova cidade |
| cliente_cep | text | NÃO | Novo CEP |
| cliente_estado | text | NÃO | Novo estado |
| client_status | text | NÃO | Novo status ('ativo', 'inativo', 'suspenso') |

### Ação - Data (Things): Make changes to a thing

**Lógica:**
1. Buscar cliente por ID e escritorio_id
2. Verificar permissões (cliente pertence ao escritório)
3. Atualizar apenas os campos fornecidos (not empty)
4. Definir updated_at timestamp
5. Retornar cliente atualizado

**Campos a atualizar (condicionalmente):**
```
IF cliente_nome is not empty:
  nome ← cliente_nome

IF cliente_email is not empty:
  VALIDATE: email não é duplicado
  email ← cliente_email

IF cliente_cnpj is not empty:
  VALIDATE: CNPJ não é duplicado
  cnpj ← cliente_cnpj

... (repetir para outros campos)

ALWAYS:
  updated_at ← Current date/time
```

### Valor de Retorno
**Tipo:** Cliente (objeto atualizado)
**Campo:** id do cliente atualizado

### Tratamento de Erros
- ✓ Validar se cliente existe
- ✓ Validar se escritorio_id coincide
- ✓ Detectar tentativa de duplicar email/CNPJ
- ✓ Validar formato de dados
- ✓ Retornar 400 se nenhum campo para atualizar

---

## 4. WORKFLOW: deletar_cliente (DELETE)

### ⏳ Status: NÃO INICIADO (Documentação de especificação)

### Trigger
**Nome:** `deletar_cliente_trigger`
**Tipo:** Custom Event (Backend)
**Descrição:** Deleta um cliente do sistema

### Parâmetros de Entrada

| Parâmetro | Tipo | Obrigatório | Descrição |
|-----------|------|-------------|----------|
| escritorio_id | text | SIM | ID do Escritório |
| cliente_id | text | SIM | ID do cliente a deletar |
| confirmar_delecao | yes/no | SIM | Confirmação de deleção (segurança) |

### Ação - Data (Things): Delete a thing

**Lógica:**
1. Validar cliente existe e pertence ao escritório
2. Verificar permissões de deleção
3. OPÇÃO A: Hard delete (remover completamente)
4. OPÇÃO B: Soft delete (marcar como 'deletado')
5. Sugestão: Usar soft delete para manter histórico

**Implementação recomendada (Soft Delete):**
```
Make changes to Cliente:
  status ← 'deletado'
  deleted_at ← Current date/time
```

### Valor de Retorno
**Tipo:** text
**Valor:** "Cliente {id} deletado com sucesso" ou ID do cliente deletado

### Tratamento de Erros
- ✓ Validar se cliente existe
- ✓ Validar se escritorio_id coincide
- ✓ Verificar se cliente tem pedidos/relacionamentos
- ✓ Avisar se há dados referenciados
- ✓ Retornar 403 se não tem permissão

---

## Resumo de Implementação

| Workflow | Status | Trigger | Ação | Retorno |
|----------|--------|---------|------|----------|
| criar_cliente | ✅ Completo | criar_cliente_trigger | Create new Cliente | Cliente.id |
| ler_cliente | ⏳ Em Dev | ler_cliente_trigger | Search database | Full Cliente object |
| atualizar_cliente | ⏹️ Pendente | atualizar_cliente_trigger | Make changes | Updated Cliente |
| deletar_cliente | ⏹️ Pendente | deletar_cliente_trigger | Delete/Archive | Confirmation |

---

## Próximos Passos

1. ✅ Completar implementação do ler_cliente
2. ⏳ Criar atualizar_cliente workflow
3. ⏳ Criar deletar_cliente workflow
4. ⏳ Testar todos os 4 workflows com dados de teste
5. ⏳ Documentar casos de erro e edge cases
6. ⏳ Prosseguir para Tier 2 (Pedido e Orcamento)

---

**Autor:** NOOX Development Team
**Última Atualização:** 2025-11-14
**Próxima Revisão:** Após conclusão de todos os 4 workflows
