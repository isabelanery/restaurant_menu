# Restaurant Menu API

A Ruby on Rails API for managing restaurants, their menus, and menu items. Supports multiple menus per restaurant with unique menu item names, shared items across menus, and JSON data import functionality.

## Prerequisites

- Ruby 3.3.2
- Rails 8.0.2.1
- SQLite3
- Bundler

## Setup and Running Locally

You can set up and run the application using either the `Makefile` commands or the step-by-step manual process.

1. Clone the repository using one of the following methods:

   - **Using HTTPS**:

     ```bash
     git clone https://github.com/isabelanery/restaurant_menu.git
     cd restaurant_menu
     ```

   - **Using SSH** (requires SSH key configured with GitHub):

     ```bash
     git clone git@github.com:isabelanery/restaurant_menu.git
     cd restaurant_menu
     ```
     *Note*: Ensure your SSH key is added to your GitHub account. See [GitHub's SSH setup guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) for details.

### Option 1: Using Makefile

2. Install dependencies:

   ```bash
   make install
   ```

3. Set up the database and start the server:

   ```bash
   make server
   ```

### Option 2: Manual Setup

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Set up the database:

   ```bash
   rails db:create db:migrate db:seed
   ```

4. Start the server:

   ```bash
   rails server
   ```

### Access the API at `http://localhost:3000`. Example endpoints:

   - `GET /api/restaurants` - List all restaurants
   - `GET /api/restaurants/:restaurant_id` - Get a specific restaurant with its menus
   - `GET /api/restaurants/:restaurant_id/menus` - List all menus for a restaurant
   - `GET /api/restaurants/:restaurant_id/menus/:menu_id` - Get a specific menu of a restaurant with its items
   - `GET /api/menu_items` - List all menu items
   - `GET /api/menu_items/:id` - Get a specific menu item
   - `POST /api/import_restaurants` - Import restaurant data from a JSON payload

## Importing Restaurant Data

The API supports importing restaurant data (including menus and menu items) from a JSON file or payload. This can be done via an HTTP endpoint or a rake task.

### Option 1: Using the HTTP Endpoint

- **Endpoint**: `POST /api/import_restaurants`
- **Description**: Accepts a JSON payload containing restaurant data and persists it to the database. The endpoint validates the JSON structure, ensures no duplicate menu item names, and logs the import process.
- **Request Body**: A JSON object matching the structure of `restaurant_data.json` (e.g., containing restaurants, menus, and menu items).
- **Response**: Returns a JSON object with a `success` boolean indicating whether the import was successful and a `logs` array containing details for each menu item processed (e.g., success or failure messages).
- **Example Request**:
   - Ensure the `restaurant_data.json` file is in the project root directory.
   - Make sure the Rails server is running. Start it with:

      ```bash
      make server
      ```

  ```bash
  curl -X POST http://localhost:3000/api/import_restaurants \
  -H "Content-Type: application/json" \
  -d @restaurant_data.json
  ```

- **Example Response**:

  ```json
  {
    "success": true,
    "logs": [
      "Processing restaurant: Example Restaurant",
      "  Processing menu: Lunch",
      "    Imported item 'Burger' (price: 9.0) to menu 'Lunch' - success",
   ]
  }
  ```

### Option 2: Using the Rake Task

- **Command**: `rake 'import:json[restaurant_data.json]'` or `make import`
- **Description**: Imports restaurant data from a specified JSON file (e.g., `restaurant_data.json`) into the database. The task processes the JSON, validates the data, ensures no duplicate menu item names, and logs the import process.
- **Running the Rake Task**: You can set up and run the rake task using either the `Makefile` commands or the step-by-step manual process.

  - Using Makefile:

    ```bash
    make import
    ```

   - **Manual Import**
      - Ensure the JSON file (e.g., `restaurant_data.json`) is in the project root or provide the correct path.
      - Make sure the database is set up. If you haven't already created and migrated the database, run:

         ```bash
         bin/rails db:create db:migrate
         ```

   - Run the task:

      ```bash
      rake 'import:json[restaurant_data.json]'
      ```

- **Output**: The task outputs logs to the console for each menu item processed, indicating success or failure, and a final summary of the import result (success or failure).

- **Example Output**:

  ```
  Processing restaurant: Example Restaurant
     Processing menu: Lunch
        Imported item 'Burger' (price: 9.0) to menu 'Lunch' - success
  ```

- **Notes**:
  - The JSON file must follow the expected structure (e.g., as in `restaurant_data.json`).
  - Logs are generated for each menu item, and errors (e.g., duplicate names) are handled gracefully without stopping the import process.
  - The import ensures data consistency, such as unique menu item names within the database.

## Running Tests

You can run tests using either the `Makefile` or the manual process.

### Option 1: Using Makefile

1. Run the test suite:

   ```bash
   make test
   ```

2. Run the test suite with coverage report:

   ```bash
   make test_coverage
   ```

### Option 2: Manual Process

1. Ensure test dependencies are installed:

   ```bash
   bundle install
   ```

2. Set up the test database:

   ```bash
   rails RAILS_ENV=test db:create db:migrate
   ```

3. Run the test suite:

   ```bash
   rspec
   ```

4. Run the test suite with coverage:

   ```bash
   COVERAGE=true rspec
   ```

## Directory Structure

The project adheres to a standard Ruby on Rails directory structure, enhanced with conventions for clarity and modularity. Below is a detailed breakdown of key directories and their purposes:

| Directory         | Purpose                                                                 |
|-------------------|-------------------------------------------------------------------------|
| `app/`            | Core application code, organized to enforce separation of concerns.      |
| `app/controllers/`| Handles HTTP requests and defines API endpoints (e.g., `RestaurantsController`). |
| `app/models/`     | Defines database entities (e.g., `Restaurant`, `Menu`) with ActiveRecord validations. |
| `app/services/`   | Manages complex business logic, such as JSON import processing, to keep controllers and models lightweight. |
| `app/blueprints/` | Serializes data for JSON responses using the Blueprinter gem, ensuring consistent output. |
| `app/jobs/`       | Reserved for future background tasks using ActiveJob (currently unused). |
| `app/mailers/`    | Reserved for future email-sending logic (currently unused).              |
| `config/`         | Configures application settings, including `routes.rb`, database, and initializers. |
| `db/`             | Manages database-related files for SQLite, including migrations, `seeds.rb`, and `schema.rb`. |
| `db/migrations/`  | Defines database schema changes.                                        |
| `db/seeds.rb`     | Populates the database with initial or test data.                       |
| `db/schema.rb`    | Represents the current database schema.                                 |
| `spec/`           | Contains RSpec tests mirroring the `app/` structure for unit, integration, and system testing. |
| `lib/`            | Stores reusable utility code and modules for shared logic.              |
| `public/`         | Stores static assets served directly by the web server (e.g., error pages).  |
| `storage/`        | Manages file uploads and persistent storage.                           |
| `tmp/`            | Holds temporary files generated during runtime.                        |
| `log/`            | Contains application logs for debugging and monitoring.                |
| `bin/`            | Includes executable scripts for Rails tasks (e.g., `bin/rails`, `bin/setup`). |
| `Makefile`        | Defines shortcuts for common tasks (e.g., `make server`, `make test`) to enhance productivity. |
