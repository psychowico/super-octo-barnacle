const gulp       = require('gulp');

const livereload = require('gulp-livereload');
const webpack    = require('webpack');
const babel      = require('gulp-babel');
const serve      = require('gulp-serve');
const watch      = require('gulp-watch');
const batch      = require('gulp-batch');
const plumber    = require('gulp-plumber');

gulp.task('default', ['watch', 'serve']);

gulp.task('watch', function () {
    livereload.listen();
    watch('./src/**/*.js', batch(function (events, done) {
        gulp.start('webpack', done);
    }));
});

gulp.task('babel', ()=> {
  return gulp.src('./src/**/*.js')
    .pipe(plumber())
    .pipe(babel({
      presets: ['es2015']
    }))
    .pipe(gulp.dest('dist'));
});

gulp.task('webpack', ['babel'], function(done) {
    gulp.src('./src/index.html', {base: './src'})
      .pipe(gulp.dest('./dist'));

    webpack({
        context: __dirname + '/dist',
        entry: './index',
        output: {
            path: __dirname + '/dist',
            filename: 'bundle.js'
        }
    }, function () {
        gulp.src('./dist/bundle.js', {base: './dist'})
            .pipe(livereload())
            .on('end', done);
    });
});
gulp.task('serve', ['babel', 'webpack'], serve({
    root: ['./dist'],
    port: 8080,
}));
