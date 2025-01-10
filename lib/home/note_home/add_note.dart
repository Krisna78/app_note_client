import 'package:app_note_client/controller/note_controller.dart';
import 'package:app_note_client/model/notes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../component/button.dart';
import '../component/textfield.dart';

class AddNote extends StatefulWidget {
  AddNote({super.key});
  final _formKey = GlobalKey<FormState>();
  final titleControl = TextEditingController();
  final dateControl = TextEditingController();
  final predictPesertaControl = TextEditingController();
  final realPesertaControl = TextEditingController();
  final proposalDesicionControl = TextEditingController();
  final linkProposalControl = TextEditingController();
  final predictAnggaranControl = TextEditingController();
  final realAnggaranControl = TextEditingController();
  final saranKritikControl = TextEditingController();
  final deskripsiControl = TextEditingController();

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final NoteController noteController = Get.find<NoteController>();
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(2000),
        lastDate: now,
      );
      if (picked != null && picked != now) {
        setState(() {
          now = picked;
          widget.dateControl.text = DateFormat('dd-MM-yyyy').format(now);
        });
      }
    }

    String formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    int removeDotAndParse(String value) {
      String cleanedValue = value.replaceAll('.', '');
      return int.tryParse(cleanedValue) ?? 0;
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 25),
          alignment: Alignment.center,
          child: Form(
            key: widget._formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Catatan Baru",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 24),
                ),
                const SizedBox(height: 12),
                TextFieldPage(
                  controller: widget.titleControl,
                  hintText: "Judul",
                ),
                const SizedBox(height: 12),
                TextFieldPage(
                  controller: widget.dateControl,
                  hintText: "Tanggal",
                  textInputType: TextInputType.datetime,
                  isFilled: true,
                  isDateField: true,
                  prefixIcon: IconButton(
                      onPressed: () => _selectDate(context),
                      icon: Icon(Icons.calendar_month)),
                ),
                const SizedBox(height: 12),
                TextFieldPage(
                  controller: widget.predictPesertaControl,
                  hintText: "Prediksi Peserta",
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextFieldPage(
                  controller: widget.realPesertaControl,
                  hintText: "Real Peserta",
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF80AF81))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF80AF81))),
                      focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF80AF81))),
                      fillColor: Colors.grey.shade100,
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      hintText: "Pakai Proposal",
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                    ),
                    value: widget.proposalDesicionControl.text.isEmpty
                        ? null
                        : widget.proposalDesicionControl.text,
                    items: ["ya", "tidak"].map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        widget.proposalDesicionControl.text = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12),
                if (widget.proposalDesicionControl.text == "ya")
                  TextFieldPage(
                    controller: widget.linkProposalControl,
                    hintText: "Link Proposal",
                    textInputType: TextInputType.url,
                  ),
                const SizedBox(height: 12),
                TextFieldPage(
                  controller: widget.predictAnggaranControl,
                  hintText: "Pengajuan Anggaran",
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextFieldPage(
                  controller: widget.realAnggaranControl,
                  hintText: "Anggaran Terpakai",
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextFieldPage(
                  controller: widget.deskripsiControl,
                  hintText: "Deskripsi",
                  isLongText: true,
                  maxLine: 5,
                  textInputType: TextInputType.multiline,
                ),
                const SizedBox(height: 12),
                TextFieldPage(
                  controller: widget.saranKritikControl,
                  hintText: "Saran dan Kritik",
                  isLongText: true,
                  maxLine: 3,
                  textInputType: TextInputType.multiline,
                ),
                const SizedBox(height: 12),
                MyButton(
                    onTap: () async {
                      if (widget._formKey.currentState!.validate()) {
                        String dbFormattedDate =
                            widget.dateControl.text.isNotEmpty
                                ? DateFormat('yyyy-MM-dd').format(
                                    DateFormat('dd-MM-yyyy')
                                        .parse(widget.dateControl.text))
                                : formattedDate;
                        final noteData = Notes(
                          periode_tanggal: dbFormattedDate,
                          type_proposal: widget.proposalDesicionControl.text,
                          prediction_peserta:
                              removeDotAndParse(widget.predictPesertaControl.text),
                          real_peserta:
                              removeDotAndParse(widget.realPesertaControl.text),
                          anggaran_prediction:
                              removeDotAndParse(widget.predictAnggaranControl.text),
                          anggaran_real:
                              removeDotAndParse(widget.realAnggaranControl.text),
                          title: widget.titleControl.text,
                          saranKritik: widget.saranKritikControl.text,
                          deskripsi: widget.deskripsiControl.text,
                          link_proposal: widget.linkProposalControl.text.isEmpty
                              ? ""
                              : widget.linkProposalControl.text,
                        );
                        await noteController.addNote(noteData);
                        Navigator.pop(context);
                      }
                    },
                    nameBtn: "Simpan"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
