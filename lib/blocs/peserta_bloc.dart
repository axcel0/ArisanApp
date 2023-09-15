import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../nama_peserta.dart';

part 'peserta_event.dart';
part 'peserta_state.dart';

class PesertaBloc extends Bloc<PesertaEvent, PesertaState> {
  List<NamaPeserta> daftarPeserta = [];
  List<NamaPeserta> daftarPemenang = [];

  PesertaBloc() : super(PesertaInitial()) {
    on<AddNewPeserta>(_addNewPeserta);
    on<AddNewPemenang>(_addNewPemenang);
  }

  Future<void> _addNewPeserta(AddNewPeserta event, Emitter<PesertaState> emit) async {
    daftarPeserta.addAll([NamaPeserta(idPeserta: event.newIdPeserta, namaPeserta: event.newNamaPeserta)]);
    emit(ListPesertaInitial(daftarPeserta));
  }

  Future<void> _addNewPemenang(AddNewPemenang event, Emitter<PesertaState> emit) async {
    daftarPemenang.addAll([NamaPeserta(idPeserta: event.newIdPeserta, namaPeserta: event.newNamaPeserta)]);
    emit(ListPemenangInitial(daftarPemenang));
  }

}
