import { Injectable } from "@nestjs/common";
import { createHash, randomBytes } from "node:crypto";

/** Token opaque 32-byte + SHA-256. KHÔNG scrypt: token đã đủ entropy (256 bit),
 *  và mỗi lần refresh phải tra cứu O(1) theo hash. */
@Injectable()
export class RefreshTokenService {
  /** Trả token thô đúng 1 lần sau bước này chỉ hash tồn tại */
  mint(): { token: string; hash: string } {
    const token = randomBytes(32).toString("base64url");
    return { token, hash: this.hash(token) };
  }

  hash(token: string): string {
    return createHash("sha256").update(token).digest("hex");
  }
}
