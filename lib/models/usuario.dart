class Usuario{
  final String nomeUsuario;
  final String email;
  final String password;
  final String latitude;
  final String longitude;

  const Usuario({required this.nomeUsuario, required this.email, required this.password, required this.latitude, required this.longitude});

  Map<String, Object> toMap(){
    return {
      'nome': nomeUsuario,
      'email': email,
      'password': password,
      'latitude': latitude,
      'longitude': longitude
    };
  }

}