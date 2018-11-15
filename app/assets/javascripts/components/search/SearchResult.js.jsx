function SearchResult(props) {
  const breadcrumb = props.resource.breadcrumbs ?
          <span className='o-search-results__subheader'><span className='s-bullet'></span>{props.resource.breadcrumbs}</span>
          : null;
  const colorCode = colorCodeCss(props.resource.subject, props.resource.grade);
  return (
    <li className='o-search-results__item'>
      <a href={props.resource.path}>
        <div className={`cs-txt--${colorCode}`}>
          <span className='o-search-results__header'>{props.resource.type_name}</span>
          {breadcrumb}
        </div>
        <div className='o-search-results__title'>
          {props.resource.title}
        </div>
        <div className='o-search-results__teaser'>
          {props.resource.teaser}
        </div>
      </a>
    </li>
  );
}
