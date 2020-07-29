node default {
  include vault
  $secret = vault::secret_field('test1', 'token')
  file { '/etc/secrets/data_from_function':
    ensure  => file,
    content => $secret
  }
}
