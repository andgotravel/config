require 'yaml'
require 'erb'

module Config
  module Sources
    class YAMLSource
      attr_accessor :path

      def initialize(path, section_path=nil)
        @path = path
        @section_path = section_path
      end

      # returns a config hash from the YML file
      def load(include_filename_as_section: false)
        if @path and File.exist?(@path.to_s)
          result = YAML.load(ERB.new(IO.read(@path.to_s)).result)
        end

        return {} unless result
        byebug
        if @section_path
          # result = { File.basename(@path.to_s, '.*') => result }
      	  # dir = File.dirname(@path).split('/')
      	  # dir.delete('config')
      	  # dir.reverse.inject(result) { |h, s|  {s => h}  }
          @section_path.split('/')
                       .reverse
                       .inject(result) { |h, s| { s => h } }

        else
          result
        end
      rescue Psych::SyntaxError => e
        raise "YAML syntax error occurred while parsing #{@path}. " \
              "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
              "Error: #{e.message}"
      end
    end
  end
end
