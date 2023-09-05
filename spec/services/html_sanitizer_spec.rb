# frozen_string_literal: true

describe Lcms::Engine::HtmlSanitizer do
  describe '.sanitize' do
    subject { described_class.sanitize(html) }

    context 'with gdocs suggestions' do
      let(:html) do
        <<-HTML
        <tbody>
          <tr>
            <td colspan="2" rowspan="1">
              <p>
                <span>d</span><sup><a href="#cmnt1" id="cmnt_ref1">[a]</a></sup><sup><a href="#cmnt2"
                id="cmnt_ref2">[b]</a></sup><span>ocument-metadata</span><sup><a href="#cmnt3" id="cmnt_ref3">
                [c]</a></sup>
              </p>
            </td>
          </tr>
        </tbody>
        HTML
      end

      it { expect(subject).to_not include('cmnt_ref') }
    end

    context 'with gdocs charts' do
      let(:html) do
        <<-HTML
        <p>
          <span>Using the floor tiles design shown below, create </span>
          <img src="https://www.google.com/chart?cht=tx&amp;chf=bg,s,FFFFFF00&amp;chco=000000&amp;chl=4">
          <span>&nbsp;different ratios related to the image. &nbsp;Describe the ratio relationship, and write the ratio in the form </span>
          <img src="https://www.google.com/chart?cht=tx&amp;chf=bg,s,FFFFFF00&amp;chco=000000&amp;chl=A%3AB" data-pin-nopin="true"><span>&nbsp;or the form </span><img src="https://www.google.com/chart?cht=tx&amp;chf=bg,s,FFFFFF00&amp;chco=000000&amp;chl=A"><span>&nbsp;to </span><img src="https://www.google.com/chart?cht=tx&amp;chf=bg,s,FFFFFF00&amp;chco=000000&amp;chl=B"><span>. </span>
        </p>
        HTML
      end

      it 'replaces gdocs charts' do
        expect(subject).to_not include('www.google')
        expect(subject).to include('chart.googleapis')
      end
    end

    context 'with superscript/subscript' do
      let(:html) do
        <<-HTML
          <p style="padding-top:6pt;margin:0;color:#000000;padding-left:0;font-size:11pt;padding-bottom:6pt;font-family:'Calibri';line-height:1.0833333333333333;text-align:left;padding-right:0"><span style="color:#231f20">10</span><span style="color:#231f20;vertical-align: super">24</span><span style="color:#231f20">&nbsp;stars and 10</span><span style="color:#231f20;vertical-align:sub">80</span><span style="color:#231f20;font-weight:400;text-decoration:none;font-size:11pt;font-family:'Calibri';font-style:normal">&nbsp;atom
          <table>
            <td>
              <p style="padding-top:6pt;margin:0;color:#000000;padding-left:0;font-size:11pt;padding-bottom:6pt;font-family:'Calibri';line-height:1.0833333333333333;padding-right:0"><span style="color:#231f20">10</span><span style="font-style:italic;color:#231f20;vertical-align: sub">23</span><span style="color:#231f20">&nbsp;and 10</span><span style="color:#231f20;vertical-align:super">79</span></p>
            </td>
          </table>
        HTML
      end

      it 'replace sup/sub aligned spans to sup/sub' do
        expect(subject).to include('80</sub>', '79</sup>', '24</sup>', '23</sub>', 'font-style')
        expect(subject).not_to include('vertical-align')
        expect(subject.scan('span').size).to eq 10
        expect(subject.scan('sub').size).to eq 4
        expect(subject.scan('sup').size).to eq 4
      end
    end
  end

  describe '.clean_content' do
    subject { described_class.clean_content(html, opts) }

    context 'not gdoc' do
      let(:opts) { {} }
      let(:html) { '<p></p>' }

      it 'skips it' do
        expect(subject).to eq(html)
      end
    end

    context 'gdoc' do
      let(:opts) { 'gdoc' }
      let(:nested_html) do
        <<-HTML
          <p></p>
          <p><span> </span></p>
          <h4><table/></table></h4>
        HTML
      end
      let(:p_html) do
        <<-HTML
          <p>TEXT</p>
          <p><span> </span></p>
          <h4><table/></table></h4>
        HTML
      end

      context 'with simple html' do
        let(:html) do
          <<-HTML
            <p>NOT EMPTY</p>
            <h4></h4>
            <table/></table>
          HTML
        end

        it 'combines empty elements into 1' do
          expect(subject).to eq('<p>NOT EMPTY</p>')
        end
      end

      context 'with nested html' do
        let(:html) { nested_html }

        it 'collapse elements' do
          expect(subject).to be_empty
        end
      end

      context 'with nested html with p' do
        let(:html) { p_html }

        it 'combines empty elements into 1' do
          expect(subject).to eq('<p>TEXT</p>')
        end
      end

      context 'with several html blocks' do
        let(:html) do
          <<-HTML
            <div>
              #{p_html}
            </div>
            <h4>H4</h4>
            <div>
              #{nested_html}
            </div>
          HTML
        end

        it 'keeps non empty elements' do
          expect(subject.gsub(/\s*/, '')).to eq('<div><p>TEXT</p></div><h4>H4</h4><div></div>')
        end
      end

      context 'with do-not-strip elements first' do
        let(:html) do
          <<-HTML
            <table>
              <td>NOT EMPTY</td>
            </table>
            <p class="do-not-strip u-gdoc-empty-p"></p>
            <p><span> </span></p>
          HTML
        end

        it 'keeps do-not-strip element' do
          table = '<table> <td>NOT EMPTY</td> </table> <p class="do-not-strip u-gdoc-empty-p"></p>'
          expect(subject.gsub(/\s+/, ' ')).to eq table
        end
      end

      context 'with p in ul section' do
        let(:html) do
          <<-HTML
            <p><span>Students will:</span></p>
            <ul>
              <li><p><span><span>Identify the characteristics of fairy tales using literary language and explain the characteristics as they apply to the fairy tale </span></p></li>
              <li><p><span>Prior to listening to </span></p></li>
            </ul>
            <p></p>
            <p>NOT EMPTY</p>
          HTML
        end

        it 'keeps empty p after ul' do
          expect(subject.scan('<p>').size).to eq 5
        end
      end
    end
  end
end
