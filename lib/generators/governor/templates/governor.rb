# Any code below will be evaluated/executed within the scope of the caller.

# How to reference the author of an article
Governor.author = Proc.new do
  if respond_to?(:current_user)
    current_user
  else
    raise "Set up Governor.author in #{File.expand_path(__FILE__)}"
  end
end

# Rules for authorizing a particular action on a particular article
Governor.authorize_if do |action, article|
  case action.to_sym
  when :new, :create
    if respond_to?(:user_signed_in?)
      user_signed_in?
    else
      raise "Set up Governor.authorize_if in #{File.expand_path(__FILE__)}"
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
  if respond_to?(Devise)
    send("authenticate_#{Devise.default_scope}!")
  else
    raise ArgumentError.new("Set up Governor.if_not_allowed in #{File.expand_path(__FILE__)}")
  end
end