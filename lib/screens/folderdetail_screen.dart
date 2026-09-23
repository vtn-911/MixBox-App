import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mixboxapp/models/categoriesModel.dart';
import 'package:mixboxapp/models/folder_documents.dart';
import 'package:mixboxapp/providers/folder_provider.dart';
import 'package:mixboxapp/providers/user_provider.dart';
import 'package:mixboxapp/screens/document_detail_screen.dart';
import 'package:mixboxapp/service/document_service.dart';
import 'package:mixboxapp/service/folder_service.dart';
import 'package:mixboxapp/widgets/forminput_document.dart';
import 'package:provider/provider.dart';

import '../service/categories_service.dart';

class FolderdetailScreen extends StatefulWidget {
  final String folderID;
  final String nameFolder;

  const FolderdetailScreen({
    super.key,
    required this.folderID,
    required this.nameFolder,
  });

  @override
  State<FolderdetailScreen> createState() => _FolderDetailState();
}

class _FolderDetailState extends State<FolderdetailScreen> {
  List<FolderDocuments>? listDoc = [];
  final TextEditingController docNameCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  List<Categoriesmodel> categories = [];
  bool isLoadingCategories = false;

  String? selectedCategory;
  String? selectedFolder;
  String? visibilityValue = 'PUBLIC';

  @override
  void initState() {
    super.initState();
    loadListDoc();
    loadCategories();
  }

  @override
  void dispose() {
    docNameCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  String? get _currentUserId => context.read<UserProvider>().user?.id;

  void _refreshFolders() {
    if (_currentUserId != null) {
      context.read<FolderProvider>().fetchFolder(_currentUserId);
    }
  }

  Future<void> handleDeleteDocument(String documentId) async {
    final isSuccesDelete = await DocumentService.deletedDocument(documentId);
    if (!mounted) return;
    if (isSuccesDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Documents deleted successfilly')),
      );
      loadListDoc();
      _refreshFolders();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete document !!!')),
      );
    }
  }

  Future<void> handleUpdateDocument(String documentId) async {
    final isSuccessUpdate = await DocumentService.updateDocument(
      documentId,
      docNameCtrl.text,
      descCtrl.text,
      selectedCategory,
      selectedFolder,
      visibilityValue,
    );
    if (!mounted) return;
    if (isSuccessUpdate) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document updated successfully')),
      );
      loadListDoc();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update document !!!')),
      );
    }
  }

  void fillFormWithItem(FolderDocuments item) {
    docNameCtrl.text = item.title;
    descCtrl.text = item.description;
    selectedCategory = item.categoryID;
    selectedFolder = widget.folderID;
    visibilityValue = item.visibilityDoc;
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

  Future<void> loadListDoc() async {
    try {
      final response = await FolderService.getDocumentsByFolderId(
        widget.folderID,
      );
      if (!mounted) return;
      setState(() {
        listDoc = response;
      });
    } catch (e) {
      debugPrint('Load List Document (Folder) Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final folderProvider = context.watch<FolderProvider>();
    return Scaffold(
      appBar: _appBarFolderDetail(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: _lvDocments(folderProvider),
      ),
    );
  }

  Widget _lvDocments(FolderProvider folderProvider) {
    return ListView.builder(
      itemCount: listDoc!.length,
      itemBuilder: (context, index) {
        final item = listDoc![index];
        Offset tapPosition = Offset.zero;
        return GestureDetector(
          onTapDown: (details) => tapPosition = details.globalPosition,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DocumentDetailScreen(id: item.id),
              ),
            );
          },
          onLongPress: () async {
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            final selectedValue = await _showMenu_Document(
              context,
              tapPosition,
              overlay,
            );
            if (!context.mounted || selectedValue == null) return;
            switch (selectedValue) {
              case 'edit':
                fillFormWithItem(item);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Color(0xffF8F9FA),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (context) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.5,
                      maxChildSize: 0.9,
                      builder: (_, scrollController) {
                        return SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ForminputDocument(
                                docNameCtrl: docNameCtrl,
                                descCtrl: descCtrl,
                                categories: categories,
                                folders: folderProvider.folders,
                                isLoadingCategories: isLoadingCategories,
                                isLoadingFolders: folderProvider.isLoading,
                                selectedFolderId: selectedFolder,
                                selectedSubjectId: selectedCategory,
                                visibilityValue: visibilityValue,
                                onSubjectChanged: (value) {
                                  setState(() => selectedCategory = value);
                                },
                                onFolderChanged: (value) {
                                  setState(() => selectedFolder = value);
                                },
                                onVisibilityChanged: (value) {
                                  setState(() => visibilityValue = value);
                                },
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => handleUpdateDocument(item.id),
                                label: const Text(
                                  'Update Document',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF3B28CC),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B28CC)
                                      .withValues(alpha: 0.05),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 16,
                                  ),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Color(0xFF3B28CC)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
                break;
              case 'delete':
                handleDeleteDocument(item.id);
                break;
            }
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(10),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1,
                color: Color(0xffE1E3E4),
                strokeAlign: -1,
              ),
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
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color(0xff3525CD).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: item.thumbnailUrl == null
                      ? Center(
                          child: SvgPicture.asset(
                            'assets/icons/icon-document.svg',
                            width: 16,
                            height: 20,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            'http://10.0.2.2:3000${item.thumbnailUrl}',
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffEDEEEF),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          item.categoryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xff464555),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/icon-document.svg',
                            width: 12,
                            height: 12,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${item.pageCount} pages',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff464555),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.person,
                            color: Color(0xff3525CD),
                            size: 13,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              item.owner,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff464555),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.bookmark_outline),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _showMenu_Document(
    BuildContext context,
    Offset tapPosition,
    RenderBox overlay,
  ) {
    return showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        tapPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20, color: Color(0xff3525CD)),
              SizedBox(width: 8),
              Text(
                'Edit',
                style: TextStyle(fontSize: 13, color: Color(0xff3525CD)),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_forever_outlined, size: 20, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(fontSize: 13, color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  AppBar _appBarFolderDetail() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, size: 30),
        ),
      ),
      title: Text(widget.nameFolder),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert, size: 30),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
