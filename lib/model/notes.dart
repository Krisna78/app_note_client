// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Notes {
  final int? id;
  final String? periode_tanggal;
  final String? type_proposal;
  final String? link_proposal;
  final int? prediction_peserta;
  final int? real_peserta;
  final int? anggaran_prediction;
  final int? anggaran_real;
  final String? title;
  final String? deskripsi;
  final String? saranKritik;

  Notes({
    this.id,
    required this.periode_tanggal,
    required this.type_proposal,
    this.link_proposal,
    required this.prediction_peserta,
    required this.real_peserta,
    required this.anggaran_prediction,
    required this.anggaran_real,
    required this.title,
    this.deskripsi,
    this.saranKritik,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'periode_tanggal': periode_tanggal,
      'type_proposal': type_proposal,
      'link_proposal': link_proposal,
      'prediction_peserta': prediction_peserta,
      'real_peserta': real_peserta,
      'anggaran_prediction': anggaran_prediction,
      'anggaran_real': anggaran_real,
      'title': title,
      'deskripsi': deskripsi,
      'sarankritik': saranKritik,
    };
  }

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      id: map['id'] != null ? map['id'] as int : null,
      periode_tanggal: map['periode_tanggal'] != null ? map['periode_tanggal'] as String : null,
      type_proposal: map['type_proposal'] != null ? map['type_proposal'] as String : null,
      link_proposal: map['link_proposal'] != null ? map['link_proposal'] as String : null,
      prediction_peserta: map['prediction_peserta'] != null ? map['prediction_peserta'] as int : null,
      real_peserta: map['real_peserta'] != null ? map['real_peserta'] as int : null,
      anggaran_prediction: map['anggaran_prediction'] != null ? map['anggaran_prediction'] as int : null,
      anggaran_real: map['anggaran_real'] != null ? map['anggaran_real'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      deskripsi: map['deskripsi'] != null ? map['deskripsi'] as String : null,
      saranKritik: map['sarankritik'] != null ? map['sarankritik'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notes.fromJson(String source) => Notes.fromMap(json.decode(source) as Map<String, dynamic>);
}
