import Cycle from '@cycle/core';
import './rx/extensions';
import {makeDOMDriver, hJSX} from '@cycle/dom';
import SocketIODriver from './drivers/socket.io.js';

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
        checkboxChanged$: DOM.select('input').events('click'),
        initMessage$:     socketIO.get('init'),
    };
}

function model(actions) {
    return {
        DOM: actions.checkboxChanged$
            .map(ev => ev.target.checked)
            .startWith(false),
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
    return $state.map(toggled =>
            <div>
                <label><input type="checkbox" /> Click me</label>
                <p>{toggled ? 'ON' : 'off'}</p>
            </div>
    );
}

const drivers = {
  DOM: makeDOMDriver('#app'),
  socketIO: SocketIODriver.createSocketIODriver('localhost:3000'),
};

Cycle.run(main, drivers);
