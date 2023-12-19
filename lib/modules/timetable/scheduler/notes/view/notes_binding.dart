import 'package:get/get.dart';
import 'package:hub/ui/timetable/scheduler/notes/view/notes_controller.dart';

class NotesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotesController>(() => NotesController());
  }
}