import 'package:flutter/material.dart';
import 'package:mixboxapp/models/folder_model.dart';
import 'package:mixboxapp/service/folder_service.dart';

class FolderProvider extends ChangeNotifier {
  List<FolderModel> _folders = [];
  bool _isLoading = false;

  List<FolderModel> get folders => _folders;

  bool get isLoading => _isLoading;

  Future<void> fetchFolder(String? userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _folders = await FolderService.listFolder(userId);
    } catch (e) {
      debugPrint('ERROR FETCHFOLDER: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
