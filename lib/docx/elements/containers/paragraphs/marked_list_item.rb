# encoding: utf-8

module Docx
  module Elements
    module Containers
      # Bulleted list item model
      # @author [kbobykin]
      class MarkedListItem < Paragraph
        attr_accessor :bullet_style, :level
        attr_reader :number
        def initialize(node, document_properties = {})
          super(node, document_properties)
          self.bullet_style = 'ListParagraph'
          self.level = 0
          self.number = 1
        end

        # Writer for bullet style of list item
        # @param value [String] bullet style
        # @return [String] bullet style
        def bullet_style=(value)
          style_node = properties.at_xpath('//w:pStyle') ||
                       Nokogiri::XML::Element.new('//w:pStyle', properties)
          @bullet_style = style_node['w:val'] = value
        end

        # Writer for level option.
        # @param value [Integer] list level
        # @return [Integer] list level
        def level=(value)
          lvl_el = number_props.at_xpath('//w:ilvl') ||
                   Nokogiri::XML::Element.new('//w:numPr', number_props)
          @level = lvl_el['w:ilvl'] = value
        end

        private

        # Writer for number option
        # @param value [Integer] number
        # @return [Integer] number
        def number=(value)
          lvl_el = number_props.at_xpath('//w:numId') ||
                   Nokogiri::XML::Element.new('//w:numPr', number_props)
          @number = lvl_el['w:val'] = value
        end

        # Returns element of number properties contener
        # @return [Nokogiri::XML::Node] properties container
        def number_props
          properties.at_xpath('//w:numPr') ||
            Nokogiri::XML::Node.new('//w:numPr', properties)
        end
      end
    end
  end
end
