# Any code below will be evaluated/executed within the scope of the caller.

# How to reference the author of an article
Governor.author = Proc.new do
  if defined?(Devise)
    send("current_#{Devise.default_scope}")
  elsif respond_to?(:current_user)
    current_user
  else
    raise "Please define Governor.author. Run `rails generator governor:configure` to install an initializer."
  end
end

# Rules for authorizing a particular action on a particular article
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

# What should Governor do if someone tries to do something they weren't
# authorized to do?
Governor.if_not_allowed do
  if defined?(Devise)
    send("authenticate_#{Devise.default_scope}!")
  elsif respond_to?(:deny_access)
    deny_access
  else
    redirect_to :root
  end
end