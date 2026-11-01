const { PrismaPg } = require("@prisma/adapter-pg");
const { PrismaClient } = require("./dist/generated/prisma/client");
const connectionString = "postgresql://vexenhanh:vexenhanh_dev@localhost:5432/vexenhanh_dev?schema=public";
const p = new PrismaClient({ adapter: new PrismaPg({ connectionString }) });
async function main() {
  const records = await p.verification.findMany({
    orderBy: { createdAt: 'desc' },
    take: 5
  });
  console.log("VERIFICATIONS:", JSON.stringify(records, null, 2));
  process.exit(0);
}
main();
