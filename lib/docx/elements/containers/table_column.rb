module Docx
  module Elements
    module Containers
      class TableColumn < Container
        def self.tag
          'w:gridCol'
        end

        def initialize(cell_nodes)
          @node = ''
          @properties_tag = ''
          @cells = cell_nodes.map { |c_node| Containers::TableCell.new(c_node) }
        end

        # Array of cells contained within row
        attr_reader :cells
      end
    end
  end
end
