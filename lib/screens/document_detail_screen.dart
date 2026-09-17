import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mixboxapp/models/document_detail.dart';
import 'package:mixboxapp/service/document_service.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentDetailScreen extends StatefulWidget {
  final String id;

  const DocumentDetailScreen({super.key, required this.id});

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailState();
}

class _DocumentDetailState extends State<DocumentDetailScreen> {
  DocumentDetail? dcmDetail;
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    loadDocumentDetail();
    _pdfViewerController = PdfViewerController();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
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
      appBar: _appBar(context),
      body: SfPdfViewer.network(
        dcmDetail!.fileUrl,
        controller: _pdfViewerController,
        enableDoubleTapZooming: true,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi tải PDF: ${details.description}')),
          );
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.black),
          onPressed: () => _showDocumentInfoModal(context),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.bookmark_outline, color: Colors.black),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.save_alt_outlined, color: Colors.black),
        ),
      ],
    );
  }

  void _showDocumentInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xffF8F9FA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                  _category(),
                  const SizedBox(height: 16),
                  _titleDocument(),
                  const SizedBox(height: 16),
                  _uploadProfile(),
                  const SizedBox(height: 16),
                  _infoTypeFile(),
                  const SizedBox(height: 16),
                  _txtDescription(),
                ],
              ),
            );
          },
        );
      },
    );
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
}
