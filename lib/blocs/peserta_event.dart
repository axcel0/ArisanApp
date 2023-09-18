part of 'peserta_bloc.dart';

@immutable
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

class DeleteAllPemenang extends PesertaEvent {}

class ShowPeserta extends PesertaEvent {}

class ShowPemenang extends PesertaEvent {}



