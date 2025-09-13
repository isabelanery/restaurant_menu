# Restaurant Menu API

A Ruby on Rails API for managing restaurants, their menus, and menu items. Supports multiple menus per restaurant with unique menu item names and shared items across menus.

## Prerequisites

- Ruby 3.3.2
- Rails 8.0.2.1
- SQLite3
- Bundler

## Setup and Running Locally

You can set up and run the application using either the `Makefile` commands or the step-by-step manual process.

1. Clone the repository:

   ```bash
   git clone https://github.com/isabelanery/restaurant_menu.git
   cd restaurant_menu
   ```

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

5. Access the API at `http://localhost:3000`. Example endpoints:

   - `GET /api/restaurants` - List all restaurants
   - `GET /api/restaurants/:restaurant_id` - Get a specific restaurant with its menus
   - `GET /api/restaurants/:restaurant_id/menus` - List all menus for a restaurant
   - `GET /api/restaurants/:restaurant_id/menus/:menu_id` - Get a specific menu of a restaurant with its items
   - `GET /api/menu_items` - List all menu items
   - `GET /api/menu_items/:id` - Get a specific menu item

## Running Tests

You can run tests using either the `Makefile` or the manual process.

### Option 1: Using Makefile

1. Run the test suite:
   ```bash
   make test
   ```

### Option 2: Manual Process

1. Ensure test dependencies are installed:
   ```bash
   bundle install
   ```

2. Set up the test database:
   ```bash
   rails RAILS_ENV=test db:migrate
   ```

3. Run the test suite:
   ```bash
   rspec
   ```
