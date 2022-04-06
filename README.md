# IpApiService

![logo](https://ip-api.com/docs/static/logo.png)

Ruby клинет для сервиса [ip-api.com](https://ip-api.com/). Сервис позволяет получать данные геолокации по ip адресу.

## Установка

```ruby
gem 'ip-api-service'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ip-api-service

## Использование

Вы можете получить данные геолокации ip адреса вызвав метод IpApiService.lookup и передав ему следующие параметры:

* ip - ip адрес
* fields - массив с нужными полями 
* result_format - формат желаемого результата
* lang - язык

Результатом метода, при вызове с параметром result_format: :ipMetaInfo, будет объект.
Значения запрашиваемх полей будут доступны по геттеру с именем поля

```ruby
info = IpApiService.lookup '8.8.8.8'
puts info.city
```
Во всех других случаях результатом метода будет строка

Доступные для запроса поля можно получить вызвав метод available_fields

```ruby
IpApiService.available_fields
```

Поддерживаемые форматы результата - available_formats

```ruby
IpApiService.available_formats
```

Доступные языки - available_languages

```ruby
IpApiService.available_languages
```

Используя метод field_description(field) vожно получить описание поля

```ruby
IpApiServiceIpApiService.field_description :region
```

Параметр ip для метода lookup обязательный, остальные можно установить по умолчанию 

```ruby
IpApiService.default_fields = %i(city country countryCode lat lon)
IpApiService.result_format = :json
IpApiService.default_language = :en
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mike090/ip_api_service.