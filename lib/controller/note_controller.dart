import 'package:app_note_client/model/notes.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class NoteController extends GetxController {
  var notesList = <Notes>[].obs;
  var noteToday = <Notes>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodayNote();
  }

  Future<RxList<Notes>> showMonthNote(Notes Note) async { 
    notesList.value = await DatabaseHelper.instance.fetchNotesForCurrentMonth();
    return notesList;
  }

  Future<void> addNote(Notes note) async {
    await DatabaseHelper.instance.insertNote(note);
    await fetchNote();
  }

  Future<void> updateNote(Notes note) async {
    await DatabaseHelper.instance.updateNote(note);
    await fetchNote();
  }

  Future<Notes?> getNoteDetails(int id) async {
    return await DatabaseHelper.instance.fetchNoteById(id);
  }

  Future<void> deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);
    await fetchNote();
  }

  Future<void> fetchNote() async {
    noteToday.value = await DatabaseHelper.instance.fetchNotes();
    await fetchTodayNote();
  }

  Future<void> fetchTodayNote() async {
    final db = await DatabaseHelper.instance.database;
    final today = DateTime.now();
    final todayString = DateFormat('yyyy-MM-dd').format(today);

    final result = await db.query(
      'notes',
      where: 'periode_tanggal = ?',
      whereArgs: [todayString],
    );
    noteToday.value = result.map((json) => Notes.fromMap(json)).toList();
  }

  Future<RxList<Notes>> getNotesByDate(int? year, int? month, int? day) async {
    final db = await DatabaseHelper.instance.database;

    String whereClause;
    List<String> whereArgs;
    final now = DateTime.now();

    if (day != null) {
      if (month == null) month = now.month;
      if (year == null) year = now.year;
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(DateTime(year, month, day));
      whereClause = 'strftime("%Y-%m-%d", periode_tanggal) = ?';
      whereArgs = [formattedDate];
    } else if (month != null) {
      if (year == null) year = now.year;
      String formattedMonth =
          DateFormat('yyyy-MM').format(DateTime(year, month));
      whereClause = 'strftime("%Y-%m", periode_tanggal) = ?';
      whereArgs = [formattedMonth];
    } else if (year != null) {
      String formattedYear = DateFormat('yyyy').format(DateTime(year));
      whereClause = 'strftime("%Y", periode_tanggal) = ?';
      whereArgs = [formattedYear];
    } else {
      // Default to the current month if no date is provided
      String formattedMonth = DateFormat('yyyy-MM').format(now);
      whereClause = 'strftime("%Y-%m", periode_tanggal) = ?';
      whereArgs = [formattedMonth];
    }

    final result = await db.query(
      'notes',
      where: whereClause,
      whereArgs: whereArgs,
    );

    List<Notes> noteMap = [];
    for (var json in result) {
      final noteListData = Notes.fromMap(json);
      noteMap.add(noteListData);
    }
    notesList.value = noteMap;
    return notesList;
  }
}
