# Copilot Instructions

Read `AGENTS.md` before suggesting project code, commands, or commit messages.

When generating Git commit messages from VS Code Source Control:

- Follow `.github/instructions/commit-message.instructions.md`.
- Use Conventional Commits only.
- The first line must be `<type>(<scope>): <summary>`.
- Do not generate plain English sentence subjects.
- For README-only changes in the repository root, prefer `docs(root): add bilingual project readmes`.

Project notes:

- Code, API, and database identifiers use English.
- SDLC documents use Vietnamese.
- Commit and push only when explicitly requested by Khanh.
- AI usage journal is mandatory: after generating code, record one row by running `node .claude/hooks/ai-journal.mjs add "<Mảng kỹ thuật>" "<AI sử dụng>" "<Mục đích>" "<Phần AI sinh>" "" "<Nhận xét>"`. Never read, open, or hand-edit the journal file. "Phần AI sinh" holds file paths and scope only — never source code (300-char cap per cell). Rules: `doc/AI-JOURNAL.md`. The `.ai-journal/` folder is gitignored — never commit it.
