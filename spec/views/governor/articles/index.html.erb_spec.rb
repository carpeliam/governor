require 'spec_helper'

module Governor
  describe "governor/articles/index.html.erb" do
    it "can render plugin partials" do
      view.should respond_to(:render_plugin_partial)
    end
  end
end