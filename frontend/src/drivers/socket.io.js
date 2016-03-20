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

    function get(eventName) {
        return Rx.Observable.create(observer => {
            if (eventName === 'init') {
                observer.onNext();
            }
        });
    }

    function publish(messageType, message) {
        console.info(`tried to send ${messageType} event`);
    }

    return function socketIODriver(events$) {
        events$.subscribe(event => publish(event.messageType, event.message));
        return {
            get,
        }
    };
}

