module Solargraph
  module Pin
    module Conversions
      # @return [Hash]
      def completion_item
        {
          label: name,
          kind: kind,
          detail: completion_item_detail,
          data: {
            path: path,
            return_type: return_type,
            location: location
          }
        }
      end

      # @return [Hash]
      def resolve_completion_item
        extra = {}
        alldoc = ''
        alldoc += link_documentation(path) unless path.nil?
        alldoc += "\n\n" unless alldoc.empty?
        alldoc += documentation unless documentation.nil?
        extra[:documentation] = alldoc unless alldoc.empty?
        completion_item.merge(extra)
      end

      # @todo Candidate for deprecation
      # @param api_map [Solargraph::ApiMap]
      def hover
        info = ''
        if self.kind_of?(Solargraph::Pin::BaseVariable)
          info.concat link_documentation(return_type) unless return_type.nil?
        else
          info.concat link_documentation(path) unless path.nil?
        end
        info.concat "\n\n#{documentation}"
        info
      end

      # @return [Hash]
      def signature_help
        {
          label: name + '(' + arguments.join(', ') + ')',
          documentation: documentation
        }
      end

      private

      def completion_item_detail
        detail = ''
        detail += "(#{parameters.join(', ')}) " unless parameters.empty?
        detail += "=> #{return_type}" unless return_type.nil?
        return nil if detail.empty?
        detail
      end

      def link_documentation path
        uri = "solargraph:/document?query=" + URI.encode(path)
        "[#{path}](#{uri})"
      end  
    end
  end
end
