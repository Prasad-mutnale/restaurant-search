import { query } from "../config/db.js";

export async function searchDishes({ name, minPrice, maxPrice, limit = 10 }) {
  const likeTerm = `%${name.toLowerCase()}%`;

  const sql = `
    SELECT
      r.id AS restaurantId,
      r.name AS restaurantName,
      r.city,
      mi.name AS dishName,
      mi.price AS dishPrice,
      COUNT(o.id) AS orderCount
    FROM menu_items mi
    INNER JOIN restaurants r ON mi.restaurant_id = r.id
    LEFT JOIN orders o ON o.menu_item_id = mi.id
    WHERE LOWER(mi.name) LIKE ?
      AND mi.price BETWEEN ? AND ?
    GROUP BY r.id, mi.id
    ORDER BY orderCount DESC
    LIMIT ?
  `;

  const [rows] = await query(sql, [likeTerm, minPrice, maxPrice, limit]);
  return rows;
}

