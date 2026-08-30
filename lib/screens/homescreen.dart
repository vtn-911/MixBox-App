import 'package:flutter/material.dart';
import 'package:mixboxapp/models/recent_documents.dart';
import 'package:mixboxapp/models/section_quickaction.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Homescreen> {
  List<SectionQuickaction> quickAction =
      SectionQuickaction.getSectionQuickAction();
  List<RecentDocuments> recentItem = RecentDocuments.getrecentitem();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(Icons.menu),
        ),
        title: const Text(
          'MixBox',
          style: TextStyle(
            color: Color(0xff3525CD),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What do you want to do today?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 5),
              const Text(
                "Let's keep up the great work.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              _gvQuickAction(),
              const SizedBox(height: 32),
              _rTitleRecentDocs(),
              const SizedBox(height: 16),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentItem.length,

                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 16),
                      padding: EdgeInsets.all(16),
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 188,
                            height: 128,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xffEDEEEF),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(10),
                              child: Image.network(
                                recentItem[index].imageDoc,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            recentItem[index].nameDoc,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule_outlined,
                                size: 14,
                                color: Color(0xff464555),
                              ),
                              Text(
                                ' Opened ${recentItem[index].timeDoc}h',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff464555),
                                ),
                              ),
                            ],
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
      ),
    );
  }

  Row _rTitleRecentDocs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Documents',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          'See all',
          style: TextStyle(
            color: Color(0xff3525CD),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _gvQuickAction() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 171 / 116,
      children: [
        ...quickAction.map(
          (item) => Container(
            padding: const EdgeInsets.all(16),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(0xffE1E0FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.iconAction),
                ),
                const SizedBox(height: 10),
                Text(
                  item.nameAction,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
