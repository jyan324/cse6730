var gulp = require('gulp');
var csv = require('csv');
var fs = require('fs');
var mean = require('./mean.js');
var histogram = require('./histogram.js');

/**
 * Helper method for querying the CSV file
 */
var getCsv = function() {
    // return a stream filtered and transformed into a new format
    return fs.createReadStream('data.csv')
        .pipe(csv.parse());
};

/**
 * Helper method for only getting the first appearances of the cars
 */
var keepFirst = function() {
    var seenCars = {};
    var firstTracker = function(row) {
        var car_id = row[0];

        // if we've seen the car skip it
        if(seenCars[car_id]) {
            return null;
        }

        seenCars[car_id] = true;
        return row;
    };

    return csv.transform(firstTracker);
};

gulp.task('northbound-input-distribution', function(taskDone) {

    var startTimes = [];

    getCsv()
        .pipe(csv.transform(function(row) {
            // Filter only rows that are northbound, and in the correct section of road
            if(row[17] != '3' || row[18] != '2') {
                return;
            }

            return row;
        }))
        .pipe(keepFirst())
        .pipe(csv.transform(function(row) {
            startTimes.push(Number(row[3]));
            return row;
        }))
        .on('finish', function() {
            // sort the start times and calculate the differences to map to a Exponential
            startTimes.sort(function(a, b) {
                return Number(a) - Number(b);
            });
            var N = startTimes.length;
            var startOffsets = [];
            for(var i = 1; i < N; i++) {
                startOffsets.push( (startTimes[i] - startTimes[i-1]) / 1000 );
            }
            
            console.log(startOffsets);
            console.log(histogram(startOffsets, { bins: 30 }));

            // calculate the mean
            var meanOffset = mean(startOffsets);
            console.log("Raw Mean is " + meanOffset + " seconds");

            var reducedOffsets = startOffsets.filter(function(value) {
                return value < 40;
            });
            var reducedMean = mean(reducedOffsets);
            console.log('Reduced mean is ' + reducedMean);

            taskDone();
        });
});

gulp.task('input-distribution', function() {
    return keepEntrances()
        .pipe(csv.stringify())
        .pipe(process.stdout);
});

gulp.task('default', ['input-distribution']);
