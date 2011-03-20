# much love to Feather, borrowed from Merb
module Governor
  module Formatters
    class << self
      ##
      # This registers a block to format article content
      def register_formatter(name, &block)
        @formatters ||= {"default" => default_formatter}
        raise "Formatter `#{name}` already registered!" unless @formatters[name].nil?
        @formatters[name] = block
      end

      ##
      # This returns an array of available formatters that have been registered
      def available_formatters
        @formatters ||= {"default" => default_formatter}
        return @formatters
      end

      ##
      # This returns a default formatter used for replacing line breaks within text
      # This is the only formatter included within Blugg
      def default_formatter
        Proc.new do |text|
          text.gsub("\r\n", "\n").gsub("\n", "<br />")
        end
      end

      ##
      # This performs the relevant formatting for the article, and returns the formatted article content
      def format_article(article)
        format_text(article.format, article.post)
      end

      ##
      # This performs the requested formatting, returning the formatted text
      def format_text(formatter, text)
        formatter = "default" unless available_formatters.include?(formatter)
        @formatters[formatter].call(text)
      end
    end
  end
end
