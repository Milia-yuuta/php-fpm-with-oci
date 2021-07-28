# php-fpm-with-oci
It's on [docker-hub](https://hub.docker.com/repository/docker/sakurakun222/php-fpm-with-oci) and [github](https://github.com/Milia-yuuta/php-fpm-with-oci)

## <a name="dependency"> Environmental configuration

| NAME | VERSION                      |
| :--------- | :------------------------ | 
| php        | 8.0-fpm(with-oci8)                     |
| oracle_instance_client        | 21.1.0.0.0                     |

## how to build

```sh
git clone git@github.com:Milia-yuuta/php-fpm-with-oci.git
cd php-fpm-with-oci
docker build --rm -t php-fpm-with-oci .
```
## running

```sh
docker run --rm  -it php-fpm-with-oci
```