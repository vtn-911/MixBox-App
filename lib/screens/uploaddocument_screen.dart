import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mixboxapp/models/folder_model.dart';
import 'package:mixboxapp/screens/studyscreen.dart';
import 'package:mixboxapp/service/document_service.dart';
import 'package:mixboxapp/service/folder_service.dart';

import '../models/categoriesModel.dart';
import '../service/categories_service.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocumentScreen> {
  final TextEditingController docNameCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  String? selectedSubject;
  String? selectedFolder;
  List<Categoriesmodel> categories = [];
  List<FolderModel> folders = [];
  bool isLoadingCategories = true;
  bool isLoadingFolders = true;
  PlatformFile? selectedFile;
  String? visibilityValue = "PUBLIC";

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadFolders();
  }

  @override
  void dispose() {
    docNameCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  Future<void> createDocument() async {
    try {
      final result = await DocumentService.createDocument(
        title: docNameCtrl.text.trim(),
        categoryID: selectedSubject,
        folderID: selectedFolder,
        description: descCtrl.text.trim(),
        visibility: visibilityValue,
        file: selectedFile!,
      );
      if (result['success'] == true) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Studyscreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'pptx', 'jpg', 'png'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  Future<void> loadFolders() async {
    try {
      final result = await FolderService.listFolder(
        '030a3dc8-2e22-42d9-b36e-a0f567e80e6c',
      );
      setState(() {
        folders = result;
        isLoadingFolders = false;
      });
    } catch (e) {
      setState(() {
        isLoadingFolders = false;
      });
      debugPrint('Load folders error: $e');
    }
  }

  Future<void> loadCategories() async {
    try {
      final result = await CategoriesService.listCategories();
      setState(() {
        categories = result;
        isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        isLoadingCategories = false;
      });
      debugPrint('Load categories error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload Document",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "Add new study materials to your folders.",
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 24),
              _formUpload(),
            ],
          ),
        ),
      ),
    );
  }

  Container _formUpload() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: Color(0xffE1E3E4), strokeAlign: -1),
        boxShadow: [
          BoxShadow(
            color: Color(0xff000000).withValues(alpha: 0.03),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color(0xff4F46E5).withValues(alpha: 0.05),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _uploadArea(),
          const SizedBox(height: 16),
          _previewFile(),
          _lineStroke(),
          _txtTitle('DOCUMENT NAME'),
          const SizedBox(height: 5),
          _inputInfo('Enter document name', docNameCtrl),
          const SizedBox(height: 16),
          _txtTitle('SUBJECT'),
          const SizedBox(height: 5),
          _drdSubject(),
          const SizedBox(height: 16),
          _txtTitle('FOLDER'),
          const SizedBox(height: 5),
          _drdFolder(),
          const SizedBox(height: 16),
          _txtTitle('VISIBILITY'),
          const SizedBox(height: 5),
          _rdVisibility(),
          const SizedBox(height: 16),
          _txtTitle('DESCRIPTION'),
          const SizedBox(height: 5),
          _inputInfo(
            "Add any extra context or notes about this document...",
            descCtrl,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_btnCancel(), const SizedBox(width: 16), _btnUpload()],
          ),
        ],
      ),
    );
  }

  RadioGroup<String> _rdVisibility() {
    return RadioGroup<String>(
      groupValue: visibilityValue,
      onChanged: (String? value) {
        setState(() {
          visibilityValue = value;
        });
      },
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

  ElevatedButton _btnUpload() {
    return ElevatedButton.icon(
      onPressed: createDocument,
      icon: const Icon(
        Icons.file_upload_outlined,
        size: 20,
        color: Colors.white,
      ),
      label: const Text(
        'Upload Document',
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3B28CC),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  OutlinedButton _btnCancel() {
    return OutlinedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        side: const BorderSide(color: Color(0xFFC7C4D8), width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(color: Color(0xFF464555), fontSize: 14),
      ),
    );
  }

  Widget _drdFolder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownMenu<String>(
          width: constraints.maxWidth,
          initialSelection: selectedFolder,
          menuHeight: 200,
          trailingIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: Color(0xff77778A),
          ),
          hintText: isLoadingFolders ? 'Loading folders...' : 'Select folder',
          textStyle: const TextStyle(fontSize: 16, color: Color(0xff30303A)),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
            elevation: WidgetStateProperty.all<double>(4),
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          dropdownMenuEntries: folders.map((folder) {
            return DropdownMenuEntry<String>(
              value: folder.id,
              label: folder.nameFolder,
              style: MenuItemButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff30303A),
                ),
              ),
            );
          }).toList(),
          onSelected: isLoadingFolders
              ? null
              : (value) {
                  setState(() {
                    selectedFolder = value;
                  });
                },
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

  Widget _drdSubject() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownMenu<String>(
          width: constraints.maxWidth,
          initialSelection: selectedSubject,
          menuHeight: 200,
          trailingIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: Color(0xff77778A),
          ),
          hintText: isLoadingCategories
              ? 'Loading categories...'
              : 'Select subject',
          textStyle: const TextStyle(fontSize: 16, color: Color(0xff30303A)),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
            elevation: WidgetStateProperty.all<double>(4),
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          dropdownMenuEntries: categories.map((category) {
            return DropdownMenuEntry<String>(
              value: category.idCategory,
              label: category.nameCategory,
              style: MenuItemButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff30303A),
                ),
              ),
            );
          }).toList(),
          onSelected: isLoadingCategories
              ? null
              : (value) {
                  setState(() {
                    selectedSubject = value;
                  });
                },
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

  Container _lineStroke() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24),
      width: double.infinity,
      height: 1,
      color: Color(0xffC7C4D8).withValues(alpha: 0.3),
    );
  }

  Widget _previewFile() {
    if (selectedFile == null) return const SizedBox.shrink();
    final double sizeMB = selectedFile!.size / (1024 * 1024);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xffFAFAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffC7C5D8), width: 1),
      ),
      child: Row(
        children: [
          // File icon
          Container(
            width: 45,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xffECEBFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.description_outlined,
              size: 20,
              color: Color(0xff625BEF),
            ),
          ),

          const SizedBox(width: 16),

          // File information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedFile!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff202124),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${sizeMB.toStringAsFixed(2)} MB • Ready to upload',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Color(0xff858597)),
                ),
              ],
            ),
          ),

          // Remove button
          IconButton(
            onPressed: () {
              setState(() {
                selectedFile = null;
              });
            },
            icon: const Icon(Icons.close, size: 25, color: Color(0xff77778A)),
          ),
        ],
      ),
    );
  }

  Widget _uploadArea() {
    return InkWell(
      onTap: pickFile,
      child: DottedBorder(
        color: const Color(0xff3525CD).withValues(alpha: 0.3),
        strokeWidth: 2,
        dashPattern: const [6, 4],
        radius: const Radius.circular(12),
        borderType: BorderType.RRect,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xffFCFCFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Upload icon
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xff5146E5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_upload_rounded,
                  size: 29,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Click to browse or drag file here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff202124),
                ),
              ),
              const Text(
                'Supports PDF, DOCX, PPTX, JPG (Max 50MB)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xff5f5f70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
