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

-- 2. CRITÉRIOS DE AVALIAÇÃO
INSERT INTO Criterio (nome, descricao) VALUES
    ('Bem-estar e Ambiente de Trabalho', 'Avalia nível de contentamento, estresse, clima organizacional e ergonomia'),
    ('Desenvolvimento e Realização Profissional', 'Avalia satisfação na carreira, capacitação contínua e cursos de aprimoramento');

-- 3. QUESTÕES (IDs: 1 a 30 -> 27 ESCALA e 3 TEXTO_LIVRE)
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

-- 4. CICLOS DE AVALIAÇÃO (IDs: 1 a 5 — atende ao mínimo de 5 avaliações do edital)
INSERT INTO Ciclo_Avaliacao (titulo, data_inicio, data_fim) VALUES
    ('Avaliação Institucional 360° - 2026/2',       DATE '2026-11-01', DATE '2026-11-30'),
    ('Avaliação Docente e Tutoria - 2026/2',        DATE '2026-11-01', DATE '2026-11-30'),
    ('Pesquisa de Clima e Bem-estar - 2026/2',      DATE '2026-10-01', DATE '2026-10-31'),
    ('Avaliação de Desenvolvimento e Carreira',     DATE '2026-09-01', DATE '2026-09-30'),
    ('Avaliação de Cooperação Intersetorial',       DATE '2026-08-01', DATE '2026-08-31');

-- 5. QUESTÕES POR CICLO COM PESOS DIFERENCIADOS (Ciclo_Questao)
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