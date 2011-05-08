module Governor
  class ViewManager
    cattr_reader :flashes
    
    class << self
      @@flashes = {}
      
      # Registers a given partial type at the given path to be displayed a
      # single time.
      #
      # Example:
      #
      #     Governor::ViewManager.flash(:bottom_of_form, 'articles/single_use')
      #
      def flash(type, path)
        @@flashes[type] ||= []
        @@flashes[type] << path
      end
    end
  end
end