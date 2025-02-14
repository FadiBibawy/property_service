# Property Service API

## Overview

The Property Service API is a RESTful web service designed to help real estate agents quickly retrieve nearby properties along with their prices and addresses. Given the latitude, longitude, property type, and marketing type, the API returns a list of properties within a 5-kilometer radius. This service leverages PostgreSQL’s geospatial capabilities to perform fast and efficient location-based queries.

## Technologies Used

- **Ruby on Rails (API mode):** Provides a structured, maintainable, and efficient framework for building RESTful APIs.
- **PostgreSQL:** Serves as the database engine, utilizing extensions like `cube` and `earthdistance` for geospatial calculations.
- **ActiveRecord:** Rails' ORM for interacting with the database.
- **RSpec:** For testing the API endpoints and ensuring reliability.
- **psql:** PostgreSQL’s interactive terminal to manage the database and load data dumps.

## Setup Instructions

### Prerequisites

- Ruby (3.4.1)
- Rails (8.0.1)
- PostgreSQL (17.2)
- Bundler (2.6.2)

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/property_service.git
cd property_service
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Database Configuration

Edit the `config/database.yml` file to match your PostgreSQL credentials. For example:

```yaml
development:
  adapter: postgresql
  encoding: unicode
  database: property_service_development
  pool: 5
  username: personalfadi

test:
  adapter: postgresql
  encoding: unicode
  database: property_service_test
  pool: 5
  username: personalfadi
```

### 4. Create and Migrate the Database

```bash
rails db:create
rails db:migrate
```

### 5. Load the Data

The service uses a legacy SQL dump (found at db/properties.sql). 
Important: Since Rails manages the schema, it’s best to import only the data portion.

If your Rails migration has added created_at and updated_at columns with NOT NULL constraints, you might need to temporarily allow nulls:

```bash
psql -U personalfadi -d property_service_development -c "ALTER TABLE properties ALTER COLUMN created_at DROP NOT NULL, ALTER COLUMN updated_at DROP NOT NULL;"
```

Then, load the data:

```bash
psql -U personalfadi -d property_service_development -f /Users/personalfadi/Documents/github/property_service/db/properties_data.sql
```

After the import, you can update the timestamps if needed:

```bash
psql -U personalfadi -d property_service_development -c "UPDATE properties SET created_at = CURRENT_TIMESTAMP WHERE created_at IS NULL;"
psql -U personalfadi -d property_service_development -c "UPDATE properties SET updated_at = CURRENT_TIMESTAMP WHERE updated_at IS NULL;"
```

### 6. Enable Geospatial Extensions

Ensure your database has the required PostgreSQL extensions:

```bash
psql -U personalfadi -d property_service_development -c "CREATE EXTENSION IF NOT EXISTS cube;"
psql -U personalfadi -d property_service_development -c "CREATE EXTENSION IF NOT EXISTS earthdistance;"
```

### 7. Run the Server

```bash
rails server
```

Your API will now be available at http://localhost:3000.

### 8.Testing

Tests are written using RSpec. To run the test suite, execute:

```bash
bundle exec rspec
```

### 9. Example on API Usage

GET /properties
Retrieve a list of properties filtered by location and property details.

Required Query Parameters
  - lat: Latitude (e.g., 52.5342963)
  - lng: Longitude (e.g., 13.4236807)
  - property_type: apartment or single_family_house
  - marketing_type: rent or sell

Example Request

```bash
curl "http://localhost:3000/properties?lat=52.5342963&lng=13.4236807&property_type=apartment&marketing_type=sell"
```

https://github.com/user-attachments/assets/7b03a3df-b0fd-407c-83cf-dbcb6b90a5be
