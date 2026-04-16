# Landing Page CI/CD

Workflow GitHub Actions ada di:

- `.github/workflows/deploy-landing-page.yml`

## GitHub Secrets

- `DEPLOY_SSH_PRIVATE_KEY`
  Isi private key SSH untuk user `ahmaddwi`.

## Cara kerja deploy

Saat ada push ke branch `main`, workflow akan:

1. checkout source landing page
2. siapkan SSH key untuk koneksi ke server `103.103.23.184`
3. upload source landing page ke `~/lapangin-ci/landing-page`
4. sync file statis ke `/var/www/lapangin.id`
5. replace config Nginx dari `lapangin.nginx.conf`
6. test konfigurasi Nginx
7. reload Nginx

## Struktur server

- document root: `/var/www/lapangin.id`
- nginx config: `/etc/nginx/sites-available/lapangin.id`
- upload sementara CI: `~/lapangin-ci/landing-page`
