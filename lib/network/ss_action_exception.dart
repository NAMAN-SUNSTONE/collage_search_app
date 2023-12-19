enum SSExceptionTypesEnums { silent, normal }

class SSActionException implements Exception {
  String debugMsg;
  String errorMsg;
  SSExceptionTypesEnums exceptionType;
  int code;

  SSActionException(this.debugMsg, this.errorMsg, this.code,
      {this.exceptionType = SSExceptionTypesEnums.normal});

  @override
  String toString() => errorMsg;
}
