import type { StorageProvider } from "./storage-provider";

const BATCH_SIZE = 500;

/**
 * Xóa object dưới `prefix` đã cũ hơn `minAgeMs` mà không còn dòng DB nào tham chiếu: file tải lên rồi bỏ dở, hoặc
 * file bị gỡ mà lần xóa sau commit thất bại. Hỏi DB theo lô (`findReferenced`). Trả về số object đã xóa.
 */
export async function deleteOrphanObjects(options: {
  storage: Pick<StorageProvider, "list" | "delete">;
  prefix: string;
  minAgeMs: number;
  findReferenced: (keys: readonly string[]) => Promise<Set<string>>;
  now?: Date;
}): Promise<number> {
  const cutoff = (options.now ?? new Date()).getTime() - options.minAgeMs;
  let deleted = 0;
  const flush = async (keys: string[]) => {
    if (keys.length === 0) {
      return;
    }
    const referenced = await options.findReferenced(keys);
    for (const key of keys) {
      if (!referenced.has(key)) {
        await options.storage.delete(key);
        deleted += 1;
      }
    }
  };

  let batch: string[] = [];
  for await (const object of options.storage.list(options.prefix)) {
    if (object.lastModified.getTime() >= cutoff) {
      continue;
    }
    batch.push(object.key);
    if (batch.length === BATCH_SIZE) {
      await flush(batch);
      batch = [];
    }
  }
  await flush(batch);
  return deleted;
}
