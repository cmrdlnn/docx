# encoding: utf-8

module Docx
  module Elements
    class Element
      attr_accessor :node
      delegate :at_xpath, :xpath, to: :@node

      def initialize(node)
        @node = node
      end

      # TODO: Should create a docx object from this
      def parent(type = '*')
        @node.at_xpath("//parent::#{type}")
      end

      # Get parent paragraph of element
      def parent_paragraph
        Elements::Containers::Paragraph.new(parent('w:p'))
      end

      # Insertion methods
      # Insert node as last child
      def append_to(element)
        @node = element.node.add_child(@node)
        self
      end

      # Insert node as first child (after properties)
      def prepend_to(element)
        @node = element.node.properties.add_next_sibling(@node)
        self
      end

      def insert_after(element)
        # Returns newly re-parented node
        @node = element.node.add_next_sibling(@node)
        self
      end

      def insert_before(element)
        @node = element.node.add_previous_sibling(@node)
        self
      end

      # Creation/edit methods
      def copy
        self.class.new(@node.dup)
      end

      # A method to wrap content in an HTML tag.
      # Currently used in paragraph and text_run for the to_html methods
      #
      # content:: The base text content for the tag.
      # styles:: Hash of the inline CSS styles to be applied. e.g.
      #          { 'font-size' => '12pt', 'text-decoration' => 'underline' }
      #
      def html_tag(name, options = {})
        content = options[:content]
        styles = options[:styles]

        html = "<#{name}"
        unless styles.nil? || styles.empty?
          styles_array = []
          styles.each do |property, value|
            styles_array << "#{property}:#{value};"
          end
          html << " style=\"#{styles_array.join('')}\""
        end
        html << '>'
        html << content if content
        html << "</#{name}>"
      end

      class << self
        def create_with(element, tag = nil)
          # Need to somehow get the xml document accessible here by default, but this is alright in the interim
          new(Nokogiri::XML::Element.new("w:#{tag || self.tag}", element.node))
        end

        def create_within(element, tag = nil)
          new_element = create_with(element, tag)
          new_element.append_to(element)
          new_element
        end
      end
    end
  end
end

Dir["#{__dir__}/elements/*.rb"].each do |element|
  require element
end
