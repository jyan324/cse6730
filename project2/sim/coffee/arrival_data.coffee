Directions = require './Directions'

###
# The empirical distribution of train interarrival times
###
module.exports[Directions.WEST] = {
    pdf: [
        0.038950715,
        0.108903021,
        0.135930048,
        0.12718601,
        0.123211447,
        0.107313196,
        0.119236884,
        0.059618442,
        0.046104928,
        0.036565978,
        0.029411765,
        0.019077901,
        0.021462639,
        0.007949126,
        0.003974563,
        0.00317965,
        0.003974563,
        0.001589825,
        0.00317965,
        0.000794913,
        0,
        0,
        0.000794913,
        0.000794913,
        0.0007949131
    ],
    min: 0,
    max: 1680
}

module.exports[Directions.EAST] = {
    pdf: [
        0.015206372,
        0.089065894,
        0.074583635,
        0.131788559,
        0.118754526,
        0.115133961,
        0.094858798,
        0.055756698,
        0.073859522,
        0.049239681,
        0.044895004,
        0.037653874,
        0.027516293,
        0.024619841,
        0.013758146,
        0.011585807,
        0.005792904,
        0.004344678,
        0.007965243,
        0,
        0.000724113,
        0.002172339,
        0,
        0,
        0.000724113,
    ],
    min: 36
    max: 816
}
