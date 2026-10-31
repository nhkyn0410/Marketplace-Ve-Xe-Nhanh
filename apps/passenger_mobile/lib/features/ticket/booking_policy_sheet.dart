import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import 'booking_models.dart';

/// Mở nội dung ngay trên bước xác nhận, giữ nguyên phiên giữ ghế bên dưới.
Future<void> showBookingPolicySheet({
  required BuildContext context,
  required String title,
  required Future<List<BookingPolicyDocument>> Function() loadDocuments,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  backgroundColor: Colors.white,
  builder: (_) => FractionallySizedBox(
    heightFactor: 0.82,
    child: _BookingPolicySheet(title: title, loadDocuments: loadDocuments),
  ),
);

class _BookingPolicySheet extends StatefulWidget {
  const _BookingPolicySheet({required this.title, required this.loadDocuments});

  final String title;
  final Future<List<BookingPolicyDocument>> Function() loadDocuments;

  @override
  State<_BookingPolicySheet> createState() => _BookingPolicySheetState();
}

class _BookingPolicySheetState extends State<_BookingPolicySheet> {
  late Future<List<BookingPolicyDocument>> _documents = widget.loadDocuments();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        key: const Key('booking-policy-sheet'),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Color(0xFF0B2942),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('booking-policy-close'),
                  tooltip: 'Đóng',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<BookingPolicyDocument>>(
              future: _documents,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final documents = snapshot.data ?? const [];
                if (snapshot.hasError || documents.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            snapshot.hasError
                                ? 'Chưa tải được nội dung. Vui lòng thử lại.'
                                : 'Chưa có nội dung được công bố.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          TextButton.icon(
                            key: const Key('booking-policy-retry'),
                            onPressed: () => setState(() {
                              _documents = widget.loadDocuments();
                            }),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    for (final document in documents)
                      if (documents.length == 1)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (document.title != widget.title) ...[
                              Text(
                                document.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                            ],
                            _PolicyMarkdown(document: document),
                          ],
                        )
                      else
                        ExpansionTile(
                          title: Text(document.title),
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: const EdgeInsets.only(bottom: 16),
                          children: [_PolicyMarkdown(document: document)],
                        ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyMarkdown extends StatelessWidget {
  const _PolicyMarkdown({required this.document});

  final BookingPolicyDocument document;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: document.bodyMarkdown,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        p: const TextStyle(color: Color(0xFF0B2942), fontSize: 14, height: 1.6),
        // Văn bản được đọc tại đây, không điều hướng ra khỏi phiên đặt vé.
        a: const TextStyle(color: Color(0xFF0B2942), fontSize: 14, height: 1.6),
      ),
    );
  }
}
