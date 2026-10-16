"use client";

import ReactMarkdown, { type Components } from "react-markdown";

// Xem trước Markdown của bài viết (LLD §6.10 bước 2): react-markdown KHÔNG render HTML thô và tự bỏ liên kết
// `javascript:` — chỉ tập thẻ Markdown chuẩn. Kiểu chữ theo Figma ADM-13b ("Xem trước").
const COMPONENTS: Components = {
  h1: ({ children }) => <h2 className="mt-1 mb-2 text-xl leading-7 font-semibold text-vxn-ink">{children}</h2>,
  h2: ({ children }) => <h3 className="mt-1 mb-2 text-lg leading-7 font-semibold text-vxn-ink">{children}</h3>,
  h3: ({ children }) => <h4 className="mt-1 mb-2 text-base leading-6 font-semibold text-vxn-ink">{children}</h4>,
  p: ({ children }) => <p className="mb-3 text-sm leading-6 text-vxn-fg-1">{children}</p>,
  ul: ({ children }) => <ul className="mb-3 list-disc pl-5 text-sm leading-6 text-vxn-fg-1">{children}</ul>,
  ol: ({ children }) => <ol className="mb-3 list-decimal pl-5 text-sm leading-6 text-vxn-fg-1">{children}</ol>,
  blockquote: ({ children }) => (
    <blockquote className="mb-3 rounded-lg bg-accent px-3 py-2 text-sm leading-6 text-accent-foreground [&_p]:mb-0 [&_p]:text-accent-foreground">
      {children}
    </blockquote>
  ),
  a: ({ children, href }) => (
    <a href={href} target="_blank" rel="noopener noreferrer nofollow" className="text-primary underline">
      {children}
    </a>
  ),
  // Ảnh ở kho công khai: <img> thường, không qua bộ tối ưu ảnh của Next.
  img: ({ src, alt }) => (typeof src === "string" ? <img src={src} alt={alt ?? ""} className="mb-3 max-w-full rounded-lg" /> : null),
  code: ({ children }) => <code className="rounded bg-muted px-1 py-0.5 font-mono text-[13px]">{children}</code>
};

export function MarkdownPreview({ markdown }: { markdown: string }) {
  if (markdown.trim() === "") {
    return <p className="text-sm leading-6 text-muted-foreground">Nội dung xem trước sẽ hiện ở đây.</p>;
  }
  return <ReactMarkdown components={COMPONENTS}>{markdown}</ReactMarkdown>;
}
