# Changelog

Todos os mudanças relevantes no projeto serão documentadas neste arquivo.

## [0.1.0] - 2025-11-13

## [0.1.1] - 2025-11-14

### Added (Phase 3 Complete - Field Mapping)

- **Bubble Data Types**: Todos os 30+ campos obrigatórios mapeados com sucesso
  - 8 tipos com suporte multi-tenant via `escritorio_id`
  - 5 campos de catálogo de produtos em Produto
  - 4 campos de contato em ContatoCliente
  - 4 campos de contrato em ContratoRepresentacao
  - 3 campos de território em TerritorioVendedor

### Documentation

- `06-phase3-validation-report.md`: Status atualizado para 95%+ completo
- `07-phase3-fields-mapping-complete.md`: Documentação completa do mapeamento
- Multi-tenant infrastructure implementada para RLS policies

### Fixed

- Phase 4 blocker removido - workflows CRUD podem agora prosseguir
- Todas as entidades de negócio com cobertura completa de campos

### Status

- Phase 3: ✅ 100% COMPLETE
- Phase 4: READY TO START

### Adicionado
- Repositório inicial criado
- Estrutura de diretórios configurada
- README com visão do projeto
- Guia de contribuição (CONTRIBUTING.md)
- Template de issues (.github/ISSUE_TEMPLATE/)
- Schema inicial do banco de dados (database/schema.sql)
- Licença MIT

### Planejado
- Frontend Bubble.io com formularios de cadastro
- Integração Supabase para autenticação
- Dashboard com indicadores
- Automações N8N

---

**Status**: 🟡 MVP em Desenvolvimento
