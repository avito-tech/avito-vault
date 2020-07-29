# Создаёт сертификат и ключ к нему. Расширение указывать не нужно.
#
# @summary Создаёт сертификат и ключ к нему
#
# @example
#   vault::ssl { 'www.avito.ru': }
#
# <!-- Официальная документация Puppet Strings: https://puppet.com/docs/puppet/6.2/puppet_strings.html#available-strings-tags -->
define vault::ssl {
  vault::secret_file { ["${name}.crt", "${name}.key"]: }
}
