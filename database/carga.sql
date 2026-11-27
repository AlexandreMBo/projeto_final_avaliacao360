-- ============================================================================
-- teste da carga para verificar a funcionalidade das tabelas
-- ============================================================================

-- COLABORADORES (IDs gerados: 1 a 20 — 1 Diretor, 2 Coordenadores, 10 Tutores, 3 Professores, 2 Supervisores, 2 TI)
INSERT INTO Colaborador (cpf, nome, email, senha, cargo, departamento) VALUES
    -- IDs 1 a 7 (originais mantidos para preservar designações e respostas)
    ('11111111111', 'Marcos Oliveira',   'marcos.dir@uni.edu.br',    '1234', 'Diretor de Unidade',   'Diretoria Acadêmica'),
    ('22222222222', 'Ana Silva',         'ana.coord@uni.edu.br',     '1234', 'Coordenador de Curso', 'Ciência de Dados'),
    ('33333333333', 'Carlos Mendes',     'carlos.prof@uni.edu.br',   '1234', 'Professor',            'Ciência de Dados'),
    ('44444444444', 'Beatriz Santos',    'bia.sup@uni.edu.br',       '123',  'Supervisor',           'Tutoria EAD'),
    ('55555555555', 'Lucas Pereira',     'lucas.tutor@uni.edu.br',   '1234', 'Tutor',                'Tutoria EAD'),
    ('66666666666', 'Fernanda Lima',     'fer.supti@uni.edu.br',     '1234', 'Supervisor de TI',     'Infraestrutura e TI'),
    ('77777777777', 'Rafael Costa',      'rafa.ti@uni.edu.br',       '1234', 'Técnico de TI',        'Infraestrutura e TI'),

    -- ID 8 (+1 Coordenador de Curso -> total 2)
    ('88888888888', 'Juliana Rocha',     'juliana.coord@uni.edu.br', '1234', 'Coordenador de Curso', 'Engenharia de Software'),

    -- IDs 9 a 17 (+9 Tutores -> total 10)
    ('99999999999', 'Camila Ferreira',   'camila.tutor@uni.edu.br',  '1234', 'Tutor',                'Tutoria EAD'),
    ('10101010101', 'Bruno Souza',       'bruno.tutor@uni.edu.br',   '1234', 'Tutor',                'Tutoria EAD'),
    ('12121212121', 'Mariana Gomes',     'mariana.tutor@uni.edu.br', '1234', 'Tutor',                'Tutoria EAD'),
    ('13131313131', 'Thiago Martins',    'thiago.tutor@uni.edu.br',  '1234', 'Tutor',                'Tutoria EAD'),
    ('14141414141', 'Larissa Barbosa',   'larissa.tutor@uni.edu.br', '1234', 'Tutor',                'Tutoria EAD'),
    ('15151515151', 'Gabriel Ribeiro',   'gabriel.tutor@uni.edu.br', '1234', 'Tutor',                'Tutoria EAD'),
    ('16161616161', 'Amanda Carvalho',   'amanda.tutor@uni.edu.br',  '1234', 'Tutor',                'Tutoria EAD'),
    ('17171717171', 'Felipe Nascimento', 'felipe.tutor@uni.edu.br',  '1234', 'Tutor',                'Tutoria EAD'),
    ('18181818181', 'Patrícia Moreira',  'patricia.tutor@uni.edu.br','1234', 'Tutor',                'Tutoria EAD'),

    -- IDs 18 e 19 (+2 Professores -> total 3) e ID 20 (+1 Supervisor -> total 2)
    ('19191919191', 'Rodrigo Teixeira',  'rodrigo.prof@uni.edu.br',  '1234', 'Professor',            'Engenharia de Software'),
    ('20202020202', 'Ricardo Almeida',   'ricardo.prof@uni.edu.br',  '1234', 'Professor',            'Ciência de Dados'),
    ('21212121212', 'Vanessa Cardoso',   'vanessa.sup@uni.edu.br',   '1234', 'Supervisor',           'Tutoria EAD');

