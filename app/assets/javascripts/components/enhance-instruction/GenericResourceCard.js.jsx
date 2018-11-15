// eslint-disable-next-line no-unused-vars
function GenericResourceCard(props) {
  const item = props.item;
  const mainClass = 'o-generic-card';
  const bemClass = _.partial(convertToBEM, mainClass);
  const cssGeneric = classNames(
    mainClass,
    `cs-link-bg--${colorCodeCss(item.subject, item.grade_avg)}`
  );

  return (
    // eslint-disable-next-line no-undef
    <a className={cssGeneric} href={item.path} onClick={heapTrackPd.bind(null, item)}>
      <div className={bemClass('wrap')}>
        <div className={bemClass('title')}>{item.title}</div>
        <div className={bemClass('teaser')}>{item.teaser}</div>
      </div>
    </a>
  );
}
