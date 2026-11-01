const { Pool } = require("pg");
const pool = new Pool({ connectionString: "postgresql://vexenhanh:vexenhanh_dev@localhost:5432/vexenhanh_dev" });

async function run() {
  const res = await pool.query(`
    SELECT t.id, t.departure_at, r.origin_city, r.dest_city, o.name as operator_name
    FROM trips t
    JOIN routes r ON t.route_id = r.id
    JOIN operators o ON t.operator_id = o.id
    WHERE t.status = 'SCHEDULED'
    ORDER BY t.departure_at ASC
    LIMIT 20
  `);
  console.log(JSON.stringify(res.rows, null, 2));
  await pool.end();
}

run().catch(console.error);
