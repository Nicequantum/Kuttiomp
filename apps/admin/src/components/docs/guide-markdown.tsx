import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import rehypeSlug from "rehype-slug";

interface GuideMarkdownProps {
  content: string;
}

export function GuideMarkdown({ content }: GuideMarkdownProps) {
  return (
    <article
      className="guide-prose prose prose-stone max-w-none
        prose-headings:font-serif prose-headings:text-emerald-950 prose-headings:scroll-mt-20
        prose-h1:text-3xl prose-h2:text-2xl prose-h2:border-b prose-h2:border-stone-200 prose-h2:pb-2
        prose-h3:text-xl prose-p:leading-relaxed prose-p:text-stone-700
        prose-a:text-emerald-800 prose-a:font-medium prose-a:no-underline hover:prose-a:underline
        prose-strong:text-stone-900 prose-code:rounded prose-code:bg-stone-100 prose-code:px-1.5 prose-code:py-0.5
        prose-code:text-emerald-900 prose-code:before:content-none prose-code:after:content-none
        prose-pre:bg-stone-900 prose-pre:text-stone-100
        prose-table:text-sm prose-th:bg-stone-100 prose-th:px-3 prose-th:py-2
        prose-td:px-3 prose-td:py-2 prose-td:border-stone-200
        prose-li:text-stone-700 prose-blockquote:border-emerald-800 prose-blockquote:text-stone-600
        prose-hr:border-stone-200"
    >
      <ReactMarkdown remarkPlugins={[remarkGfm]} rehypePlugins={[rehypeSlug]}>
        {content}
      </ReactMarkdown>
    </article>
  );
}