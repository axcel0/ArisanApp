import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../nama_peserta.dart';

part 'peserta_event.dart';
part 'peserta_state.dart';

class PesertaBloc extends Bloc<PesertaEvent, PesertaState> {
  List<NamaPeserta> daftarPeserta = [];
  List<NamaPeserta> daftarPemenang = [];
  List<NamaPeserta> daftarKocok = [];

  PesertaBloc() : super(PesertaInitial()) {
    on<AddNewPeserta>(_addNewPeserta);
    on<AddNewPemenang>(_addNewPemenang);
    on<LoadPeserta>(_loadPeserta);
    on<LoadPemenang>(_loadPemenang);
    on<DeleteAllPeserta>(_deleteAllPeserta);
    on<DeletePeserta>(_deletePeserta);
    on<EditPeserta>(_editPeserta);
    on<DeleteAllPemenang>(_deleteAllPemenang);
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

  Future<void> _loadPeserta(LoadPeserta event, Emitter<PesertaState> emit) async {
    daftarPeserta.add(NamaPeserta(idPeserta: event.newIdPeserta, namaPeserta: event.newNamaPeserta));
  }

  Future<void> _loadPemenang(LoadPemenang event, Emitter<PesertaState> emit) async {
    daftarPemenang.add(NamaPeserta(idPeserta: event.idPeserta, namaPeserta: event.namaPeserta));
  }

  Future<void> _deleteAllPeserta(DeleteAllPeserta event, Emitter<PesertaState> emit) async {
    daftarPeserta.clear();
    emit(ListPesertaInitial(daftarPeserta));
  }

  Future<void> _deleteAllPemenang(DeleteAllPemenang event, Emitter<PesertaState> emit) async {
    daftarPemenang.clear();
    emit(ListPemenangInitial(daftarPemenang));
  }

  Future<void> _addNewPemenang(AddNewPemenang event, Emitter<PesertaState> emit) async {

    Random random = Random();
    int randomNumber = random.nextInt(daftarPeserta.length);

    daftarPemenang.addAll([NamaPeserta(idPeserta: daftarPeserta[randomNumber].idPeserta, namaPeserta: daftarPeserta[randomNumber].namaPeserta)]);
    emit(ListPemenangInitial(daftarPemenang));
    emit(ShowPemenangInitial(daftarPeserta[randomNumber].idPeserta, daftarPeserta[randomNumber].namaPeserta));

    // print("Daftar Peserta");
    // for (var i in daftarPeserta) {
    //   print("${i.idPeserta}, ${i.namaPeserta}");
    // }
    //
    // print("Daftar Pemenang");
    // for (var i in daftarPemenang) {
    //   print("${i.idPeserta}, ${i.namaPeserta}");
    // }
    //
    // print("random : $randomNumber");
    
  }
  Future<void> _deletePeserta(DeletePeserta event, Emitter<PesertaState> emit) async {
    //delete peserta by index id
    daftarPeserta.removeWhere((element) => element.idPeserta == event.idPeserta);
    emit(ListPesertaInitial(daftarPeserta));
  }
//make fucntion to edit peserta
  Future<void> _editPeserta(EditPeserta event, Emitter<PesertaState> emit) async {
    daftarPeserta[daftarPeserta.indexWhere((element) => element.idPeserta == event.idPeserta)].namaPeserta = event.namaPeserta;
    emit(ListPesertaInitial(daftarPeserta));
  }
}
