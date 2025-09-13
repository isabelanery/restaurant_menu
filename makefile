
install:
	bundle install

server:
	bin/rails db:create db:migrate db:seed
	bin/rails s
