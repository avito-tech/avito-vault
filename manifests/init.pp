# Управляет секретами
#
# @summary Управляет секретами
#
# @param secrets Список секретов, которые нужно создать на ноде
# @param ssl Список сертификатов, которые нужно создать на ноде. Вместе с каждым сертификатом идёт ключ.
#
# @example Hiera
#   ---
#   vault::secrets:
#     - verysecrettoken.txt
#   vault::ssl:
#     - cert1
#     - cert2
#
# <!-- Официальная документация Puppet Strings: https://puppet.com/docs/puppet/6.2/puppet_strings.html#available-strings-tags -->
class vault (
  Array[String] $secrets = [],
  Array[String] $ssl = [],
) {
  $secrets.each |$secret| {
    vault::secret_file { $secret: }
  }
  $ssl.each |$cert| {
    vault::ssl { $cert: }
  }
}
