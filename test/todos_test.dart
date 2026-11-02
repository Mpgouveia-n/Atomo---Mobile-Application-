import 'console_test.dart';
import 'dados_mock_test.dart';
import 'historico_test.dart';
import 'modelos_test.dart';
import 'quiz_test.dart';
import 'suporte.dart';

void main() {
  testarModelos();
  testarDadosMock();
  testarConsole();
  testarQuiz();
  testarHistorico();
  concluir();
}
