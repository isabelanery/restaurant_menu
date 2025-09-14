
install:
	bundle install

server:
	bin/rails db:create db:migrate db:seed
	bin/rails s

test:
	bundle install
	bin/rails RAILS_ENV=test db:create db:migrate
	rspec

import:
	bin/rails db:create db:migrate db:seed
	rake 'import:json[restaurant_data.json]'
