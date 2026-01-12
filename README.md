# api2spec Gleam Fixture

A sample Gleam API application using Wisp framework for testing api2spec.

## Prerequisites

- Docker and Docker Compose

## Development with Docker

### Build and Run

```bash
# Build and start the application
docker compose up app

# Or run in detached mode
docker compose up -d app
```

The API will be available at `http://localhost:8080`.

### Interactive Development Shell

```bash
# Start an interactive shell with Gleam available
docker compose run --rm dev

# Inside the container, you can run:
gleam build
gleam run
gleam test
```

### Rebuild After Changes

```bash
# Rebuild the image
docker compose build

# Or rebuild and start
docker compose up --build app
```

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/health` | Health check |
| GET | `/health/ready` | Readiness check |
| GET | `/users` | List all users |
| POST | `/users` | Create a user |
| GET | `/users/:id` | Get a user |
| PUT | `/users/:id` | Update a user |
| DELETE | `/users/:id` | Delete a user |
| GET | `/users/:id/posts` | Get user's posts |
| GET | `/posts` | List all posts |
| POST | `/posts` | Create a post |
| GET | `/posts/:id` | Get a post |

## Testing the API

```bash
# Health check
curl http://localhost:8080/health

# List users
curl http://localhost:8080/users

# Get a specific user
curl http://localhost:8080/users/1

# Create a user
curl -X POST http://localhost:8080/users

# Get user posts
curl http://localhost:8080/users/1/posts
```

## Project Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── gleam.toml           # Project configuration
├── manifest.toml        # Dependency lock file
├── README.md
└── src/
    └── api2spec_fixture_gleam.gleam  # Main application
```

## Local Development (without Docker)

If you have Gleam installed locally:

```bash
# Download dependencies
gleam deps download

# Build
gleam build

# Run
gleam run

# Run tests
gleam test
```
