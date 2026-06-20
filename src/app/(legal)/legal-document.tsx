import "server-only";

import { readFile } from "node:fs/promises";
import path from "node:path";

import styles from "./legal-page.module.css";

type LegalDocumentProps = {
  fileName: "priv-policy.txt" | "terms.txt";
  title: string;
};

type LegalBlock =
  | { type: "heading" | "paragraph" | "subheading" | "notice"; text: string }
  | { type: "ordered-list" | "unordered-list" | "lettered-list"; items: string[] };

function isSectionHeading(line: string) {
  const match = line.match(/^\d+\.\s+(.+)$/u);

  if (!match) {
    return false;
  }

  const heading = match[1];
  return heading === heading.toLocaleUpperCase("es");
}

function isSubheading(line: string) {
  const match = line.match(/^\d+\.\d+\.\s*(.+)$/u);

  if (!match) {
    return false;
  }

  const text = match[1];
  return text.length < 72 && !text.includes(":") && !text.includes(". ");
}

function parseDocument(source: string): LegalBlock[] {
  const lines = source
    .split(/\r?\n/u)
    .map((line) => line.trim())
    .filter(Boolean);
  const blocks: LegalBlock[] = [];

  for (let index = 0; index < lines.length; index += 1) {
    const line = lines[index];

    if (line.startsWith("\u2022")) {
      const items: string[] = [];

      while (index < lines.length && lines[index].startsWith("\u2022")) {
        items.push(lines[index].replace(/^\u2022\s*/u, ""));
        index += 1;
      }

      blocks.push({ type: "unordered-list", items });
      index -= 1;
      continue;
    }

    if (/^[a-z]\)\s*/u.test(line)) {
      const items: string[] = [];

      while (index < lines.length && /^[a-z]\)\s*/u.test(lines[index])) {
        items.push(lines[index].replace(/^[a-z]\)\s*/u, ""));
        index += 1;
      }

      blocks.push({ type: "lettered-list", items });
      index -= 1;
      continue;
    }

    if (/^\d+\.\s+/u.test(line) && !isSectionHeading(line)) {
      const items: string[] = [];

      while (
        index < lines.length &&
        /^\d+\.\s+/u.test(lines[index]) &&
        !isSectionHeading(lines[index])
      ) {
        items.push(lines[index].replace(/^\d+\.\s*/u, ""));
        index += 1;
      }

      blocks.push({ type: "ordered-list", items });
      index -= 1;
      continue;
    }

    if (isSectionHeading(line)) {
      blocks.push({ type: "heading", text: line });
    } else if (isSubheading(line)) {
      blocks.push({ type: "subheading", text: line });
    } else if (line.startsWith("AVISO IMPORTANTE:")) {
      blocks.push({ type: "notice", text: line });
    } else {
      blocks.push({ type: "paragraph", text: line });
    }
  }

  return blocks;
}

function renderParagraph(text: string, index: number) {
  const clause = text.match(/^(\d+\.\d+\.)\s*(.+)$/u);

  if (!clause) {
    return <p key={index}>{text}</p>;
  }

  return (
    <p key={index}>
      <strong>{clause[1]}</strong> {clause[2]}
    </p>
  );
}

export async function LegalDocument({ fileName, title }: LegalDocumentProps) {
  const filePath = path.join(process.cwd(), "src", "constants", fileName);
  const source = await readFile(filePath, "utf8");
  const blocks = parseDocument(source);

  return (
    <main id="top" className={styles.page}>
      <article className={styles.content}>
        <header className={styles.header}>
          <h1>{title}</h1>
        </header>

        <div className={styles.document}>
          {blocks.map((block, index) => {
            if (block.type === "heading") {
              return <h2 key={index}>{block.text}</h2>;
            }

            if (block.type === "subheading") {
              return <h3 key={index}>{block.text}</h3>;
            }

            if (block.type === "notice") {
              return (
                <p key={index} className={styles.notice}>
                  {block.text}
                </p>
              );
            }

            if (block.type === "unordered-list") {
              return (
                <ul key={index} className={styles.list}>
                  {block.items.map((item) => (
                    <li key={item}>{item}</li>
                  ))}
                </ul>
              );
            }

            if (block.type === "ordered-list") {
              return (
                <ol key={index} className={styles.list}>
                  {block.items.map((item) => (
                    <li key={item}>{item}</li>
                  ))}
                </ol>
              );
            }

            if (block.type === "lettered-list") {
              return (
                <ol key={index} className={`${styles.list} ${styles.letteredList}`}>
                  {block.items.map((item) => (
                    <li key={item}>{item}</li>
                  ))}
                </ol>
              );
            }

            if (block.type === "paragraph") {
              return renderParagraph(block.text, index);
            }

            return null;
          })}
        </div>
      </article>
    </main>
  );
}
