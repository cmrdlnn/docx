module Docx
  module Elements
    class Text < Element
      delegate :content, :content=, to: :@node

      def self.tag
        't'
      end
    end
  end
end
