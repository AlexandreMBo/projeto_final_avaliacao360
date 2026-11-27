-- ----------------------------------------------------------------------------
-- relatorios.sql
-- consultas para extrair as notas finais, médias por tema, comentários e pendências
-- ----------------------------------------------------------------------------

-- 1. nota final ponderada de cada pessoa por ciclo (com ranking)
-- multiplica a nota pelo peso da pergunta e pelo peso de quem avaliou (ex: gestor vale 2.0, par 1.5),
-- depois divide pela soma dos pesos para chegar na média final de 1 a 5
SELECT 
    RANK() OVER (
        PARTITION BY ca.titulo
        ORDER BY ROUND(
            SUM(r.nota_escala * cq.peso * r.peso_relacao) / SUM(cq.peso * r.peso_relacao),
            2
        ) DESC
    ) AS posicao_ranking,
    ca.titulo AS ciclo,
    col.nome AS avaliado,
    col.cargo,
    col.departamento,
    ROUND(
        SUM(r.nota_escala * cq.peso * r.peso_relacao) / SUM(cq.peso * r.peso_relacao),
        2
    ) AS media_ponderada_final
FROM Resposta r
JOIN Colaborador col     ON r.id_avaliado = col.id_colaborador
JOIN Ciclo_Avaliacao ca  ON r.id_ciclo = ca.id_ciclo
JOIN Ciclo_Questao cq    ON r.id_ciclo = cq.id_ciclo AND r.id_questao = cq.id_questao
WHERE r.nota_escala IS NOT NULL -- ignora perguntas de texto livre para não atrapalhar a conta
GROUP BY ca.titulo, col.nome, col.cargo, col.departamento
ORDER BY ca.titulo, media_ponderada_final DESC;

-- 2. notas separadas por competência (critério)
-- mostra tanto a média simples quanto a média com peso para cada tema avaliado (comunicação, prazos, didática, etc.)
SELECT 
    ca.titulo AS ciclo,
    col.nome AS avaliado,
    cr.nome AS criterio,
    ROUND(AVG(r.nota_escala), 2) AS media_simples_criterio,
    ROUND(
        SUM(r.nota_escala * r.peso_relacao) / SUM(r.peso_relacao),
        2
    ) AS media_ponderada_criterio
FROM Resposta r
JOIN Colaborador col     ON r.id_avaliado = col.id_colaborador
JOIN Ciclo_Avaliacao ca  ON r.id_ciclo = ca.id_ciclo
JOIN Questao q           ON r.id_questao = q.id_questao
JOIN Criterio cr         ON q.id_criterio = cr.id_criterio
WHERE r.nota_escala IS NOT NULL
GROUP BY ca.titulo, col.nome, cr.nome
ORDER BY col.nome, ca.titulo, media_ponderada_criterio DESC;

-- 3. feedbacks escritos (texto livre)
-- traz os comentários mantendo o sigilo: mostra só o papel de quem escreveu (gestor, par, liderado), sem o nome
SELECT 
    ca.titulo AS ciclo,
    col.nome AS avaliado,
    r.relacao AS perspectiva_avaliador,
    r.texto_resposta AS comentario_anonimo
FROM Resposta r
JOIN Colaborador col     ON r.id_avaliado = col.id_colaborador
JOIN Ciclo_Avaliacao ca  ON r.id_ciclo = ca.id_ciclo
WHERE r.texto_resposta IS NOT NULL -- pega apenas as respostas que têm texto escrito
ORDER BY col.nome, ca.titulo, r.relacao;

-- 4. lista de avaliações pendentes
-- olha na tabela de designações quem ainda não terminou de responder para poder cobrar
SELECT 
    ca.titulo AS ciclo,
    av.nome AS avaliador_pendente,
    av.email,
    alvo.nome AS colega_a_avaliar,
    d.relacao
FROM Designacao_360 d
JOIN Ciclo_Avaliacao ca  ON d.id_ciclo = ca.id_ciclo
JOIN Colaborador av      ON d.id_avaliador = av.id_colaborador
JOIN Colaborador alvo    ON d.id_avaliado = alvo.id_colaborador
WHERE d.status = 'PENDENTE'
ORDER BY ca.titulo, av.nome;

-- 5. taxa de participação por colaborador (usando LEFT JOIN)
-- mostra todos os 20 colaboradores, mesmo quem ainda não recebeu nenhuma designação como avaliador
SELECT 
    col.nome AS colaborador,
    col.cargo,
    col.departamento,
    COUNT(d.id_ciclo) AS total_designacoes,
    COUNT(CASE WHEN d.status = 'CONCLUIDA' THEN 1 END) AS concluidas,
    COUNT(CASE WHEN d.status = 'PENDENTE'  THEN 1 END) AS pendentes
FROM Colaborador col
LEFT JOIN Designacao_360 d ON col.id_colaborador = d.id_avaliador
GROUP BY col.id_colaborador, col.nome, col.cargo, col.departamento
ORDER BY total_designacoes DESC, col.nome;

-- 6. colaboradores acima da média geral da instituição (usando GROUP BY, HAVING e subconsulta)
-- filtra quem teve média ponderada maior que a média global de todas as respostas registradas
SELECT 
    col.nome AS colaborador,
    col.cargo,
    col.departamento,
    ROUND(
        SUM(r.nota_escala * cq.peso * r.peso_relacao) / SUM(cq.peso * r.peso_relacao),
        2
    ) AS media_colaborador
FROM Resposta r
JOIN Colaborador col   ON r.id_avaliado = col.id_colaborador
JOIN Ciclo_Questao cq  ON r.id_ciclo = cq.id_ciclo AND r.id_questao = cq.id_questao
WHERE r.nota_escala IS NOT NULL
GROUP BY col.id_colaborador, col.nome, col.cargo, col.departamento
HAVING (
    SUM(r.nota_escala * cq.peso * r.peso_relacao) / SUM(cq.peso * r.peso_relacao)
) > (
    -- subconsulta que calcula a média ponderada geral da instituição
    SELECT SUM(r2.nota_escala * cq2.peso * r2.peso_relacao) / SUM(cq2.peso * r2.peso_relacao)
    FROM Resposta r2
    JOIN Ciclo_Questao cq2 ON r2.id_ciclo = cq2.id_ciclo AND r2.id_questao = cq2.id_questao
    WHERE r2.nota_escala IS NOT NULL
)
ORDER BY media_colaborador DESC;