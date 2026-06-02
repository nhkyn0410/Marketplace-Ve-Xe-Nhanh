# Commit Message Instructions

Generate commit messages for this repository using Conventional Commits.

Output only the commit message. Do not explain the message.

## Format

Use this shape:

```text
<type>(<scope>): <summary>

<body>
```

The body is optional. Add it only when it clarifies why the change was made or what risk/verification matters.

## Types

- `feat`: user-visible feature or new capability
- `fix`: bug fix or behavior correction
- `refactor`: code restructuring without behavior change
- `test`: test-only change
- `docs`: documentation-only change
- `chore`: tooling, dependency, workspace, or maintenance change
- `build`: build, package, Turborepo, or bundling change
- `ci`: GitHub Actions or deployment pipeline change

## Scope

Prefer a short workspace or domain scope, for example:

- `root`
- `api`
- `marketplace`
- `operator-os`
- `admin`
- `passenger-mobile`
- `employee-mobile`
- `types`
- `api-client`
- `ui`
- `utils`
- `config`

Omit scope only when the change truly spans the whole repository.

## Rules

- The first line must match this pattern: `<type>(<scope>): <summary>`.
- Write the subject in English, imperative mood, lowercase after the type.
- Keep the subject at 72 characters or fewer.
- Describe exactly one logical change per commit.
- Do not include ticket/task IDs unless the user explicitly asks.
- Do not mention generated or ignored artifacts unless they are the point of the change.
- Never include secrets, tokens, OTPs, credentials, or private account data.
- If verification is relevant, include a short body line such as `Verified with pnpm lint`.
- For sprint, milestone, or changelog commits, include `Date: YYYY-MM-DD` in the body.

## Examples

For README changes, prefer:

```text
docs(root): add bilingual project readmes
```

Do not generate plain sentence subjects such as:

```text
Add initial README with project overview, stack details, and development guidelines
```

```text
chore(root): scaffold pnpm turborepo workspace
```

```text
build(api): add NestJS health endpoint scaffold

Verified with pnpm typecheck.
```

```text
docs(root): add VS Code commit instructions
```
