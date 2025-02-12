set dotenv-load

process: build
	node -r dotenv/config lib/processor.js

serve:
	@npx squid-graphql-server

up *FLAGS:
  docker compose up {{FLAGS}}

upd:
	@just up -d

pull:
  docker compose pull

clear:
  docker compose rm -f
  rm -rf .data

down:
  docker compose down

build:
	npm run build

codegen:
	npx squid-typeorm-codegen

typegen: ksmVersion
	npx squid-substrate-typegen typegen.json

ksmVersion: explore

explore:
	npx squid-substrate-metadata-explorer \
		--archive $ARCHIVE_URL \
		--out kusamaVersions.jsonl

bug: down upd

reset: migrate

quickstart: migrate process

quick: build reset process

db: update-db migrate

prod TAG:
	gh pr create --base release-{{TAG}}

migrate:
	npx squid-typeorm-migration apply

update-db:
	npx squid-typeorm-migration generate

test:
  npm run test:unit

improve TAG:
	npx sqd squid:update snekk@{{TAG}} -e VERSION={{TAG}}

release TAG:
	npx sqd squid:release snekk@{{TAG}}

kill TAG:
	npx sqd squid:kill snekk@{{TAG}}

exec:
	docker exec -it snek-db-1 psql -U postgres -d squid

brutal TAG:
	npx sqd squid:update snekk@{{TAG}} --hardReset -e VERSION={{TAG}}

update-deps:
	npx npm-check-updates -u

tail TAG:
	npx sqd squid logs snekk@{{TAG}} -f

where-chain:
	echo "https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Fbasilisk-kodadot.hydration.cloud#/explorer" | pbcopy