-- CRITÉRIOS DE AVALIAÇÃO 
INSERT INTO Criterio (nome, descricao) VALUES
    ('Comunicação e Transparência',               'Clareza nas orientações, escuta ativa e transparência nos processos'),
    ('Comprometimento e Entregas',                'Cumprimento de prazos, organização e responsabilidade pelos resultados'),
    ('Cooperação e Trabalho em Equipe',           'Colaboração, compartilhamento de conhecimento e apoio entre colegas'),
    ('Didática e Apoio Acadêmico',                'Clareza didática e metodologias de ensino (exclusivo para Docentes/Tutores)'),
    ('Bem-estar e Ambiente de Trabalho',          'Avalia nível de contentamento, estresse, clima organizacional e ergonomia'),
    ('Desenvolvimento e Realização Profissional', 'Avalia satisfação na carreira, capacitação contínua e cursos de aprimoramento');

-- QUESTÕES (IDs: 1 a 30 -> 27 ESCALA e 3 TEXTO_LIVRE)
INSERT INTO Questao (enunciado, tipo, id_criterio) VALUES
    -- Questões originais mantidas (IDs 1 a 5)
    ('Comunica orientações, demandas e feedbacks de forma clara?',                                               'ESCALA',      1),
    ('Cumpre os prazos acadêmicos ou técnicos com qualidade?',                                                    'ESCALA',      2),
    ('Colabora com os colegas do setor na resolução de problemas?',                                               'ESCALA',      3),
    ('Apresenta os conteúdos e tira dúvidas com clareza didática?',                                               'ESCALA',      4),
    ('Destaque um ponto forte ou sugestão de melhoria para este colega:',                                         'TEXTO_LIVRE', 1),

    -- Comunicação e Transparência (Critério 1 - IDs 6 a 8)
    ('Escuta ativamente as opiniões e sugestões da equipe antes de tomar decisões?',                              'ESCALA',      1),
    ('Mantém os colegas informados sobre mudanças importantes nos processos ou cronogramas?',                     'ESCALA',      1),
    ('Age com transparência e respeito ao tratar divergências ou conflitos no setor?',                           'ESCALA',      1),

    -- Comprometimento e Entregas (Critério 2 - IDs 9 a 11)
    ('Demonstra organização e planejamento na execução das suas atividades diárias?',                            'ESCALA',      2),
    ('Assume responsabilidade pelos resultados de suas entregas, buscando soluções diante de imprevistos?',      'ESCALA',      2),
    ('Utiliza os recursos e ferramentas da universidade de forma eficiente e ética?',                             'ESCALA',      2),

    -- Cooperação e Trabalho em Equipe (Critério 3 - IDs 12 a 15)
    ('Compartilha conhecimentos, materiais e boas práticas espontaneamente com os colegas?',                     'ESCALA',      3),
    ('Demonstra disponibilidade para auxiliar membros da equipe em períodos de alta demanda?',                    'ESCALA',      3),
    ('Contribui para um clima de cooperação mútua e confiança entre diferentes setores?',                         'ESCALA',      3),
    ('Integra e acolhe bem novos colaboradores, estagiários ou docentes na rotina da equipe?',                   'ESCALA',      3),

    -- Didática e Apoio Acadêmico (Critério 4 - IDs 16 a 17 - exclusivas para Docentes/Tutores na trigger)
    ('Atualiza constantemente as metodologias e materiais didáticos utilizados nas aulas ou tutorias?',           'ESCALA',      4),
    ('Estimula o pensamento crítico e a participação ativa dos estudantes durante as atividades?',               'ESCALA',      4),

    -- Bem-estar, Contentamento, Estresse e Ambiente de Trabalho (Critério 5 - IDs 18 a 23)
    ('Qual é o seu nível atual de contentamento e satisfação geral com o seu trabalho na universidade?',          'ESCALA',      5),
    ('Como você avalia o seu nível de equilíbrio emocional e controle do estresse na rotina atual?',              'ESCALA',      5),
    ('O volume de demandas e prazos atuais permite manter uma carga de trabalho saudável?',                       'ESCALA',      5),
    ('Você sente que o ambiente físico e digital do seu setor é confortável, seguro e acolhedor?',                'ESCALA',      5),
    ('Sente-se respeitado(a) e valorizado(a) como pessoa pelas lideranças e colegas no dia a dia?',                'ESCALA',      5),
    ('Consegue conciliar satisfatoriamente sua vida pessoal e familiar com as responsabilidades profissionais?',   'ESCALA',      5),

    -- Realização Profissional e Cursos de Aprimoramento (Critério 6 - IDs 24 a 28)
    ('Sente-se profissionalmente realizado(a) com as atividades e desafios que desempenha atualmente?',           'ESCALA',      6),
    ('Enxerga oportunidades claras de crescimento e evolução na carreira dentro da instituição?',                 'ESCALA',      6),
    ('Com que frequência você realiza cursos de aprimoramento, capacitações ou leituras técnicas na sua área?',   'ESCALA',      6),
    ('Como você avalia o nível de profundidade e aplicabilidade dos cursos de aprimoramento que vem realizando?', 'ESCALA',      6),
    ('O quanto a instituição incentiva e apoia a sua participação em eventos, pós-graduações ou capacitações?',   'ESCALA',      6),

    -- Questões Abertas solicitadas (IDs 29 e 30 -> totalizando 3 TEXTO_LIVRE junto com o ID 5)
    ('Como a nossa universidade poderia contribuir para o seu desenvolvimento pessoal e profissional?',            'TEXTO_LIVRE', 6),
    ('Apresente ideias que promovam um ambiente de trabalho mais acolhedor e confortável:',                       'TEXTO_LIVRE', 5);

