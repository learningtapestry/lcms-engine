import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import { Foundation } from 'foundation-sites';
import TagsInput from 'react-tagsinput';
import $ from 'jquery';
import '../../../vendor/jstree/jstree.min';

class DirectoryPicker extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      directory: props.directory,
      parent: props.parent,
    };

    this.onClick = this.onClick.bind(this);
    this.handleDirChange = this.handleDirChange.bind(this);
  }

  componentDidMount() {
    // eslint-disable-next-line react/no-find-dom-node
    const $this = $(ReactDOM.findDOMNode(this));
    $this.parent().addClass('o-curriculum-tree-picker__container');

    const editor = $this.find('#curriculum-tree-picker');
    editor.on('changed.jstree', this.onChanged.bind(this)).jstree({
      core: {
        animation: 0,
        themes: { dots: true },
        check_callback: true,
        data: {
          url: this.props.path,
          data: node => {
            return { id: node.id };
          },
        },
      },
      plugins: ['wholerow', 'changed'],
    });
    this.jsTree = editor.data('jstree');

    Foundation.addToJquery($);
    this.jqmodal = $this.find('#curriculum-picker-modal');
    new Foundation.Reveal(this.jqmodal, null);
  }

  closeModal() {
    this.jqmodal.foundation('close');
  }

  onChanged(_e, data) {
    const dir = this.directory(data.node);
    const parent = {
      id: data.node.id,
      title: data.node.li_attr.title,
      directory: dir,
    };
    this.setState({ directory: dir, parent: parent });
    this.closeModal();
  }

  onClick(e) {
    e.preventDefault();
    this.jqmodal.foundation('open');
  }

  directory(node) {
    return node.parents
      .map(el => this.jsTree.get_node(el, null).text)
      .reverse()
      .slice(1)
      .concat(node.text);
  }

  handleDirChange(tags) {
    this.setState({ directory: tags });
  }

  render() {
    const curr = this.state.parent.directory;
    const parent_aside = curr.length > 0 ? `(${curr.join(' | ')}) : ` : '';
    return (
      <div>
        <div className="input text optional resource_parent_id">
          <label className="text optional" htmlFor="resource_parent_id">
            Parent Resource
          </label>
          <input type="hidden" name="resource[parent_id]" id="resource_parent_id" value={this.state.parent.id || ''} />
          {/* eslint-disable jsx-a11y/anchor-is-valid */}
          <a href="#" className="button reveal-button" onClick={this.onClick}>
            Select Parent
          </a>
          {/* eslint-enable jsx-a11y/anchor-is-valid */}
          <div className="resource_parent">
            <aside>{parent_aside}</aside> <strong>{this.state.parent.title}</strong>
          </div>
        </div>
        <div className="input text optional resource_directory">
          <label className="text optional" htmlFor="resource_directory">
            Curriculum directory{' '}
            <aside>
              (You can pick a parent above, or enter curriculum tags below; i.e.: subject, grade, unit, etc;)
            </aside>
          </label>
          <TagsInput value={this.state.directory} onChange={this.handleDirChange} />
          <input type="hidden" name="resource[directory]" value={this.state.directory} />
        </div>
        <div className="curriculum-picker-modal reveal" id="curriculum-picker-modal">
          <h2>Select a Parent Resource</h2>
          <div id="curriculum-tree-picker" className="o-curriculum-tree-picker"></div>
        </div>
      </div>
    );
  }
}

DirectoryPicker.propTypes = {
  tree: PropTypes.array,
  directory: PropTypes.array,
  parent: PropTypes.object,
  path: PropTypes.string,
};

export default DirectoryPicker;
