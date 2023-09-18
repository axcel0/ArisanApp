class NamaPeserta {
  String idPeserta;
  String namaPeserta;

  NamaPeserta({
    required this.idPeserta,
    required this.namaPeserta,
  });

  Map<String, dynamic> toJson() {
    return {
      'idPeserta': idPeserta,
      'namaPeserta': namaPeserta,
    };
  }

  factory NamaPeserta.fromJson(Map<String, dynamic> json) {
    return NamaPeserta(idPeserta: json['idPeserta'], namaPeserta: json['namaPeserta']);
  }

}