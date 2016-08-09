# encdoing: utf-8

module Docx
  module Elements
    module Containers
      class MarkedListItem < Paragraph
        def initialize(node, document_properties = {})
          super(node, document_properties)
          properties
        end
      end
    end
  end
end
