# Warning Namespace
namespace :warning do
  desc "Show a warning if running against a Production {stage}"
  task :warning do
    # This might be useful for Production stages
    logger.log(0,"*\n*\n*\n*\t\t\t!!  W A R N I N G  !!\n*\n*\t\tYou are about to run a POTENTIALLY DESTRUCTIVE action on #{stage.upcase}.\n*\n*\t\tIf you did not intend to do this, press CTRL + C now.\n*\n*\n*")
    sleep 5
  end
end
