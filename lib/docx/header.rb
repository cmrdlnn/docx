module Docx
  class Header < HeaderFooter
    # return top-level tag in header XML file
    def root_tag
      'w:hdr'
    end
  end
end
