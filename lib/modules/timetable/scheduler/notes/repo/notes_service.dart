import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hub/constants/constants.dart';
import 'package:hub/network/network.dart';
import 'package:hub/sunstone_base/data/ss_file.dart';
import 'package:hub/utils/exceptions.dart';
import 'package:ss_network/ss_network_client.dart';
import 'package:ss_network/ss_request.dart';
import 'package:ss_network/ss_response.dart';

class NotesAPI {
  static final SSNetworkClient _client = Get.find();
  //returns the list of dynamic cards
  static Future createUpdateNotes(Map<String, dynamic> params,
      {SSFile? file}) async {
    var request = AppServiceFactory.getRequest(
        HubEndPoints.note, SSRequestType.postMultipart, AppBaseRequestType.base,
        queryParams: params);
    if (file != null) {
      request.addFiles(SSNetworkFile('attachments', file.file,
          fileBytes: file.bytes, fileName: file.fileName));
    }

    SSNetworkResponse data = await _client.makeRequest(request);

    try {
      if (data.error == null) {
        return (data.data);
      }
      throw Exception();
    } catch (e) {
      ThrowCustomException(data);
    }
  }

  //deletes a note
  static Future deleteNote(String noteId) async {
    var request = AppServiceFactory.getRequest(
      HubEndPoints.note + '?note_id=$noteId',
      SSRequestType.delete,
      AppBaseRequestType.base,
    );

    SSNetworkResponse data = await _client.makeRequest(request);

    try {
      if (data.error != null) {
        debugPrint(data.error!.errorMessage);
        throw Exception();
      }
    } catch (e) {
      ThrowCustomException(data);
    }
  }

  //deletes a note attachment
  static Future deleteAttachment(String attachmentId) async {
    var request = AppServiceFactory.getRequest(
        HubEndPoints.noteAttachment + '?attachment_id=$attachmentId',
        SSRequestType.delete,
        AppBaseRequestType.base);

    SSNetworkResponse data = await _client.makeRequest(request);

    try {
      if (data.error != null) {
        debugPrint(data.error!.errorMessage);
        throw Exception();
      }
    } catch (e) {
      ThrowCustomException(data);
    }
  }
}
