project=$(shell basename $(shell pwd))

in:
	@docker exec --user=php -it "$(project)-php-fpm-1" /bin/sh

in-root:
	docker exec --user=root -it "$(project)-php-fpm-1" /bin/sh

up:
	@docker-compose up -d

down:
	@docker-compose down

refresh:
	@docker-compose down -v
	@docker-compose up -d

build:
	@docker-compose build
	@docker-compose up -d

rebuild:
	@docker-compose down
	@docker-compose build
	@docker-compose up -d

tail:
	@docker compose logs --follow

install:
	@cp .env.example .env
	@cp .env.testing.example .env.testing
	@composer install
	@php artisan key:generate
	@chown -R www-data:www-data /var/www/html/public
	@chmod o+w ./storage/ -R

permissions:
	@chown -R www-data:www-data /var/www/html/public
	@chmod o+w ./storage/ -R

md:
	@./vendor/bin/phpmd app,database,routes ansi phpmd.xml

stan:
	./vendor/bin/phpstan analyse --memory-limit=500M

cs-fixer:
	 ./vendor/bin/phpcbf

cs:
	./vendor/bin/phpcs

optimize:
	php artisan optimize
	php artisan config:clear
	php artisan cache:clear
	phh artisan route:clear

db.backup:
	docker exec elastic-mysql-1 sh -c "mysqldump -u root -p\$$MYSQL_ROOT_PASSWORD \$$MYSQL_DATABASE" > backup.sql

db.restore:
	cat backup.sql | docker exec -i elastic-mysql-1 sh -c "mysql -u root -p\$$MYSQL_ROOT_PASSWORD \$$MYSQL_DATABASE"
