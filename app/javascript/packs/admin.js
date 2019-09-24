import Initializer from '../components/admin/Initializer';

document.addEventListener('turbolinks:load', () => {
  Initializer.initializeResourcesForm();
  Initializer.initializeResourcesList();
  Initializer.initializeSelectAll();
});

// Support component names relative to this directory:
const componentRequireContext = require.context('components', true);
const ReactRailsUJS = require('react_ujs');
ReactRailsUJS.useContext(componentRequireContext);
