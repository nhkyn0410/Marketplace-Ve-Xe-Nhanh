import ReactMarkdown, { type Components } from "react-markdown";

const components: Components = {
  h1: ({ children }) => <h2 className="mt-6 mb-3 text-2xl font-bold text-vxn-ink">{children}</h2>,
  h2: ({ children }) => <h2 className="mt-6 mb-3 text-xl font-bold text-vxn-ink">{children}</h2>,
  h3: ({ children }) => <h3 className="mt-5 mb-2 text-lg font-semibold text-vxn-ink">{children}</h3>,
  p: ({ children }) => <p className="mb-3 leading-relaxed">{children}</p>,
  ul: ({ children }) => <ul className="mb-3 list-disc space-y-1 pl-5">{children}</ul>,
  ol: ({ children }) => <ol className="mb-3 list-decimal space-y-1 pl-5">{children}</ol>,
  blockquote: ({ children }) => <blockquote className="my-3 border-l-4 border-vxn-teal-600 bg-vxn-bg-soft py-2 pl-4">{children}</blockquote>,
  a: ({ children, href }) => <a href={href} className="text-vxn-teal-800 underline break-words">{children}</a>,
  img: ({ src, alt }) => typeof src === "string" ? <img src={src} alt={alt ?? ""} className="my-4 max-h-[32rem] max-w-full rounded-xl object-contain" /> : null,
  pre: ({ children }) => <pre className="my-3 overflow-x-auto rounded-lg bg-vxn-bg-soft p-3">{children}</pre>,
  code: ({ children }) => <code className="rounded bg-vxn-bg-soft px-1 font-mono text-sm">{children}</code>
};

/** Hiển thị Markdown đã xuất bản, bỏ HTML thô và liên kết có giao thức không an toàn. */
export function MarkdownContent({ children }: { readonly children: string }) {
  return <div className="text-sm leading-relaxed text-vxn-fg-2"><ReactMarkdown skipHtml components={components}>{children}</ReactMarkdown></div>;
}
