# README

- You can change the host side ports by editing `.env` file.
 
## First time installation
```shell
cp -p .env.example .env
docker-compose up
docker-compose exec app bundle exec rails db:create 
```

- Open http://localhost:3001/ (Default)
