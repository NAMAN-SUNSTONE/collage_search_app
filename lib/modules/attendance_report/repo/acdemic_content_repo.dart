// import 'package:hub/academic_content/base/academic_content_model.dart';

import '../model/academic_content_model.dart';

abstract class AcademicContentRepo {
  Future<AcademicContentModel> fetchAcademicContent(String id);
  Future<Module> fetchModuleDetails({required int moduleId, required int courseId});
}