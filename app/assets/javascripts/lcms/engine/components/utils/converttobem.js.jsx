function convertToBEM(cssCl, el) {
  return _(cssCl).split(/\s+/).map(cl => `${cl}__${el}`).join(' ');
}
