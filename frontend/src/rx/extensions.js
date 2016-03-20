import Rx from 'rx';

// adding .log() function to rx observable.
// WARN: it's only for debug purposes - it's subscribe
// to stream too, not only logging
Rx.Observable.prototype.log = function () {
    this.subscribe(
        (ev)  => console.log('Log$: ', ev),
        (err) => console.err('Log$: ', err)
    );

    return this;
};
