# 02 - Relacionamentos e Diagrama ER

## Diagrama Entidade-Relacionamento (ER)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    ARQUITECTURA MULTI-TENANT                        │
│                    (Isolamento por escritorio_id)                   │
└─────────────────────────────────────────────────────────────────────┘

                          ┌──────────────┐
                          │ escritorio   │
                          │──────────────│
                          │ id (PK)      │
                          │ nome         │
                          │ endereco     │
                          │ telefone     │
                          └──────────────┘
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
        ▼                        ▼                        ▼
┌──────────────┐        ┌──────────────┐        ┌──────────────┐
│  usuario     │        │   cliente    │        │  industria   │
│──────────────│        │──────────────│        │──────────────│
│ id (FK auth) │        │ id (PK)      │        │ id (PK)      │
│escritorio_id │        │escritorio_id │        │escritorio_id │
│ nome         │        │razao_social  │        │ nome         │
│ email        │        │ cnpj         │        │ descricao    │
│ papel        │        │vendedor_id→  │        │preco_base    │
│ status       │        │ email        │        └──────────────┘
└──────────────┘        │ telefone     │                 │
        │               │ endereco     │                 ▼
        │               │ cidade       │        ┌──────────────┐
        │               │ estado       │        │  produto     │
        │               └──────────────┘        │──────────────│
        │                      │                │ id (PK)      │
        │                      │                │industria_id→ │
        │                      ▼                │ nome         │
        │               ┌──────────────┐        │ descricao    │
        │               │  comissao    │        │ sku          │
        │               │──────────────│        └──────────────┘
        │               │ id (PK)      │                 │
        ├──→│usuario_id │               │                 ├─────────┐
        │   │cliente_id→│               │                 │         │
        │   │ valor     │               │                 ▼         ▼
        │   │ data      │               │        ┌──────────────┐ ┌──────────────┐
        │   │ status    │               │        │preco_produto │ │ tabela_preco │
        │   └──────────────┘            │        │──────────────│ │──────────────│
        │                               │        │produto_id→  │ │ id (PK)      │
        │                               │        │escritorio_id │ │escritorio_id │
        │                               │        │preco         │ │ nome         │
        │                               │        └──────────────┘ │vigencia_ini  │
        │                               │                         │vigencia_fim  │
        │                               │                         └──────────────┘
        │                               │
        │                               └─→ CONEXÕES:
        │                                    • cliente (1) → (N) pedido
        │                                    • cliente (1) → (N) orcamento
        │                                    • cliente (1) → (N) comissao
        │                                    • cliente (1) → (N) duplicata
        │                                    • cliente (1) → (N) nota_fiscal
        │
        └─→ VENDAS:
            • pedido → pedido_item → produto
            • orcamento → orcamento_item → produto
            • nota_fiscal → nota_fiscal_item → produto
```

## Relacionamentos Detalhados

### 1:N (Um-para-Muitos)

| De | Para | Cardinalidade | Descrição |
|---|---|---|---|
| escritorio | usuario | 1:N | Um escritório tem mérios usuários |
| escritorio | cliente | 1:N | Um escritório tem mérios clientes |
| escritorio | industria | 1:N | Um escritório tem mérias indústrias |
| usuario | comissao | 1:N | Um vendedor recebe mérias comissões |
| usuario | cliente | 1:N | Um vendedor tem mérios clientes |
| cliente | pedido | 1:N | Um cliente faz mérios pedidos |
| cliente | orcamento | 1:N | Um cliente recebe mérios orçamentos |
| cliente | nota_fiscal | 1:N | Um cliente tem mérias notas fiscais |
| cliente | comissao | 1:N | Um cliente gera mérias comissões |
| cliente | duplicata | 1:N | Um cliente tem mérias duplicatas |
| industria | produto | 1:N | Uma indústria produz mérios produtos |
| industria_produto_schema | produto | 1:N | Uma configuração tem mérios produtos |
| produto | preco_produto | 1:N | Um produto tem mérios preços |
| produto | pedido_item | 1:N | Um produto aparece em mérios itens de pedido |
| produto | orcamento_item | 1:N | Um produto aparece em mérios itens de orçamento |
| produto | nota_fiscal_item | 1:N | Um produto aparece em mérios itens de NF |
| pedido | pedido_item | 1:N | Um pedido tem mérios itens |
| orcamento | orcamento_item | 1:N | Um orçamento tem mérios itens |
| nota_fiscal | nota_fiscal_item | 1:N | Uma NF tem mérios itens |
| contrato_representacao | territorio_vendedor | 1:N | Um contrato cobre mérios territórios |
| cliente | contato_cliente | 1:N | Um cliente tem mérios contatos |
| cliente | documento_anexo | 1:N | Um cliente pode ter mérios documentos |

## Chaves Estrangeiras (Foreign Keys)

```sql
-- Usuario
ALTER TABLE usuario ADD CONSTRAINT fk_usuario_escritorio 
  FOREIGN KEY (escritorio_id) REFERENCES escritorio(id) ON DELETE CASCADE;

