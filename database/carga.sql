-- ============================================================================
-- teste da carga para verificar a funcionalidade das tabelas
-- ============================================================================

-- COLABORADORES (IDs gerados: 1 a 7)
INSERT INTO Colaborador (cpf, nome, email, senha, cargo, departamento) VALUES
    ('11111111111', 'Marcos Oliveira', 'marcos.dir@uni.edu.br',  '1234', 'Diretor de Unidade',   'Diretoria Acadêmica'),
    ('22222222222', 'Ana Silva',       'ana.coord@uni.edu.br',   '1234', 'Coordenador de Curso', 'Ciência de Dados'),
    ('33333333333', 'Carlos Mendes',   'carlos.prof@uni.edu.br', '1234', 'Professor',            'Ciência de Dados'),
    ('44444444444', 'Beatriz Santos',  'bia.sup@uni.edu.br',     '123', 'Supervisor',           'Tutoria EAD'),
    ('55555555555', 'Lucas Pereira',   'lucas.tutor@uni.edu.br', '1234', 'Tutor',                'Tutoria EAD'),
    ('66666666666', 'Fernanda Lima',   'fer.supti@uni.edu.br',   '1234', 'Supervisor de TI',     'Infraestrutura e TI'),
    ('77777777777', 'Rafael Costa',    'rafa.ti@uni.edu.br',     '1234', 'Técnico de TI',        'Infraestrutura e TI');

-- 2. CRITÉRIOS DE AVALIAÇÃO (IDs: 1 a 3)
INSERT INTO Criterio (nome) VALUES
    ('Comunicação e clareza'),
    ('Liderança'),
    ('Comprometimento e Prazos'),
    ('Trabalho em Equipe e Apoio'),
    ('Didática');

-- 3. QUESTÕES (IDs: 1 a 4)
INSERT INTO Questao (enunciado, tipo, id_criterio) VALUES
    ('Comunica orientações, demandas e feedbacks de forma clara?',       'ESCALA',      1),
    ('Cumpre os prazos acadêmicos ou técnicos com qualidade?',            'ESCALA',      2),
    ('Colabora com os colegas do setor na resolução de problemas?',       'ESCALA',      3),
    ('Apresenta os conteúdos e tira dúvidas com clareza didática?',       'ESCALA',      4),
    ('Destaque um ponto forte ou sugestão de melhoria para este colega:', 'TEXTO_LIVRE', 1);

-- 4. CICLO DE AVALIAÇÃO (ID: 1)
INSERT INTO Ciclo_Avaliacao (titulo, data_inicio, data_fim) VALUES
    ('Avaliação Institucional 360° - 2026/2', DATE '2026-11-01', DATE '2026-11-30'),
    ('Avaliação Docente e Tutoria - 2026/2',  DATE '2026-11-01', DATE '2026-11-30');

-- 5. QUESTÕES DO CICLO 1 COM PESOS
-- A questão 2 (Comprometimento e Prazos) tem peso 2.0; as demais têm peso 1.0
-- o ciclo 2 é destinado apenas a docentes e tutores - relacionamento com a didática (questão 5)
INSERT INTO Ciclo_Questao (id_ciclo, id_questao, peso, ordem) VALUES
    (1, 1, 1.0, 1),
    (1, 2, 2.0, 2),
    (1, 3, 1.0, 3),
    (1, 5, 1.0, 4),
    (2, 4, 2.0, 1),
    (2, 1, 1.0, 2),
    (2, 5, 1.0, 3);

-- 6. DESIGNAÇÕES 360° (Quem avalia quem — núcleos separados!)
-- Exemplo 1: Avaliação completa 360° do Professor Carlos (id = 3)
-- Exemplo 2: Avaliação no núcleo de Tutoria (Beatriz e Lucas)
-- Exemplo 3: Avaliação isolada no núcleo de TI (Fernanda e Rafael — sem contato com Tutores)
INSERT INTO Designacao_360 (id_ciclo, id_avaliador, id_avaliado, relacao, status) VALUES
    -- Visão 360° completa para o Professor Carlos (id 3):
    (1, 3, 3, 'AUTOAVALIACAO', 'CONCLUIDA'), -- Carlos se autoavalia
    (1, 2, 3, 'GESTOR',        'CONCLUIDA'), -- Ana (Coordenadora) avalia Carlos
    (1, 5, 3, 'LIDERADO',      'CONCLUIDA'), -- Lucas (Tutor da disciplina) avalia Carlos
    
    -- Núcleo de Tutoria e Diretoria:
    (1, 4, 5, 'GESTOR',        'CONCLUIDA'), -- Beatriz (Supervisora) avalia Lucas (Tutor)
    (1, 1, 2, 'GESTOR',        'PENDENTE'),  -- Marcos (Diretor) avalia Ana (Coordenadora)

    -- Núcleo de TI (isolado das avaliações pedagógicas):
    (1, 6, 7, 'GESTOR',        'CONCLUIDA'), -- Fernanda (Sup. TI) avalia Rafael (Técnico TI)
    (1, 7, 6, 'LIDERADO',      'PENDENTE'),  -- Rafael (Técnico TI) avalia Fernanda (Sup. TI)

    -- Ciclo 2 (Acadêmico - questão didática aplicada somente a docentes e tutores):
    (2, 2, 3, 'GESTOR', 'CONCLUIDA'),
    (2, 4, 5, 'GESTOR', 'CONCLUIDA');


