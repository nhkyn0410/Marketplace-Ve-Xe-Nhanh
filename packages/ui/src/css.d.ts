// Cho phép `import "….css"` trong package này (file CSS của thư viện bản đồ). App Next đã có khai báo tương tự
// qua `next-env.d.ts`; ở đây cần riêng vì package tự typecheck.
declare module "*.css";
