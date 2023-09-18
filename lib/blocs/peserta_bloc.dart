import 'dart:async';
import 'dart:math';

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
    on<ShowPeserta>(_showPeserta);
    on<ShowPemenang>(_showPemenang);
  }

  Future<void> _showPemenang(ShowPemenang event, Emitter<PesertaState> emit) async {
    emit(ListPemenangInitial(daftarPemenang));
  }

  Future<void> _showPeserta(ShowPeserta event, Emitter<PesertaState> emit) async {
    emit(ListPesertaInitial(daftarPeserta));
  }

  Future<void> _addNewPeserta(AddNewPeserta event, Emitter<PesertaState> emit) async {
    daftarPeserta.addAll([NamaPeserta(idPeserta: event.newIdPeserta, namaPeserta: event.newNamaPeserta)]);
    emit(ListPesertaInitial(daftarPeserta));
  }

  Future<void> _addNewPemenang(AddNewPemenang event, Emitter<PesertaState> emit) async {

    //randomize index
    Random random = Random();
    int randomNumber = random.nextInt(daftarPeserta.length);

    daftarPemenang.addAll([NamaPeserta(idPeserta: daftarPeserta[randomNumber].idPeserta, namaPeserta: daftarPeserta[randomNumber].namaPeserta)]);
    emit(ListPemenangInitial(daftarPemenang));
    emit(ShowPemenangInitial(daftarPeserta[randomNumber].idPeserta, daftarPeserta[randomNumber].namaPeserta));

    print("Daftar Peserta");
    for (var i in daftarPeserta) {
      print("${i.idPeserta}, ${i.namaPeserta}");
    }

    print("Daftar Pemenang");
    for (var i in daftarPemenang) {
      print("${i.idPeserta}, ${i.namaPeserta}");
    }

    print("random : $randomNumber");
    
  }

}
