"use client";

import ReactMarkdown, { type Components } from "react-markdown";

import { readingMinutes } from "../../lib/article/article-format";

// Xem bài viết như trên app hành khách (màn đọc bài `article_reader_screen.dart`).
// Cỡ chữ / màu / khoảng cách chép từ `ArticleMarkdown.styleSheet` (`article_markdown.dart`) —
// đổi ở một bên thì đổi cả bên kia. Vẫn là react-markdown: không render HTML thô, bỏ liên kết `javascript:`.
const INK = "#142246";
const BODY = "#53617C";
const BLUE = "#078FC9";

const COMPONENTS: Components = {
  h1: ({ children }) => (
    <h2 className="mb-3.5 text-[20px] leading-[1.4] font-bold" style={{ color: INK }}>
      {children}
    </h2>
  ),
  h2: ({ children }) => (
    <h3 className="mb-3.5 text-[18px] leading-[1.4] font-bold" style={{ color: INK }}>
      {children}
    </h3>
  ),
  h3: ({ children }) => (
    <h4 className="mb-3.5 text-[16px] leading-[1.4] font-bold" style={{ color: INK }}>
      {children}
    </h4>
  ),
  p: ({ children }) => <p className="mb-3.5 text-[14px] leading-[1.6]">{children}</p>,
  strong: ({ children }) => (
    <strong className="font-bold" style={{ color: INK }}>
      {children}
    </strong>
  ),
  ul: ({ children }) => <ul className="mb-3.5 list-disc pl-6 text-[14px] leading-[1.6] marker:text-[#078FC9]">{children}</ul>,
  ol: ({ children }) => <ol className="mb-3.5 list-decimal pl-6 text-[14px] leading-[1.6] marker:text-[#078FC9]">{children}</ol>,
  blockquote: ({ children }) => (
    <blockquote
      className="mb-3.5 rounded-[10px] border-l-[3px] bg-[#E6F6FF] px-3.5 py-3 text-[14px] leading-[1.6] italic [&_p]:mb-0"
      style={{ borderColor: BLUE, color: INK }}
    >
      {children}
    </blockquote>
  ),
  a: ({ children, href }) => (
    <a href={href} target="_blank" rel="noopener noreferrer nofollow" className="underline" style={{ color: BLUE }}>
      {children}
    </a>
  ),
  // Ảnh ở kho công khai: <img> thường, không qua bộ tối ưu ảnh của Next.
  img: ({ src, alt }) => (typeof src === "string" ? <img src={src} alt={alt ?? ""} className="mb-3.5 w-full rounded-xl object-cover" /> : null),
  code: ({ children }) => (
    <code className="rounded bg-[#F1F5F9] px-1 font-mono text-[13px]" style={{ color: INK }}>
      {children}
    </code>
  ),
  hr: () => <hr className="mb-3.5 border-[#E0E6EE]" />
};

type MobileArticlePreviewProps = {
  title: string;
  summary: string;
  markdown: string;
  categoryName: string | null;
  coverUrl: string | null;
};

function today(): string {
  return new Intl.DateTimeFormat("vi-VN", { day: "2-digit", month: "2-digit", year: "numeric", timeZone: "Asia/Ho_Chi_Minh" }).format(new Date());
}

/** Khung điện thoại rộng 390px hiển thị bài viết theo bố cục và kiểu chữ của app hành khách. */
export function MobileArticlePreview({ title, summary, markdown, categoryName, coverUrl }: MobileArticlePreviewProps) {
  return (
    <div className="mx-auto w-[406px] max-w-full rounded-[36px] border-8 border-[#1B2430] bg-[#1B2430] shadow-lg">
      <div aria-label="Xem trên điện thoại" className="h-[720px] overflow-y-auto rounded-[28px] bg-white" style={{ color: BODY }}>
        <div className="h-[220px] w-full bg-[#E6F6FF]">
          {coverUrl ? (
            <img src={coverUrl} alt="" className="h-full w-full object-cover" />
          ) : (
            <div className="flex h-full items-center justify-center text-xs text-[#7B8A9F]">Ảnh bìa</div>
          )}
        </div>
        <div className="px-[18px] pt-4 pb-6">
          <span className="inline-block rounded-[10px] bg-[#8DE5B6] px-2.5 py-[3px] text-[11px] leading-[1.4] font-semibold text-[#0E5C35]">
            {categoryName ?? "Chuyên mục"}
          </span>
          <h1 className="mt-3 text-[21px] leading-[1.45] font-bold text-[#101E44]">{title.trim() || "Tiêu đề bài viết"}</h1>
          <p className="mt-2.5 text-[12px] leading-[1.5] text-[#7B8A9F]">
            {today()} &nbsp;·&nbsp; {readingMinutes(markdown)} phút đọc &nbsp;·&nbsp; Vé Xe Nhanh
          </p>
          <hr className="my-3.5 border-[#E0E6EE]" />
          {summary.trim() !== "" && (
            <p className="mb-3.5 text-[15px] leading-[1.6] font-medium" style={{ color: INK }}>
              {summary}
            </p>
          )}
          {markdown.trim() === "" ? (
            <p className="text-[14px] leading-[1.6] text-[#7B8A9F]">Nội dung xem trước sẽ hiện ở đây.</p>
          ) : (
            <ReactMarkdown components={COMPONENTS}>{markdown}</ReactMarkdown>
          )}
          <div className="mt-5 rounded-[14px] bg-[#E6F6FF] px-3.5 py-3">
            <p className="text-[16px] leading-[1.5] font-bold" style={{ color: INK }}>
              Sẵn sàng lên đường?
            </p>
            <p className="mt-1 text-[12px] leading-[1.5] text-[#597D9F]">Tìm chuyến xe phù hợp cho hành trình của bạn.</p>
            <div className="mt-2.5 flex h-10 items-center justify-center rounded-full text-[14px] font-medium text-white" style={{ background: BLUE }}>
              Tìm chuyến đi ›
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
