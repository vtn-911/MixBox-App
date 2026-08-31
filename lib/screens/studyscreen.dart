import 'package:flutter/material.dart';
import 'package:mixboxapp/models/categories_study.dart';

class Studyscreen extends StatefulWidget {
  const Studyscreen({super.key});

  @override
  State<Studyscreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<Studyscreen> {
  List<CategoriesStudy> listItem = CategoriesStudy.getlistCategories();

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
              'Popular Documents',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Expanded(child: ListView.builder(itemBuilder: (context, index) {})),
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
        itemCount: listItem.length,
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
                listItem[index].nameCategory,
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