-- CICLOS DE AVALIAÇÃO (IDs: 1 a 5 — atende ao mínimo de 5 avaliações do edital)
INSERT INTO Ciclo_Avaliacao (titulo, data_inicio, data_fim) VALUES
    ('Avaliação Institucional 360° - 2026/2',       DATE '2026-11-01', DATE '2026-11-30'),
    ('Avaliação Docente e Tutoria - 2026/2',        DATE '2026-11-01', DATE '2026-11-30'),
    ('Pesquisa de Clima e Bem-estar - 2026/2',      DATE '2026-10-01', DATE '2026-10-31'),
    ('Avaliação de Desenvolvimento e Carreira',     DATE '2026-09-01', DATE '2026-09-30'),
    ('Avaliação de Cooperação Intersetorial',       DATE '2026-08-01', DATE '2026-08-31');

-- QUESTÕES POR CICLO COM PESOS DIFERENCIADOS (Ciclo_Questao)
-- Pesos: 2.0 (critério central do ciclo), 1.5 (critério secundário), 1.0 (padrão e questões abertas)
INSERT INTO Ciclo_Questao (id_ciclo, id_questao, peso, ordem) VALUES
    -- CICLO 1: Avaliação Institucional 360° (foco em entregas e comunicação)
    (1, 1,  1.5, 1),  -- Comunicação clara
    (1, 2,  2.0, 2),  -- Prazos e qualidade (peso máximo)
    (1, 3,  1.5, 3),  -- Cooperação
    (1, 6,  1.0, 4),  -- Escuta ativa
    (1, 7,  1.0, 5),  -- Transparência em mudanças
    (1, 9,  1.5, 6),  -- Organização diária
    (1, 10, 2.0, 7),  -- Responsabilidade pelos resultados (peso máximo)
    (1, 11, 1.0, 8),  -- Uso eficiente de recursos
    (1, 5,  1.0, 9),  -- Aberta: ponto forte / melhoria

    -- CICLO 2: Avaliação Docente e Tutoria (exclusivo para Docentes/Tutores — trigger Didática)
    (2, 1,  1.0, 1),  -- Comunicação
    (2, 4,  2.0, 2),  -- Clareza didática (peso máximo)
    (2, 16, 2.0, 3),  -- Atualização de metodologias didáticas (peso máximo)
    (2, 17, 1.5, 4),  -- Estímulo ao pensamento crítico
    (2, 2,  1.0, 5),  -- Prazos acadêmicos
    (2, 5,  1.0, 6),  -- Aberta: ponto forte / melhoria

    -- CICLO 3: Pesquisa de Clima e Bem-estar (contentamento, estresse e ambiente)
    (3, 18, 2.0, 1),  -- Contentamento e satisfação geral (peso máximo)
    (3, 19, 2.0, 2),  -- Equilíbrio emocional e controle do estresse (peso máximo)
    (3, 20, 1.5, 3),  -- Carga de trabalho saudável
    (3, 21, 1.5, 4),  -- Conforto e acolhimento do ambiente
    (3, 22, 1.5, 5),  -- Respeito e valorização
    (3, 23, 1.5, 6),  -- Conciliação vida pessoal e profissional
    (3, 30, 1.0, 7),  -- Aberta: ideias para ambiente acolhedor

    -- CICLO 4: Avaliação de Desenvolvimento e Carreira (realização e cursos)
    (4, 24, 2.0, 1),  -- Realização profissional (peso máximo)
    (4, 25, 1.5, 2),  -- Oportunidades de crescimento
    (4, 26, 1.5, 3),  -- Frequência de cursos de aprimoramento
    (4, 27, 2.0, 4),  -- Profundidade e aplicabilidade dos cursos (peso máximo)
    (4, 28, 1.5, 5),  -- Incentivo institucional para capacitações
    (4, 29, 1.0, 6),  -- Aberta: como a universidade pode contribuir

    -- CICLO 5: Avaliação de Cooperação Intersetorial (trabalho em equipe e integração)
    (5, 3,  2.0, 1),  -- Colaboração na resolução de problemas (peso máximo)
    (5, 8,  1.5, 2),  -- Transparência ao tratar divergências
    (5, 12, 1.5, 3),  -- Compartilhamento de conhecimentos
    (5, 13, 2.0, 4),  -- Disponibilidade em alta demanda (peso máximo)
    (5, 14, 1.5, 5),  -- Clima de confiança entre setores
    (5, 15, 1.5, 6),  -- Acolhimento de novos membros
    (5, 30, 1.0, 7);  -- Aberta: ideias para ambiente acolhedor

