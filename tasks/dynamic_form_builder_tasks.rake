namespace :dynamic_form_builder do
  desc "Sync extra files from dynamic_form_builder plugin."
  task :sync do
    system "rsync -ruv vendor/plugins/dynamic_form_builder/db/migrate db"
  end
end