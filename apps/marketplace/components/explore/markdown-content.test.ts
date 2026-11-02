import { createElement } from "react";
import { renderToStaticMarkup } from "react-dom/server";
import { describe, expect, it } from "vitest";
import { MarkdownContent } from "./markdown-content";

describe("published Markdown", () => {
  it("renders headings, lists and emphasis from published content", () => {
    const html = renderToStaticMarkup(createElement(MarkdownContent, { children: "## Lên xe\n\n- Mang **vé điện tử**\n- Đến đúng giờ" }));
    expect(html).toContain("<h2");
    expect(html).toContain("<ul");
    expect(html).toContain("<strong>vé điện tử</strong>");
  });

  it("does not execute raw HTML or dangerous link protocols", () => {
    const html = renderToStaticMarkup(createElement(MarkdownContent, { children: '<script>alert(1)</script>\n\n[liên kết](javascript:alert%281%29)\n\n<img src="x" onerror="alert(1)">' }));
    expect(html).not.toContain("<script");
    expect(html).not.toContain("javascript:");
    expect(html).not.toContain("onerror");
    expect(html).toContain("liên kết");
  });
});
