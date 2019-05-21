release: bin/rails db:migrate
web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -c 10 -t 25 -q default
