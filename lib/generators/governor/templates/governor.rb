GOVERNOR_AUTHOR = Proc.new do
  if respond_to?(:current_user)
    current_user
  else
    raise "Set up GOVERNOR_AUTHOR in #{__FILE__}"
  end
end

Governor.authorize_if do |article, action|
  case action.to_sym
  when :new, :create then user_logged_in?
  when :edit, :update, :destroy
    article.author == GOVERNOR_AUTHOR.call
  else
    raise ArgumentError.new('action must be new, create, edit, update, or destroy')
  end
end

