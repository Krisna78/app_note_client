import 'package:app_note_client/controller/note_controller.dart';
import 'package:app_note_client/home/component/button_navigation.dart';
import 'package:app_note_client/model/notes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../component/button.dart';
import '../component/textfield.dart';

class UpdateNote extends StatefulWidget {
  final int id;
  UpdateNote({super.key, required this.id});
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
  // late String type;
  late DateTime selectedDate;

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  final NoteController noteController = Get.put(NoteController());

  @override
  void initState() {
    super.initState();
    _loadNoteDetails();
  }

  Future<void> _loadNoteDetails() async {
    Notes? income = await noteController.getNoteDetails(widget.id);
    if (income != null) {
      widget.titleControl.text = income.title!;
      widget.predictPesertaControl.text = income.prediction_peserta.toString();
      widget.realPesertaControl.text = income.real_peserta.toString();
      widget.proposalDesicionControl.text = income.type_proposal.toString();
      widget.linkProposalControl.text = income.link_proposal.toString();
      widget.predictAnggaranControl.text =
          income.anggaran_prediction.toString();
      widget.realAnggaranControl.text = income.anggaran_real.toString();
      widget.deskripsiControl.text = income.deskripsi ?? '';
      widget.saranKritikControl.text = income.saranKritik ?? '';
      widget.selectedDate = DateTime.parse(income.periode_tanggal!);
      widget.dateControl.text = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(income.periode_tanggal!));
      ;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null && picked != now) {
      setState(() {
        widget.selectedDate = picked;
        widget.dateControl.text =
            DateFormat('dd-MM-yyyy').format(widget.selectedDate);
      });
    }
  }

  int removeDotAndParse(String value) {
      String cleanedValue = value.replaceAll('.', '');
      return int.tryParse(cleanedValue) ?? 0;
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<Notes?>(
          future: noteController.getNoteDetails(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Tidak Ada Data di Database'));
            } else {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(bottom: 25),
                  alignment: Alignment.center,
                  child: Form(
                    key: widget._formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Update Catatan",
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
                              icon: const Icon(Icons.calendar_month)),
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
                                  borderSide:
                                      BorderSide(color: Color(0xFF80AF81))),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF80AF81))),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF80AF81))),
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
                        //
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
                                final noteUpdateData = Notes(
                                  id: widget.id,
                                  periode_tanggal: DateFormat('yyyy-MM-dd')
                                      .format(widget.selectedDate),
                                  type_proposal:
                                      widget.proposalDesicionControl.text,
                                  prediction_peserta: removeDotAndParse(
                                      widget.predictPesertaControl.text),
                                  real_peserta:
                                      removeDotAndParse(widget.realPesertaControl.text),
                                  anggaran_prediction: removeDotAndParse(
                                      widget.predictAnggaranControl.text),
                                  anggaran_real: removeDotAndParse(
                                      widget.realAnggaranControl.text),
                                  title: widget.titleControl.text,
                                  deskripsi: widget.deskripsiControl.text,
                                  saranKritik: widget.saranKritikControl.text,
                                  link_proposal:
                                      widget.linkProposalControl.text.isEmpty
                                          ? ""
                                          : widget.linkProposalControl.text,
                                );
                                await noteController.addNote(noteUpdateData);
                                Get.off(() => ButtonNavigation());
                              }
                            },
                            nameBtn: "Update"),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