-- 7. RESPOSTAS ANÔNIMAS DAS AVALIAÇÕES CONCLUÍDAS
INSERT INTO Resposta (id_submissao, id_ciclo, id_avaliado, id_questao, relacao, nota_escala, texto_resposta) VALUES
    -- CICLO 1: Submissão 1 para Prof. Carlos (Autoavaliação)
    ('sub-c1-001', 1, 3, 1, 'AUTOAVALIACAO', 4, NULL),
    ('sub-c1-001', 1, 3, 2, 'AUTOAVALIACAO', 5, NULL),
    ('sub-c1-001', 1, 3, 3, 'AUTOAVALIACAO', 4, NULL),
    ('sub-c1-001', 1, 3, 5, 'AUTOAVALIACAO', NULL, 'Busco atualizar constantemente os materiais práticos das aulas.'),

    -- CICLO 1: Submissão 2 para Prof. Carlos (Gestor)
    ('sub-c1-002', 1, 3, 1, 'GESTOR', 5, NULL),
    ('sub-c1-002', 1, 3, 2, 'GESTOR', 5, NULL),
    ('sub-c1-002', 1, 3, 3, 'GESTOR', 5, NULL),
    ('sub-c1-002', 1, 3, 5, 'GESTOR', NULL, 'Excelente engajamento com a coordenação e alunos.'),

    -- CICLO 1: Submissão 3 para Prof. Carlos (Liderado)
    ('sub-c1-003', 1, 3, 1, 'LIDERADO', 4, NULL),
    ('sub-c1-003', 1, 3, 2, 'LIDERADO', 4, NULL),
    ('sub-c1-003', 1, 3, 3, 'LIDERADO', 5, NULL),
    ('sub-c1-003', 1, 3, 5, 'LIDERADO', NULL, 'Sempre alinha os roteiros de aula com antecedência.'),

    -- CICLO 1: Submissão 4 para Tutor Lucas (Gestor)
    ('sub-c1-004', 1, 5, 1, 'GESTOR', 5, NULL),
    ('sub-c1-004', 1, 5, 2, 'GESTOR', 4, NULL),
    ('sub-c1-004', 1, 5, 3, 'GESTOR', 5, NULL),
    ('sub-c1-004', 1, 5, 5, 'GESTOR', NULL, 'Atendimento muito ágil aos alunos no fórum.'),

    -- CICLO 1: Submissão 5 para Técnico Rafael (Gestor)
    ('sub-c1-005', 1, 7, 1, 'GESTOR', 4, NULL),
    ('sub-c1-005', 1, 7, 2, 'GESTOR', 5, NULL),
    ('sub-c1-005', 1, 7, 3, 'GESTOR', 5, NULL),
    ('sub-c1-005', 1, 7, 5, 'GESTOR', NULL, 'Resolveu rapidamente a manutenção dos laboratórios.'),

    -- CICLO 2 (Acadêmico/Didática): Submissão 1 para Prof. Carlos (Gestor)
    ('sub-c2-001', 2, 3, 4, 'GESTOR', 5, NULL),
    ('sub-c2-001', 2, 3, 1, 'GESTOR', 5, NULL),
    ('sub-c2-001', 2, 3, 5, 'GESTOR', NULL, 'Didática clara e exemplos práticos em laboratório.'),

    -- CICLO 2 (Acadêmico/Didática): Submissão 2 para Tutor Lucas (Gestor)
    ('sub-c2-002', 2, 5, 4, 'GESTOR', 5, NULL),
    ('sub-c2-002', 2, 5, 1, 'GESTOR', 5, NULL),
    ('sub-c2-002', 2, 5, 5, 'GESTOR', NULL, 'Explica as dúvidas dos alunos de forma objetiva.');