import isolate from '@cycle/isolate';
import {svg} from '@cycle/dom';

export function Cell(sources) {
    return isolate(CellComponent)(sources);
};

const MaxRadius = 100;

function CellComponent(sources) {
    return {
        DOM: sources.props$.map(({position, radius}) => {
            const factor = radius / MaxRadius;
            const R = Math.floor(factor * 255);
            const B = Math.floor((1 - factor) * 255);
            return svg('circle', {
                cx: position.x,
                cy: position.y,
                r: radius,
                stroke: 'black',
                'stroke-width': '3',
                fill: `rgb(${R}, 64, ${B})`,
            });
        })
    };
}

