const _ = require('lodash');
import Rx from 'rx';

export function triggerDebugEvents(socketIO) {
    socketIO.simulateIncomingEvent('init');

    const cells = getRandomCells(10);
    cells.forEach((cell) => socketIO.simulateIncomingEvent('spawn', cell));

    Rx.Observable.interval(1000)
        .flatMap(() => cells)
        .map(randMove)
        .subscribe((cell) => socketIO.simulateIncomingEvent('move', cell));

    var moveMatrix = {};
    function randMove(cell) {
        const Rate = 70;
        const oldState = (moveMatrix[cell.id] || {
            position: cell.position,
            velocity: {x: 1, y: -1},
            radius: cell.radius
        });

        const velocity = {
            x: (Math.random() < 0.8 ? 1 : -1) * oldState.velocity.x,
            y: (Math.random() < 0.8 ? 1 : -1) * oldState.velocity.y,
        };
        const newState = {
            position: {
                x: oldState.position.x + Rate * velocity.x,
                y: oldState.position.y + Rate * velocity.y,
            },
            velocity: velocity,
            radius: Math.trunc(100 * Math.random()),
        };
        moveMatrix[cell.id] = newState;

        return _.assign({}, cell, newState);
    }
    cells.forEach((cell) => socketIO.simulateIncomingEvent('move', cell));
}

function getRandomCells(count) {
    return Array.apply(null, {length: count}).map(() => ({
        id: debugId(),
        position: {x: Math.random() * 800, y: Math.random() * 600},
        radius: Math.random() * 100,
    }));
}

function debugId() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        const r = Math.random() * 16 | 0;
        const v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}
