
# pull_zephir_updates
script for pulling updates from zephir so they can be indexed into catalog search

## To Start Development

clone and cd into the repository
```
git clone git@github.com:mlibrary/pull_zephir_updates.git
cd pull_zephir_updates
```

copy .env-example to .env
```
cp .env-example .env
```

build the images
```
docker-compose build
```

install the gems
```
docker-compose run --rm web bundle
```

start up the mock http server
```
docker-compose up -d
```

run the script to download a file from the fake http server and move it to the ./tmp directory

```
docker-compose run --rm web bundle exec pull_latest_zephir_update.rb
```

