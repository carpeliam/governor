require 'spec_helper'

module Governor
  describe Plugin do
    before(:each) do
      @plugin = Plugin.new('test')
      @plugin.register_model_callback do |base|
        def base.test_method
          true
        end
      end
      PluginManager.register @plugin
    end
    it "can add code to the model" do
      class ArticleStub < ActiveRecord::Base
        establish_connection 'nulldb'
        include Article
      end
      ArticleStub.should respond_to :test_method
    end
  end
end