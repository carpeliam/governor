module Governor
  # heavily based on Feather[https://github.com/mleung/feather]
  module Formatters
    class << self
      ##
      # Registers a block to format article content
      def register_formatter(name, &block)
        @formatters ||= {'default' => default_formatter}
        raise "Formatter `#{name}` already registered!" unless @formatters[name].nil?
        @formatters[name] = block
      end

      ##
      # Returns an array of available formatters that have been registered
      def available_formatters
        @formatters ||= {'default' => default_formatter}
        return @formatters
      end

      ##
      # Returns a default formatter used for replacing line breaks within text
      # This is the only formatter included within Governor
      def default_formatter
        Proc.new do |text|
          text.to_s.gsub("\r\n", "\n").gsub("\n", '<br>')
        end
      end

      ##
      # Performs the relevant formatting for the article, and returns the formatted article content
      def format_article(article)
        format_text(article.format, article.post)
      end

      ##
      # Performs the requested formatting, returning the formatted text
      def format_text(formatter, text)
        formatter = 'default' unless available_formatters.include?(formatter)
        @formatters[formatter].call(text).html_safe
      end
    end
  end
end
