web: bundle exec rails server -p $PORT
resque: bundle exec rake resque:work QUEUE='*'
private_pub: bundle exec rackup private_pub.ru -s thin -E production