-- Cliente
ALTER TABLE cliente ADD CONSTRAINT fk_cliente_escritorio 
  FOREIGN KEY (escritorio_id) REFERENCES escritorio(id) ON DELETE CASCADE;
ALTER TABLE cliente ADD CONSTRAINT fk_cliente_vendedor 
  FOREIGN KEY (vendedor_id) REFERENCES usuario(id);

-- Comissão
ALTER TABLE comissao ADD CONSTRAINT fk_comissao_usuario 
  FOREIGN KEY (usuario_id) REFERENCES usuario(id);
ALTER TABLE comissao ADD CONSTRAINT fk_comissao_cliente 
  FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE CASCADE;

-- Pedido
ALTER TABLE pedido ADD CONSTRAINT fk_pedido_cliente 
  FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE CASCADE;
ALTER TABLE pedido_item ADD CONSTRAINT fk_pedido_item_pedido 
  FOREIGN KEY (pedido_id) REFERENCES pedido(id) ON DELETE CASCADE;
ALTER TABLE pedido_item ADD CONSTRAINT fk_pedido_item_produto 
  FOREIGN KEY (produto_id) REFERENCES produto(id);

-- Orçamento
ALTER TABLE orcamento ADD CONSTRAINT fk_orcamento_cliente 
  FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE CASCADE;
ALTER TABLE orcamento_item ADD CONSTRAINT fk_orcamento_item_orcamento 
  FOREIGN KEY (orcamento_id) REFERENCES orcamento(id) ON DELETE CASCADE;
ALTER TABLE orcamento_item ADD CONSTRAINT fk_orcamento_item_produto 
  FOREIGN KEY (produto_id) REFERENCES produto(id);

-- Nota Fiscal
ALTER TABLE nota_fiscal ADD CONSTRAINT fk_nota_fiscal_cliente 
  FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE CASCADE;
ALTER TABLE nota_fiscal_item ADD CONSTRAINT fk_nota_fiscal_item_nf 
  FOREIGN KEY (nota_fiscal_id) REFERENCES nota_fiscal(id) ON DELETE CASCADE;
ALTER TABLE nota_fiscal_item ADD CONSTRAINT fk_nota_fiscal_item_produto 
  FOREIGN KEY (produto_id) REFERENCES produto(id);
```

## Cascatas de Exclusão

Quando um registro é deletado, as seguintes ações ocorrem (ON DELETE CASCADE):

- **Delete escritorio** → Deleta todos: usuarios, clientes, industrias, etc.
- **Delete cliente** → Deleta: pedidos, orcamentos, notas_fiscais, duplicatas, comissões, contatos
- **Delete pedido/orcamento/nota_fiscal** → Deleta seus itens relacionados
- **Delete industria** → Deleta: produtos da indústria

---

**Documentação Relacionada**:
- [01-schema-completo.md](./01-schema-completo.md) - Definição completa das tabelas
- [03-rls-policies.md](./03-rls-policies.md) - Políticas de segurança RLS
