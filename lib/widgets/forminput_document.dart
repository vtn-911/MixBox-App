import 'package:flutter/material.dart';
import 'package:mixboxapp/models/dropdown_item_model.dart';

class ForminputDocument extends StatelessWidget {
  final TextEditingController docNameCtrl;
  final TextEditingController descCtrl;
  final List<DropdownItemModel> categories;
  final List<DropdownItemModel> folders;
  final bool isLoadingCategories;
  final bool isLoadingFolders;
  final String? selectedSubjectId;
  final String? selectedFolderId;
  final String? visibilityValue;
  final ValueChanged<String?> onSubjectChanged;
  final ValueChanged<String?> onFolderChanged;
  final ValueChanged<String?> onVisibilityChanged;

  const ForminputDocument({
    super.key,
    required this.docNameCtrl,
    required this.descCtrl,
    required this.categories,
    required this.folders,
    required this.isLoadingCategories,
    required this.isLoadingFolders,
    this.selectedSubjectId,
    this.selectedFolderId,
    required this.visibilityValue,
    required this.onSubjectChanged,
    required this.onFolderChanged,
    required this.onVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        _txtTitle('DOCUMENT NAME'),
        const SizedBox(height: 5),
        _inputInfo('Enter document name', docNameCtrl),
        const SizedBox(height: 16),
        _txtTitle('SUBJECT'),
        const SizedBox(height: 5),
        _drdSubject_Cate(
          selectedId: selectedSubjectId,
          isLoading: isLoadingCategories,
          items: categories,
          hintText: 'subject',
          onSelected: onSubjectChanged,
        ),
        const SizedBox(height: 16),
        _txtTitle('FOLDER'),
        const SizedBox(height: 5),
        _drdSubject_Cate(
          selectedId: selectedFolderId,
          isLoading: isLoadingFolders,
          items: folders,
          hintText: 'folders',
          onSelected: onFolderChanged,
        ),
        const SizedBox(height: 16),
        _txtTitle('VISIBILITY'),
        const SizedBox(height: 5),
        _rdVisibility(visibilityValue, onVisibilityChanged),
        const SizedBox(height: 16),
        _txtTitle('DESCRIPTION'),
        const SizedBox(height: 5),
        _inputInfo(
          "Add any extra context or notes about this document...",
          descCtrl,
        ),
      ],
    );
  }

  RadioGroup<String> _rdVisibility(
    String? currentVisibility,
    ValueChanged<String?> onChange,
  ) {
    return RadioGroup<String>(
      groupValue: currentVisibility,
      onChanged: onChange,
      child: Row(
        children: [
          Row(
            children: [
              Radio<String>(value: 'PUBLIC'),
              Text('Public'),
            ],
          ),
          Row(
            children: [
              Radio<String>(value: 'PRIVATE'),
              Text('Private'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _drdSubject_Cate({
    required String? selectedId,
    required bool isLoading,
    required List<DropdownItemModel> items,
    required String hintText,
    required ValueChanged<String?> onSelected,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownMenu<String>(
          width: constraints.maxWidth,
          initialSelection: selectedId,
          menuHeight: 200,
          trailingIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: Color(0xff77778A),
          ),
          hintText: isLoading ? 'Loading $hintText...' : 'Select $hintText',
          textStyle: const TextStyle(fontSize: 16, color: Color(0xff30303A)),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
            elevation: WidgetStateProperty.all<double>(4),
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          dropdownMenuEntries: items.map((item) {
            return DropdownMenuEntry<String>(
              value: item.id,
              label: item.name,
              style: MenuItemButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff30303A),
                ),
              ),
            );
          }).toList(),
          onSelected: isLoading ? null : onSelected,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xff898797),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xff898797),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xff5146E5), width: 2),
            ),
          ),
        );
      },
    );
  }

  Text _txtTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        color: Color(0xff464555),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextField _inputInfo(String txtHint, TextEditingController? controller) {
    return TextField(
      controller: controller,
      maxLines: null,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: txtHint,
        hintStyle: TextStyle(color: Color(0xffC7C4D8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffC7C4D8), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff777587), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff5146E5), width: 1.5),
        ),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}
