FROM ghcr.io/gleam-lang/gleam:v1.0-erlang-alpine

WORKDIR /app

# Copy manifest first for caching
COPY gleam.toml manifest.toml ./
RUN gleam deps download

# Copy source
COPY . .
RUN gleam build

EXPOSE 8080

CMD ["gleam", "run"]
