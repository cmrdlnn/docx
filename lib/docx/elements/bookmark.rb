module Docx
  module Elements
    class Bookmark < Element
      attr_accessor :name

      def self.tag
        'bookmarkStart'
      end

      def initialize(node)
        @node = node
        @name = @node['w:name']
      end

      # Insert text before bookmarkStart node
      def insert_text_before(text)
        text_run = get_run_after
        text_run.text = "#{text}#{text_run.text}"
      end

      # Insert text after bookmarkStart node
      def insert_text_after(text)
        text_run = get_run_before
        text_run.text = "#{text_run.text}#{text}"
      end

      # Get text run immediately prior to bookmark node
      def get_run_before
        # at_xpath returns the first match found and preceding-sibling returns siblings in the
        # order they appear in the document not the order as they appear when moving out from
        # the starting node
        if !(r_nodes = @node.xpath('./preceding-sibling::w:r')).empty?
          r_node = r_nodes.last
          Containers::Run.new(r_node)
        else
          new_r = Containers::Run.create_with(self)
          new_r.insert_before(self)
          new_r
        end
      end

      # Get text run immediately after bookmark node
      def get_run_after
        if (r_node = @node.at_xpath('./following-sibling::w:r'))
          Containers::Run.new(r_node)
        else
          new_r = Containers::Run.create_with(self)
          new_r.insert_after(self)
          new_r
        end
      end
    end
  end
end
