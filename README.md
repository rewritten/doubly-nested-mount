Rack nested mount issue showcase
================================

Problem statement
-----------------

This repo analyzes following problematic configuration, and the needed fixes
to make it actually work:

- One frontend gateway app that takes paths under /gateway/my_app and proxies to
  a rails app. This app is running on port 9292
- The path is _changed_ when proxying, so rails never gets the original prefix.
- Said rails app, running on port 5100, that has one static page showcasing
  some urls, and mounts sidekiq under `/sidekiq`.
- The same rails app, running on port 5555, is started naked, without any proxy
  configuration.
- Redis should be running (you can use the provided `docker-compose` file).

To run this configuration, uncomment the `env['PATH_INFO'] =` line of the
gateway app (`gateway.ru`) and remove the block that handles app prefix at the
end of rails' own `config.ru`.

The app should be accessible at <http://localhost:9292/gateway/my-app>. One can
see that url generation and sidekiq UI (at <http://localhost:9292/gateway/my-app/sidekiq>)
are broken.

On the other side, the naked application at <http://localhost:5555/> works.

Sidekiq assets could be fixed by patching the `Sidekq::WebHelpers`  module, see
`config/initializers/sidekiq.rb`. But still urls in the rails app won't work.

The problem is due to the fact that rails does not really know what was the
original path, so it has no way to build the correct links.

Solution
--------

The problem is solved by _not modifying the path at all_ in the proxy.

Rails should get the `RAILS_RELATIVE_URL_ROOT` variable and itself route
starting by that point.

With this configuration, both the application _behind the proxy, with env set_,
and _naked, without env set_ work.

Noticeable files:

- [config.ru](config.ru#L30-L34): Main app rackup file, where rails responds
  under an optionally configured path
- [gateway.ru](gateway.ru#L12-L13): Gateway rackup file, proxying to rails _without
  changing the path_
- [Procfile](Procfile): Where the app is run with an appropriate environment
  variable so it responds to namespaced routes
