class Contato{
  final String nome;
  final String email;

  const Contato({required this.nome, required this.email});

  Map<String, Object> toMap(){
    return {
      'nome': nome,
      'email': email,
    };
  }
}