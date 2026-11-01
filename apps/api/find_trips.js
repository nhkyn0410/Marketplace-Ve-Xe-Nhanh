const { Pool } = require("pg");
const pool = new Pool({ connectionString: "postgresql://vexenhanh:vexenhanh_dev@localhost:5432/vexenhanh_dev" });

async function run() {
  const trips = await pool.query(`
    SELECT t.id, t.departure_at, t.online_sale_cutoff_minutes, t.status, r.name as route_name
    FROM trips t
    JOIN routes r ON t.route_id = r.id
    WHERE t.departure_at >= '2026-11-01T02:00:00Z'
      AND t.departure_at <= '2026-11-01T04:00:00Z'
    ORDER BY t.departure_at ASC
  `);
  console.log("Trips 9h-11h:", JSON.stringify(trips.rows, null, 2));
  await pool.end();
}

run().catch(console.error);
