default['slurm']['slurm']['config']\
       ['SlurmctldPidFile'] = '/var/run/slurmctld.pid'
default['slurm']['slurm']['config']\
       ['SlurmdPidFile'] = '/var/run/slurmd.pid'
default['slurm']['mungekey']['type'] = 'databag'
default['slurm']['buildit'] = false
default['slurm']['checksum'] = '9381db4eb452ce1bb660f46dfcbe6197'\
                               '5aaf31dde05847afd8fb05c089d1449f'
override['slurm']['version'] = '15.08.8'
override['slurm']['outputdir'] = '/var/www/html/slurm-rpms'
