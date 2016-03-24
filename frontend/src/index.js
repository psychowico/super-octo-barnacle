require('file?name=[name].[ext]!./index.html');

import Cycle from '@cycle/core';
import './rx/extensions';
import Rx from 'rx';
import {makeDOMDriver, h, svg} from '@cycle/dom';
import SocketIODriver from './drivers/socket.io.js';
import {Cell} from './components/cell';

function main({DOM, socketIO}) {
    const actions = intent(DOM, socketIO);

    var $state = model(actions);

    actions.socket.init$.subscribe(() => console.log('init...'));

    return {
        DOM: view($state)
    };
}

function intent(DOM, socketIO) {
    const initMessage$ = socketIO.get('init');
    const spawnMessage$ = socketIO.get('spawn');
    triggerDebugEvents(socketIO);

    return {
        socket: {
            init$: initMessage$,
            spawn$: spawnMessage$,
        },
        click$: DOM.select('svg').events('click')
    };
}

function model(actions) {
    const clickSpawns$ = actions.click$.map(() => ({
        position: {
            x: Math.random() * 800, y: Math.random() * 600
        },
        radius: Math.random() * 100
    }));
    const cells$ = actions.socket.spawn$.merge(clickSpawns$).map((props) =>
        Cell({
            props$: Rx.Observable.of(props)
        }).DOM
    )
    .flatMap((vdom) => vdom)
    .scan((arr, cell) => arr.concat(cell), []);

    return {
        cells$: cells$
    };
}

function view($state) {
    return $state.cells$.map((cells) =>
        svg('svg', {width: 800, height: 600}, cells)
    );
}

function triggerDebugEvents(socketIO) {
    socketIO.simulateIncomingEvent('init');
    const cells = [
        {position: {x: 40, y: 33}, radius: 20},
        {position: {x: 400, y: 170}, radius: 100},
        {position: {x: 95, y: 225}, radius: 66},
    ]
    cells.forEach((cell) => socketIO.simulateIncomingEvent('spawn', cell));
}

const drivers = {
  DOM: makeDOMDriver('#app'),
  socketIO: SocketIODriver.createSocketIODriver('localhost:3000'),
};

Cycle.run(main, drivers);
