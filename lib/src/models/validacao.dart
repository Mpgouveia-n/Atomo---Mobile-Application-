/// Validação compartilhada dos campos textuais obrigatórios.
String textoObrigatorio(String valor, String campo) {
  final texto = valor.trim();
  if (texto.isEmpty) {
    throw ArgumentError.value(valor, campo, 'Não pode ser vazio.');
  }
  return texto;
}
