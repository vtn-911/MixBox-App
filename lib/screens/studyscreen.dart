import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mixboxapp/models/categoriesModel.dart';
import 'package:mixboxapp/models/documents_model.dart';
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchDocs(),
            const SizedBox(height: 32),
            Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _lvCategories(),
            const SizedBox(height: 16),
            Text(
              'Recommended for you',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: listAllDoc.length,
                itemBuilder: (context, index) {
                  return Container(
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
                          child: listAllDoc[index].thumbnailUrl == null
                              ? Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/icon-document.svg',
                                    width: 16,
                                    height: 20,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    4,
                                  ),
                                  child: Image.network(
                                    'http://10.0.2.2:3000${listAllDoc[index].thumbnailUrl}',
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
                                listAllDoc[index].title,
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
                                  listAllDoc[index].category,
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
                                    '${listAllDoc[index].pageCount} pages',
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
                                      listAllDoc[index].owner,
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _lvCategories() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listCate.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Color(0xffE7E8E9),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Center(
              child: Text(
                listCate[index].nameCategory,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            prefixIcon: Icon(Icons.search, size: 20),
            hintText: 'Search documents...',
            hintStyle: TextStyle(color: Color(0xff464555), fontSize: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color(0xffE1E3E4),
                width: 1,
                strokeAlign: -1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
