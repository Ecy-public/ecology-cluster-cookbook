# rubocop:disable Style/FileName
# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://github.com/opscode/chef-dk/blob/master/POLICYFILE_README.md

# A name that describes what the system you're building with Chef does.
name 'ecology-cluster'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'ecology-cluster::default'

# Specify a custom source for a single cookbook:
cookbook 'ecology-cluster', path: '.'
cookbook 'slurm', git: 'https://github.com/EMSL-MSC/slurm-cookbook.git'
