require 'governor/rails/routes'

module Governor
  # Standard <code>Rails::Engine</code>.
  class Engine < ::Rails::Engine
    config.to_prepare do
      ActionController::Base.helper(GovernorApplicationHelper)
    end
  end
end