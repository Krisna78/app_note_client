import 'package:app_note_client/controller/note_controller.dart';
import 'package:app_note_client/home/note_home/add_note.dart';
import 'package:app_note_client/home/note_home/update_note.dart';
import 'package:app_note_client/home/note_home/view_detail_note.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  final NoteController noteController = Get.put(NoteController());
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Data Hari Ini",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Obx(() {
                        final incomes = widget.noteController.noteToday;
                        if (incomes.isEmpty) {
                          return const Center(child: Text("Belum Ada Data"));
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  margin: const EdgeInsets.only(bottom: 10),
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
                                    desc:
                                        'Apakah ingin menghapus ${income.title}?',
                                    btnCancelOnPress: () {
                                      shouldDelete = false;
                                    },
                                    btnOkOnPress: () async {
                                      await widget.noteController
                                          .deleteNote(income.id!);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                    Get.to(
                                        () => ViewDetailNote(id: income.id!));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD6EFD8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  "${formatCurrency(income.anggaran_prediction! - income.anggaran_real!)}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                              "${formattedDate(income.periode_tanggal!)}",
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
                          return const Center(
                              child: Text("Tidak ada Data Hari ini"));
                        }
                      }),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => AddNote());
                      },
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(
                          Color(0xFF80AF81),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        padding: const WidgetStatePropertyAll<EdgeInsets>(
                          EdgeInsets.only(
                              top: 12, bottom: 12, left: 25, right: 25),
                        ),
                      ),
                      child: const Text(
                        "Catatan Baru",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
