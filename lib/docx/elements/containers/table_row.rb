module Docx
  module Elements
    module Containers
      class TableRow < Container
        def self.tag
          'tr'
        end

        def initialize(node)
          @node = node
          @properties_tag = ''
        end

        # Array of cells contained within row
        def cells
          @node.xpath('w:tc').map { |c_node| Containers::TableCell.new(c_node) }
        end

        def add_cell(text = '')
          tc = TableCell.create_within(self)
          p = Paragraph.create_within(tc)
          p.text = text
          tc
        end
      end
    end
  end
end
