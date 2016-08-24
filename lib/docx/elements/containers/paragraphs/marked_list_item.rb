# encoding: utf-8

module Docx
  module Elements
    module Containers
      # Bulleted list item model
      # @author [kbobykin]
      class MarkedListItem < Paragraph
        attr_accessor :bullet_style, :level
        attr_reader :number
        def initialize(node, number, document_properties = {})
          super(node, document_properties)
          self.bullet_style = 'ListParagraph'
          self.level = 0
          self.number = number
        end

        # Writer for bullet style of list item
        # @param value [String] bullet style
        # @return [String] bullet style
        def bullet_style=(value)
          style_node = Container.new(properties).child('pStyle') ||
                       Element.create_within(Container.new(properties), 'pStyle').node
          @bullet_style = style_node['w:val'] = value
        end

        # Writer for level option.
        # @param value [Integer] list level
        # @return [Integer] list level
        def level=(value)
          lvl_el = Container.new(number_props).child('ilvl') ||
                   Element.create_within(Container.new(number_props), 'ilvl').node
          @level = lvl_el['w:val'] = value
        end

        # Writer for number option
        # @param value [Integer] number
        # @return [Integer] number
        def number=(value)
          lvl_el = Container.new(number_props).child('numId') ||
                   Element.create_within(Container.new(number_props), 'numId').node
          @number = lvl_el['w:val'] = value
        end

        private

        # Returns element of number properties contener
        # @return [Nokogiri::XML::Node] properties container
        def number_props
          Container.new(properties).child('numPr') ||
            Container.create_within(Container.new(properties), 'numPr').node
        end
      end
    end
  end
end
