package web;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;
import dao.Conexao;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class ServidorWeb {

    public static void main(String[] args) throws IOException {
        int porta = 8080;
        HttpServer server = HttpServer.create(new InetSocketAddress(porta), 0);

        // Página HTML principal
        server.createContext("/", exchange -> {
            if (!"/".equals(exchange.getRequestURI().getPath())) {
                enviarResposta(exchange, 404, "text/plain; charset=UTF-8", "404 - Não encontrado");
                return;
            }
            Path htmlPath = Path.of("web", "index.html");
            if (!Files.exists(htmlPath)) {
                enviarResposta(exchange, 500, "text/plain; charset=UTF-8", "Arquivo web/index.html não encontrado.");
                return;
            }
            byte[] bytes = Files.readAllBytes(htmlPath);
            exchange.getResponseHeaders().set("Content-Type", "text/html; charset=UTF-8");
            exchange.sendResponseHeaders(200, bytes.length);
            try (OutputStream os = exchange.getResponseBody()) {
                os.write(bytes);
            }
        });

        // 1. Ranking Geral Ponderado
        server.createContext("/api/ranking", exchange -> responderJsonSql(exchange, """
            SELECT DENSE_RANK() OVER (PARTITION BY ca.titulo ORDER BY
                   ROUND(SUM(r.nota_escala * cq.peso * r.peso_relacao) / SUM(cq.peso * r.peso_relacao), 2) DESC) AS posicao_ranking,
                   ca.titulo AS ciclo,
                   col.nome AS avaliado,
                   col.cargo,
                   col.departamento,
                   ROUND(SUM(r.nota_escala * cq.peso * r.peso_relacao) / SUM(cq.peso * r.peso_relacao), 2) AS media_ponderada_final
            FROM Resposta r
            JOIN Colaborador col    ON r.id_avaliado = col.id_colaborador
            JOIN Ciclo_Avaliacao ca ON r.id_ciclo = ca.id_ciclo
            JOIN Ciclo_Questao cq   ON r.id_ciclo = cq.id_ciclo AND r.id_questao = cq.id_questao
            WHERE r.nota_escala IS NOT NULL
            GROUP BY ca.titulo, col.nome, col.cargo, col.departamento
            ORDER BY ca.titulo, media_ponderada_final DESC
        """));

        // 2. Desempenho por Critério
        server.createContext("/api/criterios", exchange -> responderJsonSql(exchange, """
            SELECT c.nome AS criterio,
                   ROUND(AVG(r.nota_escala), 2) AS media_simples,
                   ROUND(SUM(r.nota_escala * cq.peso * r.peso_relacao) / SUM(cq.peso * r.peso_relacao), 2) AS media_ponderada
            FROM Resposta r
            JOIN Questao q        ON r.id_questao = q.id_questao
            JOIN Criterio c       ON q.id_criterio = c.id_criterio
            JOIN Ciclo_Questao cq ON r.id_ciclo = cq.id_ciclo AND r.id_questao = cq.id_questao
            WHERE r.nota_escala IS NOT NULL
            GROUP BY c.nome
            ORDER BY media_ponderada DESC
        """));

        // 3. Adesão e Pendências (LEFT JOIN)
        server.createContext("/api/adesao", exchange -> responderJsonSql(exchange, """
            SELECT col.id_colaborador,
                   col.nome AS colaborador,
                   col.departamento,
                   COUNT(d.id_designacao) AS total_designadas,
                   COUNT(CASE WHEN d.status = 'CONCLUIDA' THEN 1 END) AS concluidas,
                   COUNT(CASE WHEN d.status = 'PENDENTE' THEN 1 END) AS pendentes
            FROM Colaborador col
            LEFT JOIN Designacao_360 d ON col.id_colaborador = d.id_avaliador
            GROUP BY col.id_colaborador, col.nome, col.departamento
            ORDER BY concluidas DESC, pendentes DESC, col.nome
        """));

        // 4. Dados auxiliares para os formulários (Colaboradores, Critérios, Ciclos, Pendências e Questões)
        server.createContext("/api/colaboradores", exchange -> responderJsonSql(exchange,
            "SELECT id_colaborador, nome, email, cargo, departamento FROM Colaborador ORDER BY nome"));

        server.createContext("/api/lista-criterios", exchange -> responderJsonSql(exchange,
            "SELECT id_criterio, nome FROM Criterio ORDER BY id_criterio"));

        server.createContext("/api/ciclos", exchange -> responderJsonSql(exchange,
            "SELECT * FROM Ciclo_Avaliacao ORDER BY id_ciclo DESC"));

        server.createContext("/api/pendencias", exchange -> {
            Map<String, String> params = parseQuery(exchange.getRequestURI().getRawQuery());
            int idAvaliador = Integer.parseInt(params.getOrDefault("id_avaliador", "0"));
            String sql = """
                SELECT d.id_ciclo, ca.titulo AS ciclo, d.id_avaliado, alvo.nome AS avaliado, alvo.cargo, d.relacao
                FROM Designacao_360 d
                JOIN Ciclo_Avaliacao ca ON d.id_ciclo = ca.id_ciclo
                JOIN Colaborador alvo   ON d.id_avaliado = alvo.id_colaborador
                WHERE d.id_avaliador = %d AND d.status = 'PENDENTE'
                ORDER BY d.id_ciclo, alvo.nome
            """.formatted(idAvaliador);
            responderJsonSql(exchange, sql);
        });

        server.createContext("/api/questoes-ciclo", exchange -> {
            Map<String, String> params = parseQuery(exchange.getRequestURI().getRawQuery());
            int idCiclo = Integer.parseInt(params.getOrDefault("id_ciclo", "0"));
            String sql = """
                SELECT q.id_questao, c.nome AS criterio, q.enunciado, q.tipo_resposta, cq.peso
                FROM Ciclo_Questao cq
                JOIN Questao q  ON cq.id_questao = q.id_questao
                JOIN Criterio c ON q.id_criterio = c.id_criterio
                WHERE cq.id_ciclo = %d
                ORDER BY q.id_questao
            """.formatted(idCiclo);
            responderJsonSql(exchange, sql);
        });

// 5. POST: Cadastrar novo Colaborador
        server.createContext("/api/novo-colaborador", exchange -> {
            if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
                enviarResposta(exchange, 405, "application/json", "{\"erro\":\"Método não permitido\"}");
                return;
            }
            Map<String, String> form = parseFormBody(exchange);
            String sql = "INSERT INTO Colaborador (cpf, nome, email, senha, cargo, departamento) VALUES (?, ?, ?, ?, ?, ?) RETURNING id_colaborador";
            try (Connection conn = Conexao.conectar();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, form.get("cpf"));
                ps.setString(2, form.get("nome"));
                ps.setString(3, form.get("email"));
                ps.setString(4, form.get("senha"));
                ps.setString(5, form.get("cargo"));
                ps.setString(6, form.get("departamento"));
                ResultSet rs = ps.executeQuery();
                int novoId = rs.next() ? rs.getInt(1) : 0;
                enviarResposta(exchange, 200, "application/json; charset=UTF-8",
                        "{\"mensagem\":\"Colaborador cadastrado com sucesso!\",\"id\":" + novoId + "}");
            } catch (Exception e) {
                enviarResposta(exchange, 400, "application/json; charset=UTF-8",
                        "{\"erro\":\"" + escaparJson(e.getMessage()) + "\"}");
            }
        });

        // 6. POST: Cadastrar nova Questão e vincular ao Ciclo
        server.createContext("/api/nova-questao", exchange -> {
            if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
                enviarResposta(exchange, 405, "application/json", "{\"erro\":\"Método não permitido\"}");
                return;
            }
            Map<String, String> form = parseFormBody(exchange);
            try (Connection conn = Conexao.conectar()) {
                conn.setAutoCommit(false);
                try {
                    int idQuestao;
                    String sqlQ = "INSERT INTO Questao (id_criterio, enunciado, tipo_resposta) VALUES (?, ?, ?) RETURNING id_questao";
                    try (PreparedStatement psQ = conn.prepareStatement(sqlQ)) {
                        psQ.setInt(1, Integer.parseInt(form.get("id_criterio")));
                        psQ.setString(2, form.get("enunciado"));
                        psQ.setString(3, form.get("tipo_resposta"));
                        ResultSet rs = psQ.executeQuery();
                        rs.next();
                        idQuestao = rs.getInt(1);
                    }

                    String idCicloStr = form.get("id_ciclo");
                    if (idCicloStr != null && !idCicloStr.isBlank()) {
                        String sqlVinculo = "INSERT INTO Ciclo_Questao (id_ciclo, id_questao, peso) VALUES (?, ?, ?)";
                        try (PreparedStatement psV = conn.prepareStatement(sqlVinculo)) {
                            psV.setInt(1, Integer.parseInt(idCicloStr));
                            psV.setInt(2, idQuestao);
                            psV.setDouble(3, Double.parseDouble(form.getOrDefault("peso", "1.0").replace(",", ".")));
                            psV.executeUpdate();
                        }
                    }
                    conn.commit();
                    enviarResposta(exchange, 200, "application/json; charset=UTF-8",
                            "{\"mensagem\":\"Pergunta cadastrada e vinculada ao ciclo!\",\"id\":" + idQuestao + "}");
                } catch (Exception ex) {
                    conn.rollback();
                    throw ex;
                }
            } catch (Exception e) {
                enviarResposta(exchange, 400, "application/json; charset=UTF-8",
                        "{\"erro\":\"" + escaparJson(e.getMessage()) + "\"}");
            }
        });

        // 7. POST: Criar nova Designação 360°
        server.createContext("/api/nova-designacao", exchange -> {
            if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
                enviarResposta(exchange, 405, "application/json", "{\"erro\":\"Método não permitido\"}");
                return;
            }
            Map<String, String> form = parseFormBody(exchange);
            String sql = "INSERT INTO Designacao_360 (id_ciclo, id_avaliador, id_avaliado, relacao, status) VALUES (?, ?, ?, ?, 'PENDENTE')";
            try (Connection conn = Conexao.conectar();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(form.get("id_ciclo")));
                ps.setInt(2, Integer.parseInt(form.get("id_avaliador")));
                ps.setInt(3, Integer.parseInt(form.get("id_avaliado")));
                ps.setString(4, form.get("relacao"));
                ps.executeUpdate();
                enviarResposta(exchange, 200, "application/json; charset=UTF-8",
                        "{\"mensagem\":\"Designação 360° criada! Agora ela aparece na lista para responder.\"}");
            } catch (Exception e) {
                enviarResposta(exchange, 400, "application/json; charset=UTF-8",
                        "{\"erro\":\"" + escaparJson(e.getMessage()) + "\"}");
            }
        });

        // 8. POST: Responder Questionário 360° (Transação JDBC + Anonimato UUID)
        server.createContext("/api/responder", exchange -> {
            if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
                enviarResposta(exchange, 405, "application/json", "{\"erro\":\"Método não permitido\"}");
                return;
            }
            Map<String, String> form = parseFormBody(exchange);
            int idCiclo = Integer.parseInt(form.get("id_ciclo"));
            int idAvaliador = Integer.parseInt(form.get("id_avaliador"));
            int idAvaliado = Integer.parseInt(form.get("id_avaliado"));

            try (Connection conn = Conexao.conectar()) {
                conn.setAutoCommit(false);
                try {
                    String relacao;
                    String sqlDes = "SELECT relacao FROM Designacao_360 WHERE id_ciclo = ? AND id_avaliador = ? AND id_avaliado = ? AND status = 'PENDENTE'";
                    try (PreparedStatement psDes = conn.prepareStatement(sqlDes)) {
                        psDes.setInt(1, idCiclo);
                        psDes.setInt(2, idAvaliador);
                        psDes.setInt(3, idAvaliado);
                        ResultSet rs = psDes.executeQuery();
                        if (!rs.next()) {
                            throw new IllegalStateException("Designação pendente não encontrada.");
                        }
                        relacao = rs.getString("relacao");
                    }

                    String uuid = UUID.randomUUID().toString();
                    String sqlInsert = """
                        INSERT INTO Resposta (id_submissao, id_ciclo, id_avaliado, id_questao, relacao, nota_escala, texto_resposta)
                        VALUES (?, ?, ?, ?, ?, ?, ?)
                    """;

                    try (PreparedStatement psIns = conn.prepareStatement(sqlInsert)) {
                        for (Map.Entry<String, String> entry : form.entrySet()) {
                            String key = entry.getKey();
                            if (key.startsWith("nota_")) {
                                int idQuestao = Integer.parseInt(key.substring(5));
                                int nota = Integer.parseInt(entry.getValue());
                                psIns.setString(1, uuid);
                                psIns.setInt(2, idCiclo);
                                psIns.setInt(3, idAvaliado);
                                psIns.setInt(4, idQuestao);
                                psIns.setString(5, relacao);
                                psIns.setInt(6, nota);
                                psIns.setNull(7, Types.VARCHAR);
                                psIns.executeUpdate();
                            } else if (key.startsWith("texto_")) {
                                int idQuestao = Integer.parseInt(key.substring(6));
                                String texto = entry.getValue().trim();
                                psIns.setString(1, uuid);
                                psIns.setInt(2, idCiclo);
                                psIns.setInt(3, idAvaliado);
                                psIns.setInt(4, idQuestao);
                                psIns.setString(5, relacao);
                                psIns.setNull(6, Types.INTEGER);
                                psIns.setString(7, texto);
                                psIns.executeUpdate();
                            }
                        }
                    }

                    String sqlUpd = "UPDATE Designacao_360 SET status = 'CONCLUIDA' WHERE id_ciclo = ? AND id_avaliador = ? AND id_avaliado = ?";
                    try (PreparedStatement psUpd = conn.prepareStatement(sqlUpd)) {
                        psUpd.setInt(1, idCiclo);
                        psUpd.setInt(2, idAvaliador);
                        psUpd.setInt(3, idAvaliado);
                        psUpd.executeUpdate();
                    }

                    conn.commit();
                    enviarResposta(exchange, 200, "application/json; charset=UTF-8",
                            "{\"mensagem\":\"Avaliação enviada com sucesso! Protocolo anônimo: " + uuid + "\"}");
                } catch (Exception ex) {
                    conn.rollback();
                    throw ex;
                }
            } catch (Exception e) {
                enviarResposta(exchange, 400, "application/json; charset=UTF-8",
                        "{\"erro\":\"" + escaparJson(e.getMessage()) + "\"}");
            }
        });

        server.setExecutor(null);
        server.start();
        System.out.println("Servidor Web 360° rodando em: http://localhost:" + porta);
    }

    private static void responderJsonSql(HttpExchange exchange, String sql) throws IOException {
        try (Connection conn = Conexao.conectar();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            ResultSetMetaData meta = rs.getMetaData();
            int colunas = meta.getColumnCount();
            StringBuilder json = new StringBuilder("[");
            boolean primeiro = true;

            while (rs.next()) {
                if (!primeiro) json.append(",");
                primeiro = false;
                json.append("{");
                for (int i = 1; i <= colunas; i++) {
                    if (i > 1) json.append(",");
                    String nome = meta.getColumnLabel(i);
                    Object val = rs.getObject(i);
                    json.append("\"").append(escaparJson(nome)).append("\":");
                    if (val == null) json.append("null");
                    else if (val instanceof Number || val instanceof Boolean) json.append(val);
                    else json.append("\"").append(escaparJson(val.toString())).append("\"");
                }
                json.append("}");
            }
            json.append("]");
            enviarResposta(exchange, 200, "application/json; charset=UTF-8", json.toString());
        } catch (Exception e) {
            enviarResposta(exchange, 500, "application/json; charset=UTF-8",
                    "{\"erro\":\"" + escaparJson(e.getMessage()) + "\"}");
        }
    }

    private static Map<String, String> parseFormBody(HttpExchange exchange) throws IOException {
        try (InputStream is = exchange.getRequestBody()) {
            String body = new String(is.readAllBytes(), StandardCharsets.UTF_8);
            return parseQuery(body);
        }
    }

    private static Map<String, String> parseQuery(String raw) {
        Map<String, String> map = new HashMap<>();
        if (raw == null || raw.isBlank()) return map;
        for (String pair : raw.split("&")) {
            String[] kv = pair.split("=", 2);
            String k = URLDecoder.decode(kv[0], StandardCharsets.UTF_8);
            String v = kv.length > 1 ? URLDecoder.decode(kv[1], StandardCharsets.UTF_8) : "";
            map.put(k, v);
        }
        return map;
    }

    private static void enviarResposta(HttpExchange exchange, int status, String contentType, String corpo) throws IOException {
        byte[] bytes = corpo.getBytes(StandardCharsets.UTF_8);
        exchange.getResponseHeaders().set("Content-Type", contentType);
        exchange.sendResponseHeaders(status, bytes.length);
        try (OutputStream os = exchange.getResponseBody()) {
            os.write(bytes);
        }
    }

    private static String escaparJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}