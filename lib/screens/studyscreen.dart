import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mixboxapp/models/categoriesModel.dart';
import 'package:mixboxapp/models/documents_model.dart';
import 'package:mixboxapp/screens/document_detail_screen.dart';
import 'package:mixboxapp/service/categories_service.dart';
import 'package:mixboxapp/service/document_service.dart';

class Studyscreen extends StatefulWidget {
  const Studyscreen({super.key});

  @override
  State<Studyscreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<Studyscreen> {
  List<Categoriesmodel> listCate = [];
  List<DocumentsModel> listAllDoc = [];
  final TextEditingController searchCtrl = TextEditingController();
  String? selectedCategoryId;

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadListAllDocuments();
  }

  Future<void> loadCategories() async {
    final data = await CategoriesService.listCategories();
    setState(() {
      listCate = data;
    });
  }

  Future<void> loadListAllDocuments() async {
    final data = await DocumentService.listallDocuments();
    setState(() {
      listAllDoc = data;
    });
  }

  Future<void> searchDocuments() async {
    final query = searchCtrl.text.trim();
    if (query.isEmpty) return;
    try {
      final documents = await DocumentService.searchDocuments(query: query);
      setState(() {
        listAllDoc = documents;
      });
    } catch (e) {
      print('Search error: $e');
    }
  }

  Future<void> filterCategories(String categoryID) async {
    try {
      final documents = await DocumentService.searchDocuments(
        categoryId: categoryID,
      );
      setState(() {
        listAllDoc = documents;
      });
    } catch (e) {
      print('Category filter error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchDocs(),
            const SizedBox(height: 16),
            _txtCategories('Categories'),
            const SizedBox(height: 16),
            _lvCategories(),
            const SizedBox(height: 16),
            _txtCategories('Recommended for you'),
            const SizedBox(height: 16),
            _lvDocments(),
          ],
        ),
      ),
    );
  }

  Text _txtCategories(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Expanded _lvDocments() {
    return Expanded(
      child: ListView.builder(
        itemCount: listAllDoc.length,
        itemBuilder: (context, index) {
          final item = listAllDoc[index];
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
                            borderRadius: BorderRadiusGeometry.circular(4),
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
      ),
    );
  }

  SizedBox _lvCategories() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listCate.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return InkWell(
              borderRadius: BorderRadius.circular(9999),
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  selectedCategoryId = null;
                });
                loadListAllDocuments();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: selectedCategoryId == null
                      ? Color(0xff3525CD)
                      : Color(0xffE7E8E9),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Center(
                  child: Text(
                    'All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: selectedCategoryId == null
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }
          final category = listCate[index - 1];
          return InkWell(
            splashColor: Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
            onTap: () {
              setState(() {
                selectedCategoryId = category.idCategory;
              });
              filterCategories(category.idCategory);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: selectedCategoryId == category.idCategory
                    ? Color(0xff3525CD)
                    : Color(0xffE7E8E9),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Center(
                child: Text(
                  category.nameCategory,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: selectedCategoryId == category.idCategory
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Container _searchDocs() {
    return Container(
      width: double.infinity,
      height: 49,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: searchCtrl,
          onSubmitted: (_) => searchDocuments(),
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            prefixIcon: Icon(Icons.search, size: 20),
            hintText: 'Search documents...',
            hintStyle: TextStyle(color: Color(0xff464555), fontSize: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xffE2E4E9)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xffE2E4E9)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xffC7C4D8),
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
