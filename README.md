# Peegee

This web app is a password generator.

## Setting secrets

To regenerate Rails credentials, run the following commands:

```bash
# Remove existing credential files
rm config/credentials.yml.enc
rm config/master.key

# Generate new credentials with automatic secret_key_base
EDITOR="echo 'secret_key_base: $(bin/rails secret)' >" bin/rails credentials:edit
```

This will create new master.key and credentials.yml.enc files with a fresh secret_key_base automatically configured.

## Peegee start

```shell
$ bundle exec rails s
```

## Buy coffee to the author.

[Github Sponsor | https://github.com/sponsors/masoo](https://github.com/sponsors/masoo)

[PayPal.Me | https://paypal.me/masoojp](https://paypal.me/masoojp)