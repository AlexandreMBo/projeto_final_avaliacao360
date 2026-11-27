import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// gerencia a abertura de conexao com o banco postgresql
public class Conexao {
    private static final String URL = "jdbc:postgresql://localhost:5432/postgres";
    private static final String USUARIO = "postgres";
    private static final String SENHA = "Graduacao2026"; 
    public static Connection conectar() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }
}