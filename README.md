# Puppet модуль для управления секретами

Модуль, автоматизирующий выкладку секретов из vault. Выложен в ознакомительных целях к статье [«Инфраструктура как Код в Авито: уроки, которые мы извлекли»](https://habr.com/ru/company/avito/blog/513008/)

## Установка

Модуль тестировался на Puppet 6.2+, для работы на более ранних версиях могут потребоваться доработки.

Для работы модуля в control repo должен быть подлкючён hiera-backend [petems-hiera_vault](https://github.com/petems/petems-hiera_vault).

Примеры hiera.yaml и Puppetfile есть в репозитории [template-control](FIXME):

Puppetfile:
```
#!/usr/bin/env ruby
#^syntax detection

forge "https://forgeapi.puppetlabs.com"

mod 'petems-hiera_vault',
  :git => 'https://github.com/petems/petems-hiera_vault',
  :ref => 'v0.4.1'
```

hiera.yaml:
```
---
version: 5

defaults:
  datadir: data

hierarchy:
  - name: "Hiera-vault lookup"
    lookup_key: hiera_vault
    options:
      confine_to_keys:
        - '^vault::secret::[a-zA-Z0-9_-].+$'
      strip_from_keys:
        - 'vault::secret::'
      ssl_verify: false
      # FIXME: 
      # token: path/to/your/vault/token
      # address: https://your.vault.url:8200
      mounts:
        puppet:
          - nodes/%{::trusted.certname}
          - roles/%{::role}
          - common
<...>
```

# Как работает hiera_vault бекенд?

Hiera-ключи, описанные в секции confine_to_keys обрабатываются бэкендом hiera_vault. При получении данных, бэкенд проходит проходит по иерархии, описанной в mounts/puppet сверху вниз и возвращает первое найденное значение в виде словаря. Формат хранения данных имитирует иерархию hiera.

## Пример

Предположим, что мы хотим получить значение секрета tokens, для каждой из 3 машин: srv01, srv02, srv03. При этом srv01, srv02 имеют роль k8s, а на srv03 роль не назначена.

В vault у нас лежат следущие секреты:

```
.
├── nodes
│   └── srv01
│       └── token # { data: "srv01-token" }
├── roles
│   └── k8s
│       └── token # { data: "k8s-token" }
└── common
     └── token # { data: "common-token" }

```

Hiera_lookup ключа 'vault::secret::token' на каждой из машин вернёт разное значение:

- на srv01 он вернет { data: "srv01-token" }, т.к. для этой машины секрет лежит в наиболее специфичном слое иерархии — nodes
- на srv02 вернёт { data: "k8s-token" }, поскольку для этой машины в nodes никаких данных не лежит, и первым найденным значением будет roles/k8s/token
- srv03 не имеет роли, поэтому для нее запрос ключа вернёт данные из common/token — { data: "common-token" }

# Использование модуля

Модуль avito-vault является обёрткой над hiera_lookup, скрывающая детали настройки hiera_vault и позволяющая запрашивать секрет как значение в переменную, либо класть секрет в файл в /etc/sercrets/<имя секрета>.

## Получение секрета из vault в переменную

```
$navigator_token_data = vault::secret_field('tokens.csv', 'data')
```

## Запись секрета в файл

```
vault::secret_file { 'creds': }
```

При этом, формат хранения данных в vault, должен следовать следующему соглашению:

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

## Запись ssl сертификата и ключа на сервер

```
vault::ssl { $::fqdn: }
```

В директорию /etc/secrets/ssl положит сертификат и ключ $::fqdn.crt и $::fqdn.key. В vault должны лежать файлы секреты, в формате, описанным выше.

# Разработка модуля

Требования:
- ruby 2.5.1+
- Docker
- bundler 2.0+

## Валидация кода

Перед началом работы нужно установить все зависимости через bundler:

```
bundle install
```

Проверка синтаксиса:

```
bundle exec rake validate
```

Запуск puppet-линтера:

```
bundle exec rake lint
```

Запуск ruby-линтера:

```
bundle exec rake rubocop
```

## Запуск юнит-тестов

[rspec-puppet](https://rspec-puppet.com) тесты находятся в директории spec/{classes, defines, functions}.
Для запуска тестов:

```
bundle exec rake spec
```

## Acceptance тестирование

Тестирование происходит в докере, вам потребуется образ с установленным и настроенным Puppet. Его можно собрать самостоятельно, воспользовавшить Dockerfile из репозитория [template-module](FIXME) или воспользоваться уже собранным образом из Docker Hub:

kitchen.yml:
```
platforms:
- name: debian-docker
  driver_config:
    image:  kozl/puppet:6.15.0
    platform: debian
    use_cache: true
    privileged: true
    provision_command:
      - apt-get update
    run_options: "-v /sys/fs/cgroup:/sys/fs/cgroup:ro"
    run_command: "/lib/systemd/systemd"
```

Для запуска acceptance тестов:

```
bundle exec kitchen test -t spec/acceptance
```

# Сгенерировать документацию по модулю

```
bundle exec rake strings:readme
```
