module.exports = {
  'env': {
    'browser': true
  },
  'extends': 'standard',
  'rules': {
    'semi': ['error', 'always'],
    'semi-spacing': ['error', {'after': true, 'before': false}],
    'semi-style': ['error', 'last'],
    'no-extra-semi': 'error',
    'no-unexpected-multiline': 'error',
    'no-unreachable': 'error'
  },
  'globals': {
    'INTERMediator': false,
    'INTERMediatorLib': false,
    'INTERMediator_DBAdapter': false,
    'INTERMediatorOnPage': false,
    'IMLib': false,
    'IMLibNodeGraph': false,
    'IMLibElement': false,
    'IMLibContextPool': false,
    'IMLibLocalContext': false,
    'IMLibContext': false,
    'IMLibCalc': false,
    'IMLibEventDispatch': false,
    'IMLibMouseEventDispatch': false,
    'IMLibKeyDownEventDispatch': false,
    'IMLibKeyUpEventDispatch': false,
    'IMLibInputEventDispatch': false,
    'IMLibChangeEventDispatch': false,
    'IMLibBlurEventDispatch': false,
    'IMLibEventResponder': false,
    'IMLibPageNavigation': false,
    'IMParts_Catalog': false,
    'IMLibQueue': false,
    'IMLibUI': false,
    'Parser': false,
    'Pusher': false,
    'SHA1': false,
    'jsSHA': false,
    'Base64': false,
    'console': false,
    'Exception': false
  }
}
