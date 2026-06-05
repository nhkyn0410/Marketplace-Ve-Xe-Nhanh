import type { CallbackWithoutResultAndOptionalError, Schema } from "mongoose";

const APPEND_ONLY_OPERATIONS = [
  "deleteOne",
  "deleteMany",
  "findOneAndDelete",
  "findOneAndReplace",
  "findOneAndUpdate",
  "replaceOne",
  "updateOne",
  "updateMany"
] as const;

export const APPEND_ONLY_ERROR_MESSAGE = "Audit collections are append-only.";

export function applyAppendOnlyGuard(schema: Schema): void {
  for (const operation of APPEND_ONLY_OPERATIONS) {
    schema.pre(operation, blockMutation);
  }
}

function blockMutation(next: CallbackWithoutResultAndOptionalError): void {
  next(new Error(APPEND_ONLY_ERROR_MESSAGE));
}
