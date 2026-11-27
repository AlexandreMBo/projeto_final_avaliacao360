Esquema Relacional do Sistema de Avaliação 360°

O esquema possui 7 tabelas que armazenam os dados dos colaboradores, critérios, questões, ciclos de avaliação, designações e respostas anônimas.

1 - Tabelas do sistema

COLABORADOR (id_colaborador, cpf, nome, email, senha, cargo, departamento)

Restrições: id_colaborador é a chave primária (PK). O cpf e o email são chaves alternativas (UNIQUE) e não podem ser repetidos. Uma trigger no banco valida os cargos permitidos antes de inserir ou atualizar registros.

CRITERIO (id_criterio, nome)

Restrições: id_criterio é a chave primária (PK). O nome é UNIQUE e não pode ser repetido.

QUESTAO (id_questao, enunciado, tipo, id_criterio)

Restrições: id_questao é a chave primária (PK). O id_criterio é chave estrangeira (FK) que referencia CRITERIO(id_criterio). O campo tipo aceita apenas valores de escala numérica ou texto livre.

CICLO_AVALIACAO (id_ciclo, titulo, data_inicio, data_fim)

Restrições: id_ciclo é a chave primária (PK). A data_fim deve ser maior ou igual à data_inicio.

CICLO_QUESTAO (id_ciclo, id_questao, peso, ordem)

Restrições: A chave primária (PK) é composta por id_ciclo e id_questao. São chaves estrangeiras (FK) que referenciam CICLO_AVALIACAO e QUESTAO. O peso deve ser maior que zero e a ordem é obrigatória (NOT NULL) para ordenar o questionário no ciclo.

DESIGNACAO_360 (id_ciclo, id_avaliador, id_avaliado, relacao, status)

Restrições: A chave primária (PK) é composta por id_ciclo, id_avaliador e id_avaliado (garante que cada avaliador avalie cada avaliado apenas uma vez por ciclo). O id_ciclo referencia CICLO_AVALIACAO, e tanto id_avaliador quanto id_avaliado são chaves estrangeiras (FK) que referenciam COLABORADOR(id_colaborador). A relacao aceita AUTOAVALIACAO (peso 1,0), PAR (peso 1,5), GESTOR (peso 2,0) ou LIDERADO (peso 1,5), e o status aceita PENDENTE ou CONCLUIDA.

RESPOSTA (id_submissao, id_ciclo, id_avaliado, id_questao, relacao, peso_relacao, nota_escala, texto_resposta)

Restrições: A chave primária (PK) é composta por id_submissao (protocolo UUID gerado por envio) e id_questao. Possui chave estrangeira (FK) composta (id_ciclo, id_questao) referenciando CICLO_QUESTAO e FK id_avaliado referenciando COLABORADOR(id_colaborador). A tabela não armazena id_avaliador para assegurar o anonimato das respostas. A nota_escala aceita apenas valores inteiros de 1 a 5.

2 - Justificativa da Terceira Forma Normal (3FN)

O esquema está na 3FN porque todos os campos guardam apenas um valor atômico sem listas dentro de uma mesma coluna (1FN), todos os atributos não-chave nas tabelas de chave composta dependem da chave primária inteira (2FN), e não existe dependência transitiva entre atributos comuns (3FN) — por exemplo, o nome do critério fica isolado na tabela CRITERIO para não repetir texto em QUESTAO, o peso específico de cada pergunta no semestre fica na tabela associativa CICLO_QUESTAO, e a média final ponderada de cada colaborador é calculada dinamicamente nas consultas SQL em vez de ser armazenada como coluna derivada.