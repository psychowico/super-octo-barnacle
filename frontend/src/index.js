require('file?name=[name].[ext]!./index.html');

import Cycle from '@cycle/core';
import './rx/extensions';
import Rx from 'rx';
import {makeDOMDriver, h, svg} from '@cycle/dom';
import SocketIODriver from './drivers/socket.io.js';
import {Cell} from './components/cell';
import {triggerDebugEvents} from './helpers/debug';

function main({DOM, socketIO}) {
    const actions = intent(DOM, socketIO);

    var $state = model(actions);

    actions.socket.init$.subscribe(() => console.log('init...'));

    return {
        DOM: view($state)
    };
}

function intent(DOM, socketIO) {
    triggerDebugEvents(socketIO);
    return {
        socket: {
            init$:  socketIO.get('init'),
            spawn$: socketIO.get('spawn'),
            move$:  socketIO.get('move'),
        },
        click$: DOM.select('svg').events('click')
    };
}

function model(actions) {
    const cells$ = actions.socket.spawn$
        .merge(actions.socket.move$)
        .map((props) =>
            Cell({
                props$: Rx.Observable.of(props)
            }).DOM
        )
        .flatMap((vdom) => vdom)
        .scan((cellsDOM, cellVDom) => {
            cellsDOM[cellVDom.id] = cellVDom;
            return cellsDOM;
        }, {})
        .map((cells) => Object.keys(cells).sort().map(key => cells[key]));

    return {
        cells$: cells$
    };
}

function view($state) {
    return $state.cells$.map((cells) =>
        svg(
            'svg',
            {width: 800, height: 600},
            cells
        )
    );
}

const drivers = {
  DOM: makeDOMDriver('#app'),
  socketIO: SocketIODriver.createSocketIODriver('localhost:3000'),
};

Cycle.run(main, drivers);
