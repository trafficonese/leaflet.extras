module.exports = {
  parserOptions: {
    'ecmaVersion': 6,
    'sourceType': 'module'
  },
  env: {
    browser: true,
    node: true,
  },
  extends: 'eslint:recommended',
  plugins: [
    '@stylistic/js'
  ],
  rules: {
    'indent': ['error', 2],
    '@stylistic/js/array-bracket-spacing': ['error', 'never'],
    '@stylistic/js/arrow-spacing': 'error',
    '@stylistic/js/comma-spacing': ['error', { 'before': false, 'after': true }],
    '@stylistic/js/comma-style': ['error', 'last'],
    '@stylistic/js/multiline-ternary': ['error', 'always'],
    '@stylistic/js/eol-last': ['error', 'always'],
    '@stylistic/js/function-paren-newline': ['error', 'never'],
    '@stylistic/js/space-infix-ops': 'error',
    '@stylistic/js/key-spacing': ['error', { 'beforeColon': false, 'afterColon': true}],
    '@stylistic/js/lines-around-comment': ['error', { 'beforeBlockComment': true }],
    '@stylistic/js/function-call-spacing': ['error', 'never'],
    '@stylistic/js/no-floating-decimal': 'error',
    '@stylistic/js/no-multi-spaces': 'error',
    '@stylistic/js/space-before-blocks': 'error',
    '@stylistic/js/keyword-spacing': ['error', { 'before': true, 'after': true }],
    'linebreak-style': 'off',
    'quotes': ['error', 'single'],
    'semi': ['error', 'always'],
    'no-unused-vars': ['error', {'args': 'none'}],
    'no-console': ['error', { allow: ['warn', 'error'] }],
    'no-var': 'off',
    'prefer-const': 'error',
    'no-assign-const': 'off'
  }
};
