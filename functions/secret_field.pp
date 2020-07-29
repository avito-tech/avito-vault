# Возвращает значение поля из секрета в Vault.
# @summary возвращает значение поля из секрета в Vault
# @param secretname Название секрета
# @param fieldname Название поля секрета
# @return [String] Значение поля из секрета
# @example
#   $secret_key = vault::secret_field('secretname', 'fieldname')
#
# <!-- Reference: https://puppet.com/docs/puppet/5.5/puppet_strings.html#available-strings-tags -->
function vault::secret_field(String $secretname, String $fieldname = 'data') >> String
{
  lookup("'vault::secret::${secretname}'")[$fieldname]
}
