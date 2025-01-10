import 'package:app_note_client/home/component/button.dart';
import 'package:app_note_client/home/component/textview.dart';
import 'package:app_note_client/home/note_home/update_note.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/note_controller.dart';
import '../../model/notes.dart';

class ViewDetailNote extends StatefulWidget {
  final int id;
  ViewDetailNote({super.key, required this.id});

  @override
  State<ViewDetailNote> createState() => _ViewDetailNoteState();
}

class _ViewDetailNoteState extends State<ViewDetailNote> {
  final NoteController noteController = Get.put(NoteController());

  String formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: "Rp ",
      decimalDigits: 0,
    ).format(amount);
  }

  String formatDecimal(int amount) {
    return NumberFormat.decimalPattern('id_ID').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Catatan"),
        centerTitle: true,
      ),
      body: FutureBuilder<Notes?>(
        future: noteController.getNoteDetails(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Tidak Ada data di Database"));
          } else {
            final noteDetail = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(bottom: 25, top: 20),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Textview(
                      textView: noteDetail.title.toString(),
                      titleTextView: "Judul",
                      // isLink: false,
                    ),
                    const SizedBox(height: 10),
                    Textview(
                      textView: formatDecimal(noteDetail.prediction_peserta!),
                      titleTextView: "Prediksi Peserta",
                      // isLink: false,
                    ),
                    const SizedBox(height: 10),
                    Textview(
                      textView: formatDecimal(noteDetail.real_peserta!),
                      titleTextView: "Peserta yang Hadir",
                      // isLink: false,
                    ),
                    const SizedBox(height: 10),
                    Textview(
                      textView: noteDetail.type_proposal.toString(),
                      titleTextView: "Proposal",
                      // isLink: false,
                    ),
                    const SizedBox(height: 10),
                    if (noteDetail.type_proposal == "ya")
                      Textview(
                        textView: noteDetail.link_proposal.toString(),
                        titleTextView: "Link Proposal",
                        // isLink: true,
                      ),
                    const SizedBox(height: 10),
                    Textview(
                      textView: formatCurrency(noteDetail.anggaran_prediction!),
                      titleTextView: "Pengajuan Anggaran",
                      // isLink: false,
                    ),
                    const SizedBox(height: 10),
                    Textview(
                      textView: formatCurrency(noteDetail.anggaran_real!),
                      titleTextView: "Realita Anggaran",
                      // isLink: false,
                    ),
                    const SizedBox(height: 10),
                    Textview(
                      textView: noteDetail.deskripsi.toString(),
                      titleTextView: "Deskripsi",
                      // isLink: true,
                    ),
                    const SizedBox(height: 10),
                    Textview(
                      textView: noteDetail.saranKritik.toString(),
                      titleTextView: "Saran dan Kritik",
                      // isLink: true,
                    ),
                    const SizedBox(height: 10),
                    MyButton(
                        onTap: () {
                          Get.to(() => UpdateNote(id: widget.id));
                        },
                        nameBtn: "Update"),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
