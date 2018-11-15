// eslint-disable-next-line no-unused-vars
function MaterialsList(props) {
  const materials = props.data.map(m => <li key={m.id}><strong>{m.subtitle}</strong> <a href={m.pdf_url}>{m.title}</a></li>);
  const cssClasses = classNames('o-m-list__wrap',
    {
      [`o-material-wrapper--${props.subject}`]: !props.for_group,
      ['o-material-wrapper--bg-color']: props.color,
      ['o-material-wrapper--within-group']: props.for_group
    }
  );
  return (
    <div className={cssClasses}>
      <h3>Materials</h3>
      <ul className="o-m-list">
        {materials}
      </ul>
    </div>
  );
}
