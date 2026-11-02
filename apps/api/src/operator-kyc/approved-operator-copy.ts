import type { DbTransaction } from "../database/prisma.service";
import { BankAccountStatus } from "../database/prisma.types";

/**
 * Chép dữ liệu của hồ sơ vừa duyệt sang dữ liệu của chính nhà xe (TASK-OPR-001b): thông tin pháp lý / công khai,
 * giấy tờ KYC (cùng khóa object ở kho private) và tài khoản nhận tiền đã xác minh qua bước duyệt. Chạy TRONG transaction
 * duyệt (scope platform) — lỗi thì không duyệt gì.
 */
export async function copyApplicationToOperator(
  tx: DbTransaction,
  applicationId: string,
  operatorId: string,
  reviewer: string,
  approvedAt: Date,
): Promise<void> {
  const application = await tx.operatorApplication.findUniqueOrThrow({
    where: { id: applicationId },
    select: {
      legalName: true,
      taxCode: true,
      hotline: true,
      contactEmail: true,
      address: true,
      description: true,
      bankName: true,
      bankAccountNumber: true,
      bankAccountHolder: true,
      documents: { select: { type: true, objectKey: true, fileName: true, contentType: true, sizeBytes: true, uploadedAt: true } },
    },
  });
  await tx.operatorProfile.update({
    where: { id: operatorId },
    data: {
      legalName: application.legalName,
      taxCode: application.taxCode,
      hotline: application.hotline,
      publicEmail: application.contactEmail,
      address: application.address,
      description: application.description,
      approvedAt,
    },
  });
  if (application.documents.length > 0) {
    await tx.kycDocument.createMany({ data: application.documents.map((document) => ({ ...document, operatorId })) });
  }
  if (application.bankName && application.bankAccountNumber && application.bankAccountHolder) {
    await tx.bankAccount.create({
      data: {
        operatorId,
        bankName: application.bankName,
        accountNumber: application.bankAccountNumber,
        accountHolder: application.bankAccountHolder,
        status: BankAccountStatus.VERIFIED,
        reviewedBy: reviewer,
        reviewedAt: approvedAt,
      },
    });
  }
}
