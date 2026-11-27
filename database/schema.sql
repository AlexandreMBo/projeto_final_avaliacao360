-- Garantir que as tabelas estejam limpas ao rodar o programa
DROP TABLE IF EXISTS Resposta CASCADE;
DROP TABLE IF EXISTS Designacao_360 CASCADE;
DROP TABLE IF EXISTS Ciclo_Questao CASCADE;
DROP TABLE IF EXISTS Ciclo_Avaliacao CASCADE;
DROP TABLE IF EXISTS Questao CASCADE;
DROP TABLE IF EXISTS Criterio CASCADE;
DROP TABLE IF EXISTS Colaborador CASCADE;

-- =============================================================================
-- TABELAS DAS ENTIDADES INDEPENDENTES
-- =============================================================================

-- COLABORADOR
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
CREATE TABLE Criterio (
    id_criterio SERIAL PRIMARY KEY,
    nome VARCHAR(60) UNIQUE NOT NULL CHECK (nome IN (
        'Comunicação e Transparência',
        'Comprometimento e Entregas',
        'Cooperação e Trabalho em Equipe',
        'Didática e Apoio Acadêmico',
        'Bem-estar e Ambiente de Trabalho',
        'Desenvolvimento e Realização Profissional'
    )),
    descricao VARCHAR(200)
);

-- CICLO_AVALIACAO
CREATE TABLE Ciclo_Avaliacao (
    id_ciclo SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    CONSTRAINT chk_datas_ciclo CHECK (data_fim >= data_inicio)
);

-- =============================================================================
-- TABELAS DEPENDENTES (POSSUEM CHAVES ESTRANGEIRAS - FK)
-- =============================================================================

-- QUESTAO
CREATE TABLE Questao (
    id_questao SERIAL PRIMARY KEY,
    enunciado TEXT NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    id_criterio INT NOT NULL,
    CONSTRAINT fk_questao_criterio FOREIGN KEY (id_criterio) REFERENCES Criterio(id_criterio) ON DELETE RESTRICT,
    CONSTRAINT chk_tipo_questao CHECK (tipo IN ('ESCALA', 'TEXTO_LIVRE'))
);

-- CICLO_QUESTAO (Relacionamento M:N com peso da questão no ciclo)
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

-- RESPOSTA (Versão anônima com UUID de submissão)
CREATE TABLE Resposta (
    id_resposta    SERIAL PRIMARY KEY,
    id_submissao   VARCHAR(36) NOT NULL,
    id_ciclo       INT NOT NULL,
    id_avaliado    INT NOT NULL,
    id_questao     INT NOT NULL,
    relacao        VARCHAR(20) NOT NULL,
    peso_relacao   NUMERIC(4,2) GENERATED ALWAYS AS (
        CASE relacao
            WHEN 'GESTOR'        THEN 2.0
            WHEN 'PAR'           THEN 1.5
            WHEN 'LIDERADO'      THEN 1.5
            WHEN 'AUTOAVALIACAO' THEN 1.0
        END
    ) STORED,
    nota_escala    INT,
    texto_resposta TEXT,
    CONSTRAINT fk_resp_ciclo_questao FOREIGN KEY (id_ciclo, id_questao)
        REFERENCES Ciclo_Questao(id_ciclo, id_questao) ON DELETE RESTRICT,
    CONSTRAINT fk_resp_avaliado FOREIGN KEY (id_avaliado)
        REFERENCES Colaborador(id_colaborador) ON DELETE RESTRICT,
    CONSTRAINT chk_resp_relacao CHECK (relacao IN ('AUTOAVALIACAO', 'PAR', 'GESTOR', 'LIDERADO')),
    CONSTRAINT chk_nota_escala CHECK (nota_escala BETWEEN 1 AND 5),
    CONSTRAINT uq_submissao_questao UNIQUE (id_submissao, id_questao)
);

-- =============================================================================
-- REGRA DE NEGÓCIO (TRIGGER): Restringe questões de Didática a Docentes/Tutores
-- =============================================================================

CREATE OR REPLACE FUNCTION fn_validar_questao_por_cargo()
RETURNS TRIGGER AS $$
DECLARE
    v_cargo_avaliado VARCHAR(60);
    v_nome_criterio  VARCHAR(60);
BEGIN
    SELECT cargo INTO v_cargo_avaliado
    FROM Colaborador
    WHERE id_colaborador = NEW.id_avaliado;

    SELECT c.nome INTO v_nome_criterio
    FROM Questao q
    JOIN Criterio c ON q.id_criterio = c.id_criterio
    WHERE q.id_questao = NEW.id_questao;

    -- Corrigido para bater exatamente com o nome na CHECK constraint de Criterio
    IF v_nome_criterio = 'Didática e Apoio Acadêmico'
       AND v_cargo_avaliado NOT IN ('Professor', 'Tutor') THEN
        RAISE EXCEPTION 'Operação bloqueada: O critério Didática e Apoio Acadêmico só pode ser avaliado para Professor ou Tutor (Cargo atual: %).', v_cargo_avaliado;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validar_questao_por_cargo ON Resposta;

CREATE TRIGGER trg_validar_questao_por_cargo
BEFORE INSERT OR UPDATE ON Resposta
FOR EACH ROW
EXECUTE FUNCTION fn_validar_questao_por_cargo();