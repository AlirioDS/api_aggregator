# README

### Setup
```bash
  git clone git@github.com:AlirioDS/api_aggregator.git
  cd api_aggregator
  cp .env.example .env
  docker compose -f docker-compose.development.yml up --build
```

The app runs on localhost:3001

Tests

```bash
docker compose -f docker-compose.development.yml exec rails-api bundle exec rspec
```