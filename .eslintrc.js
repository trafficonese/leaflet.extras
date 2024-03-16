module.exports = {
  parserOptions: {
    "ecmaVersion": 6
  },
  env: {
    browser: true,
    node: true,
  },
  extends: "eslint:recommended",
  rules: {
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
    "no-console": ["error", { allow: ["warn", "error"] }],
    "no-var": "off", // Allow var declarations
    "prefer-const": "error", // Enforce the use of const where possible
    "no-assign-const": "off"
  }
};
