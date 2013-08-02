#
# List servers and vagrants seperately. Both will be merged to create stages.
# e.g.:
# @user_configuration["servers"] = ["example1","example2"]
# @user_configuration["vagrants"] = ["vexample1","vexample2"]
#

@project_name = "my-server"

@user_configuration["servers"]    = ["example"]
#@user_configuration["vagrants"]   = ["vexample"]
