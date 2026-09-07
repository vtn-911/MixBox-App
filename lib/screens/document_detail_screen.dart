import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mixboxapp/models/document_detail.dart';
import 'package:mixboxapp/service/document_service.dart';

class DocumentDetailScreen extends StatefulWidget {
  final String id;

  const DocumentDetailScreen({super.key, required this.id});

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailState();
}

class _DocumentDetailState extends State<DocumentDetailScreen> {
  DocumentDetail? dcmDetail;

  @override
  void initState() {
    super.initState();
    loadDocumentDetail();
  }

  Future<void> loadDocumentDetail() async {
    final data = await DocumentService.getDocumentById(widget.id);
    setState(() {
      dcmDetail = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dcmDetail == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _category(),
              const SizedBox(height: 16),
              _titleDocument(),
              const SizedBox(height: 16),
              _uploadProfile(),
              const SizedBox(height: 16),
              _infoDad(),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dcmDetail!.pages.length,
                itemBuilder: (context, index) {
                  final page = dcmDetail!.pages[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Image.network(
                      page.pageURL,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.broken_image));
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _infoDad() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoDocument(
          'assets/icons/icon-document.svg',
          'Length',
          '${dcmDetail!.pageCount} pages',
        ),
        _infoDocument(
          'assets/icons/file-type.svg',
          'File Type',
          '${dcmDetail!.fileType} • ${getFileSizeMB(dcmDetail!.fileSize)}',
        ),
      ],
    );
  }

  Container _infoDocument(String svg, String title, String desc) {
    return Container(
      width: 175,
      height: 55,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: Color(0xffE1E3E4).withValues(alpha: 0.3),
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
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffC3C0FF).withValues(alpha: 0.2),
            ),
            child: Center(child: SvgPicture.asset(svg, width: 12, height: 15)),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Color(0xff464555)),
              ),
              Text(
                desc,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _uploadProfile() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: Color(0xffF8F9FA),
              width: 2,
              strokeAlign: -1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                spreadRadius: -2,
                offset: Offset(0, 4),
              ),
              BoxShadow(
                color: Color(0xff4F46E5).withValues(alpha: 0.1),
                blurRadius: 15,
                spreadRadius: -3,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(dcmDetail!.ownerAvatar),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dcmDetail!.ownerFullName,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              getUploadedTime(dcmDetail!.createdAt),
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  String getFileSizeMB(int fileSize) {
    final mb = fileSize / (1024 * 1024);
    return '${mb.toStringAsFixed(2)} MB';
  }

  String getUploadedTime(DateTime createdAt) {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inDays > 0) {
      return 'Uploaded ${difference.inDays} days ago';
    }

    if (difference.inHours > 0) {
      return 'Uploaded ${difference.inHours} hours ago';
    }

    if (difference.inMinutes > 0) {
      return 'Uploaded ${difference.inMinutes} minutes ago';
    }

    return 'Uploaded just now';
  }

  Text _titleDocument() {
    return Text(
      dcmDetail!.title,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Container _category() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xffC0C1FF).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        dcmDetail!.categoryName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          color: Color(0xff6063EE),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, size: 30),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.bookmark_outline, size: 30),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.save_alt_outlined, size: 30),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
