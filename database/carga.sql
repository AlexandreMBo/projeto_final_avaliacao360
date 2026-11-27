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
    (1, 7, 6, 'LIDERADO',      'PENDENTE');  -- Rafael (Técnico TI) avalia Fernanda (Sup. TI)

    -- Ciclo 2 (Acadêmico - questão didática aplicada somente a docentes e tutores):
    (2, 2, 3, 'GESTOR', 'CONCLUIDA'),
    (2, 4, 5, 'GESTOR', 'CONCLUIDA');


-- 7. RESPOSTAS DAS AVALIAÇÕES CONCLUÍDAS
INSERT INTO Resposta (id_ciclo, id_avaliador, id_avaliado, id_questao, nota_escala, texto_resposta) VALUES
    -- CICLO 1: Autoavaliação do Prof. Carlos (3 -> 3)
    (1, 3, 3, 1, 4, NULL),
    (1, 3, 3, 2, 5, NULL),
    (1, 3, 3, 3, 4, NULL),
    (1, 3, 3, 5, NULL, 'Busco atualizar constantemente os materiais práticos das aulas.'), -- alterado id_questao: 4 -> 5

    -- CICLO 1: Coordenadora Ana avaliando Prof. Carlos (2 -> 3)
    (1, 2, 3, 1, 5, NULL),
    (1, 2, 3, 2, 5, NULL),
    (1, 2, 3, 3, 5, NULL),
    (1, 2, 3, 5, NULL, 'Excelente engajamento com a coordenação e alunos.'), -- alterado id_questao: 4 -> 5

    -- CICLO 1: Tutor Lucas avaliando Prof. Carlos (5 -> 3)
    (1, 5, 3, 1, 4, NULL),
    (1, 5, 3, 2, 4, NULL),
    (1, 5, 3, 3, 5, NULL),
    (1, 5, 3, 5, NULL, 'Sempre alinha os roteiros de aula com antecedência.'), -- alterado id_questao: 4 -> 5

    -- CICLO 1: Supervisora Beatriz avaliando Tutor Lucas (4 -> 5)
    (1, 4, 5, 1, 5, NULL),
    (1, 4, 5, 2, 4, NULL),
    (1, 4, 5, 3, 5, NULL),
    (1, 4, 5, 5, NULL, 'Atendimento muito ágil aos alunos no fórum.'), -- alterado id_questao: 4 -> 5

    -- CICLO 1: Supervisora de TI Fernanda avaliando Técnico Rafael (6 -> 7)
    (1, 6, 7, 1, 4, NULL),
    (1, 6, 7, 2, 5, NULL),
    (1, 6, 7, 3, 5, NULL),
    (1, 6, 7, 5, NULL, 'Resolveu rapidamente a manutenção dos laboratórios.'), -- alterado id_questao: 4 -> 5

    -- CICLO 2 (Acadêmico/Didática): Coordenadora Ana avaliando Prof. Carlos (2 -> 3)
    (2, 2, 3, 4, 5, NULL),
    (2, 2, 3, 1, 5, NULL),
    (2, 2, 3, 5, NULL, 'Didática clara e exemplos práticos em laboratório.'),

    -- CICLO 2 (Acadêmico/Didática): Supervisora Beatriz avaliando Tutor Lucas (4 -> 5)
    (2, 4, 5, 4, 5, NULL),
    (2, 4, 5, 1, 5, NULL),
    (2, 4, 5, 5, NULL, 'Explica as dúvidas dos alunos de forma objetiva.');