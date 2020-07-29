# Позволяет положить секрет из vault на файловую систему.
# Формат хранения данных в vault, должен следовать следующему соглашению:
# ```
# {
#   "data": "secret-file-contents here",
#   "file": "creds",
#   "user": "root",
#   "group": "root",
#   "path": "ssl",
#   "perms": "0644"
# }
# ```
# - **file** и **path** определяют путь, по которому секрет будет выложен на сервер: /etc/secrets/$path/$file
# - **user**, **group**, **perms** определяют unix permissions для созданного файла
# - внутри **data** должно находится содержимое файла
# @summary положить секрет из vault в /etc/secrets/
#
# @example
#   vault::secret_file { 'super-top-secret.key': }
##
# <!-- Reference: https://puppet.com/docs/puppet/5.5/puppet_strings.html#available-strings-tags -->
define vault::secret_file {
  $secret = lookup("'vault::secret::${name}'")
  $path   = $secret['path']
  $file   = $secret['file']
  $user   = $secret['user']
  $group  = $secret['group']
  $perms  = $secret['perms']
  $data   = $secret['data']

# lint:ignore:only_variable_string lint:ignore:variables_not_enclosed
  if ("$file" == '') or ("$user" == '') or ("$group" == '') or ("$perms" == '') or ("$data" == '') {
    fail("Keys file, user, group, perms and data in secret ${name} must have value")
  }
# lint:endignore
  validate_string($path)
  $secretpath = "/etc/secrets/${path}"
  validate_absolute_path($secretpath)

  include vault::create_secrets_dir

  # create all parent dirs
  $filepath = "${path}/${file}"
  vault::parents($filepath).each |$p| {
    ensure_resource('file', "/etc/secrets/${p}", {'ensure' => 'directory'})
  }
  file { "/etc/secrets/${filepath}":
    ensure  => file,
    mode    => $perms,
    owner   => $user,
    group   => $group,
    content => $secret['data'],
  }
}
