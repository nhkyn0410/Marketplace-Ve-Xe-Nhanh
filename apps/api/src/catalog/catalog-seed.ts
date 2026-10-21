import type { DbTransaction } from "../database/prisma.service";
import {
  StopPointType,
  VehicleClass,
  VehicleForm,
} from "../database/prisma.types";

/**
 * Seed catalog (TASK-CAT-001, DB-MIG-04, quyết định Q4). Lõi nằm trong `src/` để test được; CLI mỏng ở
 * `prisma/catalog-seed.ts` lo env, kết nối owner và ngữ cảnh RLS `system`.
 * CREATE-ONLY: dòng đã có (theo `code`) giữ nguyên, để chạy lại không ghi đè sửa đổi của Admin (ADM-001).
 */

export const ADMINISTRATIVE_UNITS_CSV_HEADER = [
  "province_code",
  "province_name",
  "ward_code",
  "ward_name",
] as const;

export const ADMINISTRATIVE_UNITS_EXTENDED_CSV_HEADER = [
  "province_code",
  "province_name",
  "province_level",
  "province_decree",
  "ward_code",
  "ward_name",
  "ward_level",
  "ward_decree",
] as const;

/** Thông tin đơn vị hành chính cấp tỉnh trong file CSV danh mục. */
export interface AdministrativeProvince {
  readonly code: string;
  readonly name: string;
  readonly level?: string | null;
  readonly decree?: string | null;
}

/** Thông tin đơn vị hành chính cấp xã trong file CSV danh mục. */
export interface AdministrativeWard {
  readonly code: string;
  readonly name: string;
  readonly provinceCode: string;
  readonly level?: string | null;
  readonly decree?: string | null;
}

/** Tập hợp danh mục tỉnh và xã đã phân tích từ CSV. */
export interface AdministrativeUnits {
  readonly provinces: AdministrativeProvince[];
  readonly wards: AdministrativeWard[];
}

type CodedItem = { code: string; name: string; description?: string };

type VehicleTypeItem = CodedItem & { form: VehicleForm; class: VehicleClass };

type SampleStopPoint = {
  name: string;
  type: StopPointType;
  address: string;
  provinceCode: string;
  /** Tra theo tên trong tỉnh (không phân biệt hoa/thường); không khớp thì bỏ qua bến này. */
  wardName: string;
  latitude: number;
  longitude: number;
};

export type CatalogSeedData = AdministrativeUnits & {
  vehicleTypes: VehicleTypeItem[];
  amenities: CodedItem[];
  sampleStopPoints: SampleStopPoint[];
};

export type CatalogSeedResult = {
  provinces: number;
  wards: number;
  vehicleTypes: number;
  amenities: number;
  stopPoints: number;
  skippedStopPoints: string[];
};

/**
 * Loại phương tiện chuẩn: ba dạng chỗ × hai hạng xe (BR-77). Limousine là hạng, không phải dạng chỗ.
 * Mã `LIMOUSINE` cũ được migration `add_vehicle_classification` đổi thành `SEATER_LIMOUSINE`.
 */
export const VEHICLE_TYPES: VehicleTypeItem[] = [
  {
    code: "SEATER",
    name: "Ghế ngồi",
    description: "Xe khách ghế ngồi.",
    form: VehicleForm.SEATER,
    class: VehicleClass.STANDARD,
  },
  {
    code: "SLEEPER",
    name: "Giường nằm",
    description: "Xe khách giường nằm.",
    form: VehicleForm.SLEEPER,
    class: VehicleClass.STANDARD,
  },
  {
    code: "CABIN",
    name: "Cabin",
    description: "Xe giường nằm dạng phòng cabin riêng.",
    form: VehicleForm.CABIN,
    class: VehicleClass.STANDARD,
  },
  {
    code: "SEATER_LIMOUSINE",
    name: "Ghế ngồi Limousine",
    description: "Xe ghế ngồi cao cấp, ít chỗ.",
    form: VehicleForm.SEATER,
    class: VehicleClass.LIMOUSINE,
  },
  {
    code: "SLEEPER_LIMOUSINE",
    name: "Giường nằm Limousine",
    description: "Xe giường nằm hạng limousine.",
    form: VehicleForm.SLEEPER,
    class: VehicleClass.LIMOUSINE,
  },
  {
    code: "CABIN_LIMOUSINE",
    name: "Cabin Limousine",
    description: "Xe cabin riêng hạng limousine.",
    form: VehicleForm.CABIN,
    class: VehicleClass.LIMOUSINE,
  },
];

