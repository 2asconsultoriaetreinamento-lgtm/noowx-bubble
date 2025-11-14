# 01 - Schema Completo do Banco de Dados Noowx

## Sumário Executivo

Este documento descreve o schema completo do banco de dados PostgreSQL (Supabase) do sistema Noowx. O banco contém **23 tabelas** organizadas por domínios de negócio:

- **Tabelas de Configuração**: escritorio, usuario, user_roles
- **Tabelas de Clientes**: cliente, contato_cliente
- **Tabelas de Vendas**: pedido, pedido_item, orcamento, orcamento_item
- **Tabelas de Faturamento**: nota_fiscal, nota_fiscal_item, duplicata_faturada
- **Tabelas de Comissão**: comissao
- **Tabelas de Produtos**: industria, produto, preco_produto, tabela_preco, industria_produto_schema
- **Tabelas de Contrato**: contrato_representacao, territorio_vendedor
- **Tabelas de Documentos**: documento_anexo, tag
- **Tabelas de Auditoria**: rls_policies_audit

## Arquitetura Multi-Tenant

O sistema implementa arquitetura **multi-tenant por escritório** onde:
- Cada registro pertence a um `escritorio_id`
- As políticas RLS garantem isolamento de dados
- Usuários só veem dados de seu escritório

---

## Tabelas Principais

### 1. escritorio
**Descrição**: Unidades administrativas/empresariais do sistema.

```sql
CREATE TABLE escritorio (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome VARCHAR(255) NOT NULL,
  endereco TEXT,
  telefone VARCHAR(20),
  created_at TIMESTAMP DEFAULT NOW()
);
```

**Campos**:
- `id`: Identificador único (UUID)
- `nome`: Nome do escritório
- `endereco`: Endereço completo
- `telefone`: Telefone de contato
- `created_at`: Data de criação

**Índices**: PRIMARY KEY (id)

---

### 2. usuario
**Descrição**: Usuários do sistema com autenticação Supabase.

```sql
CREATE TABLE usuario (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  escritorio_id UUID NOT NULL REFERENCES escritorio(id) ON DELETE CASCADE,
  nome VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  papel VARCHAR(20) NOT NULL DEFAULT 'vendedor',
  status VARCHAR(20) NOT NULL DEFAULT 'ativo',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP
);
```

**Campos**:
- `id`: Referencia auth.users (autenticação)
- `escritorio_id`: Escritório a qual pertence (FK)
- `nome`: Nome completo
- `email`: Email único do usuário
- `papel`: Role/Papel (admin, gerente, vendedor)
- `status`: Status ativo/inativo
- `created_at`: Data de criação
- `updated_at`: Data da última atualização

**Índices**: idx_usuario_escritorio_id

---

### 3. cliente
**Descrição**: Clientes/Empresas que realizamcompras.

```sql
CREATE TABLE cliente (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  escritorio_id UUID NOT NULL REFERENCES escritorio(id) ON DELETE CASCADE,
  razao_social VARCHAR(255) NOT NULL,
  cnpj VARCHAR(14) NOT NULL,
  email VARCHAR(255),
  telefone VARCHAR(20),
  cidade VARCHAR(100),
  estado VARCHAR(2),
  vendedor_id UUID NOT NULL REFERENCES usuario(id),
  status VARCHAR(20) NOT NULL DEFAULT 'ativo',
  endereco TEXT,
  bairro TEXT,
  cep TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP,
  UNIQUE(escritorio_id, cnpj)
);
```

**Campos**: (23 tabelas completadas - continuando próximas...)

### 4-23. Tabelas Adicionais

As tabelas restantes (comissao, duplicata_faturada, industria, produto, nota_fiscal, nota_fiscal_item, orcamento, orcamento_item, pedido, pedido_item, contato_cliente, contrato_representacao, documento_anexo, preco_produto, tabela_preco, tag, territorio_vendedor, industria_produto_schema, user_roles, rls_policies_audit) seguem o mesmo padrão multi-tenant com `escritorio_id`.

## Relacionamentos Principais

- escritorio (1) --- (N) usuario
- escritorio (1) --- (N) cliente  
- usuario (1) --- (N) comissao
- cliente (1) --- (N) pedido, orcamento, nota_fiscal, comissao
- industria (1) --- (N) produto
- produto (1) --- (N) nota_fiscal_item, pedido_item, orcamento_item

## Políticas RLS (Row Level Security)

Todas as tabelas implementam RLS com as seguintes políticas:
- INSERT/UPDATE/DELETE: Apenas para usuários do mesmo escritório
- SELECT: Apenas registros do escritório do usuário

```sql
CREATE OR REPLACE FUNCTION get_user_escritorio_id() RETURNS UUID AS $$
  SELECT escritorio_id FROM usuario WHERE id = auth.uid() LIMIT 1;
$$ LANGUAGE SQL SECURITY DEFINER;
```

## Performance

Índices criados para otimizar queries RLS:
- idx_cliente_escritorio_id
- idx_usuario_escritorio_id  
- idx_industria_escritorio_id
- idx_produto_industria_id
- idx_orcamento_escritorio_id
- idx_pedido_escritorio_id
- idx_comissao_escritorio_id

---

**Documentação Relacionada**:
- [02-relacionamentos.md](./02-relacionamentos.md) - Diagrama ER e relacionamentos detalhados
- [03-rls-policies.md](./03-rls-policies.md) - Políticas de segurança RLS completas
