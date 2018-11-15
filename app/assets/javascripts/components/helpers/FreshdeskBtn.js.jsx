function FreshdeskBtn(props) {
  const onClick = (evt)=> {
    FreshWidget.show();
    return false;
  };

  // return <a href="#" className={props.cls} onClick={onClick} >{props.text}</a>
  return <a href="mailto:pilot@unbounded.org" className={props.cls}>{props.text}</a>
}
