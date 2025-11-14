# 03 - Políticas RLS (Row Level Security)

## Visão Geral

Row Level Security (RLS) é um mecanismo de segurança de banco de dados PostgreSQL que garante isolamento de dados em arquitetura multi-tenant. Cada usuário só vê/modifica dados do seu escritorio_id.

## Habilitar RLS nas Tabelas

```sql
-- Habilitar RLS em todas as tabelas
ALTER TABLE escritorio ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuario ENABLE ROW LEVEL SECURITY;
ALTER TABLE cliente ENABLE ROW LEVEL SECURITY;
ALTER TABLE comissao ENABLE ROW LEVEL SECURITY;
ALTER TABLE duplicata_faturada ENABLE ROW LEVEL SECURITY;
ALTER TABLE industria ENABLE ROW LEVEL SECURITY;
ALTER TABLE produto ENABLE ROW LEVEL SECURITY;
ALTER TABLE nota_fiscal ENABLE ROW LEVEL SECURITY;
ALTER TABLE nota_fiscal_item ENABLE ROW LEVEL SECURITY;
ALTER TABLE orcamento ENABLE ROW LEVEL SECURITY;
ALTER TABLE orcamento_item ENABLE ROW LEVEL SECURITY;
ALTER TABLE pedido ENABLE ROW LEVEL SECURITY;
ALTER TABLE pedido_item ENABLE ROW LEVEL SECURITY;
ALTER TABLE contato_cliente ENABLE ROW LEVEL SECURITY;
ALTER TABLE contrato_representacao ENABLE ROW LEVEL SECURITY;
ALTER TABLE documento_anexo ENABLE ROW LEVEL SECURITY;
ALTER TABLE preco_produto ENABLE ROW LEVEL SECURITY;
ALTER TABLE tabela_preco ENABLE ROW LEVEL SECURITY;
ALTER TABLE tag ENABLE ROW LEVEL SECURITY;
ALTER TABLE territorio_vendedor ENABLE ROW LEVEL SECURITY;
ALTER TABLE industria_produto_schema ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE rls_policies_audit ENABLE ROW LEVEL SECURITY;
```

## Funções Auxiliares

### get_user_escritorio_id()
Retorna o escritorio_id do usuário autenticado:

```sql
CREATE OR REPLACE FUNCTION public.get_user_escritorio_id()
RETURNS uuid
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT escritorio_id FROM usuario WHERE id = auth.uid() LIMIT 1;
$$;
```

### get_user_papel()
Retorna o papel/role do usuário:

```sql
CREATE OR REPLACE FUNCTION public.get_user_papel()
RETURNS varchar
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT papel FROM usuario WHERE id = auth.uid() LIMIT 1;
$$;
```

## Políticas RLS por Tabela

### 1. escritorio
Nenhuma política (tabela de configuração do sistema)

### 2. usuario
```sql
-- SELECT: Ver usuários do mesmo escritorio
CREATE POLICY usuario_select ON usuario
  FOR SELECT
  USING (escritorio_id = get_user_escritorio_id());

-- INSERT: Apenas admin do escritorio
CREATE POLICY usuario_insert ON usuario
  FOR INSERT
  WITH CHECK (escritorio_id = get_user_escritorio_id());

-- UPDATE: Próprio usuário ou admin
CREATE POLICY usuario_update ON usuario
  FOR UPDATE
  USING (id = auth.uid() OR get_user_papel() = 'admin')
  WITH CHECK (escritorio_id = get_user_escritorio_id());

-- DELETE: Apenas admin
CREATE POLICY usuario_delete ON usuario
  FOR DELETE
  USING (get_user_papel() = 'admin');
```

### 3. cliente
```sql
-- SELECT: Ver clientes do seu escritorio
CREATE POLICY cliente_select ON cliente
  FOR SELECT
  USING (escritorio_id = get_user_escritorio_id());

-- INSERT: Criar clientes no seu escritorio
CREATE POLICY cliente_insert ON cliente
  FOR INSERT
  WITH CHECK (escritorio_id = get_user_escritorio_id());

-- UPDATE: Atualizar clientes do seu escritorio
CREATE POLICY cliente_update ON cliente
  FOR UPDATE
  USING (escritorio_id = get_user_escritorio_id())
  WITH CHECK (escritorio_id = get_user_escritorio_id());

-- DELETE: Deletar clientes do seu escritorio
CREATE POLICY cliente_delete ON cliente
  FOR DELETE
  USING (escritorio_id = get_user_escritorio_id());
```

### 4-23. Tabelas de Dados
Todas as tabelas com `escritorio_id` implementam o mesmo padrão:

```sql
-- PADRÃO GERAL
CREATE POLICY [table]_select ON [table]
  FOR SELECT
  USING (escritorio_id = get_user_escritorio_id());

CREATE POLICY [table]_insert ON [table]
  FOR INSERT
  WITH CHECK (escritorio_id = get_user_escritorio_id());

CREATE POLICY [table]_update ON [table]
  FOR UPDATE
  USING (escritorio_id = get_user_escritorio_id())
  WITH CHECK (escritorio_id = get_user_escritorio_id());

CREATE POLICY [table]_delete ON [table]
  FOR DELETE
  USING (escritorio_id = get_user_escritorio_id());
```

**Tabelas**: comissao, duplicata_faturada, industria, produto, nota_fiscal, nota_fiscal_item, orcamento, orcamento_item, pedido, pedido_item, contato_cliente, contrato_representacao, documento_anexo, preco_produto, tabela_preco, tag, territorio_vendedor, industria_produto_schema, user_roles

## Testes de RLS

### Verificar políticas ativas
```sql
SELECT * FROM rls_policies_audit;
```

### Testar isolamento
```sql
-- Como admin do escritorio 1
SET LOCAL user.escritorio_id = '00000000-0000-0000-0000-000000000001';
SELECT * FROM cliente;  -- Verá apenas clientes do escritorio 1

-- Como admin do escritorio 2
SET LOCAL user.escritorio_id = '00000000-0000-0000-0000-000000000002';
SELECT * FROM cliente;  -- Verá apenas clientes do escritorio 2
```

## Performance

As RLS policies usam Índices para otimização:
- `idx_cliente_escritorio_id` - Acelera filtros por escritorio
- `idx_usuario_escritorio_id`
- `idx_industria_escritorio_id`
- E outras conforme documentado em 01-schema-completo.md

## Casos Especiais

### user_roles
Mantenha politica aberta (sem restrições por escritorio_id)

### rls_policies_audit
View de auditoria - acesso controlado por admin apenas

```sql
CREATE POLICY rls_policies_audit_select ON rls_policies_audit
  FOR SELECT
  USING (get_user_papel() = 'admin');
```

## Monitoramento

### Ver todas as políticas aplicadas
```sql
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
```

### Auditoria de acessos
```sql
SELECT * FROM rls_policies_audit WHERE tablename = 'cliente';
```

## Conclusão

A implementação de RLS garante:
- ✅ Isolamento total de dados por escritorio
- ✅ Segurança a nível de banco de dados
- ✅ Compliance com regulamentações de privacidade
- ✅ Performance otimizada com Índices

---

**Documentação Relacionada**:
- [01-schema-completo.md](./01-schema-completo.md) - Definição de tabelas
- [02-relacionamentos.md](./02-relacionamentos.md) - Relacionamentos entre tabelas
