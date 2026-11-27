import dao.CicloDAO;
import dao.QuestaoDAO;
import java.sql.Date;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        QuestaoDAO questaoDAO = new QuestaoDAO();
        CicloDAO cicloDAO = new CicloDAO();
        AvaliacaoService avaliacaoService = new AvaliacaoService();

        int opcao = -1;
        while (opcao != 0) {
            System.out.println("\n=============================================");
            System.out.println("   SISTEMA DE AVALIAÇÃO DE DESEMPENHO 360°   ");
            System.out.println("=============================================");
            System.out.println("1. [RF1] Cadastrar novo Critério");
            System.out.println("2. [RF2] Cadastrar nova Questão (ESCALA_1_5 / TEXTO_LIVRE)");
            System.out.println("3. [RF3] Criar Ciclo de Avaliação");
            System.out.println("4. [RF3] Vincular Questão ao Ciclo com Peso");
            System.out.println("5. [RF4] Designar Avaliador (360°)");
            System.out.println("6. [RF5/RF6] Responder Avaliação Pendente (Anônima)");
            System.out.println("7. [RF7] Exibir Boletim Geral Ponderado");
            System.out.println("8. Consultar Ciclos, Questões e Colaboradores");
            System.out.println("0. Sair");
            System.out.print("Escolha uma opção: ");

            try {
                opcao = Integer.parseInt(sc.nextLine().trim());

                switch (opcao) {
                    case 1 -> {
                        System.out.print("Nome do critério: ");
                        String nome = sc.nextLine();
                        System.out.print("Descrição: ");
                        String desc = sc.nextLine();
                        int id = questaoDAO.cadastrarCriterio(nome, desc);
                        System.out.println("Critério cadastrado com ID: " + id);
                    }
                    case 2 -> {
                        questaoDAO.listarCriterios();
                        System.out.print("ID do Critério: ");
                        int idCrit = Integer.parseInt(sc.nextLine().trim());
                        System.out.print("Enunciado da questão: ");
                        String enunciado = sc.nextLine();
                        System.out.print("Tipo (ESCALA_1_5 ou TEXTO_LIVRE): ");
                        String tipo = sc.nextLine();
                        int idQ = questaoDAO.cadastrarQuestao(idCrit, enunciado, tipo);
                        System.out.println("Questão cadastrada com ID: " + idQ);
                    }
                    case 3 -> {
                        System.out.print("Título do ciclo (ex: Ciclo 2026.2): ");
                        String titulo = sc.nextLine();
                        System.out.print("Data início (AAAA-MM-DD): ");
                        Date inicio = Date.valueOf(sc.nextLine().trim());
                        System.out.print("Data fim (AAAA-MM-DD): ");
                        Date fim = Date.valueOf(sc.nextLine().trim());
                        System.out.print("Status (PLANEJADO, ABERTO, ENCERRADO): ");
                        String status = sc.nextLine();
                        int idCiclo = cicloDAO.criarCiclo(titulo, inicio, fim, status);
                        System.out.println("Ciclo criado com ID: " + idCiclo);
                    }
                    case 4 -> {
                        cicloDAO.listarCiclos();
                        System.out.print("ID do Ciclo: ");
                        int idCiclo = Integer.parseInt(sc.nextLine().trim());
                        questaoDAO.listarQuestoes();
                        System.out.print("ID da Questão: ");
                        int idQuestao = Integer.parseInt(sc.nextLine().trim());
                        System.out.print("Peso da questão neste ciclo (ex: 1.0, 1.5, 2.0): ");
                        double peso = Double.parseDouble(sc.nextLine().trim().replace(",", "."));
                        cicloDAO.vincularQuestaoAoCiclo(idCiclo, idQuestao, peso);
                        System.out.println("Questão vinculada ao ciclo com sucesso!");
                    }
                    case 5 -> {
                        cicloDAO.listarCiclos();
                        System.out.print("ID do Ciclo: ");
                        int idCiclo = Integer.parseInt(sc.nextLine().trim());
                        cicloDAO.listarColaboradores();
                        System.out.print("ID do Avaliador: ");
                        int idAvaliador = Integer.parseInt(sc.nextLine().trim());
                        System.out.print("ID do Avaliado: ");
                        int idAvaliado = Integer.parseInt(sc.nextLine().trim());
                        System.out.print("Relação (GESTOR, PAR, LIDERADO, AUTOAVALIACAO): ");
                        String relacao = sc.nextLine();
                        cicloDAO.designarAvaliador(idCiclo, idAvaliador, idAvaliado, relacao);
                        System.out.println("Designação 360° registrada como PENDENTE!");
                    }
                    case 6 -> {
                        System.out.print("Digite seu e-mail institucional para autenticar: ");
                        String email = sc.nextLine().trim();
                        Integer idAvaliador = avaliacaoService.autenticar(email);
                        if (idAvaliador == null) {
                            System.out.println("Colaborador não encontrado ou inativo.");
                            break;
                        }
                        avaliacaoService.listarPendencias(idAvaliador);
                        System.out.print("\nDigite o ID do Ciclo que deseja responder: ");
                        int idCiclo = Integer.parseInt(sc.nextLine().trim());
                        System.out.print("Digite o ID do Avaliado: ");
                        int idAvaliado = Integer.parseInt(sc.nextLine().trim());
                        avaliacaoService.responderAvaliacao(idAvaliador, idCiclo, idAvaliado, sc);
                    }
                    case 7 -> avaliacaoService.exibirBoletimGeral();
                    case 8 -> {
                        cicloDAO.listarCiclos();
                        questaoDAO.listarCriterios();
                        questaoDAO.listarQuestoes();
                        cicloDAO.listarColaboradores();
                    }
                    case 0 -> System.out.println("Encerrando sistema...");
                    default -> System.out.println("Opção inválida.");
                }
            } catch (Exception e) {
                System.out.println("Erro na operação: " + e.getMessage());
            }
        }
        sc.close();
    }
}