/* eslint-disable no-unused-vars, no-undef */
let excludesStore = _.extend({}, EventEmitter.prototype, {
  updateMaterialsList: function(excludes) {
    this.excludes = excludes;
    this.emit('upd_materials');
  },

  getState: function() {
    return this.excludes || [];
  }
});
