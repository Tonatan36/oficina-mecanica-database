-- 1. Tabela de Clientes
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(150),
    telefone VARCHAR(20) NOT NULL
);

-- 2. Tabela de Veículos (Ligado ao cliente dono do carro)
CREATE TABLE veiculo (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    ano INT,
    placa VARCHAR(10) NOT NULL UNIQUE,
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

-- 3. Tabela de Mecânicos
CREATE TABLE mecanico (
    id_mecanico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(150),
    especialidade VARCHAR(50) NOT NULL -- Ex: 'Motor', 'Elétrica', 'Suspensão'
);

-- 4. Tabela de Equipes (A narrativa diz que veículos são designados a equipes)
CREATE TABLE equipe (
    id_equipe INT AUTO_INCREMENT PRIMARY KEY,
    nome_equipe VARCHAR(50) NOT NULL -- Ex: 'Equipe Alpha', 'Equipe Beta'
);

-- 5. Tabela de Ligação: Quais mecânicos fazem parte de qual equipe (Muitos para Muitos)
CREATE TABLE equipe_mecanico (
    id_equipe INT NOT NULL,
    id_mecanico INT NOT NULL,
    PRIMARY KEY (id_equipe, id_mecanico),
    CONSTRAINT fk_eq_mec_equipe FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe) ON DELETE CASCADE,
    CONSTRAINT fk_eq_mec_mecanico FOREIGN KEY (id_mecanico) REFERENCES mecanico(id_mecanico) ON DELETE CASCADE
);

-- 6. Tabela de Referência de Mão-de-Obra (Serviços)
CREATE TABLE servico_referencia (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    descricao_servico VARCHAR(150) NOT NULL,
    valor_mao_de_obra DECIMAL(10,2) NOT NULL
);

-- 7. Tabela de Peças (Estoque da oficina)
CREATE TABLE peca (
    id_peca INT AUTO_INCREMENT PRIMARY KEY,
    nome_peca VARCHAR(100) NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL
);

-- 8. Tabela de Ordem de Serviço (OS)
CREATE TABLE ordem_servico (
    id_os INT AUTO_INCREMENT PRIMARY KEY,
    id_veiculo INT NOT NULL,
    id_equipe INT NOT NULL,
    data_emissao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_conclusao DATE,
    status_os VARCHAR(50) NOT NULL, -- Ex: 'Em análise', 'Em execução', 'Concluída', 'Cancelada'
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    CONSTRAINT fk_os_veiculo FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
    CONSTRAINT fk_os_equipe FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe)
);

-- 9. Tabela de Ligação: Serviços executados em cada OS
CREATE TABLE os_servico (
    id_os INT NOT NULL,
    id_servico INT NOT NULL,
    quantidade INT DEFAULT 1,
    PRIMARY KEY (id_os, id_servico),
    CONSTRAINT fk_oss_os FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os) ON DELETE CASCADE,
    CONSTRAINT fk_oss_servico FOREIGN KEY (id_servico) REFERENCES servico_referencia(id_servico)
);

-- 10. Tabela de Ligação: Peças utilizadas em cada OS
CREATE TABLE os_peca (
    id_os INT NOT NULL,
    id_peca INT NOT NULL,
    quantidade INT NOT NULL,
    PRIMARY KEY (id_os, id_peca),
    CONSTRAINT fk_osp_os FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os) ON DELETE CASCADE,
    CONSTRAINT fk_osp_peca FOREIGN KEY (id_peca) REFERENCES peca(id_peca)
);


-- Cadastrando um Cliente
INSERT INTO cliente (nome, endereco, telefone) VALUES ('Carlos Souza', 'Rua Principal, 123', '83988887777');

-- Cadastrando o Veículo dele
INSERT INTO veiculo (id_cliente, marca, modelo, ano, placa) VALUES (1, 'Fiat', 'Palio', 2012, 'ABC-1234');

-- Cadastrando Mecânicos
INSERT INTO mecanico (nome, endereco, especialidade) VALUES ('Roberto Lima', 'Rua das Flores, 45', 'Motor');
INSERT INTO mecanico (nome, endereco, especialidade) VALUES ('Marcos Silva', 'Av. Central, 89', 'Elétrica');

-- Criando uma Equipe e associando os mecânicos
INSERT INTO equipe (nome_equipe) VALUES ('Equipe Técnica A');
INSERT INTO equipe_mecanico (id_equipe, id_mecanico) VALUES (1, 1), (1, 2);

-- Cadastrando tabela de serviços e peças
INSERT INTO servico_referencia (descricao_servico, valor_mao_de_obra) VALUES ('Troca de Óleo e Filtro', 80.00);
INSERT INTO peca (nome_peca, valor_unitario) VALUES ('Filtro de Óleo', 35.00), ('Óleo Sintético 5W30', 45.00);

-- Abrindo uma Ordem de Serviço (OS)
INSERT INTO ordem_servico (id_veiculo, id_equipe, data_conclusao, status_os, valor_total) 
VALUES (1, 1, '2026-09-15', 'Em execução', 160.00);

-- Adicionando o serviço e as peças usadas na OS 1
INSERT INTO os_servico (id_os, id_servico, quantidade) VALUES (1, 1, 1);
INSERT INTO os_peca (id_os, id_peca, quantidade) VALUES (1, 1, 1), (1, 2, 1);



-- Consulta para ver os detalhes da OS na oficina
SELECT 
    os.id_os AS 'Nº OS',
    c.nome AS 'Cliente',
    v.marca AS 'Marca',
    v.modelo AS 'Modelo',
    v.placa AS 'Placa',
    eq.nome_equipe AS 'Equipe Responsável',
    os.status_os AS 'Status',
    os.valor_total AS 'Valor Total (R$)'
FROM ordem_servico os
JOIN veiculo v ON os.id_veiculo = v.id_veiculo
JOIN cliente c ON v.id_cliente = c.id_cliente
JOIN equipe eq ON os.id_equipe = eq.id_equipe;
