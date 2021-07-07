class ContadorUsuario {
  ContadorUsuario({
    required this.id,
  });

  int id;

  factory ContadorUsuario.fromJson(Map<String, dynamic> json) =>
      ContadorUsuario(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
