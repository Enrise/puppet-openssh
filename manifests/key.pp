# = Class: openssh::key
#
# This is the openssh key class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*username*]
#   Optional. The name of the user the keys are generated for. Ownership of the
#   keys will be granted to this user. If no usenrame is specified it will be
#   derived from the name of the resource.
#
# [*dir*]
#   Optional. The name of the directory where the keys should be installed. If
#   no directory is specified a default of /home/$username/.ssh will be used.
#
# [*server_path*]
#   Optional. The absolute path on the server where the keys should be stored.
#   This path must be made available through the built-in fileserver in order to
#   serve the ssh keys to the puppet agent.
#
# [*source_dir*]
#   Optional. The path from which the puppet agent can retrieve the keys. If no
#   path is specified a default of puppet:///private/ssh/$username will be used.
#
#
define openssh::key (
  $username    = null,
  $dir         = null,
  $server_path = null,
  $source_dir  = null,
) {

  /* Determine values to work with. Use sane defaults if necessary */
  if($username == null) {
    $def_username = $name
  } else {
    $def_username = $username
  }

  if ($source_dir == null) {
    $def_source_dir = "puppet:///private/ssh/${def_username}"
  } else {
    $def_source_dir = $source_dir
  }

  if ($server_path == null) {
     $def_server_path = "/etc/puppet/files/private/${::fqdn}/ssh/${def_username}"
  } else {
    $def_server_path = $server_path
  }

  if($dir == null) {
    $def_dir = "/home/${def_username}/.ssh"
  } else {
    $def_dir = $dir
  }


  /* Generate the keys on the server side, and ship them to the client. */

  $module_dir = get_module_path('openssh')
  if generate("${module_dir}/scripts/generate_keys.sh", $def_server_path) {

    file { $def_dir:
      ensure   => directory,
      owner    => $def_username,
      group    => $def_username,
      require  => User[ $def_username ],
    }

    file { "${def_dir}/ssh_host_dsa_key":
      ensure  => file,
      owner   => $def_username,
      group   => $def_username,
      mode    => '0644',
      source  => "${def_source_dir}/ssh_host_dsa_key.pub",
      require => File [ $def_dir ],
    }

    file { "${def_dir}/ssh_host_dsa_key.pub":
      ensure  => file,
      owner   => $def_username,
      group   => $def_username,
      mode    => '0644',
      source  => "${def_source_dir}/ssh_host_dsa_key.pub",
      require => File [ $def_dir ],
    }

    file { "${def_dir}/ssh_host_key":
      ensure  => file,
      owner   => $def_username,
      group   => $def_username,
      mode    => '0644',
      source  => "${def_source_dir}/ssh_host_key",
      require => File [ $def_dir ],
    }

    file { "${def_dir}/ssh_host_key.pub":
      ensure  => file,
      owner   => $def_username,
      group   => $def_username,
      mode    => '0644',
      source  => "${def_source_dir}/ssh_host_key.pub",
      require => File [ $def_dir ],
    }

    file { "${def_dir}/ssh_host_rsa_key":
      ensure  => file,
      owner   => $def_username,
      group   => $def_username,
      mode    => '0644',
      source  => "${def_source_dir}/ssh_host_rsa_key",
      require => File [ $def_dir ],
    }

    file { "${def_dir}/ssh_host_rsa_key.pub":
      ensure  => file,
      owner   => $def_username,
      group   => $def_username,
      mode    => '0644',
      source  => "${def_source_dir}/ssh_host_rsa_key.pub",
      require => File [ $def_dir ],
    }

  }

}
