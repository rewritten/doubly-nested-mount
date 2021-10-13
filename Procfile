gateway: bundle exec puma --pidfile tmp/pids/gateway.pid -p 9292 gateway.ru
app: RAILS_RELATIVE_URL_ROOT=/gateway/my-app bundle exec rails s
naked_app: bundle exec rails s -p 5555 --pid tmp/pids/naked.pid
