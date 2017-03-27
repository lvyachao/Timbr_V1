Package.describe({
  name: 'timber-server-util',
  summary: 'Timber server-side utilities',
  version: '0.1.0'
});

Npm.depends({
  nightmare: '1.7.0',
  weak: '0.3.3',
  url: '0.10.2'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.2.1');
  api.use(['coffeescript', 'mongo', 'particle4dev:cheerio', 'zaku:phantom', 'meteorhacks:async']);
  api.addFiles('server-inject.coffee', 'server');
  api.addFiles('timber-server-util.coffee', 'server');
  api.export('TimberServerUtil', 'server');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('timber-server-util');
  //api.addFiles('timber-server-util-tests.js');
});
