#!/bin/bash
set -e

# Initialize MySQL data directory if needed
if [ ! -d /var/lib/mysql/mysql ]; then
  echo "Initializing MySQL data directory..."
  mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
fi

# Start MySQL service
echo "Starting MySQL..."
service mysql start

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
until mysqladmin ping -h localhost --silent; do
  sleep 2
done
echo "MySQL is ready!"

# Set MySQL root password from environment or use default
MYSQL_ROOT_PASSWORD=${MYSQLPASSWORD:-rootpassword}

# Configure MySQL root user (try without password first, then with password)
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';" 2>/dev/null || \
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';" 2>/dev/null || true

mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';" 2>/dev/null || \
mysql -uroot -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';" 2>/dev/null || true

mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;" 2>/dev/null || \
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;" 2>/dev/null || true

mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;" 2>/dev/null || \
mysql -uroot -e "FLUSH PRIVILEGES;" 2>/dev/null || true

# Get database name from environment or use default
MYSQL_DATABASE_NAME=${MYSQLDATABASE:-restaurant_search}

# Create database if it doesn't exist
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE_NAME};" 2>/dev/null || \
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE_NAME};" 2>/dev/null || true

# Check if tables exist, if not run seed file
TABLE_COUNT=$(mysql -uroot -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE_NAME} -e "SHOW TABLES;" 2>/dev/null | wc -l || \
              mysql -uroot ${MYSQL_DATABASE_NAME} -e "SHOW TABLES;" 2>/dev/null | wc -l || echo "0")

if [ "$TABLE_COUNT" -lt 2 ] && [ -f /app/seeds/seed.sql ]; then
  echo "Initializing database with seed data..."
  mysql -uroot -p${MYSQL_ROOT_PASSWORD} < /app/seeds/seed.sql 2>/dev/null || \
  mysql -uroot < /app/seeds/seed.sql 2>/dev/null || true
  echo "Database initialized!"
fi

# Set environment variables for the app
export MYSQLHOST=localhost
export MYSQLPORT=3306
export MYSQLUSER=root
export MYSQLPASSWORD=${MYSQL_ROOT_PASSWORD}
export MYSQLDATABASE=${MYSQL_DATABASE_NAME}

# Start the Node.js application
echo "Starting Node.js application..."
exec node src/index.js

