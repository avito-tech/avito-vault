# Достаёт секрет из Vault в виде словаря.
# @summary достаёт секрет из Vault в виде словаря
# @param name Название секрета
# @return [Hash] Секрет в виде словаря
# @example
#   $secret_dict = vault::secret('topsecret')
#
# <!-- Reference: https://puppet.com/docs/puppet/5.5/puppet_strings.html#available-strings-tags -->
function vault::secret(String $name) >> Hash
{
  lookup("'vault::secret::${name}'")
}
