# Server Side has restructured as Meteor Packages
# Deps on TimberServerUtil and TimberQueue

tq = new TimberQueue

# Methods
Meteor.methods
  getPhContent: TimberServerUtil.getPhContent
  getHttpContent: TimberServerUtil.getHttpContent
  getPhContentNightmare: TimberServerUtil.getPhContentNightmare
  getSearchContent: TimberServerUtil.getSearchContent
  previewResult: TimberServerUtil.previewResult
  runQueue: tq.run
