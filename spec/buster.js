var config = module.exports;

config['My tests'] = {
    environment: 'browser',
    autoRun: false,
    rootPath: '../',
    sources: [
        'INTER-Mediator.js',
        'INTER-Mediator-Page.js',
        'INTER-Mediator-Context.js',
        'INTER-Mediator-Lib.js',
        'INTER-Mediator-Format.js',
        'INTER-Mediator-Element.js',
        'lib/js_lib/js-expression-eval-parser.js',
        'INTER-Mediator-Calc.js',
        'INTER-Mediator-Parts.js',
        'INTER-Mediator-Navi.js',
        'INTER-Mediator-UI.js',
        'INTER-Mediator-Log.js',
        'lib/js_lib/tinySHA1.js',
        'lib/js_lib/sha256.js',
        'lib/js_lib/jsencrypt.min.js',
        'Adapter_DBServer.js',
        'INTER-Mediator-Queuing.js',
        'INTER-Mediator-Events.js',
        'INTER-Mediator-DoOnStart.js'
    ],
    tests: [
        'INTER-Mediator-UnitTest/INTER-Mediator-test.js',
        'INTER-Mediator-UnitTest/INTER-Mediator-Page-test.js',
        'INTER-Mediator-UnitTest/INTER-Mediator-Element-test.js',
        'INTER-Mediator-UnitTest/INTER-Mediator-Context-test.js',
        'INTER-Mediator-UnitTest/INTER-Mediator-Lib-test.js',
        'INTER-Mediator-UnitTest/sha1-test.js',
        'INTER-Mediator-UnitTest/JSEncrypt-test.js',
        'INTER-Mediator-UnitTest/js-expression-eval-test.js',
        'spec/run.js'
    ]
};