export default {createSocketIODriver: createFakeSocketIODriver};

import Rx from 'rx';
import io from 'socket.io-client';

// should be used later, when we have real socket.io server to connect
function createSocketIODriver(url) {
    const socket = io(url);

    function get(eventName) {
        return Rx.Observable.create(observer => {
            const sub = socket.on(eventName, function (message) {
                observer.onNext(message);
            });
            return function dispose() {
                sub.dispose();
            };
        });
    }

    function publish(messageType, message) {
        socket.emit(messageType, message);
    }

    return function socketIODriver(events$) {
        events$.forEach(event => publish(event.messageType, event.message));
        return {
            get,
            dispose: socket.destroy.bind(socket)
        }
    };
}

// just for test purposes
function createFakeSocketIODriver(url) {

    const debugEventsObservers = new Map();

    function get(messageType) {
        return Rx.Observable.create(observer => {
            var debug = debugEventsObservers.get(messageType) || {};
            debug.observer = observer;
            debugEventsObservers.set(messageType, debug);
            flushDebugMessages();
        });
    }

    function publish(messageType, message) {
        console.info(`tried to send ${messageType} event`);
    }

    function simulateIncomingEvent(messageType, message) {
        var debug = debugEventsObservers.get(messageType) || {};
        debug.messages = debug.messages || [];
        debug.messages.push({messageType, message});
        debugEventsObservers.set(messageType, debug);
        flushDebugMessages();
    }

    function flushDebugMessages() {
        Rx.Observable.from(debugEventsObservers.values())
            .filter((debug) => debug.observer)
            .flatMap((debug) => {
                const messages = debug.messages;
                debug.messages = [];
                return Rx.Observable.combineLatest(
                    Rx.Observable.of(debug.observer),
                    Rx.Observable.from(messages)
                )
            })
            .subscribe(([observer, event]) => observer.onNext(event.message));
    }

    return function socketIODriver(events$) {
        events$.subscribe(event => publish(event.messageType, event.message));
        return {
            get,
            simulateIncomingEvent: simulateIncomingEvent
        }
    };
}

