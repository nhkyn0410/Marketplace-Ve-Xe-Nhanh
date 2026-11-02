import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const _ink = Color(0xFF142246);
const _body = Color(0xFF53617C);
const _blue = Color(0xFF078FC9);

/// Nội dung Markdown của bài viết theo kiểu chữ của app.
///
/// Khung "Xem trên điện thoại" của Admin (`apps/admin/components/article/mobile-article-preview.tsx`)
/// chép đúng các giá trị dưới đây — đổi ở một bên thì đổi cả bên kia.
class ArticleMarkdown extends StatelessWidget {
  const ArticleMarkdown({required this.data, super.key});

  final String data;

  static final styleSheet = MarkdownStyleSheet(
    p: const TextStyle(color: _body, fontSize: 14, height: 1.6),
    h1: const TextStyle(
      color: _ink,
      fontSize: 20,
      height: 1.4,
      fontWeight: FontWeight.w700,
    ),
    h2: const TextStyle(
      color: _ink,
      fontSize: 18,
      height: 1.4,
      fontWeight: FontWeight.w700,
    ),
    h3: const TextStyle(
      color: _ink,
      fontSize: 16,
      height: 1.4,
      fontWeight: FontWeight.w700,
    ),
    strong: const TextStyle(color: _ink, fontWeight: FontWeight.w700),
    em: const TextStyle(fontStyle: FontStyle.italic),
    a: const TextStyle(color: _blue, decoration: TextDecoration.underline),
    listBullet: const TextStyle(color: _blue, fontSize: 14, height: 1.6),
    blockSpacing: 14,
    blockquote: const TextStyle(
      color: _ink,
      fontSize: 14,
      height: 1.6,
      fontStyle: FontStyle.italic,
    ),
    blockquotePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    blockquoteDecoration: const BoxDecoration(
      color: Color(0xFFE6F6FF),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border(left: BorderSide(color: _blue, width: 3)),
    ),
    code: const TextStyle(
      color: _ink,
      fontFamily: 'monospace',
      fontSize: 13,
      backgroundColor: Color(0xFFF1F5F9),
    ),
    codeblockDecoration: const BoxDecoration(
      color: Color(0xFFF1F5F9),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    horizontalRuleDecoration: const BoxDecoration(
      border: Border(top: BorderSide(color: Color(0xFFE0E6EE))),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      key: const Key('article-markdown'),
      data: data,
      styleSheet: styleSheet,
      onTapLink: (_, href, _) {
        final uri = href == null ? null : Uri.tryParse(href);
        if (uri != null) launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      imageBuilder: (uri, _, alt) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          uri.toString(),
          width: double.infinity,
          fit: BoxFit.cover,
          semanticLabel: alt,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
