namespace :mine do
  desc "Migrate all databases to the latest"
  task migrate_all: :environment do
    %w[development test].each do |env_instance|
      Rails.env = env_instance.to_s
      Rake::Task['db:migrate'].invoke
    end
  end

end
