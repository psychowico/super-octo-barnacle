import Cycle from '@cycle/core';
import {makeDOMDriver, hJSX} from '@cycle/dom';
import SocketIODriver from './drivers/socket.io.js';

function main({SocketIO, DOM}) {
    const incomingMessages$ = SocketIO.get('init');
    incomingMessages$.subscribe(() => console.log('test'));
    return {
        DOM: DOM.select('input').events('click')
            .map(ev => ev.target.checked)
            .startWith(false)
            .map(toggled =>
                <div>
                    <label><input type="checkbox" /> Click me</label>
                    <p>{toggled ? 'ON' : 'off'}</p>
                </div>
            )
    };
}

const drivers = {
  DOM: makeDOMDriver('#app'),
  SocketIO: SocketIODriver.createSocketIODriver('localhost:3000'),
};

Cycle.run(main, drivers);
