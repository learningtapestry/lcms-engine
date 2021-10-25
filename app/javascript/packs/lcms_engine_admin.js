import Initializer from '../components/admin/Initializer';

document.addEventListener('turbolinks:load', () => {
  Initializer.initializeResourcesForm();
  Initializer.initializeResourcesList();
  Initializer.initializeSelectAll();
});

// Support component names relative to this directory:
// eslint-disable-next-line no-undef
const componentRequireContext = require.context('components', true);
// eslint-disable-next-line no-undef
const ReactRailsUJS = require('react_ujs');
// eslint-disable-next-line react-hooks/rules-of-hooks
ReactRailsUJS.useContext(componentRequireContext);
