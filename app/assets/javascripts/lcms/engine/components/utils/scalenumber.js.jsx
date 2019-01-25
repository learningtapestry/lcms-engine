// Scales a number `src` from range `[minSrc,maxSrc]` to `[minTgt,maxTgt]`.
// Ref. http://stackoverflow.com/a/5295202
// eslint-disable-next-line no-unused-vars
function scaleNumber(minTgt, maxTgt, minSrc, maxSrc, src) {
  src = parseFloat(src);
  if (maxSrc === minSrc) return maxTgt;
  return (((maxTgt - minTgt) * (src - minSrc)) / (maxSrc - minSrc)) + minTgt;
}
