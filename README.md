# Deploying a Rails API with PostgreSQL

This code snippet demonstrates the steps to deploy a Rails API with PostgreSQL.

# Prerequisites:
  - Ruby 3.3.4
  - Rails gem installed
  - PostgreSQL installed and configured

# Steps:
 1. Clone the vacation-api project repository from GitHub.
 2. Install the required gems by running `bundle install` in the project directory.
 3. Copy envirotment variable `cp .env.example .env`
 4. Ensure that the `config/database.yml` can access to the credentials.
 4. Create the database by running `rails db:create`.
 5. Run the database migrations by executing `rails db:migrate`.
 6. Start the Rails server by running `rails s`.
 7. The Rails API with PostgreSQL is now deployed and accessible at the specified host and port.

```bash
  http://localhost:3000
```

 Example:
 ```
 $ git clone https://github.com/AlfredoVillalobos/vacation-api.git
 $ cd vacation-api
 $ bundle install
 $ rails db:create
 $ rails db:migrate
 $ rails s
 ```
