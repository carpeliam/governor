require 'governor/plugin'
require 'governor/plugin_manager'
require 'governor/view_manager'
require 'governor/article'
require 'governor/formatters'
require 'governor/mapping'

require 'governor/controllers/helpers'
require 'governor/controllers/methods'

require 'governor/rails'


module Governor
  @@resources = {}
  mattr_reader :resources, :default_resource, :authorization_rules
  
  # Specifies the action that should occur if an unpermitted action is
  # attempted. Usually specified within the initializer, though evaluated in
  # the scope of a Rails session. If not defined, the default is to redirect
  # to the root path.
  #
  # Example:
  #
  #     Governor.if_not_allowed do
  #       if respond_to?(Devise)
  #         send("authenticate_#{Devise.default_scope}!")
  #       else
  #         raise ArgumentError.new("Set up Governor.if_not_allowed in #{File.expand_path(__FILE__)}")
  #       end
  #     end
  #
  mattr_accessor :if_not_allowed
  Governor.if_not_allowed do
    if defined?(Devise)
      send("authenticate_#{Devise.default_scope}!")
    elsif respond_to?(:deny_access)
      deny_access
    else
      redirect_to :root
    end
  end
  
  # Specifies how to reference the author of an article. Usually specified
  # within the initializer, though evaluated in the scope of a Rails session.
  #
  # Example:
  #
  #     Governor.author = Proc.new do
  #       if respond_to?(:current_user)
  #         current_user
  #       else
  #         raise "Set up Governor.author in #{File.expand_path(__FILE__)}"
  #       end
  #     end
  #
  mattr_accessor :author
  Governor.author = Proc.new do
    if defined?(Devise)
      send("current_#{Devise.default_scope}")
    elsif respond_to?(:current_user)
      current_user
    else
      raise "Please define Governor.author. Run `rails generator governor:configure` to install an initializer."
    end
  end
  
  # Maps a given resource name with a pair of options, to be supplied as
  # arguments to the routes. Usually called from within +governate+.
  def self.map(resource, options = {})
    @@default_resource ||= self.resources[resource] = Governor::Mapping.new(resource, options)
  end
  
  # Supply a set of rules that describe what the requirements are to perform a
  # given Governor-related action on a given article. Usually specified within
  # the initializer, though evaluated in the scope of a Rails session.
  #
  # Example (from the generated initialization file):
  #
  #     Governor.authorize_if do |action, article|
  #       case action.to_sym
  #       when :new, :create
  #         if respond_to?(:user_signed_in?)
  #           user_signed_in?
  #         else
  #           raise "Set up Governor.authorize_if in #{File.expand_path(__FILE__)}"
  #         end
  #       when :edit, :update, :destroy
  #         article.author == instance_eval(&Governor.author)
  #       else
  #         raise ArgumentError.new('action must be new, create, edit, update, or destroy')
  #       end
  #     end
  #
  def self.authorize_if(&blk)
    @@authorization_rules = blk
  end
  Governor.authorize_if do |action, article|
    case action.to_sym
    when :new, :create
      if defined?(Devise) && respond_to?("#{Devise.default_scope}_signed_in?")
        send("#{Devise.default_scope}_signed_in?")
      elsif respond_to?(:signed_in?)
        signed_in?
      elsif respond_to?(:current_user)
        current_user.present?
      else
        raise "Please define Governor.authorize_if. Run `rails generator governor:configure` to install an initializer."
      end
    when :edit, :update, :destroy
      article.author == instance_eval(&Governor.author)
    else
      raise ArgumentError.new('action must be new, create, edit, update, or destroy')
    end
  end
end