/** Tiện ích cơ bản trên xe; Admin bổ sung qua ADM-001. */
export const AMENITIES: CodedItem[] = [
  { code: "AIR_CONDITIONER", name: "Điều hòa" },
  { code: "WIFI", name: "Wi-Fi" },
  { code: "WATER", name: "Nước uống" },
  { code: "BLANKET", name: "Chăn đắp" },
  { code: "USB_CHARGER", name: "Cổng sạc điện thoại" },
  { code: "TOILET", name: "Nhà vệ sinh trên xe" },
];

/**
 * Bến xe MẪU cho môi trường dev (KHÔNG seed production). Toạ độ gần đúng; tên phường sau sắp xếp 2025
 * chưa đối chiếu — nếu file danh mục chính thức không có phường trùng tên, bến đó bị bỏ qua kèm cảnh báo.
 */
export const SAMPLE_STOP_POINTS: SampleStopPoint[] = [
  {
    name: "Bến xe Miền Đông mới",
    type: StopPointType.BUS_STATION,
    address: "501 Hoàng Hữu Nam, TP. Hồ Chí Minh",
    provinceCode: "79",
    wardName: "Phường Long Bình",
    latitude: 10.8787,
    longitude: 106.8164,
  },
  {
    name: "Bến xe Miền Tây",
    type: StopPointType.BUS_STATION,
    address: "395 Kinh Dương Vương, TP. Hồ Chí Minh",
    provinceCode: "79",
    wardName: "Phường An Lạc",
    latitude: 10.7406,
    longitude: 106.619,
  },
  {
    name: "Bến xe Mỹ Đình",
    type: StopPointType.BUS_STATION,
    address: "20 Phạm Hùng, Hà Nội",
    provinceCode: "01",
    wardName: "Phường Từ Liêm",
    latitude: 21.0285,
    longitude: 105.7784,
  },
  {
    name: "Bến xe Nước Ngầm",
    type: StopPointType.BUS_STATION,
    address: "1 Ngọc Hồi, Hà Nội",
    provinceCode: "01",
    wardName: "Phường Hoàng Liệt",
    latitude: 20.9645,
    longitude: 105.8423,
  },
  {
    name: "Bến xe Trung tâm Đà Nẵng",
    type: StopPointType.BUS_STATION,
    address: "201 Tôn Đức Thắng, Đà Nẵng",
    provinceCode: "48",
    wardName: "Phường Liên Chiểu",
    latitude: 16.0622,
    longitude: 108.1717,
  },
  {
    name: "Bến xe liên tỉnh Đà Lạt",
    type: StopPointType.BUS_STATION,
    address: "01 Tô Hiến Thành, Lâm Đồng",
    provinceCode: "68",
    wardName: "Phường Xuân Hương - Đà Lạt",
    latitude: 11.9275,
    longitude: 108.4448,
  },
];

const SAMPLE_DESCRIPTION = "Dữ liệu mẫu cho môi trường dev — toạ độ gần đúng.";
const SAMPLE_LEGAL_BASIS = "Căn cứ giả lập cho dữ liệu mẫu dev — không phải văn bản thật.";

/**
 * Ghép dữ liệu seed. Bến xe mẫu phải xin TƯỜNG MINH (`withSamples`) — mặc định không có, để lỡ trỏ
 * nhầm DB production mà quên `NODE_ENV` cũng không đăng dữ liệu mẫu; xin ở production thì từ chối.
 */
export function catalogSeedData(
  units: AdministrativeUnits,
  options: { nodeEnv: string | undefined; withSamples: boolean },
): CatalogSeedData {
  if (options.withSamples && options.nodeEnv?.trim() === "production") {
    throw new Error("Không seed bến xe mẫu ở production (bỏ --with-samples).");
  }
  return {
    ...units,
    vehicleTypes: VEHICLE_TYPES,
    amenities: AMENITIES,
    sampleStopPoints: options.withSamples ? SAMPLE_STOP_POINTS : [],
  };
}

