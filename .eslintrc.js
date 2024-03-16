module.exports = {
  "parserOptions": {
    "ecmaVersion": 6
  },
  "extends": "eslint:recommended",
  "rules": {
    "indent": [
      "error",
      2
    ],
    "linebreak-style": "off", // Disable linebreak style rule
    "quotes": [
      "error",
      "single"
    ],
    "semi": [
      "error",
      "always"
    ],
    "no-unused-vars": [
       "error",
       {"args": "none"}
    ],
    "no-console": "off",
    "no-restricted-syntax": [
        "error",
        {
            "selector": "CallExpression[callee.object.name='console'][callee.property.name!=/^(log|warn|error|info|trace)$/]",
            "message": "Unexpected property on console object was called"
        }
    ],
    "no-var": "off", // Allow var declarations
    "prefer-const": "error", // Enforce the use of const where possible
    "no-assign-const": "off"
  }
};
