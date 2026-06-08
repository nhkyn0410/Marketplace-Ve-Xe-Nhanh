/**
 * Resolve identifier → namespace (LLD §6.5 bước 1, ADR-017 Account-separate).
 *  - Passenger  = email (không có "/")
 *  - Platform   = `platform/{username}`
 *  - Operator   = `{operatorSlug}/{username}`
 * Mỗi `(scope, username)` là account riêng — KHÔNG federate.
 */
export type ResolvedIdentity =
  | { scope: "passenger"; email: string }
  | { scope: "operator"; operatorSlug: string; username: string }
  | { scope: "platform"; username: string };

export const PLATFORM_NAMESPACE = "platform";

const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export function resolveIdentifier(rawIdentifier: string): ResolvedIdentity | null {
  const identifier = rawIdentifier.trim();
  if (identifier.length === 0) {
    return null;
  }

  const slashIndex = identifier.indexOf("/");
  if (slashIndex > 0) {
    const prefix = identifier.slice(0, slashIndex).trim().toLowerCase();
    const username = identifier.slice(slashIndex + 1).trim();
    if (prefix.length === 0 || username.length === 0 || username.includes("/")) {
      return null;
    }
    if (prefix === PLATFORM_NAMESPACE) {
      return { scope: "platform", username };
    }
    return { scope: "operator", operatorSlug: prefix, username };
  }

  if (EMAIL_PATTERN.test(identifier)) {
    return { scope: "passenger", email: identifier.toLowerCase() };
  }

  return null;
}
