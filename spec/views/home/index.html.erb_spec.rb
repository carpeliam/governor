require 'spec_helper'

describe "home/index.html.erb" do
  it "includes the helper" do
    view.should respond_to(:governor_header)
  end
end