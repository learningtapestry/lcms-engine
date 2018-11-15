// eslint-disable-next-line no-unused-vars
function linkWithParams(route, params = {}) {
  let path = route;
  _.each(params, (v, k) => {
    path = _.replace(path, `:${k}`, v);
  });
  return path;
}
