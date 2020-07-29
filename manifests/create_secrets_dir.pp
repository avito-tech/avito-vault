# Управляет директорией `/etc/secrets/`
# @summary Управляет директорией `/etc/secrets/`
# @api private
class vault::create_secrets_dir {
  file { '/etc/secrets':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0644',
    recurse => true,
    purge   => true,
    force   => true,
  }
}