-- DESIGNAÇÕES 360° (Quem avalia quem — núcleos separados!)
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


-- RESPOSTAS ANÔNIMAS DAS AVALIAÇÕES CONCLUÍDAS
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


    -- ---------------------------------
    -- complemento de respostas para outros ciclos e avaliados 
    -------------------------------------


-- ============================================================================
-- 8. COMPLEMENTO DE DESIGNAÇÕES 360° (CICLOS 3, 4 E 5 — NOVOS COLABORADORES)
-- ============================================================================
INSERT INTO Designacao_360 (id_ciclo, id_avaliador, id_avaliado, relacao, status) VALUES
    -- CICLO 3 (Pesquisa de Clima e Bem-estar — questões 18, 19, 20, 21, 22, 23, 30)
    (3, 8,  8,  'AUTOAVALIACAO', 'CONCLUIDA'), -- Juliana (Coord. Eng. Software)
    (3, 18, 8,  'LIDERADO',      'CONCLUIDA'), -- Rodrigo (Prof.) avalia Juliana
    (3, 1,  8,  'GESTOR',        'CONCLUIDA'), -- Marcos (Diretor) avalia Juliana
    (3, 9,  9,  'AUTOAVALIACAO', 'CONCLUIDA'), -- Camila (Tutora)
    (3, 20, 9,  'GESTOR',        'CONCLUIDA'), -- Vanessa (Supervisora) avalia Camila
    (3, 10, 11, 'PAR',           'CONCLUIDA'), -- Bruno (Tutor) avalia Mariana (Tutora)
    (3, 12, 13, 'PAR',           'PENDENTE'),  -- Thiago avalia Larissa (pendente para relatórios)

    -- CICLO 4 (Desenvolvimento e Carreira — questões 24, 25, 26, 27, 28, 29)
    (4, 18, 18, 'AUTOAVALIACAO', 'CONCLUIDA'), -- Prof. Rodrigo
    (4, 8,  18, 'GESTOR',        'CONCLUIDA'), -- Juliana (Coord.) avalia Rodrigo
    (4, 19, 19, 'AUTOAVALIACAO', 'CONCLUIDA'), -- Prof. Ricardo
    (4, 2,  19, 'GESTOR',        'CONCLUIDA'), -- Ana (Coord.) avalia Ricardo
    (4, 20, 14, 'GESTOR',        'CONCLUIDA'), -- Vanessa (Sup.) avalia Gabriel (Tutor)
    (4, 4,  15, 'GESTOR',        'PENDENTE'),  -- Beatriz avalia Amanda (pendente)

    -- CICLO 5 (Cooperação Intersetorial — questões 3, 8, 12, 13, 14, 15, 30)
    (5, 2,  8,  'PAR',           'CONCLUIDA'), -- Ana avalia Juliana (entre coordenações)
    (5, 8,  2,  'PAR',           'CONCLUIDA'), -- Juliana avalia Ana
    (5, 16, 17, 'PAR',           'CONCLUIDA'), -- Felipe avalia Patrícia (Tutores)
    (5, 6,  20, 'PAR',           'CONCLUIDA'), -- Fernanda (Sup. TI) avalia Vanessa (Sup. Tutoria)
    (5, 17, 16, 'PAR',           'PENDENTE');  -- Patrícia avalia Felipe (pendente)

