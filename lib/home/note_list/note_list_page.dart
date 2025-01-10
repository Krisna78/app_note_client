import 'package:app_note_client/controller/note_controller.dart';
import 'package:app_note_client/home/note_home/update_note.dart';
import 'package:app_note_client/home/note_home/view_detail_note.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../component/button.dart';

class NoteListPage extends StatefulWidget {
  NoteListPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final NoteController noteController = Get.put(NoteController());
  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;

  final List<String> _days =
      List.generate(31, (index) => (index + 1).toString());
  final List<String> _months =
      List.generate(12, (index) => (index + 1).toString());
  final List<String> _years =
      List.generate(200, (index) => (2000 + index).toString());

  void _onDayChanged(String? selectedValue) {
    setState(() {
      _selectedDay = selectedValue;
    });
  }

  void _onMonthChanged(String? selectedValue) {
    setState(() {
      _selectedMonth = selectedValue;
    });
  }

  void _onYearChanged(String? selectedValue) {
    setState(() {
      _selectedYear = selectedValue;
    });
  }

  String formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  String formattedDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Obx(() {
                  final incomes = widget.noteController.notesList;
                  if (incomes.isEmpty) {
                    return const Center(child: Text("Tidak Ada Data"));
                  } else if (!incomes.isEmpty) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: incomes.length,
                      itemBuilder: (context, index) {
                        final income = incomes[index];
                        Color arrowColor = const Color(0xFF508D4E);
                        return Dismissible(
                          key: Key(income.id.toString()),
                          background: Container(
                            alignment: Alignment.centerRight,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            bool shouldDelete = false;
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: "Konfirmasi",
                              desc: 'Apakah ingin menghapus ${income.title}?',
                              btnCancelOnPress: () {
                                shouldDelete = false;
                              },
                              btnOkOnPress: () async {
                                await widget.noteController
                                    .deleteNote(income.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${income.title} Terhapus',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    backgroundColor: Color(0xFF508D4E),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                                shouldDelete = true;
                              },
                            ).show();
                            return shouldDelete;
                          },
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => ViewDetailNote(id: income.id!));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFD6EFD8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons
                                              .keyboard_double_arrow_up_outlined,
                                          size: 40,
                                          color: arrowColor,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${income.title}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            "${formatCurrency(income.anggaran_prediction! - income.anggaran_real!)}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month_outlined),
                                      const SizedBox(width: 3),
                                      Text(
                                        formattedDate(income.periode_tanggal!),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("Tidak ada data"));
                  }
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: widget._formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(158, 158, 158, 0.675),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            child: DropdownButton<String>(
                              hint: Text("Hari"),
                              value: _selectedDay,
                              menuMaxHeight: 200,
                              iconEnabledColor: Color(0xFF80AF81),
                              items: _days.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: _onDayChanged,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(158, 158, 158, 0.675),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            child: DropdownButton<String>(
                              hint: Text("Bulan"),
                              value: _selectedMonth,
                              menuMaxHeight: 200,
                              iconEnabledColor: Color(0xFF80AF81),
                              items: _months.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: _onMonthChanged,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(158, 158, 158, 0.675),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            child: DropdownButton<String>(
                              hint: Text("Tahun"),
                              value: _selectedYear,
                              menuMaxHeight: 200,
                              iconEnabledColor: Color(0xFF80AF81),
                              items: _years.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: _onYearChanged,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            MyButton(
              onTap: () {
                int? day =
                    _selectedDay != null ? int.parse(_selectedDay!) : null;
                int? month =
                    _selectedMonth != null ? int.parse(_selectedMonth!) : null;
                int? year =
                    _selectedYear != null ? int.parse(_selectedYear!) : null;
                widget.noteController.getNotesByDate(year, month, day);
              },
              nameBtn: "Cari",
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
