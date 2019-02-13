// Workaround after react-rails upgrade to 1.11.0
// https://github.com/reactjs/react-rails/blob/master/CHANGELOG.md#breaking-changes-4
// Alias window = this; has been removed from the default server rendering JavaScript to improve detection of the
// server rendering environment. To get the old behavior, you can add the alias in your own server rendering code.

/* eslint-disable no-global-assign */
window = this;
