part of 'peserta_bloc.dart';

abstract class PesertaEvent {}

class AddNewPeserta extends PesertaEvent {
  late String newIdPeserta;
  late String newNamaPeserta;
  AddNewPeserta(this.newIdPeserta, this.newNamaPeserta);
}

class AddNewPemenang extends PesertaEvent {}

class LoadPeserta extends PesertaEvent {
  late String newIdPeserta;
  late String newNamaPeserta;
  LoadPeserta(this.newIdPeserta, this.newNamaPeserta);
}

class LoadPemenang extends PesertaEvent {
  late String idPeserta;
  late String namaPeserta;
  LoadPemenang(this.idPeserta, this.namaPeserta);
}

class DeleteAllPeserta extends PesertaEvent {}

class DeletePeserta extends PesertaEvent {
  late String idPeserta;
  DeletePeserta(this.idPeserta);
}

class DeletePemenang extends PesertaEvent {
  late String idPeserta;
  DeletePemenang(this.idPeserta);
}

class EditPeserta extends PesertaEvent {
  late String idPeserta;
  late String namaPeserta;
  late String oldIdPeserta;
  late String oldNamaPeserta;

  EditPeserta(this.idPeserta, this.namaPeserta, this.oldIdPeserta, this.oldNamaPeserta);
}

class DeleteAllPemenang extends PesertaEvent {}

class ShowPeserta extends PesertaEvent {}

class ShowPemenang extends PesertaEvent {}



