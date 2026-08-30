import 'package:flutter/material.dart';

class SectionQuickaction {
  String nameAction;
  IconData iconAction;

  SectionQuickaction({required this.nameAction, required this.iconAction});

  static List<SectionQuickaction> getSectionQuickAction() {
    List<SectionQuickaction> quickAction = [
      SectionQuickaction(nameAction: 'Search Docs', iconAction: Icons.search),
      SectionQuickaction(
        nameAction: 'Scan Document',
        iconAction: Icons.document_scanner_outlined,
      ),
      SectionQuickaction(
        nameAction: 'Create Quiz',
        iconAction: Icons.quiz_outlined,
      ),
      SectionQuickaction(
        nameAction: 'My Folders',
        iconAction: Icons.folder_outlined,
      ),
    ];
    return quickAction;
  }
}
