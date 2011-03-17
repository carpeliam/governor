module Governor
  class Create<%= model_name.pluralize %> < ActiveRecord::Migration
    def self.up
      create_table :<%= table_name %> do |t|
        t.string      :title, :description
        t.string      :format, :default => 'default'
        t.text        :post
        t.references  :author, :polymorphic => true
        t.timestamps
      end
    end

    def self.down
      drop_table :<%= table_name %>
    end
  end
end