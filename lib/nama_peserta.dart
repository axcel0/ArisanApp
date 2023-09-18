class NamaPeserta {
  String idPeserta;
  String namaPeserta;

  NamaPeserta({
    required this.idPeserta,
    required this.namaPeserta,
  });
  //convert to json format
  Map<String, dynamic> toJson() {
    return {
      'idPeserta': idPeserta,
      'namaPeserta': namaPeserta,
    };
  }
  //convert from json format
  factory NamaPeserta.fromJson(Map<String, dynamic> map) {
    return NamaPeserta(
      idPeserta: map['idPeserta'],
      namaPeserta: map['namaPeserta'],
    );
  }

}