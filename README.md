# Restaurant Search Service

A Node.js + MySQL REST API service for searching restaurants by dish name with price range filtering. Returns restaurants ranked by order count for the specified dish.

## Features

- **Single Search Endpoint**: Search restaurants by dish name with mandatory price range filter
- **Ranked Results**: Returns top 10 restaurants ordered by order count (popularity)
- **Case-Insensitive Search**: Partial matching on dish names
- **Price Range Filtering**: Mandatory min/max price parameters
- **MVC Architecture**: Clean separation of routes, controllers, and services
- **Error Handling**: Comprehensive validation and error responses

## Tech Stack

- **Runtime**: Node.js 18+ (ES modules)
- **Framework**: Express.js 4.19.2
- **Database**: MySQL (mysql2 3.10.0)
- **Configuration**: dotenv 16.4.5
- **Development**: nodemon 3.1.11

## Project Structure

```
restaurant-search/
├── src/
│   ├── config/
│   │   └── db.js              # Database connection and pool configuration
│   ├── controllers/
│   │   └── dishController.js # Request handling and validation
│   ├── routes/
│   │   └── searchRoutes.js   # Route definitions
│   ├── services/
│   │   └── dishService.js    # Business logic and database queries
│   └── index.js              # Application entry point
├── seeds/
│   └── seed.sql              # Database schema and sample data
├── env.example               # Environment variables template
├── package.json
└── README.md
```

## Database Schema

The application uses three main tables:

- **restaurants**: Restaurant information (id, name, city)
- **menu_items**: Menu items with prices (id, restaurant_id, name, price)
- **orders**: Order history (id, menu_item_id, created_at)

Relationships:
- `menu_items.restaurant_id` → `restaurants.id`
- `orders.menu_item_id` → `menu_items.id`

## Getting Started

### Prerequisites

- Node.js 18 or higher
- MySQL 5.7+ or MySQL 8.0+
- npm or yarn

### Installation

1. **Clone the repository** (or navigate to the project directory)

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Set up the database**:
   ```bash
   mysql -u <user> -p < seeds/seed.sql
   ```
   This will:
   - Create the `restaurant_search` database
   - Create all necessary tables
   - Insert sample data (10 restaurants, 12 menu items, 66 orders)

4. **Configure environment variables**:
   
   Create a `.env` file in the project root (copy from `env.example`):
   ```env
   PORT=3000
   MYSQLHOST=localhost
   MYSQLPORT=3306
   MYSQLUSER=root
   MYSQLPASSWORD=yourpassword
   MYSQLDATABASE=restaurant_search
   ```

5. **Start the server**:
   ```bash
   npm start
   ```
   
   For development with auto-reload:
   ```bash
   npm run dev
   ```

6. **Verify the server is running**:
   - Visit `http://localhost:3000/` - should return "Testing the server!!"
   - Server logs should show: "Connected to database!" and "Server listening on port 3000"

## API Documentation

### Base URL

```
http://localhost:3000
```

### Endpoints

#### 1. Health Check

**GET** `/`

Returns a simple test message.

**Response:**
```
Testing the server!!
```

#### 2. Search Dishes

**GET** `/search/dishes`

Search for restaurants that serve a specific dish within a price range, ranked by order count.

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `name` | string | Yes | Dish name (partial match, case-insensitive) |
| `minPrice` | number | Yes | Minimum price (inclusive) |
| `maxPrice` | number | Yes | Maximum price (inclusive) |

**Validation Rules:**
- `name` must be provided and non-empty (after trimming)
- `minPrice` and `maxPrice` must be valid numbers
- `minPrice` must be less than or equal to `maxPrice`

**Example Request:**
```bash
GET /search/dishes?name=biryani&minPrice=150&maxPrice=300
```

**Success Response (200 OK):**
```json
{
  "restaurants": [
    {
      "restaurantId": 1,
      "restaurantName": "Hyderabadi Spice House",
      "city": "Hyderabad",
      "dishName": "Chicken Biryani",
      "dishPrice": 220,
      "orderCount": 20
    },
    {
      "restaurantId": 2,
      "restaurantName": "Biryani Palace",
      "city": "Bengaluru",
      "dishName": "Chicken Biryani",
      "dishPrice": 200,
      "orderCount": 8
    }
  ]
}
```

**Response Fields:**
- `restaurantId`: Unique restaurant identifier
- `restaurantName`: Name of the restaurant
- `city`: City where the restaurant is located
- `dishName`: Name of the dish matching the search
- `dishPrice`: Price of the dish
- `orderCount`: Number of orders for this dish (used for ranking)

**Error Responses:**

**400 Bad Request** - Missing or invalid parameters:
```json
{
  "message": "Query param 'name' is required"
}
```

```json
{
  "message": "Query params 'minPrice' and 'maxPrice' must be numbers"
}
```

```json
{
  "message": "'minPrice' must be less than or equal to 'maxPrice'"
}
```

**404 Not Found** - No restaurants found:
```json
{
  "message": "No restaurants found for given dish and price range",
  "restaurants": []
}
```

**500 Internal Server Error**:
```json
{
  "message": "Internal server error"
}
```

## How It Works

1. **Request Validation**: The controller validates all query parameters
2. **Database Query**: The service performs a SQL query that:
   - Joins `menu_items` with `restaurants` and `orders`
   - Filters by dish name (case-insensitive LIKE) and price range
   - Groups by restaurant and menu item
   - Counts orders for ranking
   - Orders by order count (descending)
   - Limits to top 10 results
3. **Response**: Returns ranked list of restaurants

## Sample Data

The seed file includes:
- **10 Restaurants** across different cities (Hyderabad, Bengaluru, Chennai, Delhi, Lucknow, Mumbai, Goa, Kolkata)
- **12 Menu Items** (various biryani dishes with different prices)
- **66 Orders** distributed across menu items

## Deployment

### Environment Variables for Production

When deploying to platforms like Render, Railway, or Heroku, set these environment variables:

```env
PORT=3000                    # Or use platform-assigned port
MYSQLHOST=your-db-host       # Database host
MYSQLPORT=3306               # Database port
MYSQLUSER=your-db-user      # Database username
MYSQLPASSWORD=your-password # Database password
MYSQLDATABASE=restaurant_search # Database name
```

### Platform-Specific Notes

- **Render**: Use managed MySQL database service and connect via provided connection string variables
- **Railway**: MySQL service automatically provides `MYSQL*` environment variables
- **Heroku**: Use Heroku Postgres or JawsDB MySQL addon

## Development

### Available Scripts

- `npm start` - Start the production server
- `npm run dev` - Start development server with nodemon (auto-reload)
- `npm run lint` - Run linter (currently not configured)

### Database Connection

The application uses a connection pool with:
- Maximum 10 concurrent connections
- Automatic connection management
- Error handling and reconnection

## Notes

- Each order represents a single menu item (simplified model)
- Search is case-insensitive and supports partial matching
- Results are limited to top 10 restaurants by order count
- All error responses follow a consistent JSON format with a `message` field
- The application uses ES modules (`type: "module"` in package.json)

## License

This project is provided as-is for educational/demonstration purposes.
