import 'package:cached_network_image/cached_network_image.dart';
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

    if (!mounted) return;

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
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _category(),
                  const SizedBox(height: 16),
                  _titleDocument(),
                  const SizedBox(height: 16),
                  _uploadProfile(),
                  const SizedBox(height: 16),
                  _infoTypeFile(),
                  const SizedBox(height: 16),
                  _txtDescription(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverList(delegate: _listImage()),
          ),
        ],
      ),
    );
  }

  SliverChildBuilderDelegate _listImage() {
    return SliverChildBuilderDelegate((context, index) {
      final page = dcmDetail!.pages[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 1000),
            child: CachedNetworkImage(
              imageUrl: page.pageURL,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              memCacheWidth: 600,
              placeholder: (context, url) {
                return AspectRatio(
                  aspectRatio: 1 / 1.414,
                  child: Container(
                    color: Colors.grey[100],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return Container(
                  height: 200,
                  color: Colors.grey[100],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 36,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }, childCount: dcmDetail!.pages.length);
  }

  Container _txtDescription() {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: const Color(0xffE1E3E4).withValues(alpha: 0.3),
          strokeAlign: -1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withValues(alpha: 0.03),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: const Color(0xff4F46E5).withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Desciption',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            dcmDetail!.description,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16, color: Color(0xff464555)),
          ),
        ],
      ),
    );
  }

  Row _infoTypeFile() {
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: const Color(0xffE1E3E4).withValues(alpha: 0.3),
          strokeAlign: -1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withValues(alpha: 0.03),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: const Color(0xff4F46E5).withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
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
              color: const Color(0xffC3C0FF).withValues(alpha: 0.2),
            ),
            child: Center(child: SvgPicture.asset(svg, width: 12, height: 15)),
          ),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Color(0xff464555)),
              ),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
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
              color: const Color(0xffF8F9FA),
              width: 2,
              strokeAlign: -1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                spreadRadius: -2,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: const Color(0xff4F46E5).withValues(alpha: 0.1),
                blurRadius: 15,
                spreadRadius: -3,
                offset: const Offset(0, 10),
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              getUploadedTime(dcmDetail!.createdAt),
              style: const TextStyle(fontSize: 12),
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
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Container _category() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffC0C1FF).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        dcmDetail!.categoryName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
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
        padding: const EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, size: 30),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.bookmark_outline, size: 30),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.save_alt_outlined, size: 30),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
