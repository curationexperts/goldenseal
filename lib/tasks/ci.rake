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
    sh('wget https://s3-us-west-2.amazonaws.com/washington-u/sample-assets.tgz')
    sh('tar zxfv sample-assets.tgz')
    sh('script/import -t text -p sample-assets/text')
    sh('script/import -t video -p sample-assets/video')
    sh('script/import -t image -p sample-assets/image')
  end
end
