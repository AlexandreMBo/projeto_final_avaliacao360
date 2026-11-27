-- Garantir que as tabelas estejam limpas ao rodar o programa
DROP TABLE IF EXISTS Resposta CASCADE;
DROP TABLE IF EXISTS Designacao_360 CASCADE;
DROP TABLE IF EXISTS Ciclo_Questao CASCADE;
DROP TABLE IF EXISTS Ciclo_Avaliacao CASCADE;
DROP TABLE IF EXISTS Questao CASCADE;
DROP TABLE IF EXISTS Criterio CASCADE;
DROP TABLE IF EXISTS Colaborador CASCADE;

-- tabelas das entidades


-- COLABORADOR
-- Tabela independente
-- armazena os dados de cada funcionário o id será utilizado como chave primária, cpf e email serão unique, já que não pode haver funcionários com mesmo email e cpf.
-- restrição de cargo para os cargos pré-definidos no sistema na constraint para garantir que não haja erro de preenchimento ou cargo inválido.
CREATE TABLE Colaborador (
    id_colaborador SERIAL PRIMARY KEY,
    cpf CHAR(11) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(50) NOT NULL,
    cargo VARCHAR(60) NOT NULL,
    departamento VARCHAR(60) NOT NULL,
    CONSTRAINT chk_cargo CHECK (cargo IN (
        'Diretor de Unidade',
        'Coordenador de Curso',
        'Professor',
        'Supervisor',
        'Tutor',
        'Supervisor de TI',
        'Técnico de TI'
    ))
);

-- CRITERIO
-- Tabela independente
-- Guarda as competências avaliadas (ex: Comunicação, Liderança) para não repetir texto na tabela Questao (3FN).
CREATE TABLE Criterio (
    id_criterio SERIAL PRIMARY KEY,
    nome VARCHAR(60) UNIQUE NOT NULL
);

-- CICLO_AVALIACAO
-- Tabela independente
-- Representa cada edição da avaliação (ex: Ciclo 360° - 2026/2). A data_fim não pode ser menor que a data_inicio.
CREATE TABLE Ciclo_Avaliacao (
    id_ciclo SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    CONSTRAINT chk_datas_ciclo CHECK (data_fim >= data_inicio)
);


-- tabelas dependentes (possuem chaves estrangeiras - FK)


-- QUESTAO
-- Depende de Criterio (relacionamento 1:N)
-- Guarda as perguntas reutilizáveis. O id_criterio é FK apontando para Criterio.
CREATE TABLE Questao (
    id_questao SERIAL PRIMARY KEY,
    enunciado TEXT NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    id_criterio INT NOT NULL,
    CONSTRAINT fk_questao_criterio FOREIGN KEY (id_criterio) REFERENCES Criterio(id_criterio) ON DELETE RESTRICT,
    CONSTRAINT chk_tipo_questao CHECK (tipo IN ('ESCALA', 'TEXTO_LIVRE'))
);

-- CICLO_QUESTAO
-- Tabela associativa (relacionamento M:N entre Ciclo_Avaliacao e Questao)
-- A PK composta (id_ciclo, id_questao) impede repetir a mesma pergunta no ciclo. Guarda o peso de cada questão.
CREATE TABLE Ciclo_Questao (
    id_ciclo INT,
    id_questao INT,
    peso NUMERIC(4,2) NOT NULL DEFAULT 1.0,
    ordem INT NOT NULL,
    PRIMARY KEY (id_ciclo, id_questao),
    CONSTRAINT fk_cq_ciclo FOREIGN KEY (id_ciclo) REFERENCES Ciclo_Avaliacao(id_ciclo) ON DELETE CASCADE,
    CONSTRAINT fk_cq_questao FOREIGN KEY (id_questao) REFERENCES Questao(id_questao) ON DELETE RESTRICT,
    CONSTRAINT chk_peso_positivo CHECK (peso > 0)
);

