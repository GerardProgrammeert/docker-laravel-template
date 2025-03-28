project=$(shell basename $(shell pwd))

in:
	docker exec -it "$(project)-php-fpm-1" /bin/bash

up:
	docker-compose up -d

down:
	docker-compose down

refresh:
	docker-compose down -v
	docker-compose up -d

rebuild:
	docker-compose down
	docker-compose build
	docker-compose up -d

tail:
	@docker compose logs --follow

install-laravel:
	composer create-project laravel/laravel
	mv laravel/* laravel/.* .
	rm -d laravel

laravel-chmod:
	@chmod o+w ./storage/ -R

git-rm-untracked:
	git clean -fd
	git clean -fx
	rm -rf vendor public bootstrap
	rm -f composer.json composer.lock
set-permission:
	sudo find . -type f -exec chmod 644 {} \; && \
	sudo find . -type d -exec chmod 755 {} \; && \
	sudo chmod -R 777 ./storage && \
	sudo chmod -R 777 ./bootstrap/cache

md:
	./vendor/bin/phpmd app,database,routes ansi phpmd.xml

stan:
	./vendor/bin/phpstan analyse --memory-limit=500M

cs-fixer:
	 ./vendor/bin/phpcbf

cs:
	./vendor/bin/phpcs
