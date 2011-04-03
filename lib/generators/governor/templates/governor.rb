# Any code below will be evaluated/executed within the scope of the caller.

GOVERNOR_AUTHOR = Proc.new do
  if respond_to?(:current_user)
    current_user
  else
    raise "Set up GOVERNOR_AUTHOR in #{File.expand_path(__FILE__)}"
  end
end

Governor.authorize_if do |action, article|
  case action.to_sym
  when :new, :create
    if respond_to?(:user_signed_in?)
      user_signed_in?
    else
      raise "Set up Governor.authorize_if in #{File.expand_path(__FILE__)}"
    end
  when :edit, :update, :destroy
    article.author == instance_eval(&GOVERNOR_AUTHOR)
  else
    raise ArgumentError.new('action must be new, create, edit, update, or destroy')
  end
end
