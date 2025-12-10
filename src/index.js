import dotenv from "dotenv";
import express from "express";
import searchRoutes from "./routes/searchRoutes.js";
import { connectDB } from "./config/db.js";

dotenv.config();

const app = express();
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Testing the server!!");
});
app.use("/search", searchRoutes);

app.use((err, req, res, _next) => {
  console.error(err);
  res.status(500).json({ message: "Internal server error" });
});

const PORT = Number(process.env.PORT || 3000);

async function start() {
  try {
    await connectDB();
    app.listen(PORT, () => {
      console.log(`Server listening on port ${PORT}`);
    });
  } catch (err) {
    console.error("Failed to start server:", err);
    process.exit(1);
  }
}

start();

