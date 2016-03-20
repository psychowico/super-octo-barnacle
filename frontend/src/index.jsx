import Cycle from '@cycle/core';
import './rx/extensions';
import {makeDOMDriver, hJSX} from '@cycle/dom';
import SocketIODriver from './drivers/socket.io.js';

function main({socketIO, DOM, log}) {
    const checkboxChanged$  = DOM.select('input').events('click');
    const incomingMessages$ = socketIO.get('init');

    const outgoingMessages$ = checkboxChanged$
        .map(ev => {
            return {
                messageType: 'user-click',
                message: {},
            };
        })
        .log();

    // incomingMessages$.subscribe(() => console.log('init...'));
    return {
        DOM: checkboxChanged$
            .map(ev => ev.target.checked)
            .startWith(false)
            .map(toggled =>
                <div>
                    <label><input type="checkbox" /> Click me</label>
                    <p>{toggled ? 'ON' : 'off'}</p>
                </div>
            ),
        socketIO: outgoingMessages$,
    };
}

const drivers = {
  DOM: makeDOMDriver('#app'),
  socketIO: SocketIODriver.createSocketIODriver('localhost:3000'),
};

Cycle.run(main, drivers);
