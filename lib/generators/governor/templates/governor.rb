GOVERNOR_AUTHOR = Proc.new do |actor|
  if actor.respond_to?(:current_user)
    actor.current_user
  else
    raise "Set up GOVERNOR_AUTHOR in #{File.expand_path(__FILE__)}"
  end
end

Governor.authorize_if do |actor, action, article|
  case action.to_sym
  when :new, :create
    # if respond_to?(:user_signed_in?)
      actor.user_signed_in?
    # else
    #   raise "Set up Governor.authorize_if in #{File.expand_path(__FILE__)}"
    # end
  when :edit, :update, :destroy
    article.author == GOVERNOR_AUTHOR.call(actor)
  else
    raise ArgumentError.new('action must be new, create, edit, update, or destroy')
  end
end
