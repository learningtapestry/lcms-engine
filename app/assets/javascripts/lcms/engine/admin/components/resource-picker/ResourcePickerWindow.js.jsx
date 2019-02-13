// eslint-disable-next-line no-unused-vars
class ResourcePickerWindow extends React.Component {
  constructor(props) {
    super(props);

    this.typeOptions = [
      ['subject', 'subject'],
      ['grade', 'grade'],
      ['module', 'module'],
      ['unit', 'unit']
    ];

    this.subjectOptions = [
      ['ela', 'ELA'],
      ['math', 'Math']
    ];

    this.gradeOptions = [
      ['pk', 'prekindergarten'],
      ['k', 'kindergarten'],
      ['1', 'grade 1'],
      ['2', 'grade 2'],
      ['3', 'grade 3'],
      ['4', 'grade 4'],
      ['5', 'grade 5'],
      ['6', 'grade 6'],
      ['7', 'grade 7'],
      ['8', 'grade 8'],
      ['9', 'grade 9'],
      ['10', 'grade 10'],
      ['11', 'grade 11'],
      ['12', 'grade 12']
    ];

    const initialState = {
      pagination: {
        current_page: 1,
        total_pages: 0
      },
      results: [],
      type: null,
      subject: null,
      grade: null,
      q: null
    };

    this.state = { ...initialState, ...props };
  }

  filterElement(title, value, type, data) {
    return (
      <label className="medium-3 columns">{ title }
        <select value={value || ''} onChange={ this.props.onFilterChange.bind(this, type) }>
          <option />
          {data.map(([value, title]) => (
            <option key={value} value={value}>{title}</option>
          ))}
        </select>
      </label>
    );
  }

  selectResource(resource) {
    if ('onSelectResource' in this.props) {
      this.props.onSelectResource(resource);
    }
  }

  render() {
    const { grade, q, subject, type } = this.props;

    return (
      <div className="o-assocpicker">
        <div className="o-page">
          <div className="o-page__module">
            <h4 className="text-center">Select resource</h4>
            <div className="row">
              { this.filterElement('Curriculum Type', type, 'type', this.typeOptions) }
              { this.filterElement('Subject', subject, 'subject', this.subjectOptions) }
              { this.filterElement('Grade', grade, 'grade', this.gradeOptions) }

              <label className="medium-3 columns">Title
              <input type="text" value={q || ''} onChange={ this.props.onFilterChange.bind(this, 'q') } />
              </label>
            </div>
          </div>
        </div>

        <div className="o-page">
          <div className="o-page__module">
            <table className="c-admcur-results">
              <thead>
                <tr>
                  <th>Title</th>
                </tr>
              </thead>
              <tbody>
                {this.props.results.map(resource => (
                  <tr key={resource.id}>
                    <td onClick={this.selectResource.bind(this, resource)}>{resource.title}</td>
                  </tr>
                ))}
              </tbody>
            </table>

            { this.props.pagination() }
          </div>
        </div>
      </div>
    );
  }
}
