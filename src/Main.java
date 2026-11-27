import java.sql.SQLException;
import java.util.Scanner;

// ponto de entrada da aplicacao de avaliacao 360
public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        AvaliacaoService service = new AvaliacaoService();

        System.out.println("=== sistema de avaliacao de desempenho 360 ===");
        System.out.print("Digite seu e-mail institucional para entrar: ");
        String email = scanner.nextLine().trim();

        try {
            Integer idUsuario = service.autenticar(email);
            if (idUsuario == null) {
                System.out.println("Usuario nao encontrado ou inativo.");
                return;
            }

            int opcao = -1;
            while (opcao != 0) {
                System.out.println("\nEscolha uma opcao:");
                System.out.println("1 - Ver minhas avaliacoes pendentes");
                System.out.println("2 - Responder uma avaliacao pendente");
                System.out.println("3 - Consultar boletim geral 360");
                System.out.println("0 - Sair");
                System.out.print("> ");

                opcao = Integer.parseInt(scanner.nextLine().trim());

                switch (opcao) {
                    case 1 -> service.listarPendencias(idUsuario);
                    case 2 -> {
                        System.out.print("Informe o ID do Ciclo: ");
                        int idCiclo = Integer.parseInt(scanner.nextLine().trim());
                        System.out.print("Informe o ID do Colaborador a avaliar: ");
                        int idAvaliado = Integer.parseInt(scanner.nextLine().trim());
                        service.responderAvaliacao(idUsuario, idCiclo, idAvaliado, scanner);
                    }
                    case 3 -> service.exibirBoletimGeral();
                    case 0 -> System.out.println("Encerrando sistema...");
                    default -> System.out.println("Opcao invalida.");
                }
            }
        } catch (SQLException e) {
            System.out.println("Falha de comunicacao com o banco de dados: " + e.getMessage());
        } finally {
            scanner.close();
        }
    }
}