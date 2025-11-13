-- Noowx Database Schema
-- PostgreSQL (Supabase)

-- Tabela: escritorio
CREATE TABLE escritorio (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome VARCHAR(255) NOT NULL,
  endereco TEXT,
  telefone VARCHAR(20),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Tabela: cliente
CREATE TABLE cliente (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome VARCHAR(255) NOT NULL,
  cnpj VARCHAR(18) UNIQUE,
  telefone VARCHAR(20),
  endereco TEXT,
  escritorio_id UUID REFERENCES escritorio(id),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Tabela: usuario
CREATE TABLE usuario (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  papel VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Tabela: comissao
CREATE TABLE comissao (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  valor DECIMAL(15,2) NOT NULL,
  cliente_id UUID REFERENCES cliente(id),
  usuario_id UUID REFERENCES usuario(id),
  data_comissao DATE,
  status VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Tabela: duplicata_faturada
CREATE TABLE duplicata_faturada (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id UUID REFERENCES cliente(id),
  valor DECIMAL(15,2) NOT NULL,
  vencimento DATE,
  status VARCHAR(50),
  created_at TIMESTAMP DEFAULT NOW()
);
