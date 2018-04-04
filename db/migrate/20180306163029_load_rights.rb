class LoadRights < ActiveRecord::Migration
  def change
    Rake::Task['data:rights'].invoke
  end
end
