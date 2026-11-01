const { Pool } = require("pg");
const pool = new Pool({ connectionString: "postgresql://vexenhanh:vexenhanh_dev@localhost:5432/vexenhanh_dev" });

async function run() {
  const c = await pool.query("SELECT column_name FROM information_schema.columns WHERE table_name='routes'");
  console.log("Cols:", c.rows.map(x => x.column_name));
  const r = await pool.query("SELECT * FROM routes LIMIT 1");
  console.log("Sample route:", r.rows[0]);
  await pool.end();
}

run().catch(console.error);
