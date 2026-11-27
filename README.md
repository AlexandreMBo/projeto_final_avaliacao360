Sistema de Avaliação de Desempenho 360°

Aluno: Alexandre de Mello Bordignon
Disciplina: Banco de Dados I
CDIA
Docente: Prof. Dr Anderson Paulo Avila Santos

Sistema completo de Avaliação de Desempenho 360° desenvolvido para a disciplina de Banco de Dados I, integrando modelagem relacional normalizada (3FN), PostgreSQL, back-end em Java (JDBC + HttpServer) e dashboard analítico interativo em HTML/JS + Chart.js.

1. Visão Geral e Funcionalidades

Avaliação 360° Multiperspectiva: Suporta avaliações de Gestor (peso 2.0), Par (peso 1.5), Liderado (peso 1.5) e Autoavaliação (peso 1.0), além de pesos específicos por questão dentro de cada ciclo.

Coleta Anônima com Protocolo UUID: A tabela Resposta não armazena id_avaliador. Cada envio gera um identificador único (id_submissao UUID) em transação atômica (commit/rollback), atualizando o status da designação para CONCLUIDA sem vincular a autoria às notas ou feedbacks textuais.

Integridade no Banco de Dados: Uso de chaves primárias simples e compostas, chaves estrangeiras com ações referenciais, restrições CHECK e UNIQUE, além de trigger em PL/pgSQL para validação dos cargos permitidos em Colaborador.

Gestão Dinâmica via Interface Web: Permite cadastrar colaboradores, criar perguntas vinculadas a critérios e ciclos, gerar designações 360° (com detecção automática de papel hierárquico) e responder questionários pendentes.

Relatórios Analíticos (Tabelas + Gráficos):

Ranking Geral Ponderado: Classificação dos avaliados por ciclo utilizando DENSE_RANK() OVER (...) e média ponderada (peso_questao × peso_relacao).

Desempenho Médio por Critério: Comparativo entre média simples (AVG) e média ponderada por competência.

Taxa de Adesão e Pendências: Listagem de todos os colaboradores cadastrados (incluindo quem ainda não possui designações) utilizando LEFT JOIN e contagem condicional (CASE WHEN).

2. Estrutura do Repositório

├── database/
│   ├── schema.sql          # DDL das 7 tabelas, restrições e trigger de validação
│   ├── carga.sql           # Massa de dados inicial para testes
│   └── relatorios.sql      # Consultas analíticas do sistema
├── docs/
│   ├── DER.png             # Diagrama Entidade-Relacionamento
│   └── esquema_relacional.md # Mapeamento relacional e justificativa da 3FN
├── lib/
│   └── postgresql-*.jar    # Driver JDBC do PostgreSQL
├── src/
│   ├── dao/
│   │   └── Conexao.java    # Gerenciamento de conexão JDBC
│   └── web/
│       └── ServidorWeb.java # API REST/JSON e servidor HTTP na porta 8080
├── web/
│   └── index.html          # Interface web (Dashboard Chart.js + Formulários 360°)
└── README.md


3. Como Executar o Projeto

Pré-requisitos

Java JDK 11+

PostgreSQL 11+ (com psql ou pgAdmin 4)

Driver PostgreSQL JDBC na pasta lib/

Passo 1: Criar e popular o banco de dados

No pgAdmin 4 (ou via terminal psql), crie um banco de dados chamado avaliacao360 (ou conforme configurado em src/dao/Conexao.java).

Execute o script database/schema.sql para criar as tabelas, restrições e triggers.

Execute o script database/carga.sql para inserir os colaboradores, critérios, ciclos, questões e designações iniciais.

Passo 2: Compilar e iniciar o servidor Java

No terminal (PowerShell ou Bash), a partir da raiz do projeto:

Windows (PowerShell):

javac -encoding UTF-8 -cp "lib/*" -d bin src/dao/*.java src/web/*.java src/*.java
java -cp "bin;lib/*" web.ServidorWeb


Linux / macOS:

javac -encoding UTF-8 -cp "lib/*" -d bin src/dao/*.java src/web/*.java src/*.java
java -cp "bin:lib/*" web.ServidorWeb


Passo 3: Acessar a aplicação

Abra o navegador em:

http://localhost:8080


Na tela inicial são exibidos os 3 relatórios gerenciais (gráficos e tabelas).

Clique em + Novo Questionário / Cadastros no topo para cadastrar colaboradores, adicionar perguntas aos ciclos, liberar designações e enviar avaliações anônimas.

4. Consultas Analíticas Principais

Ranking Ponderado (GET /api/ranking): Utiliza JOIN entre Resposta, Colaborador, Ciclo_Avaliacao e Ciclo_Questao, agregando com SUM(nota_escala * peso * peso_relacao) / SUM(peso * peso_relacao) e ranqueando com DENSE_RANK() OVER (PARTITION BY ...).

Média por Critério (GET /api/criterios): Agrupa por Criterio (GROUP BY) comparando AVG(nota_escala) com a média ponderada.

Adesão por Colaborador (GET /api/adesao): Utiliza LEFT JOIN a partir de Colaborador para garantir que colaboradores com zero designações também apareçam no relatório.