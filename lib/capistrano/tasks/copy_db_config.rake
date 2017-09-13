namespace "deploy" do
  desc "Copy production db config to current deployment"
  task :copy_db_config do
    base_dir = "/home/ubuntu/deploy/depot"
    on roles(:web) do
      info execute "cat #{base_dir}/shared/production_database.yml >> #{base_dir}/current/config/database.yml"
    end
  end
end
before "deploy:published", "deploy:copy_db_config"
