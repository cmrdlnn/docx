module Docx
  class Footer < HeaderFooter
    # return top-level tag in footer XML file
    def root_tag
      'w:ftr'
    end
  end
end
