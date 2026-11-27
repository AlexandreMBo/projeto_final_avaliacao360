package dao;

import java.sql.*;

public class CicloDAO {

    public void listarColaboradores() throws SQLException {
        String sql = "SELECT id_colaborador, nome, cargo, departamento FROM Colaborador ORDER BY id_colaborador";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            System.out.println("\n--- COLABORADORES ---");
            while (rs.next()) {
                System.out.printf("[%d] %s (%s - %s)%n",
                        rs.getInt("id_colaborador"),
                        rs.getString("nome"),
                        rs.getString("cargo"),
                        rs.getString("departamento"));
            }
        }
    }

    public void listarCiclos() throws SQLException {
        String sql = "SELECT id_ciclo, titulo, data_inicio, data_fim, status FROM Ciclo_Avaliacao ORDER BY id_ciclo";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            System.out.println("\n--- CICLOS DE AVALIAÇÃO ---");
            while (rs.next()) {
                System.out.printf("[%d] %s (%s a %s) - Status: %s%n",
                        rs.getInt("id_ciclo"),
                        rs.getString("titulo"),
                        rs.getDate("data_inicio"),
                        rs.getDate("data_fim"),
                        rs.getString("status"));
            }
        }
    }

    // RF3: Criar novo ciclo de avaliação
    public int criarCiclo(String titulo, Date dataInicio, Date dataFim, String status) throws SQLException {
        String sql = """
            INSERT INTO Ciclo_Avaliacao (titulo, data_inicio, data_fim, status)
            VALUES (?, ?, ?, ?)
            RETURNING id_ciclo
        """;
        try (Connection conn = Conexao.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, titulo);
            ps.setDate(2, dataInicio);
            ps.setDate(3, dataFim);
            ps.setString(4, status.trim().toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_ciclo");
                }
            }
        }
        return -1;
    }

    // RF3: Vincular questão ao ciclo com peso específico (N:N)
    public void vincularQuestaoAoCiclo(int idCiclo, int idQuestao, double peso) throws SQLException {
        String sql = """
            INSERT INTO Ciclo_Questao (id_ciclo, id_questao, peso)
            VALUES (?, ?, ?)
            ON CONFLICT (id_ciclo, id_questao) DO UPDATE SET peso = EXCLUDED.peso
        """;
        try (Connection conn = Conexao.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idCiclo);
            ps.setInt(2, idQuestao);
            ps.setDouble(3, peso);
            ps.executeUpdate();
        }
    }

    // RF4: Designar avaliador para um avaliado no ciclo (GESTOR, PAR, LIDERADO, AUTOAVALIACAO)
    public void designarAvaliador(int idCiclo, int idAvaliador, int idAvaliado, String relacao) throws SQLException {
        String relacaoNormalizada = relacao.trim().toUpperCase();
        String sql = """
            INSERT INTO Designacao_360 (id_ciclo, id_avaliador, id_avaliado, relacao, status)
            VALUES (?, ?, ?, ?, 'PENDENTE')
        """;
        try (Connection conn = Conexao.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idCiclo);
            ps.setInt(2, idAvaliador);
            ps.setInt(3, idAvaliado);
            ps.setString(4, relacaoNormalizada);
            ps.executeUpdate();
        }
    }
}