/**
 * Đọc + kiểm file CSV danh mục hành chính chính thức (định dạng: `CAT-001-todo.md` Q4). Sai ở đâu ném
 * lỗi kèm số dòng — không bao giờ trả dữ liệu dở, để seed không ghi mã sai (vd. Excel xoá số 0 đầu).
 * Hỗ trợ cả định dạng 4 cột cơ bản và 8 cột mở rộng (có cấp hành chính + nghị định).
 */
export function parseAdministrativeUnitsCsv(text: string): AdministrativeUnits {
  const BYTE_ORDER_MARK = 0xfeff; // Excel "CSV UTF-8" ghi BOM đầu file
  const lines = (
    text.codePointAt(0) === BYTE_ORDER_MARK ? text.slice(1) : text
  ).split(/\r?\n/);
  while (lines.at(-1)?.trim() === "") {
    lines.pop();
  }
  // File không phải UTF-8 (Excel "CSV (Comma delimited)") được Node đọc thành U+FFFD mà không báo lỗi;
  // mã vẫn là chữ số nên lọt mọi kiểm tra khác, và seed create-only không sửa lại được tên hỏng.
  const REPLACEMENT_CHARACTER = String.fromCodePoint(0xfffd);
  const brokenLine = lines.findIndex((line) =>
    line.includes(REPLACEMENT_CHARACTER),
  );
  if (brokenLine >= 0) {
    throw new Error(
      `Dòng ${brokenLine + 1}: ký tự lỗi mã hoá — lưu lại file bằng "CSV UTF-8".`,
    );
  }
  const [header, ...rows] = lines;
  const expectedBasic = ADMINISTRATIVE_UNITS_CSV_HEADER.join(",");
  const expectedExtended = ADMINISTRATIVE_UNITS_EXTENDED_CSV_HEADER.join(",");
  const actual =
    header === undefined
      ? null
      : splitCsvLine(header)
          ?.map((field) => field.trim().toLowerCase())
          .join(",");
  const isExtended = actual === expectedExtended;
  if (actual !== expectedBasic && !isExtended) {
    throw new Error(
      `Dòng 1: tiêu đề phải đúng "${expectedBasic}" hoặc "${expectedExtended}" (phân cách bằng dấu phẩy, không phải dấu chấm phẩy).`,
    );
  }
  if (rows.length === 0) {
    throw new Error("File không có dòng dữ liệu nào.");
  }

  const expectedColCount = isExtended
    ? ADMINISTRATIVE_UNITS_EXTENDED_CSV_HEADER.length
    : ADMINISTRATIVE_UNITS_CSV_HEADER.length;
  const provincesByCode = new Map<string, AdministrativeProvince>();
  const wardCodes = new Set<string>();
  const wards: AdministrativeWard[] = [];

  rows.forEach((line, index) => {
    const lineNo = index + 2;
    // NFC: cùng một tên có thể lưu dạng dựng sẵn hoặc tổ hợp dấu; không chuẩn hoá thì so tên sai.
    const fields = splitCsvLine(line)?.map((field) =>
      field.trim().normalize("NFC"),
    );
    if ((fields?.length ?? 0) !== expectedColCount) {
      throw new Error(
        `Dòng ${lineNo}: cần đúng ${expectedColCount} cột, dấu nháy phải đóng.`,
      );
    }

    let provinceCode: string;
    let provinceName: string;
    let provinceLevel: string | null = null;
    let provinceDecree: string | null = null;
    let wardCode: string;
    let wardName: string;
    let wardLevel: string | null = null;
    let wardDecree: string | null = null;

    if (isExtended) {
      const [pCode, pName, pLevel, pDecree, wCode, wName, wLevel, wDecree] =
        fields as [
          string,
          string,
          string,
          string,
          string,
          string,
          string,
          string,
        ];
      provinceCode = pCode;
      provinceName = pName;
      provinceLevel = pLevel || null;
      provinceDecree = pDecree || null;
      wardCode = wCode;
      wardName = wName;
      wardLevel = wLevel || null;
      wardDecree = wDecree || null;
    } else {
      const [pCode, pName, wCode, wName] = fields as [
        string,
        string,
        string,
        string,
      ];
      provinceCode = pCode;
      provinceName = pName;
      wardCode = wCode;
      wardName = wName;
    }

    if (!/^\d{2}$/.test(provinceCode)) {
      throw new Error(
        `Dòng ${lineNo}: mã tỉnh "${provinceCode}" phải gồm đúng 2 chữ số (giữ số 0 đầu).`,
      );
    }
    if (!/^\d{5}$/.test(wardCode)) {
      throw new Error(
        `Dòng ${lineNo}: mã xã "${wardCode}" phải gồm đúng 5 chữ số (giữ số 0 đầu).`,
      );
    }
    if (!provinceName || !wardName) {
      throw new Error(`Dòng ${lineNo}: tên tỉnh và tên xã không được trống.`);
    }
    const knownProvince = provincesByCode.get(provinceCode);
    if (knownProvince !== undefined) {
      if (knownProvince.name !== provinceName) {
        throw new Error(
          `Dòng ${lineNo}: mã tỉnh ${provinceCode} mang hai tên "${knownProvince.name}" và "${provinceName}".`,
        );
      }
      if (
        isExtended &&
        ((knownProvince.level ?? null) !== provinceLevel ||
          (knownProvince.decree ?? null) !== provinceDecree)
      ) {
        throw new Error(
          `Dòng ${lineNo}: mã tỉnh ${provinceCode} có cấp hành chính hoặc nghị định không nhất quán.`,
        );
      }
    }
    if (wardCodes.has(wardCode)) {
      throw new Error(`Dòng ${lineNo}: trùng mã xã ${wardCode}.`);
    }

    provincesByCode.set(
      provinceCode,
      isExtended
        ? {
            code: provinceCode,
            name: provinceName,
            level: provinceLevel,
            decree: provinceDecree,
          }
        : { code: provinceCode, name: provinceName },
    );
    wardCodes.add(wardCode);
    wards.push(
      isExtended
        ? {
            code: wardCode,
            name: wardName,
            provinceCode,
            level: wardLevel,
            decree: wardDecree,
          }
        : { code: wardCode, name: wardName, provinceCode },
    );
  });

  return {
    provinces: [...provincesByCode.values()],
    wards,
  };
}

