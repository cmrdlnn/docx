module Docx
  class HeaderFooter
    attr_reader :id, :filename, :type, :content

    def initialize(id, filename, type, content)
      @id = id
      @filename = filename
      @type = type
      @content = content
    end

    def paragraphs
      content.xpath("//#{root_tag}//w:p").map do |p_node|
        Elements::Containers::Paragraph.new(p_node)
      end
    end

    class << self
      def extract(zip, references)
        doc_refs = Nokogiri::XML(zip.read('word/_rels/document.xml.rels'))
        references[:list].map do |ref|
          attributes = ref.attributes
          filename = relationships(doc_refs, attributes['id']).attr('Target').value

          classname_by_string(references[:type]).new(
            attributes['id'],
            filename,
            attributes['type'],
            Nokogiri::XML(zip.read("word/#{filename}"))
          )
        end
      end

      private_class_method

      def relationships(doc, id)
        doc.xpath(
          "xmlns:Relationships/xmlns:Relationship[@Id='#{id}']",
          xmlns: 'http://schemas.openxmlformats.org/package/2006/relationships'
        )
      end

      def classname_by_string(type)
        type == 'header' ? Header : Footer
      end
    end
  end
end
