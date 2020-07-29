# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

#### Public Classes

* [`vault`](#vault): Управляет секретами

#### Private Classes

* `vault::create_secrets_dir`: Управляет директорией `/etc/secrets/`

### Defined types

* [`vault::secret_file`](#vaultsecret_file): положить секрет из vault в /etc/secrets/
* [`vault::ssl`](#vaultssl): Создаёт сертификат и ключ к нему

### Functions

* [`vault::parents`](#vaultparents): Возвращает все родительские директории для пути
* [`vault::secret`](#vaultsecret): достаёт секрет из Vault в виде словаря
* [`vault::secret_field`](#vaultsecret_field): возвращает значение поля из секрета в Vault

## Classes

### `vault`

Управляет секретами

<!-- Официальная документация Puppet Strings: https://puppet.com/docs/puppet/6.2/puppet_strings.html#available-strings-tags -->

#### Examples

##### Hiera

```puppet
---
vault::secrets:
  - verysecrettoken.txt
vault::ssl:
  - cert1
  - cert2
```

#### Parameters

The following parameters are available in the `vault` class.

##### `secrets`

Data type: `Array[String]`

Список секретов, которые нужно создать на ноде

Default value: `[]`

##### `ssl`

Data type: `Array[String]`

Список сертификатов, которые нужно создать на ноде. Вместе с каждым сертификатом идёт ключ.

Default value: `[]`

## Defined types

### `vault::secret_file`

Позволяет положить секрет из vault на файловую систему.
Формат хранения данных в vault, должен следовать следующему соглашению:
```
{
  "data": "secret-file-contents here",
  "file": "creds",
  "user": "root",
  "group": "root",
  "path": "ssl",
  "perms": "0644"
}
```
- **file** и **path** определяют путь, по которому секрет будет выложен на сервер: /etc/secrets/$path/$file
- **user**, **group**, **perms** определяют unix permissions для созданного файла
- внутри **data** должно находится содержимое файла
<!-- Reference: https://puppet.com/docs/puppet/5.5/puppet_strings.html#available-strings-tags -->

#### Examples

##### 

```puppet
vault::secret_file { 'super-top-secret.key': }
```

### `vault::ssl`

Создаёт сертификат и ключ к нему. Расширение указывать не нужно.

<!-- Официальная документация Puppet Strings: https://puppet.com/docs/puppet/6.2/puppet_strings.html#available-strings-tags -->

#### Examples

##### 

```puppet
vault::ssl { 'www.avito.ru': }
```

## Functions

### `vault::parents`

Type: Puppet Language

Возвращает все родительские директории для пути

#### Examples

##### 

```puppet
$parents = vault::parents('a/b/c/d') # => ['a', 'a/b', 'a/b/c']
$parents = vault::parents('/a/b/c/d') # => ['/a', '/a/b', '/a/b/c']
```

#### `vault::parents(String $path)`

Возвращает все родительские директории для пути

Returns: `Array[String]` Родительские директории пути

##### Examples

###### 

```puppet
$parents = vault::parents('a/b/c/d') # => ['a', 'a/b', 'a/b/c']
$parents = vault::parents('/a/b/c/d') # => ['/a', '/a/b', '/a/b/c']
```

##### `path`

Data type: `String`

Путь

### `vault::secret`

Type: Puppet Language

Достаёт секрет из Vault в виде словаря.
<!-- Reference: https://puppet.com/docs/puppet/5.5/puppet_strings.html#available-strings-tags -->

#### Examples

##### 

```puppet
$secret_dict = vault::secret('topsecret')
```

#### `vault::secret(String $name)`

Достаёт секрет из Vault в виде словаря.
<!-- Reference: https://puppet.com/docs/puppet/5.5/puppet_strings.html#available-strings-tags -->

Returns: `Hash` Секрет в виде словаря

##### Examples

###### 

```puppet
$secret_dict = vault::secret('topsecret')
```

##### `name`

Data type: `String`

Название секрета

### `vault::secret_field`

Type: Puppet Language

Возвращает значение поля из секрета в Vault.
<!-- Reference: https://puppet.com/docs/puppet/5.5/puppet_strings.html#available-strings-tags -->

#### Examples

##### 

```puppet
$secret_key = vault::secret_field('secretname', 'fieldname')
```

#### `vault::secret_field(String $secretname, String $fieldname = 'data')`

Возвращает значение поля из секрета в Vault.
<!-- Reference: https://puppet.com/docs/puppet/5.5/puppet_strings.html#available-strings-tags -->

Returns: `String` Значение поля из секрета

##### Examples

###### 

```puppet
$secret_key = vault::secret_field('secretname', 'fieldname')
```

##### `secretname`

Data type: `String`

Название секрета

##### `fieldname`

Data type: `String`

Название поля секрета
