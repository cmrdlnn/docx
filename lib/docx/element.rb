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
        @node.at_xpath("./parent::#{type}")
      end

      # Get parent paragraph of element
      def parent_paragraph
        return self if is_a?(Elements::Containers::Paragraph)
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

      # Inserts several paragraphs instead of the paragraph in which the element
      # is located or, if the second argument is specified, then before or after
      # it
      #
      # @params [Array<String>] text_array
      #   array of strings that will be insert into text of new paragraphs
      #
      # @params [Boolean] before_or_after
      #   if present, then indicates whether it is necessary to insert
      #   paragraphs before or after the current. Set the true value if you want
      #   to insert paragraphs before the current one and, accordingly, a false
      #   value if after
      #
      # @params [Regex, String] pattern
      #   helps to replace some part of text of paragraph if it's necessary
      #
      # @return [Array]
      #   array of new paragraphs
      #
      def insert_multiple_lines(text_array, before_or_after = nil, pattern = nil)
        return [] if text_array.nil? || text_array.empty?

        paragraph = parent_paragraph
        original = paragraph.copy
        start_point = 0
        result = []

        if before_or_after.nil?
          paragraph.process_text(text_array.first, pattern)
          result << paragraph
          start_point += 1
        end

        (start_point..text_array.size - 1).each_with_object(result) do |i, memo|
          paragraph = if before_or_after
                        original.copy.insert_before(paragraph)
                      else
                        original.copy.insert_after(paragraph)
                      end
          paragraph.process_text(text_array[i], pattern)
          memo << paragraph
        end
      end

      # Remove or replace text from paragraph
      def process_text(str, pattern)
        self.text = pattern.nil? ? str : text.sub(pattern, str)
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
          # Need to somehow get the xml document accessible here by default, but
          # this is alright in the interim
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
