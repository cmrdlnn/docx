module Docx
  module Elements
    module Containers
      class Container < Elements::Element
        # Relation methods
        # TODO: Create a properties object, include Element
        def properties
          @node.at_xpath("//w:#{@properties_tag}") || create_properties
        end

        # Erase text within an element
        def blank!
          @node.xpath('.//w:t').each { |t| t.content = '' }
        end

        def remove!
          @node.remove
        end

        protected

        def create_properties
          Nokogiri::XML::Node.new("w:#{@properties_tag}", @node)
        end

        class << self
          def create_with(element)
            # Need to somehow get the xml document accessible here by default, but this is alright in the interim
            new(Nokogiri::XML::Node.new("w:#{tag}", element.node))
          end
        end
      end
    end
  end
end

Dir["#{__dir__}/containers/*.rb"].each do |contaner|
  require contaner
end
