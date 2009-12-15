module JavascriptsHelper

  def create_template(header, footer, &block)
    # Get the data from the block 
    data = capture(&block)
    res = header + data + footer

    # Use concat method to pass text back to the view 
    concat(res)
  end
  
  def javascript(&block)
    a = '<script type="text/javascript">' + \
        '// <![CDATA['
    b = '// ]]>' + \
        '</script>'
    content_for(:javascript) { create_template(a, b, &block) }
  end

  def javascript_files(&block)
    content_for(:javascript) { capture(&block) }
  end
  
  # Adds a javascript file to the header
  def javascript_file(*files)
    content_for(:javascript) { javascript_include_tag(*files) }
  end
  
  def javascript_onload(&block)
    content_for(:javascript_onload) { capture(&block) }
  end
  
  def javascript_onloads(onloads)
    return "" if onloads.blank?
    a = '<script type="text/javascript">' + \
#        '// <![CDATA[' + \
        '$(function(){'
    b = '});' + \
#        '// ]]>' + \
        '</script>'
    return a+onloads+b
  end
end