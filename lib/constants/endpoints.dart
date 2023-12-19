class ApiEndpoints {
  static const loginUser = 'login/loginUser';
  static const logoutUser = 'pu/logout';
  static const refreshToken = 'pu/refresh';
  static const lectures = 'attendance/lectures';
  static const uploadPhoto = 'attendance/uploadImage';
  static const attendanceDetails = 'attendance/{id}/details';
  static const attendanceBroadcast = 'attendance/beacon/broadcast';
  static const markAttendance = 'attendance/mark';
  static const editAttendance = 'attendance/mark/edit';
  static const resetAttendance = 'attendance/mark/reset';
  static const attendanceSubjects = 'attendance/subject-wise';
  static const courseDetails = 'box/lms/professor/course/@courseId';
  static const moduleData = 'box/lms/user/module-content/v2/@moduleId';
  static const quizSession = 'box/lms/quiz/user/session';
  static const timeline = 'box/professor/calendar';
  static const eventDetails = 'box/professor/calendar/@EVENT_ID';
  static const markLecture = 'box/professor/mark/lecture/@EVENT_ID';
}
