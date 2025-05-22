import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

main() async {
  final email = "kaua.sousa63@aluno.ifce.edu.br";
  final pass = "iatg mgxq dbhe qplf";
  final name = "Kauã Sousa de Oliveira";

  // Configura as credenciais SMTP do Gmail
  final smtpServer = gmail(email, pass);

  // Cria uma mensagem de e-mail
  final message = Message()
    ..from = Address(email, name)
    ..recipients.add(email)
    ..subject = 'E-mail teste - Avaliação 05'
    ..text = 'Corpo do e-mail';

  try {
    // Envia o e-mail usando o servidor SMTP do Gmail
    final sendReport = await send(message, smtpServer);

    // Exibe o resultado do envio do e-mail
    print('E-mail enviado: ${sendReport.mail.text}');
  } on MailerException catch (e) {
    // Exibe informações sobre erros de envio de e-mail
    print('Erro ao enviar e-mail: ${e.toString()}');
  }
}