-- DESIGNACAO_360
-- Controla quem avalia quem em cada ciclo.
-- A PK composta (id_ciclo, id_avaliador, id_avaliado) garante que cada pessoa avalie cada colega uma única vez por ciclo.
CREATE TABLE Designacao_360 (
    id_ciclo INT,
    id_avaliador INT,
    id_avaliado INT,
    relacao VARCHAR(20) NOT NULL,
    peso_relacao NUMERIC(4,2) GENERATED ALWAYS AS (
        CASE relacao
            WHEN 'GESTOR'        THEN 2.0
            WHEN 'PAR'           THEN 1.5
            WHEN 'LIDERADO'      THEN 1.5
            WHEN 'AUTOAVALIACAO' THEN 1.0
        END
    ) STORED,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDENTE',
    PRIMARY KEY (id_ciclo, id_avaliador, id_avaliado),
    CONSTRAINT fk_desig_ciclo FOREIGN KEY (id_ciclo) REFERENCES Ciclo_Avaliacao(id_ciclo) ON DELETE CASCADE,
    CONSTRAINT fk_desig_avaliador FOREIGN KEY (id_avaliador) REFERENCES Colaborador(id_colaborador) ON DELETE RESTRICT,
    CONSTRAINT fk_desig_avaliado FOREIGN KEY (id_avaliado) REFERENCES Colaborador(id_colaborador) ON DELETE RESTRICT,
    CONSTRAINT chk_relacao CHECK (relacao IN ('AUTOAVALIACAO', 'PAR', 'GESTOR', 'LIDERADO')),
    CONSTRAINT chk_status CHECK (status IN ('PENDENTE', 'CONCLUIDA'))
);

-- RESPOSTA (Versão identificada / não anônima)
-- A PK composta (id_ciclo, id_avaliador, id_avaliado, id_questao) garante uma única
-- resposta por questão dentro de cada avaliação designada.
-- Possui duas FKs compostas: uma liga à Designacao_360 e a outra à Ciclo_Questao.
CREATE TABLE Resposta (
    id_ciclo INT,
    id_avaliador INT,
    id_avaliado INT,
    id_questao INT,
    nota_escala INT,
    texto_resposta TEXT,
    PRIMARY KEY (id_ciclo, id_avaliador, id_avaliado, id_questao),
    CONSTRAINT fk_resp_designacao FOREIGN KEY (id_ciclo, id_avaliador, id_avaliado)
        REFERENCES Designacao_360(id_ciclo, id_avaliador, id_avaliado) ON DELETE CASCADE,
    CONSTRAINT fk_resp_ciclo_questao FOREIGN KEY (id_ciclo, id_questao)
        REFERENCES Ciclo_Questao(id_ciclo, id_questao) ON DELETE RESTRICT,
    CONSTRAINT chk_nota_escala CHECK (nota_escala BETWEEN 1 AND 5)
);

--------------------------------------------------------------------------------
-- Regra de negócio (TRIGGER): Restringe questões sobre didática a docentes/tutores
--------------------------------------------------------------------------------

-- função de validação
CREATE OR REPLACE FUNCTION fn_validar_questao_por_cargo()
RETURNS TRIGGER AS $$
DECLARE
    v_cargo_avaliado VARCHAR(60);
    v_nome_criterio  VARCHAR(60);
BEGIN
    -- Busca o cargo de quem está sendo avaliado
    SELECT cargo INTO v_cargo_avaliado
    FROM Colaborador
    WHERE id_colaborador = NEW.id_avaliado;

    -- Busca o critério (tema) da pergunta que está sendo respondida
    SELECT c.nome INTO v_nome_criterio
    FROM Questao q
    JOIN Criterio c ON q.id_criterio = c.id_criterio
    WHERE q.id_questao = NEW.id_questao;

    -- Se o critério for 'Didática' e o avaliado NÃO for Professor nem Tutor, bloqueia!
    IF v_nome_criterio = 'Didática' AND v_cargo_avaliado NOT IN ('Professor', 'Tutor') THEN
        RAISE EXCEPTION 'Operação bloqueada: O critério Didática só pode ser avaliado para Professor ou Tutor (Cargo atual: %).', v_cargo_avaliado;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Amarra a função para rodar automaticamente ANTES de inserir ou atualizar uma Resposta
CREATE TRIGGER trg_validar_questao_por_cargo
BEFORE INSERT OR UPDATE ON Resposta
FOR EACH ROW
EXECUTE FUNCTION fn_validar_questao_por_cargo();