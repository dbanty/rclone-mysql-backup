[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/7GOA4r?referralCode=xsbY2R)

# Backup MySQL to Cloudflare R2

This Docker app runs a single time, dumping a MySQL database with [mydumper] and using [rclone] to push that data to [Cloudflare R2](https://developers.cloudflare.com/r2/).

You schedule the container to run at whatever interval you want backups to happen.

## Setup

The container needs the environment variables related to MySQL:

- `MYSQL_HOST`: The host to connect to, for example `localhost` or `127.0.0.1`.
- `MYSQL_DATABASE`: The name of the database to dump.
- `MYSQL_PORT`: The port to connect to, defaults to `3306`
- `MYSQL_USER`: Username for MySQL
- `MYSQL_PASSWORD`: Password for MySQL

And these variables related to Cloudflare R2:

- `R2_ACCESS_KEY_ID` and `R2_SECRET_ACCESS_KEY`: An [S3-compatible access key](https://developers.cloudflare.com/r2/api/s3/tokens/)
- `R2_ENDPOINT`: The S3 API URL for your R2 account
- `R2_BUCKET`: The name of the bucket to upload to
- `R2_PATH`: A folder within the R2 bucket to upload to, defaults to `"mysql-backup"`

### Railway-specific guide

> [!TIP]
> You can also [deploy MySQL with these backups enabled](https://railway.app/template/xNTYS8?referralCode=xsbY2R) if you don't have a database yet.

If you're running this container in Railway, you can use shared variables for all the MySQL variables (replace `MySQL` in each expression with the name of your database service):

- `MYSQL_HOST`: `${{MySQL.MYSQLHOST}}`
- `MYSQL_DATABASE`: `${{MySQL.MYSQL_DATABASE}}`
- `MYSQL_PORT`: `${{MySQL.MYSQLPORT}}`
- `MYSQL_USER`: `${{MySQL.MYSQLUSER}}`
- `MYSQL_PASSWORD`: `${{MySQL.MYSQLPASSWORD}}`

Then, in settings, set restart to never and input a cron schedule to backup as often as you'd like.

## Restoring from a backup

1. Install [mydumper] and [rclone]
2. Create the same [rclone config file] that this container does
3. Run `rclone copy remote:$R2_BUCKET/$R2_PATH ./$LOCAL_FOLDER_TO_CREATE`
4. Run `myloader -h $MYSQL_HOST -u $MYSQL_USER -p $MYSQL_PASSWORD -d $LOCAL_FOLDER_TO_CREATE`

## FAQ

### Using something other than Cloudflare R2

You can fork this repo and modify the [rclone config file] to work for any storage destination [that rclone supports](https://rclone.org/#providers) (which is pretty much everything).

### Does this work with MariaDB?

Yes! `mydumper` and `myloader` are compatible with MariaDB as well.

[mydumper]: https://github.com/mydumper/mydumper
[rclone]: https://rclone.org
[rclone config file]: https://github.com/dbanty/rclone-mysql-backup/blob/06174cac3204c2e1e7b992d8f4ff112aa801561c/entrypoint.sh#L7-L16
