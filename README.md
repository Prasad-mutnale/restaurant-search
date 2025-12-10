# Restaurant Search Service

Node + MySQL backend (MVC-style: routes → controllers → services) to search restaurants by dish name with a mandatory price range filter. Returns the top restaurants where the dish is ordered most often.

## Features
- Single endpoint: `GET /search/dishes?name={dish}&minPrice={min}&maxPrice={max}`
- Filters by dish name (partial, case-insensitive) and required price range.
- Returns top 10 restaurants ordered by order count for that dish.

## Tech
- Node 18+ (ES modules)
- Express
- MySQL (mysql2)
- Dotenv for configuration

## Getting Started
1. Install dependencies:
   - `npm install`
2. Create a MySQL database with the seed data:
   - `mysql -u <user> -p < seeds/seed.sql`
3. Configure environment variables (`.env` at project root):
   ```
   PORT=3000
   DB_HOST=localhost
   DB_PORT=3306
   DB_USER=root
   DB_PASSWORD=yourpassword
   DB_NAME=restaurant_search
   ```
4. Run the server:
   - `node src/server.js`

## API
`GET /search/dishes`

Query params:
- `name` (string, required): dish name (partial match).
- `minPrice` (number, required)
- `maxPrice` (number, required)

Example:
```
/search/dishes?name=biryani&minPrice=150&maxPrice=300
```

Response:
```json
{
  "restaurants": [
    {
      "restaurantId": 5,
      "restaurantName": "Hyderabadi Spice House",
      "city": "Hyderabad",
      "dishName": "Chicken Biryani",
      "dishPrice": 220,
      "orderCount": 96
    }
  ]
}
```

## Deploying
- Works on free hosts like Railway/Render. Provide env vars above.
- Ensure MySQL is reachable from the host or use the platform’s managed MySQL.

## Notes
- Each order is a single menu item for simplicity.
- Error responses are JSON with a `message` field.

