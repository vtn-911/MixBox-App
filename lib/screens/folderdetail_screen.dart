import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mixboxapp/models/folder_documents.dart';
import 'package:mixboxapp/screens/document_detail_screen.dart';
import 'package:mixboxapp/service/folder_service.dart';

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
  void initState() {
    super.initState();
    loadListDoc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarFolderDetail(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: _lvDocments(),
      ),
    );
  }

  Widget _lvDocments() {
    return ListView.builder(
      itemCount: listDoc!.length,
      itemBuilder: (context, index) {
        final item = listDoc![index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DocumentDetailScreen(id: item.id),
              ),
            );
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
                          item.category,
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
