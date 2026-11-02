/// Categoria da sessão e valor de cada acerto.
enum Categoria {
  CRIANCA(10),
  JOVEM(20),
  ADULTO(30);

  const Categoria(this.pontosPorAcerto);

  final int pontosPorAcerto;
}
