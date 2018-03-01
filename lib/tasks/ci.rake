#require 'jettywrapper'

#desc "Run the ci build"
#task ci: ['jetty:clean', 'jetty:config'] do
#  jetty_params = Jettywrapper.load_config
#  Jettywrapper.wrap(jetty_params) do
#    # run the tests
#    Rake::Task["spec"].invoke
#  end
#end
namespace :ci do
  desc 'loads some sample data for review branches'
  task :load_sample do
    sh('[ -e sample-assets.tgz ] && rm sample-assets.tgz')
    sh('wget https://s3-us-west-2.amazonaws.com/washington-u/sample-assets.tgz')
    sh('tar zxfv sample-assets.tgz')
    sh('su -c "script/import -t text -p sample-assets/text" app')
    sh('su -c "script/import -t video -p sample-assets/video" app')
    sh('su -c "script/import -t image -p sample-assets/image" app')
  end
end