/** Tách một dòng CSV (RFC 4180, không hỗ trợ xuống dòng trong ô); `null` nếu dấu nháy chưa đóng. */
function splitCsvLine(line: string): string[] | null {
  const fields: string[] = [];
  let field = "";
  let quoted = false;
  for (let i = 0; i < line.length; i++) {
    const char = line[i];
    if (quoted) {
      if (char === '"' && line[i + 1] === '"') {
        field += '"';
        i++;
      } else if (char === '"') {
        quoted = false;
      } else {
        field += char;
      }
    } else if (char === '"') {
      quoted = true;
    } else if (char === ",") {
      fields.push(field);
      field = "";
    } else {
      field += char;
    }
  }
  if (quoted) {
    return null;
  }
  fields.push(field);
  return fields;
}

/**
 * Ghi catalog create-only. `tx` PHẢI là transaction đã gắn scope `system`/`platform` (RLS chặn ghi ở
 * scope khác). Trả số dòng tạo mới; chạy lại lần hai trả toàn 0.
 */
export async function seedCatalog(
  tx: DbTransaction,
  data: CatalogSeedData,
): Promise<CatalogSeedResult> {
  const provinces = await tx.province.createMany({
    data: data.provinces.map((province) => ({
      code: province.code,
      name: province.name,
      ...(province.level !== undefined ? { level: province.level } : {}),
      ...(province.decree !== undefined ? { decree: province.decree } : {}),
    })),
    skipDuplicates: true,
  });

  // Bổ sung level và decree cho các tỉnh đã tồn tại từ trước mà chưa có metadata, giữ nguyên name
  const provincesMissingMeta = data.provinces.some(
    (province) => Boolean(province.level || province.decree),
  )
    ? await tx.province.findMany({
        where: {
          code: { in: data.provinces.map((province) => province.code) },
          level: null,
        },
        select: { code: true },
      })
    : [];
  if (provincesMissingMeta.length > 0) {
    const provinceByCode = new Map(
      data.provinces.map((province) => [province.code, province]),
    );
    for (const { code } of provincesMissingMeta) {
      const province = provinceByCode.get(code);
      if (province && (province.level || province.decree)) {
        await tx.province.update({
          where: { code },
          data: {
            level: province.level ?? null,
            decree: province.decree ?? null,
          },
        });
      }
    }
  }

  const provinceIds = new Map(
    (
      await tx.province.findMany({
        where: {
          code: { in: data.provinces.map((province) => province.code) },
        },
        select: { id: true, code: true },
      })
    ).map((province) => [province.code, province.id]),
  );
  const wards = await tx.ward.createMany({
    data: data.wards.map((ward) => {
      const provinceId = provinceIds.get(ward.provinceCode);
      if (!provinceId) {
        throw new Error(
          `Xã ${ward.code} tham chiếu mã tỉnh ${ward.provinceCode} không có trong dữ liệu.`,
        );
      }
      return {
        code: ward.code,
        name: ward.name,
        provinceId,
        ...(ward.level !== undefined ? { level: ward.level } : {}),
        ...(ward.decree !== undefined ? { decree: ward.decree } : {}),
      };
    }),
    skipDuplicates: true,
  });

  // Bổ sung level và decree cho các xã/phường đã tồn tại từ trước mà chưa có metadata, giữ nguyên name
  const wardsMissingMeta = data.wards.some((ward) =>
    Boolean(ward.level || ward.decree),
  )
    ? await tx.ward.findMany({
        where: {
          code: { in: data.wards.map((ward) => ward.code) },
          level: null,
        },
        select: { code: true },
      })
    : [];
  if (wardsMissingMeta.length > 0) {
    const wardByCode = new Map(data.wards.map((ward) => [ward.code, ward]));
    for (const { code } of wardsMissingMeta) {
      const ward = wardByCode.get(code);
      if (ward && (ward.level || ward.decree)) {
        await tx.ward.update({
          where: { code },
          data: {
            level: ward.level ?? null,
            decree: ward.decree ?? null,
          },
        });
      }
    }
  }

  const vehicleTypes = await tx.vehicleType.createMany({
    data: data.vehicleTypes,
    skipDuplicates: true,
  });
  const amenities = await tx.amenity.createMany({
    data: data.amenities.map(({ code, name }) => ({ code, name })),
    skipDuplicates: true,
  });

  let stopPoints = 0;
  const skippedStopPoints: string[] = [];
  for (const sample of data.sampleStopPoints) {
    const ward = await tx.ward.findFirst({
      where: {
        province: { code: sample.provinceCode },
        name: { equals: sample.wardName, mode: "insensitive" },
      },
      select: { id: true, provinceId: true },
    });
    if (!ward) {
      skippedStopPoints.push(sample.name);
      continue;
    }
    // Bến xe chuẩn không có `code`: coi (tên, tỉnh) là khoá create-only của dữ liệu mẫu.
    const existing = await tx.stopPointCatalog.findFirst({
      where: { name: sample.name, provinceId: ward.provinceId },
      select: { id: true },
    });
    if (existing) {
      continue;
    }
    await tx.stopPointCatalog.create({
      data: {
        name: sample.name,
        type: sample.type,
        address: sample.address,
        provinceId: ward.provinceId,
        wardId: ward.id,
        latitude: sample.latitude,
        longitude: sample.longitude,
        description: SAMPLE_DESCRIPTION,
        // Dữ liệu mẫu dev: căn cứ giả lập (DB §7) — bến xe / điểm dừng đón trả bắt buộc có căn cứ.
        legalBasis: SAMPLE_LEGAL_BASIS,
      },
    });
    stopPoints++;
  }

  return {
    provinces: provinces.count,
    wards: wards.count,
    vehicleTypes: vehicleTypes.count,
    amenities: amenities.count,
    stopPoints,
    skippedStopPoints,
  };
}
