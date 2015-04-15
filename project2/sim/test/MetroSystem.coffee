expect = require('chai').expect
Backbone = require 'backbone'
Directions = require '../coffee/Directions'
Train = require '../coffee/Train'
StationConnection = require '../coffee/StationConnection'
MetroSystem = require '../coffee/MetroSystem'
EventQueueSingleton = require '../coffee/EventQueueSingleton'

describe 'MetroSystem', ->
    stationData = [
        {
            code: 'A',
            name: 'A Station',
            timeToNextEasternStation: 2.0,
            timeToNextWesternStation: null,
        },
        {
            code: 'B',
            name: 'B Station',
            timeToNextEasternStation: null,
            timeToNextWesternStation: 2.1
        }
    ]
    system = null
    beforeEach ->
        system = new MetroSystem(stationData)

    describe 'constructor', ->
        it 'should create the correct number of station connections', ->
            expect(system.connections.length).to.equal(1)

    describe 'nextConnectionForTrain', ->
        connection1 = new StationConnection()
        connection2 = new StationConnection()
        connection1.off()
        connection2.off()
        train = null

        beforeEach ->
            train = new Train
            system.connections = [ connection1, connection2 ]

        it 'should return the next station if the train is westward', ->
            train.set('direction', Directions.WEST)

            expect(system.nextConnectionForTrain(train, connection1)).to.equal(connection2)

        it 'should return null if there are no more stations in the west direction and the train is westward', ->
            train.set('direction', Directions.WEST)

            expect(system.nextConnectionForTrain(train, connection2)).to.equal(null)

        it 'should return the previous station if the train is eastward', ->
            train.set('direction', Directions.EAST)

            expect(system.nextConnectionForTrain(train, connection2)).to.equal(connection1)

        it 'should return null if there are no more stations in the east direction and the train is eastward', ->
            train.set('direction', Directions.EAST)

            expect(system.nextConnectionForTrain(train, connection1)).to.equal(null)

        it 'should return null if it cannot find the connection provided', ->
            expect(system.nextConnectionForTrain(train, new StationConnection)).to.equal(null)

    describe 'onConnectionExit', ->
        stubEvent = (direction, connection) ->
            new Backbone.Model(
                name: 'train:exit'
                timestamp: 0
                data:
                    connection: connection
                    station: new Backbone.Model
                    train: new Train(direction: direction)
            )

        beforeEach ->
            connection1 = new StationConnection()
            connection2 = new StationConnection()
            connection1.off()
            connection2.off()
            system.connections = [ connection1, connection2 ]
            EventQueueSingleton.reset()

        it 'should pass it to the next westward station if the train is heading west', ->
            event = stubEvent(Directions.WEST, system.connections[0])
            system.onConnectionExit(event)
            expect(EventQueueSingleton.length).to.equal(1)
            expect(EventQueueSingleton.first().get('name')).to.equal('train:arrive')
            expect(EventQueueSingleton.first().get('data').connection).to.equal(system.connections[1])

        it 'should pass it to the next eastward train if the train is heading east', ->
            event = stubEvent(Directions.EAST, system.connections[1])
            system.onConnectionExit(event)
            expect(EventQueueSingleton.length).to.equal(1)
            expect(EventQueueSingleton.first().get('name')).to.equal('train:arrive')
            expect(EventQueueSingleton.first().get('data').connection).to.equal(system.connections[0])

        it 'should trigger a train:finish if the train is westward, with no more stations', ->
            event = stubEvent(Directions.EAST, system.connections[0])
            system.onConnectionExit(event)
            expect(EventQueueSingleton.length).to.equal(0)

        it 'should trigger a train:finish if the train is eastward, with no more stations', ->
            event = stubEvent(Directions.WEST, system.connections[1])
            system.onConnectionExit(event)
            expect(EventQueueSingleton.length).to.equal(0)
