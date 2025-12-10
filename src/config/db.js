import mysql from "mysql2/promise";
import dotenv from "dotenv";
dotenv.config();

const dbConfig = {
  host: process.env.DB_HOST || "localhost",
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "restaurant_search",
  waitForConnections: true,
  connectionLimit: 10
};

const pool = mysql.createPool(dbConfig);

export const query = (sql, params) => pool.query(sql, params);

export async function connectDB() {
  console.log("Connecting to database...");
  try {
    await pool.query("SELECT 1");
    console.log("Connected to database!");
  } catch (err) {
    console.error("Failed to connect to database:", err);
    throw err;
  }
}

export default pool;

