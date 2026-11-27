import java.sql.*;
import java.util.Scanner;
import java.util.UUID;

import dao.Conexao;

// concentra as operacoes do sistema no banco de dados
public class AvaliacaoService {

    // busca o colaborador pelo email para simular o acesso
    public Integer autenticar(String email) throws SQLException {
        String sql = "SELECT id_colaborador, nome, cargo, departamento FROM Colaborador WHERE email = ? AND ativo = TRUE";
        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                System.out.printf("\nBem-vindo(a), %s (%s - %s)\n",
                        rs.getString("nome"), rs.getString("cargo"), rs.getString("departamento"));
                return rs.getInt("id_colaborador");
            }
        }
        return null;
    }

    // lista as avaliacoes que o usuario logado ainda precisa responder
    public void listarPendencias(int idAvaliador) throws SQLException {
        String sql = """
            SELECT d.id_ciclo, ca.titulo AS ciclo, d.id_avaliado, alvo.nome AS avaliado, alvo.cargo, d.relacao
            FROM Designacao_360 d
            JOIN Ciclo_Avaliacao ca ON d.id_ciclo = ca.id_ciclo
            JOIN Colaborador alvo ON d.id_avaliado = alvo.id_colaborador
            WHERE d.id_avaliador = ? AND d.status = 'PENDENTE'
            ORDER BY d.id_ciclo, alvo.nome
        """;

        try (Connection conn = Conexao.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idAvaliador);
            ResultSet rs = stmt.executeQuery();

            System.out.println("\n--- avaliacoes pendentes ---");
            boolean temPendencia = false;
            while (rs.next()) {
                temPendencia = true;
                System.out.printf("Ciclo %d (%s) | Avaliar: [ID %d] %s (%s) | Papel: %s\n",
                        rs.getInt("id_ciclo"),
                        rs.getString("ciclo"),
                        rs.getInt("id_avaliado"),
                        rs.getString("avaliado"),
                        rs.getString("cargo"),
                        rs.getString("relacao"));
            }
            if (!temPendencia) {
                System.out.println("Nenhuma avaliacao pendente no momento.");
            }
        }
    }

    // grava as respostas de forma anonima usando uuid e marca a designacao como concluida
    public void responderAvaliacao(int idAvaliador, int idCiclo, int idAvaliado, Scanner scanner) throws SQLException {
        String sqlDesignacao = """
            SELECT relacao FROM Designacao_360
            WHERE id_ciclo = ? AND id_avaliador = ? AND id_avaliado = ? AND status = 'PENDENTE'
        """;

        try (Connection conn = Conexao.conectar()) {
            conn.setAutoCommit(false);

            try {
                String relacao;
                try (PreparedStatement stmtDes = conn.prepareStatement(sqlDesignacao)) {
                    stmtDes.setInt(1, idCiclo);
                    stmtDes.setInt(2, idAvaliador);
                    stmtDes.setInt(3, idAvaliado);
                    ResultSet rs = stmtDes.executeQuery();
                    if (!rs.next()) {
                        System.out.println("Designacao pendente nao encontrada para esses dados.");
                        conn.rollback();
                        return;
                    }
                    relacao = rs.getString("relacao");
                }

                String idSubmissao = UUID.randomUUID().toString();

                String sqlQuestoes = """
                    SELECT q.id_questao, q.enunciado, q.tipo_resposta, c.nome AS criterio
                    FROM Ciclo_Questao cq
                    JOIN Questao q ON cq.id_questao = q.id_questao
                    JOIN Criterio c ON q.id_criterio = c.id_criterio
                    WHERE cq.id_ciclo = ?
                    ORDER BY q.id_questao
                """;

                String sqlInsert = """
                    INSERT INTO Resposta (id_submissao, id_ciclo, id_avaliado, id_questao, relacao, nota_escala, texto_resposta)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

                try (PreparedStatement stmtQ = conn.prepareStatement(sqlQuestoes);
                     PreparedStatement stmtIns = conn.prepareStatement(sqlInsert)) {
                    stmtQ.setInt(1, idCiclo);
                    ResultSet rsQ = stmtQ.executeQuery();

                    while (rsQ.next()) {
                        int idQuestao = rsQ.getInt("id_questao");
                        String tipo = rsQ.getString("tipo_resposta");
                        System.out.printf("\n[%s] %s\n", rsQ.getString("criterio"), rsQ.getString("enunciado"));

                        stmtIns.setString(1, idSubmissao);
                        stmtIns.setInt(2, idCiclo);
                        stmtIns.setInt(3, idAvaliado);
                        stmtIns.setInt(4, idQuestao);
                        stmtIns.setString(5, relacao);

                        if ("ESCALA_1_5".equals(tipo)) {
                            System.out.print("Nota (1 a 5): ");
                            int nota = Integer.parseInt(scanner.nextLine().trim());
                            stmtIns.setInt(6, nota);
                            stmtIns.setNull(7, Types.VARCHAR);
                        } else {
                            System.out.print("Comentario: ");
                            String texto = scanner.nextLine().trim();
                            stmtIns.setNull(6, Types.INTEGER);
                            stmtIns.setString(7, texto);
                        }
                        stmtIns.executeUpdate();
                    }
                }

                String sqlUpdate = """
                    UPDATE Designacao_360 SET status = 'CONCLUIDA'
                    WHERE id_ciclo = ? AND id_avaliador = ? AND id_avaliado = ?
                """;
                try (PreparedStatement stmtUpd = conn.prepareStatement(sqlUpdate)) {
                    stmtUpd.setInt(1, idCiclo);
                    stmtUpd.setInt(2, idAvaliador);
                    stmtUpd.setInt(3, idAvaliado);
                    stmtUpd.executeUpdate();
                }

                conn.commit();
                System.out.println("\nAvaliacao registrada com sucesso e em total anonimato! (Protocolo: " + idSubmissao + ")");

            } catch (SQLException e) {
                conn.rollback();
                System.out.println("\nErro ao salvar avaliacao (regra do banco acionada): " + e.getMessage());
            }
        }
    }

    // exibe o boletim ponderado geral
    public void exibirBoletimGeral() throws SQLException {
        String sql = """
            SELECT ca.titulo AS ciclo, col.nome AS avaliado, col.cargo,
                   ROUND(SUM(r.nota_escala * cq.peso * r.peso_relacao) / SUM(cq.peso * r.peso_relacao), 2) AS media_final
            FROM Resposta r
            JOIN Colaborador col ON r.id_avaliado = col.id_colaborador
            JOIN Ciclo_Avaliacao ca ON r.id_ciclo = ca.id_ciclo
            JOIN Ciclo_Questao cq ON r.id_ciclo = cq.id_ciclo AND r.id_questao = cq.id_questao
            WHERE r.nota_escala IS NOT NULL
            GROUP BY ca.titulo, col.nome, col.cargo
            ORDER BY ca.titulo, media_final DESC
        """;

        try (Connection conn = Conexao.conectar();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            System.out.println("\n--- boletim geral ponderado ---");
            while (rs.next()) {
                System.out.printf("%-35s | %-18s (%-18s) | Nota Final: %.2f\n",
                        rs.getString("ciclo"),
                        rs.getString("avaliado"),
                        rs.getString("cargo"),
                        rs.getDouble("media_final"));
            }
        }
    }
}