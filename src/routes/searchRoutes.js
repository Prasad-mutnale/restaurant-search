import express from "express";
import { getDishSearch } from "../controllers/dishController.js";

const router = express.Router();

router.get("/dishes", getDishSearch);

export default router;

