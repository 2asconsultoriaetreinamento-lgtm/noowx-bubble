# FASE 1 - API Testing Guide

## Complete Testing Strategy for CRUD Workflows

**Date:** 2025-11-14  
**Version:** 2.0  
**Status:** Ready for Testing  

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [API Base URL](#api-base-url)
3. [Authentication](#authentication)
4. [Testing Order](#testing-order)
5. [Individual Tests](#individual-tests)
6. [Error Handling](#error-handling)
7. [Success Criteria](#success-criteria)

---

## Prerequisites

### Tools Required
- **Postman** (recommended): https://www.postman.com/downloads/
- **cURL** (command-line): Pre-installed on most systems
- **Insomnia** (alternative): https://insomnia.rest/

### Required Information
- `ESCRITORIO_ID`: ID of a valid office in your Supabase
- `APP_NAME`: "noox-sistema-de-gesto" (your Bubble app name)

### Sample Test Data
```json
{
  "cliente_nome": "Test Cliente Brazil SA",
  "cliente_email": "teste@empresa.com.br",
  "cliente_telefone": "(32) 3333-4444",
  "cliente_cnpj": "12.345.678/0001-90",
  "cliente_razao_social": "Test Cliente Sociedade Anonima",
  "cliente_endereco": "Avenida Testes, 123",
  "cliente_cidade": "Juiz de Fora",
  "cliente_cep": "36000-000",
  "cliente_estado": "MG",
  "cliente_bairro": "Centro",
  "escritorio_id": "[YOUR_ESCRITORIO_ID]"
}
```

---

## API Base URL

```
https://noox-sistema-de-gesto.bubbleapps.io/api/1.1/wf/
```

**Full Endpoints:**
- CREATE: `{BASE_URL}criar_cliente_trigger`
- READ: `{BASE_URL}ler_cliente_trigger`
- UPDATE: `{BASE_URL}atualizar_cliente_trigger`
- DELETE: `{BASE_URL}deletar_cliente_trigger`

---

## Authentication

Bubble workflows do not require authentication for testing in development.
For production, implement API keys if needed.

---

## Testing Order

**Sequence:** CREATE -> READ -> UPDATE -> DELETE

This order ensures:
1. Data exists before reading
2. You can verify read functionality
3. Update targets valid records
4. Delete cleans up test data

---

## Individual Tests

### Test 1: CREATE (criar_cliente)

**Objective:** Create a new cliente record  
**Method:** POST  
**Endpoint:** `{BASE_URL}criar_cliente_trigger`  

#### Using Postman
1. Create new POST request
2. URL: `https://noox-sistema-de-gesto.bubbleapps.io/api/1.1/wf/criar_cliente_trigger`
3. Headers: `Content-Type: application/json`
4. Body (raw JSON):

```json
{
  "cliente_nome": "Test Cliente Brazil SA",
  "cliente_email": "teste@empresa.com.br",
  "cliente_telefone": "(32) 3333-4444",
  "cliente_cnpj": "12.345.678/0001-90",
  "cliente_razao_social": "Test Cliente SA",
  "cliente_endereco": "Avenida Teste, 123",
  "cliente_cidade": "Juiz de Fora",
  "cliente_cep": "36000-000",
  "cliente_estado": "MG",
  "cliente_bairro": "Centro",
  "vendor_id": "vendor_test_001",
  "escritorio_id": "YOUR_ESCRITORIO_ID"
}
```

#### Using cURL
```bash
curl -X POST https://noox-sistema-de-gesto.bubbleapps.io/api/1.1/wf/criar_cliente_trigger \
  -H "Content-Type: application/json" \
  -d '{
    "cliente_nome":"Test Cliente",
    "cliente_email":"test@email.com",
    "cliente_telefone":"(32) 3333-4444",
    "cliente_cnpj":"12.345.678/0001-90",
    "cliente_razao_social":"Test",
    "cliente_endereco":"Rua Test 123",
    "cliente_cidade":"Juiz de Fora",
    "cliente_cep":"36000-000",
    "cliente_estado":"MG",
    "cliente_bairro":"Centro",
    "escritorio_id":"YOUR_ID"
  }'
```

**Expected Response:**
```json
{
  "status": 200,
  "body": {
    "cliente_id": "abc123xyz",
    "cliente_nome": "Test Cliente Brazil SA",
    "created_at": "2025-11-14T22:30:00Z"
  }
}
```

**Success Criteria:**
- ✓ HTTP Status: 200 OK
- ✓ Response contains `cliente_id`
- ✓ Data saved in Supabase (verify in dashboard)

---

### Test 2: READ (ler_cliente)

**Objective:** Retrieve cliente data by escritorio_id  
**Method:** GET  
**Endpoint:** `{BASE_URL}ler_cliente_trigger?escritorio_id=YOUR_ID`  

#### Using Postman
1. Create new GET request
2. URL: `https://noox-sistema-de-gesto.bubbleapps.io/api/1.1/wf/ler_cliente_trigger?escritorio_id=YOUR_ESCRITORIO_ID`
3. Send

#### Using cURL
```bash
curl -X GET "https://noox-sistema-de-gesto.bubbleapps.io/api/1.1/wf/ler_cliente_trigger?escritorio_id=YOUR_ESCRITORIO_ID" \
  -H "Content-Type: application/json"
```

**Expected Response:**
```json
{
  "status": 200,
  "body": {
    "cliente": [
      {
        "cliente_id": "abc123xyz",
        "cliente_nome": "Test Cliente Brazil SA",
        "cliente_email": "teste@empresa.com.br",
        "escritorioid": "YOUR_ESCRITORIO_ID"
      }
    ]
  }
}
```

**Success Criteria:**
- ✓ HTTP Status: 200 OK
- ✓ Returns array of clientes for the escritorio
- ✓ Contains at least the test record created in Test 1

---

### Test 3: UPDATE (atualizar_cliente)

**Objective:** Update an existing cliente record  
**Method:** PUT  
**Endpoint:** `{BASE_URL}atualizar_cliente_trigger`  

#### Using Postman
1. Create new PUT request
2. URL: `https://noox-sistema-de-gesto.bubbleapps.io/api/1.1/wf/atualizar_cliente_trigger`
3. Body (raw JSON):

```json
{
  "cliente_id": "abc123xyz",
  "cliente_email": "newemail@empresa.com.br",
  "cliente_telefone": "(32) 9999-8888",
  "cliente_cidade": "Viçosa"
}
```

#### Using cURL
```bash
curl -X PUT https://noox-sistema-de-gesto.bubbleapps.io/api/1.1/wf/atualizar_cliente_trigger \
  -H "Content-Type: application/json" \
  -d '{
    "cliente_id":"abc123xyz",
    "cliente_email":"newemail@email.com",
    "cliente_telefone":"(32) 9999-8888"
  }'
```

**Expected Response:**
```json
{
  "status": 200,
  "body": {
    "cliente_id": "abc123xyz",
    "cliente_email": "newemail@empresa.com.br",
    "updated_at": "2025-11-14T22:35:00Z"
  }
}
```

**Success Criteria:**
- ✓ HTTP Status: 200 OK
- ✓ Returned data reflects updates
- ✓ Changes persisted in Supabase

---

### Test 4: DELETE (deletar_cliente)

**Objective:** Delete a cliente record  
**Method:** DELETE  
**Endpoint:** `{BASE_URL}deletar_cliente_trigger`  

#### Using Postman
1. Create new DELETE request
2. URL: `https://noox-sistema-de-gesto.bubbleapps.io/api/1.1/wf/deletar_cliente_trigger`
3. Body (raw JSON):

```json
{
  "cliente_id": "abc123xyz"
}
```

#### Using cURL
```bash
curl -X DELETE https://noox-sistema-de-gesto.bubbleapps.io/api/1.1/wf/deletar_cliente_trigger \
  -H "Content-Type: application/json" \
  -d '{"cliente_id":"abc123xyz"}'
```

**Expected Response:**
```json
{
  "status": 200,
  "body": {
    "message": "Cliente deleted successfully"
  }
}
```

**Success Criteria:**
- ✓ HTTP Status: 200 OK
- ✓ Record no longer appears in READ test
- ✓ Verified deletion in Supabase

---

## Error Handling

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| 400 Bad Request | Invalid JSON format | Check JSON syntax |
| 401 Unauthorized | Missing credentials (if enabled) | Add auth header |
| 404 Not Found | Invalid endpoint URL | Verify base URL |
| 500 Server Error | Workflow exception | Check Bubble logs |
| Empty response | No data found | Verify escritorio_id |

---

## Success Criteria

### All Tests Pass When:
1. ✓ CREATE returns new cliente_id
2. ✓ READ retrieves the created record
3. ✓ UPDATE modifies record successfully
4. ✓ DELETE removes record from database
5. ✓ All responses have HTTP 200 status
6. ✓ Data persists in Supabase
7. ✓ Multi-tenant isolation via escritorioid works

---

## Next Steps

1. Execute all 4 tests in sequence
2. Verify data in Supabase dashboard
3. Test with different escritorio_id values
4. Document any issues or deviations
5. Proceed to FASE 2 (Other entities)

---

**Document Version:** 2.0  
**Last Updated:** 2025-11-14  
**Status:** READY FOR TESTING
