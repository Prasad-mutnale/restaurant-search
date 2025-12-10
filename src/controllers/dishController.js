import { searchDishes } from "../services/dishService.js";

export async function getDishSearch(req, res, next) {
  try {
    const { name, minPrice, maxPrice } = req.query;

    if (!name || !name.trim()) {
      res.status(400).json({ message: "Query param 'name' is required" });
      return;
    }

    const min = Number(minPrice);
    const max = Number(maxPrice);

    if (Number.isNaN(min) || Number.isNaN(max)) {
      res.status(400).json({ message: "Query params 'minPrice' and 'maxPrice' must be numbers" });
      return;
    }

    if (min > max) {
      res.status(400).json({ message: "'minPrice' must be less than or equal to 'maxPrice'" });
      return;
    }

    const restaurants = await searchDishes({
      name: name.trim(),
      minPrice: min,
      maxPrice: max,
      limit: 10
    });

    if (!restaurants || restaurants.length === 0) {
      res.status(404).json({ message: "No restaurants found for given dish and price range", restaurants: [] });
      return;
    }

    res.json({ restaurants });
  } catch (err) {
    next(err);
  }
}

