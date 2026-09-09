# Desafio de Projeto: Sistema de Controle e Gerenciamento de Ordens de Serviço (Oficina Mecânica)

Este repositório apresenta o modelo conceitual e lógico de banco de dados relacional desenvolvido para gerenciar as operações de uma **oficina mecânica**, cobrindo desde o atendimento ao cliente e cadastro de veículos até a execução de ordens de serviço, alocação de equipes, controle de peças e tabela de referência de mão-de-obra.

---

## 📌 Descrição do Projeto Conceitual

O objetivo deste projeto é estruturar um banco de dados robusto capaz de automatizar e organizar o fluxo de uma oficina. A narrativa principal estabelece que clientes levam veículos para consertos ou revisões periódicas, os quais são atribuídos a equipes de mecânicos responsáveis por diagnosticar, orçar e executar os serviços mediante autorização.

### 🛠️ Regras de Negócio e Premissas Adotadas

Como a narrativa abrange diversos módulos operacionais, as seguintes decisões de modelagem e premissas foram adotadas:

1. **Clientes e Veículos:**
   - Um cliente pode possuir um ou vários veículos cadastrados na oficina (relação de 1 para N).
   - Cada veículo pertence a um único proprietário.

2. **Mecânicos e Equipes:**
   - Os mecânicos possuem código, nome, endereço e especialidade (ex: motor, elétrica, suspensão).
   - Como a narrativa menciona que *"cada veículo é designado a uma equipe de mecânicos"*, criou-se a entidade `Equipe` e uma tabela de associação (`equipe_mecanico`) para permitir que múltiplos mecânicos integrem uma mesma equipe (relação de N para N).

3. **Ordem de Serviço (OS) e Composição de Custos:**
   - A OS é o documento central, contendo número, data de emissão, data prevista de conclusão, status e valor total.
   - O valor total da OS é composto pelo somatório dos custos de **mão-de-obra** (consultados na tabela de referência de serviços) e das **peças** utilizadas no conserto.
   - Para suportar isso, foram implementadas tabelas intermediárias (`os_servico` e `os_peca`), permitindo que uma mesma OS contenha múltiplos serviços e várias peças aplicadas.

---

## 🚀 Tecnologias e Ferramentas

- **Banco de Dados:** MySQL (SGBD Relacional)
- **Modelagem:** Diagrama Entidade-Relacionamento (DER) / Scripts DDL
- **Controle de Versão:** Git e GitHub

---

## 📂 Estrutura do Repositório

```text
├── sql/              
│   └── oficina_criacao_e_testes.sql   # Script DDL com a criação das tabelas e inserts de teste
└── README.md         # Documentação detalhada do projeto
