Package.describe({
  name: 'timber-queue',
  summary: 'Timber Queue',
  version: '0.1.0'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.2.1');
  api.use(['coffeescript', 'mongo', 'timber-server-util', 'cfs:power-queue', 'meteorhacks:async']);
  api.addFiles('timber-queue.coffee', 'server');
  api.export('TimberQueue', 'server');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('timber-queue');
  //api.addFiles('timber-queue-tests.js');
});