-- ============================================================================
-- 9. COMPLEMENTO DE RESPOSTAS ANÔNIMAS (CICLOS 3, 4 E 5)
-- ============================================================================
INSERT INTO Resposta (id_submissao, id_ciclo, id_avaliado, id_questao, relacao, nota_escala, texto_resposta) VALUES
    -- CICLO 3: Clima e Bem-estar — Coord. Juliana (ID 8)
    ('sub-c3-001', 3, 8,  18, 'AUTOAVALIACAO', 4, NULL),
    ('sub-c3-001', 3, 8,  19, 'AUTOAVALIACAO', 3, NULL),
    ('sub-c3-001', 3, 8,  20, 'AUTOAVALIACAO', 3, NULL),
    ('sub-c3-001', 3, 8,  30, 'AUTOAVALIACAO', NULL, 'Criar salas silenciosas para atendimento síncrono.'),

    ('sub-c3-002', 3, 8,  18, 'LIDERADO',      5, NULL),
    ('sub-c3-002', 3, 8,  21, 'LIDERADO',      5, NULL),
    ('sub-c3-002', 3, 8,  22, 'LIDERADO',      5, NULL),
    ('sub-c3-002', 3, 8,  30, 'LIDERADO',      NULL, 'Coordenação acessível e aberta ao diálogo.'),

    ('sub-c3-003', 3, 8,  18, 'GESTOR',        5, NULL),
    ('sub-c3-003', 3, 8,  23, 'GESTOR',        4, NULL),

    -- CICLO 3: Clima e Bem-estar — Tutora Camila (ID 9) e Tutora Mariana (ID 11)
    ('sub-c3-004', 3, 9,  18, 'AUTOAVALIACAO', 5, NULL),
    ('sub-c3-004', 3, 9,  19, 'AUTOAVALIACAO', 4, NULL),
    ('sub-c3-005', 3, 9,  21, 'GESTOR',        5, NULL),
    ('sub-c3-005', 3, 9,  22, 'GESTOR',        5, NULL),
    ('sub-c3-006', 3, 11, 18, 'PAR',           4, NULL),
    ('sub-c3-006', 3, 11, 20, 'PAR',           4, NULL),

    -- CICLO 4: Desenvolvimento e Carreira — Prof. Rodrigo (ID 18) e Prof. Ricardo (ID 19)
    ('sub-c4-001', 4, 18, 24, 'AUTOAVALIACAO', 5, NULL),
    ('sub-c4-001', 4, 18, 26, 'AUTOAVALIACAO', 4, NULL),
    ('sub-c4-001', 4, 18, 29, 'AUTOAVALIACAO', NULL, 'Bolsa parcial para congressos internacionais de Engenharia de Software.'),

    ('sub-c4-002', 4, 18, 24, 'GESTOR',        5, NULL),
    ('sub-c4-002', 4, 18, 27, 'GESTOR',        5, NULL),
    ('sub-c4-002', 4, 18, 28, 'GESTOR',        4, NULL),

    ('sub-c4-003', 4, 19, 24, 'AUTOAVALIACAO', 4, NULL),
    ('sub-c4-003', 4, 19, 25, 'AUTOAVALIACAO', 4, NULL),
    ('sub-c4-004', 4, 19, 27, 'GESTOR',        5, NULL),
    ('sub-c4-004', 4, 19, 29, 'GESTOR',        NULL, 'Ampliar acesso a clusters GPU para pesquisa aplicada.'),

    ('sub-c4-005', 4, 14, 24, 'GESTOR',        4, NULL),
    ('sub-c4-005', 4, 14, 26, 'GESTOR',        5, NULL),

    -- CICLO 5: Cooperação Intersetorial — Coordenações e Supervisões
    ('sub-c5-001', 5, 8,  3,  'PAR',           5, NULL),
    ('sub-c5-001', 5, 8,  12, 'PAR',           5, NULL),
    ('sub-c5-001', 5, 8,  14, 'PAR',           5, NULL),

    ('sub-c5-002', 5, 2,  3,  'PAR',           5, NULL),
    ('sub-c5-002', 5, 2,  13, 'PAR',           4, NULL),
    ('sub-c5-002', 5, 2,  30, 'PAR',           NULL, 'Reuniões mensais de alinhamento curricular entre cursos.'),

    ('sub-c5-003', 5, 17, 12, 'PAR',           4, NULL),
    ('sub-c5-003', 5, 17, 15, 'PAR',           5, NULL),

    ('sub-c5-004', 5, 20, 13, 'PAR',           5, NULL),
    ('sub-c5-004', 5, 20, 14, 'PAR',           5, NULL);