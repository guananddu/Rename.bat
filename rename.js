// rename

//////////////////////////

(function() {
    "use strict";

    var fs = require('fs');

    function noop() {}

    function copy(src, dst, cb) {
        function copyHelper(err) {
            var is, os;

            if (!err) {
                return cb(new Error("File " + dst + " exists."));
            }

            fs.stat(src, function(err, stat) {

                if (err) {
                    return cb(err);
                }
                
                is = fs.createReadStream(src);
                os = fs.createWriteStream(dst);

                is.pipe(os);
                os.on('close', function(err) {
                    if (err) {
                        return cb(err);
                    }

                    console.log( 'Done: ' + dst );
                    fs.utimes(dst, stat.atime, stat.mtime, cb);
                });
            });
        }

        cb = cb || noop;
        fs.stat(dst, copyHelper);
    }

    fs.copy = copy;
}());

//////////////////////////

var fs = require('fs');

// process argv
var a, b, args = process.argv;
if ( args.length > 2 && args.length < 5 ) {
    a = args[2];
    b = args[3];

    // start
    beginRename(a, b);
} else {
    console.log('Params Err!');
}

function beginRename(resourcesDir, renameType) {
    // if need help
    if (resourcesDir == 'help') {
        console.log('Usage: `node rename.js ' 
            +'resourcesDir renameType`\n' 
            + 'renameType: `replace`, `append`, `num`.');
    }

    // set default
    renameType = renameType || 'replace';

    // read resources dir
    fs.readdir( resourcesDir, function ( err, files ) {
        dirCallback( err, files, renameType );
    } );
}

function changeName( filename, renameType ) {
    var reg = /\d{1,3}/g;
    var num = reg.exec( filename )[ 0 ];

    var handleNum = function ( word ) {
        return word.length == 1
            ? '00' + word
            : ( word.length == 2
                ? '0' + word
                : word );
    };

    // replace || append
    if ( renameType == 'replace'
        || renameType == 'append' ) {

        var outer = filename.replace( reg, function ( word ) {
            return handleNum( word );
        } );

        return renameType == 'append'
            ? ( handleNum( num ) + outer )
            : outer;
    }

    // num
    if ( renameType == 'num' ) {
        var ext = filename.substring( 
            filename.lastIndexOf( '.' )
        );

        return handleNum( num ) + ext;
    }

    return filename;

}

function dirCallback( err, files, renameType ) {
    if (err) {
        throw err;
    }
    // getted files
    // debug output
    var output = './output';
    var input = './resources';
    if (fs.existsSync(output)) {
        fs.rmdirSync(output);
    }
    fs.mkdirSync(output);

    files.forEach(function(filename, index, arr) {
        var inputName = input + '/' + filename;

        // changename
        filename = changeName( filename, renameType );
        var outputName = output + '/' + filename;

        console.log( 'Handling: `' + inputName 
          + '` to `' + outputName + '`' );
        fs.copy( inputName, outputName );
    });
}