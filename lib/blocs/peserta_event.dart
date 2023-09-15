part of 'peserta_bloc.dart';

@immutable
abstract class PesertaEvent {}

class AddNewPeserta extends PesertaEvent {
  late String newIdPeserta;
  late String newNamaPeserta;
  AddNewPeserta(this.newIdPeserta, this.newNamaPeserta);
}

class AddNewPemenang extends PesertaEvent {
  late String newIdPeserta;
  late String newNamaPeserta;
  AddNewPemenang(this.newIdPeserta, this.newNamaPeserta);
}
