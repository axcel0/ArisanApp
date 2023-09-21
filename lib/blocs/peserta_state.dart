part of 'peserta_bloc.dart';

abstract class PesertaState {}

class PesertaInitial extends PesertaState {}

class ListPesertaInitial extends PesertaState {
  late List<NamaPeserta> listPeserta;

  ListPesertaInitial(this.listPeserta);

}

class ListPemenangInitial extends PesertaState {
  late List<NamaPeserta> listPemenang;

  ListPemenangInitial(this.listPemenang);
}

class ShowPemenangInitial extends PesertaState {
  late String newIdPeserta;
  late String newNamaPeserta;
  late String timeStamp;
  ShowPemenangInitial(this.newIdPeserta, this.newNamaPeserta);
}

class ChangeThemeState extends PesertaState {
  late bool isDark;
  ChangeThemeState(this.isDark);
}
