class AddPostgresExtensions < ActiveRecord::Migration[8.0]
  def change
    enable_extension "cube" unless extension_enabled?("cube")
    enable_extension "earthdistance" unless extension_enabled?("earthdistance")
  end
end
