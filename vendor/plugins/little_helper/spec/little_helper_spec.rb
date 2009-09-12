require File.join(File.dirname(__FILE__), 'spec_helper')

describe LittleHelper do
  include LittleHelper
  include ActionView::Helpers
  include ERB::Util

  describe '#title' do
    context 'called without options' do
      it 'should store the title for later use' do
        title 'foo'
        @_title.should == 'foo'
      end

      it 'should return the title' do
        title('foo').should == 'foo'
      end
    end

    context 'called with options' do
      it 'should return title tag with page title only when called with no :site option' do
        title 'foo'
        title.should == '<title>foo</title>'
      end

      it 'should return title tag with site name only when no title was previously set' do
        title(:site => 'bar').should == '<title>bar</title>'
      end

      it 'should return title tag with site name and page title when both are set' do
        title 'foo'
        title(:site => 'bar').should == '<title>bar &mdash; foo</title>'
      end

      it 'should reverse the site name and page title when :reverse option is specified' do
        title 'foo'
        title(:site => 'bar', :reverse => true).should == '<title>foo &mdash; bar</title>'
      end

      it 'should use :separator option to separate site name and page title' do
        title 'foo'
        title(:site => 'bar', :separator => ' &bull; ').should == '<title>bar &bull; foo</title>'
      end
    end
  end

  describe '#stylesheet' do
    it 'should link to the given stylesheets' do
      stylesheet 'foo', 'bar'
      stylesheet 'baz'
      @content_for_head.should == stylesheet_link_tag('foo', 'bar') + stylesheet_link_tag('baz')
    end
  end

  describe '#javascript' do
    it 'should include the given javascripts' do
      javascript 'foo', 'bar'
      javascript 'baz'
      @content_for_head.should == javascript_include_tag('foo', 'bar') + javascript_include_tag('baz')
    end
  end

  describe '#tab' do
    context 'without children' do
      context 'when the tab links to the current page' do
        it 'should mark the tab as active and not link to the url' do
          stub!(:current_page?).with('/foo').and_return(true)
          tab('Foo', '/foo').should == '<li class="active">Foo</li>'
        end
      end

      context 'when the tab does not link to the current page' do
        it 'should mark the tab as inactive and link to the url' do
          stub!(:current_page?).with('/foo').and_return(false)
          tab('Foo', '/foo').should == '<li><a href="/foo">Foo</a></li>'
        end
      end
    end

    context 'with children' do
      context 'when one of the children is the current page' do
        it 'should mark the tab as active and link to the url' do
          stub!(:current_page?).with('/foo').and_return(false)
          stub!(:current_page?).with('/bar').and_return(true)
          stub!(:current_page?).with('/baz').and_return(false)
          tab('Foo', '/foo') do
            child '/bar'
            child '/baz'
          end.should == '<li class="active"><a href="/foo">Foo</a></li>'
        end
      end

      context 'when neither the tab itself nor one of the children is the current page' do
        it 'should mark the tab as inactive and link to the url' do
          stub!(:current_page?).with('/foo').and_return(false)
          stub!(:current_page?).with('/bar').and_return(false)
          stub!(:current_page?).with('/baz').and_return(false)
          tab('Foo', '/foo') do
            child '/bar'
            child '/baz'
          end.should == '<li><a href="/foo">Foo</a></li>'
        end
      end
    end

    it 'should accept the same options as link_to_unless_current' do
      stub!(:current_page?).with('/foo').and_return(false)
      tab('Foo', '/foo', :class => 'foo', :id => 'foo').should == '<li><a href="/foo" class="foo" id="foo">Foo</a></li>'
    end
  end
end
