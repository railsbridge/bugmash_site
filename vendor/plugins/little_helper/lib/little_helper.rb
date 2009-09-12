module LittleHelper
  def title(*args)
    options = args.extract_options!
    options.reverse_merge!(:separator => ' &mdash; ')
    if args.first.present?
      @_title = args.first
    else
      "<title>" +
      "#{h(options[:reverse] ? @_title : options[:site])}" +
      "#{options[:separator] if @_title && options[:site]}" +
      "#{h(options[:reverse] ? options[:site] : @_title)}" +
      "</title>"
    end
  end

  def stylesheet(*args)
    @content_for_head ||= ''
    @content_for_head << stylesheet_link_tag(*args)
  end

  def javascript(*args)
    @content_for_head ||= ''
    @content_for_head << javascript_include_tag(*args)
  end

  def tab(text, url, options={})
    output = '<li'
    unless @_active # an active tab is already found
      if current_page? url
        @_active = true
        output << ' class="active"'
      else
        yield if block_given?
        output << ' class="active"' if @_active
      end
    end
    output << '>'
    output << link_to_unless_current(text, url, options)
    output << '</li>'
  end

  def child(url)
    unless @_active
      @_active = true if current_page? url
    end
  end
end
