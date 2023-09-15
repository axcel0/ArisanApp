part of 'peserta_bloc.dart';

@immutable
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
