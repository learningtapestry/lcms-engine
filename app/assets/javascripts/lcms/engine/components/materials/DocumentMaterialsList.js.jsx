/* eslint-disable no-unused-vars, no-undef */
class DocumentMaterialsList extends React.Component {
  constructor(props) {
    super(props);
    this.state = { excludes: [] };
    this.onExcludesChanged = this._excludesChanged.bind(this);
  }

  componentDidMount() {
    excludesStore.on('upd_materials', this.onExcludesChanged);
  }

  componentWillUnmount() {
    excludesStore.off('upd_materials', this.onExcludesChanged);
  }

  _excludesChanged(){
    this.setState({ excludes: excludesStore.getState() });
  }

  render() {
    const excludes = this.state.excludes;
    const filtered_materials =
      _.filter(this.props.data, m => _.difference(m.anchors.anchors, excludes).length + _.intersection(m.anchors.optional, excludes).length);

    const materials = filtered_materials.map(m => <li key={m.id}>{m.subtitle} &mdash; {m.title}</li>);
    return (
      <ul className="o-m-list">
        {materials}
      </ul>
    );
  }
}
