var gulp = require('gulp');
var ngsim = require('./ngsimFilters.js');
var inputDistribution = require('./inputDistributionTaskFactory.js');

gulp.task('northboundPlatoonLeaders', inputDistribution({
    direction: ngsim.direction.NORTH,
    intersection: '3',
    isLeader: true
}));

gulp.task('northbound', inputDistribution({
    direction: ngsim.direction.NORTH,
    intersection: '3'
}));

gulp.task('southbound', inputDistribution({
    direction: ngsim.direction.SOUTH,
    intersection: '3'
}));

gulp.task('default', ['northboundPlatoonLeaders', 'northbound']);
