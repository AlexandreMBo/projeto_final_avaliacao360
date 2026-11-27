package dao;

import java.sql.*;

public class QuestaoDAO {

    public void listarCriterios() throws SQLException {
        String sql = "SELECT id_criterio, nome, descricao FROM Criterio ORDER BY id_criterio";
        try (Connection conn = Conexao.conectar();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            System.out.println("\n--- CRITÉRIOS CADASTRADOS ---");
            while (rs.next()) {
                System.out.printf("[%d] %s — %s%n",
                        rs.getInt("id_criterio"),
                        rs.getString("nome"),
                        rs.getString("descricao"));
            }
        }
    }

    public int cadastrarCriterio(String nome, String descricao) throws SQLException {
        String sql = "INSERT INTO Criterio (nome, descricao) VALUES (?, ?) RETURNING id_criterio";
        try (Connection conn = Conexao.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nome);
            ps.setString(2, descricao);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_criterio");
                }
            }
        }
        return -1;
    }

    public int cadastrarQuestao(int idCriterio, String enunciado, String tipo) throws SQLException {
        String tipoNormalizado = tipo.trim().toUpperCase();
        if (!tipoNormalizado.equals("ESCALA_1_5") && !tipoNormalizado.equals("TEXTO_LIVRE")) {
            throw new IllegalArgumentException("Tipo inválido. Use 'ESCALA_1_5' ou 'TEXTO_LIVRE'.");
        }

        String sql = "INSERT INTO Questao (id_criterio, enunciado, tipo_resposta) VALUES (?, ?, ?) RETURNING id_questao";
        try (Connection conn = Conexao.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idCriterio);
            ps.setString(2, enunciado);
            ps.setString(3, tipoNormalizado);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_questao");
                }
            }
        }
        return -1;
    }

    public void listarQuestoes() throws SQLException {
        String sql = """
            SELECT q.id_questao, c.nome AS criterio, q.tipo_resposta, q.enunciado
            FROM Questao q
            JOIN Criterio c ON q.id_criterio = c.id_criterio
            ORDER BY q.id_questao
        """;
        try (Connection conn = Conexao.conectar();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            System.out.println("\n--- BANCO DE QUESTÕES ---");
            while (rs.next()) {
                System.out.printf("[%d] (%s | %s) %s%n",
                        rs.getInt("id_questao"),
                        rs.getString("criterio"),
                        rs.getString("tipo_resposta"),
                        rs.getString("enunciado"));
            }
        }
    }
}