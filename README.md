# Restaurant Menu API

A Ruby on Rails API for managing restaurant menus and their items.

## Prerequisites

- Ruby 3.3.2
- Rails 8.0.2.1
- SQLite3
- Bundler

## Setup and Running Locally

1. Clone the repository:

   ```bash
   git clone https://github.com/isabelanery/restaurant_menu.git
   cd restaurant_menu
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Set up the database:

   ```bash
   rails db:migrate
   ```

4. Start the server:

   ```bash
   rails server
   ```

5. Access the API at `http://localhost:3000`. Example endpoints:

   - `GET /api/menus` - List all menus
   - `GET /api/menus/:menu_id` - Get a specific menu with items
   - `GET /api/menus/:menu_id/menu_items` - List items for a menu
   - `GET /api/menus/:menu_id/menu_items/:id` - Get a specific menu item

## Running Tests

1. Ensure test dependencies are installed:

   ```bash
   bundle install
   ```

2. Run the test suite:

   ```bash
   rspec
   ```
