
install:
	bundle install

server:
	bin/rails db:create db:migrate db:seed
	bin/rails s

test:
	bundle install
	bin/rails RAILS_ENV=test db:create db:migrate
	rspec
