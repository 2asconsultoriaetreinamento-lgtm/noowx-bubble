# 14 - Phase 4 Workflows Implementation Guide

**Status**: IN PROGRESS - Starting Tier 1 Implementation

**Date**: November 17, 2025, 09:00 BRT

**Summary**: Comprehensive guide for implementing Phase 4 CRUD workflows (92 total). Starting with Tier 1 core entities: Cliente, Pedido, Orcamento.

## Phase 4 Execution Plan - Tier 1 (Core)

### Task 1: Cliente CRUD Workflows (4 workflows)

#### 1.1 - criar_cliente Workflow
**Status**: ✅ Framework initialized
**Parameters**:
- escritorio_id (text, required) - Multi-tenant isolation
- razao_social (text, required) - Company name
- cnpj (text, required) - Tax ID
- email (text, optional)
- telefone (text, optional)
- endereco (text, optional)
- cidade (text, optional)
- estado (text, optional)
- bairro (text, optional)
- cep (text, optional)
- vendedor_id (text, optional)
- status (text, optional)

**API Actions**:
```
1. Validate: Check escritorio_id belongs to current user
2. Validate: Check CNPJ format
3. API Call: INSERT into Cliente table (Supabase)
   - Include all parameters
   - Return: cliente_id, status
4. Error Handling: 
   - Duplicate CNPJ → Return error
   - Invalid escritorio → Reject
   - Missing required fields → Return validation error
```

#### 1.2 - ler_cliente Workflow
**Action**: Query Cliente by ID with escritorio_id filter
**Return**: Complete Cliente object

#### 1.3 - atualizar_cliente Workflow
**Action**: Update Cliente fields by ID
**Validation**: Verify ownership via escritorio_id
**Return**: Updated Cliente object

#### 1.4 - deletar_cliente Workflow  
**Action**: Soft/Hard delete Cliente by ID
**Validation**: Check no active orders
**Return**: Deletion status

---

### Task 2: Pedido CRUD Workflows (4 workflows)

Follows same pattern as Cliente but includes:
- cliente_id (required) - Foreign key
- total_amount (calculated)
- status (enum: draft, submitted, approved, completed)
- Line item relationships (PedidoItem)

---

### Task 3: Orcamento CRUD Workflows (4 workflows)

Follows same pattern as Pedido but for quotes

---

## Workflow Template - Standard CRUD Pattern

### CREATE Pattern
```
Workflow: criar_{entity}

Trigger: Custom event (quando chamado)

Parameters: All required + optional fields

Actions:
1. Validation Step
   - Check escritorio_id validity
   - Validate required fields
   - Check business rules

2. Error Handler
   - If validation fails → Return error message

3. API Call
   - REST API to Supabase
   - INSERT new record
   - Include timestamps (created_at)

4. Return Success
   - Return new record ID + status
```

### READ Pattern
```
Workflow: ler_{entity}

Parameters: 
- entity_id (required)
- escritorio_id (required) - Multi-tenant filter

Actions:
1. API Call - SELECT
   - Filter by ID AND escritorio_id
   - Return full object

2. Error Handler
   - Not found → Return null
   - Unauthorized → Return access denied
```

### UPDATE Pattern
```
Workflow: atualizar_{entity}

Parameters:
- entity_id (required)
- escritorio_id (required)
- Fields to update (optional)

Actions:
1. Validate ownership
   - Verify entity belongs to escritorio_id

2. API Call - UPDATE
   - Only update provided fields
   - Update updated_at timestamp

3. Return updated object
```

### DELETE Pattern
```
Workflow: deletar_{entity}

Parameters:
- entity_id (required)
- escritorio_id (required)

Actions:
1. Check for dependencies
   - If entity has child records → Error

2. API Call - DELETE
   - Remove record from database

3. Return confirmation
```

---

## Multi-Tenant Security Checklist

EVERY workflow MUST verify:

- ✅ escritorio_id parameter present
- ✅ Current user belongs to escritorio_id
- ✅ All queries filtered by escritorio_id
- ✅ No data leakage between offices
- ✅ Error messages don't leak data

---

## Implementation Progress

### Tier 1 - Core (Weeks 1-2)

- [ ] Cliente: CREATE
- [ ] Cliente: READ
- [ ] Cliente: UPDATE  
- [ ] Cliente: DELETE
- [ ] Pedido: CREATE
- [ ] Pedido: READ
- [ ] Pedido: UPDATE
- [ ] Pedido: DELETE
- [ ] Orcamento: CREATE
- [ ] Orcamento: READ
- [ ] Orcamento: UPDATE
- [ ] Orcamento: DELETE
- [ ] Integration Tests
- [ ] Multi-tenant Validation

---

## Testing Strategy

### Unit Tests per Workflow
1. Valid input → Successful creation/update
2. Missing required field → Error
3. Invalid escritorio_id → Rejected
4. Duplicate record → Error (if applicable)
5. Delete non-existent → Error

### Integration Tests
1. Create Cliente → Create Pedido with that Cliente
2. Update Pedido → Verify changes persist
3. Multi-tenant isolation → User A cannot see User B's data
4. Cascade rules → Deleting Parent handles child cleanup

---

**Next Action**: Implement criar_cliente workflow with full error handling and API integration.
