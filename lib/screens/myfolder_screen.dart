import 'package:flutter/material.dart';
import 'package:mixboxapp/models/folder_model.dart';
import 'package:mixboxapp/screens/folderdetail_screen.dart';
import 'package:mixboxapp/service/folder_service.dart';

class MyfolderScreen extends StatefulWidget {
  const MyfolderScreen({super.key});

  @override
  State<MyfolderScreen> createState() => _MyFolderState();
}

class _MyFolderState extends State<MyfolderScreen> {
  List<FolderModel> listFolder = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadListFolder();
  }

  Future<void> loadListFolder() async {
    try {
      final result = await FolderService.listFolder(
        '030a3dc8-2e22-42d9-b36e-a0f567e80e6c',
      );
      setState(() {
        listFolder = result;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Load Folder Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Folders',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Organize your study materials efficiently.',
              style: TextStyle(fontSize: 16, color: Color(0xff464555)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_btnUpDoc(), _btnCreateFolder()],
            ),
            const SizedBox(height: 16),
            lvFolders(),
          ],
        ),
      ),
    );
  }

  Expanded lvFolders() {
    return Expanded(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listFolder.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FolderdetailScreen(
                          folderID: listFolder[index].id,
                          nameFolder: listFolder[index].nameFolder,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(24),
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                listFolder[index].nameFolder,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _btnMore(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  size: 13,
                                  color: Color(0xff464555),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${listFolder[index].doucments} Docs',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff464555),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              getUpdatedTime(listFolder[index].updatedAt),
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff777587),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String getUpdatedTime(dynamic updateAt) {
    if (updateAt == null) return 'Updated recently';

    // 💡 Parse chuỗi String từ API sang DateTime
    final DateTime parsedDate = updateAt is String
        ? (DateTime.tryParse(updateAt) ?? DateTime.now())
        : (updateAt as DateTime);

    final difference = DateTime.now().difference(parsedDate);

    if (difference.inDays > 0) {
      return 'Updated ${difference.inDays} days ago';
    }
    if (difference.inHours > 0) {
      return 'Updated ${difference.inHours} hours ago';
    }
    if (difference.inMinutes > 0) {
      return 'Updated ${difference.inMinutes} mins ago';
    }

    return 'Updated just now';
  }

  Widget _btnMore() {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Icon(Icons.more_vert, color: Color(0xff464555), size: 20),
    );
  }

  ElevatedButton _btnCreateFolder() {
    return ElevatedButton.icon(
      onPressed: () {},
      label: const Text(
        'Create Folder',
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3B28CC),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  ElevatedButton _btnUpDoc() {
    return ElevatedButton.icon(
      onPressed: () {},
      label: const Text(
        'Upload Document',
        style: TextStyle(fontSize: 14, color: Color(0xFF3B28CC)),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3B28CC).withValues(alpha: 0.05),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFF3B28CC)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
