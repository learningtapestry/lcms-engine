class DirectoryPicker extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      tree: props.tree,
      directory: props.directory,
      parent: props.parent
    };
  }

  componentDidMount() {
    const $this = $(ReactDOM.findDOMNode(this));
    $this.parent().addClass('o-curriculum-tree-picker__container');

    // start jstree
    const editor = $this.find('#curriculum-tree-picker');
    editor
      .on('changed.jstree', this.onChanged.bind(this))
      .jstree({
        core : {
          animation : 0,
          themes: { dots: true },
          check_callback: true,
          data : this.state.tree
        },
        plugins : ['wholerow', 'changed']
      });

    // preserve jsTree reference so we can call methods directly
    this.jsTree = editor.data('jstree');

    // start tagsinput
    this.dirTags = $this.find('#resource_directory');
    this.dirTags.tagsInput({
      height: '2.5em',
      width:'65%',
    });

    // start modal
    this.jqmodal = $this.find('#curriculum-picker-modal');
    new Foundation.Reveal(this.jqmodal);
  }

  closeModal() {
    this.jqmodal.foundation('close');
  }

  onChanged(_e, data) {
    const dir = this.directory(data.node);
    this.dirTags.importTags(dir.join(','));

    const parent = { id: data.node.id, title: data.node.li_attr.title, directory: dir };
    this.setState({ ...this.state, parent: parent });
    this.closeModal();
  }

  onClick(_e) {
    this.jqmodal.foundation('open');
  }

  directory(node) {
    return node.parents
      .map(el => this.jsTree.get_node(el).text)
      .reverse()
      .slice(1)
      .concat(node.text);
  }

  render() {
    const dir = this.state.directory.join(',');
    const curr = this.state.parent.directory;
    const parent_aside = (curr.length > 0) ? `(${curr.join(' | ')}) : ` : '';
    return (
      <div>
        <div className="input text optional resource_parent_id">
          <label className="text optional" htmlFor="resource_parent_id">Parent Resource</label>
          <input type="hidden" name="resource[parent_id]" id="resource_parent_id" value={this.state.parent.id} />
          <a href="#" className="button reveal-button" onClick={this.onClick.bind(this)}>Select Parent</a>
          <div className="resource_parent"><aside>{parent_aside}</aside> <strong>{this.state.parent.title}</strong></div>
        </div>
        <div className="input text optional resource_directory">
          <label className="text optional" htmlFor="resource_directory">Curriculum directory <aside>(You can pick a parent above, or enter curriculum tags below; i.e.: subject, grade, unit, etc;)</aside></label>
          <input className="text optional" name="resource[directory]" id="resource_directory" defaultValue={dir}></input>
        </div>
        <div className="curriculum-picker-modal reveal" id="curriculum-picker-modal" >
          <h2>Select a Parent Resource</h2>
          <div id="curriculum-tree-picker" className="o-curriculum-tree-picker"></div>
        </div>
      </div>
    );
  }
}
