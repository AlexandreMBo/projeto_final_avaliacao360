Esquema Relacional do Sistema de Avaliação 360°

O esquema possui 7 tabelas que armazenam os dados dos colaboradores, critérios, questões, ciclos de avaliação, avaliadores e respostas.

1 - Tabelas do sistema

COLABORADOR (id_colaborador, cpf, nome, email, senha, cargo, departamento)
Restrições: id_colaborador é a chave primária (PK). O cpf e o email são chaves alternativas (UNIQUE) e não podem ser repetidos.

CRITERIO (id_criterio, nome)
Restrições: id_criterio é a chave primária (PK). O nome é UNIQUE e não pode ser repetido.

QUESTAO (id_questao, enunciado, tipo, id_criterio)
Restrições: id_questao é a chave primária (PK). O id_criterio é chave estrangeira (FK) que referencia CRITERIO(id_criterio). O tipo aceita apenas ESCALA ou TEXTO_LIVRE.

CICLO_AVALIACAO (id_ciclo, titulo, data_inicio, data_fim)
Restrições: id_ciclo é a chave primária (PK). A data_fim deve ser maior ou igual à data_inicio.

CICLO_QUESTAO (id_ciclo, id_questao, peso, ordem)
Restrições: A chave primária (PK) é composta por id_ciclo e id_questao. São chaves estrangeiras (FK) que referenciam CICLO_AVALIACAO e QUESTAO. O peso deve ser maior que zero.

DESIGNACAO_360 (id_ciclo, id_avaliador, id_avaliado, relacao, status)
Restrições: A chave primária (PK) é composta por id_ciclo, id_avaliador e id_avaliado (garante que cada avaliador avalie cada avaliado apenas uma vez por ciclo). O id_ciclo referencia CICLO_AVALIACAO, e tanto id_avaliador quanto id_avaliado são chaves estrangeiras (FK) que referenciam COLABORADOR(id_colaborador). A relacao aceita AUTOAVALIACAO (peso 1,0), PAR (peso 1,5), GESTOR (peso 2,0) ou LIDERADO (peso 1,5), e o status aceita PENDENTE ou CONCLUIDA.

RESPOSTA (id_ciclo, id_avaliador, id_avaliado, id_questao, nota_escala, texto_resposta)
Restrições: A chave primária (PK) é composta por id_ciclo, id_avaliador, id_avaliado e id_questao. Possui duas chaves estrangeiras (FK) compostas: (id_ciclo, id_avaliador, id_avaliado) referencia DESIGNACAO_360 e (id_ciclo, id_questao) referencia CICLO_QUESTAO. A nota_escala aceita apenas valores de 1 a 5.

2 - Justificativa da Terceira Forma Normal (3FN)

O esquema está na 3FN porque todos os campos guardam apenas um valor simples sem listas dentro de uma mesma coluna (1FN), todos os campos comuns nas tabelas de chave composta dependem da chave primária inteira (2FN), e não existe um campo comum dependendo de outro campo comum (3FN) — por exemplo, o nome do critério fica isolado na tabela CRITERIO para não repetir texto em QUESTAO, e a média final de cada colaborador é calculada na hora da consulta em vez de ser salva como coluna fixa.