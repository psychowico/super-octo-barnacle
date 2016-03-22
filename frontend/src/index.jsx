import Cycle from '@cycle/core';
import './rx/extensions';
import Rx from 'rx';
import {makeDOMDriver, h, svg} from '@cycle/dom';
import SocketIODriver from './drivers/socket.io.js';
import {Cell} from './components/cell';

function main({DOM, socketIO}) {
    const actions = intent(DOM, socketIO);

    var $state = model(actions);

    // actions.initMessage$.subscribe(() => console.log('init...'));
    return {
        DOM: view($state.DOM),
        socketIO: $state.socketIO,
    };
}


function intent(DOM, socketIO) {
    return {
        checkboxChanged$: DOM.select('circle').events('click'),
        initMessage$:     socketIO.get('init'),
    };
}

function model(actions) {
    return {
        DOM: actions.checkboxChanged$
            .map(ev => ev.target.checked)
            .startWith(false)
            .scan((acc, val) => !acc),
        socketIO: actions.checkboxChanged$
            .map(ev => {
                return {
                    messageType: 'user-click',
                    message: {},
                };
            })
    };
}

function view($state) {
    const props$ = Rx.Observable.interval(500).map(() => ({
        radius: Math.random() * 100, position: {x: 100, y: 100}
    }));
    const cell = Cell({
        props$: props$
    });
    return cell.DOM.map((cell) =>
        svg('svg', {width: 500, height: 500}, [
            cell
        ])
    );
}

const drivers = {
  DOM: makeDOMDriver('#app'),
  socketIO: SocketIODriver.createSocketIODriver('localhost:3000'),
};

Cycle.run(main, drivers);
