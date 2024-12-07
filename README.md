# axum-postgreSQL
axum 0.7.9, Auth, PostgreSQL, Email Verification

## Why Axum
Go with axum, i's a lot easier to get into and the performance difference is negligible.

If you’re doing anything that involves a database, that timing is going to dominate your API performance.

Other consideration:
- Number of production apps using each library
- Maintenance story: who is fixing bugs, improving the library and how frequently?
- API ergonomics

Actix uses a pool of single thread tokio runtimes and axum just uses the multithread runtime. The multithread runtime does add a litte big overhead but in situations where the endpoints in the backend do generate not even loads when executing that can be better then a bunch of single thread runtimes. 

Using actix-web adds complications because it is using its own actix-rt runtime. It is based on tokio but it does its own thing with threads which may cause some incompatibilities with other projects. Libraries like sqlx and sea-orm have feature flags to use this runtime but most other projects typically just support tokio only. You can run actix-web under the tokio runtime but then you lose support for actix actors and websockets.

## Original Source Codebase
Master Rust Backend with Axum: Full-Stack Guide for Auth, PostgreSQL & Email Verification https://www.youtube.com/watch?v=M0wi7V1rP4Y

## Add Dependencies
argon2: hashing
async-trait: Type erasure for async trait methods 
axum and axum-extra: web framework built with Tokio, Tower, and Hyper; Extra utilities for Axum
chrono: for DB timestamps
dotenvy: A well-maintained fork of the dotenv
jsonwebtoken: to make json web token
lettre: sending emails
serde and serde_json: to serialize and deserialize
sqlx: An async, pure Rust SQL toolkit featuring compile-time checked queries without a DSL. Supports PostgreSQL, MySQL, and SQLite.

time: to compliment chronos
tokio: async runtime from timer to networking
tower: networking clients and servers
tracing-subscriber: for collecting structured event logs
uuid: for unique identifier
validator: validation for data models


## Build binaries
   
```bash
cargo build
```

## Database Configuration
Set PostgreSQL installation from https://www.postgresql.org/
For Ubuntu and its derivatives
```
sudo apt update && sudo apt upgrade -y
sudo apt install postgresql postgresql-contrib
sudo systemctl status postgresql
```
You should see an output indicating that PostgreSQL is active and running.
By default, PostgreSQL creates a user named **postgres**. 

https://www.pgadmin.org/
For Ubuntu, go to https://www.pgadmin.org/download/pgadmin-4-apt/
```
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
```
For LinuxMint, replace `$(lsb_release -cs)` with `noble`
```
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
```

Install for desktop mode only:
`sudo apt install pgadmin4-desktop`

Managing PostgreSQL Service:
Check PostgreSQL status:
```bash
systemctl status postgresql
```
Start PostgreSQL:
```bash
sudo systemctl start postgresql
```
Stop PostgreSQL:
```bash
sudo systemctl stop postgresql
```
Restart PostgreSQL:
```bash
sudo systemctl restart postgresql
```


Testing the Installation:
```bash
psql -U postgres
```
You should be able to see the PostgreSQL prompt if everything is set up correctly.

Troubleshooting Tips:
**Cannot Connect to PostgreSQL**: Make sure the service is running with `sudo systemctl status postgresql`.

**Authentication Error**: Verify that your user credentials are correct and that the user has the necessary privileges.

**Network Access Issues**: Double-check the configuration files (`postgresql.conf` and `pg_hba.conf`) if you are setting up remote access.

```bash
ps -ef | grep postgres
sudo systemctl status postgresql
```
Use the default username `postgres` to login:
```bash
sudo -u postgres psql
alter user postgres with password 'password';
quit
```

Switch to the default `postgres` user to access the PostgreSQL command-line interface:
`sudo -i -u postgres`

Launch the PgAdmin tool from your OS
File -> Preferences -> Miscellaneous -> Theme -> Se to Dark
Right click on Server in the left sidebar -> Register -> Server
General Tab: Name = localhost
Connection Tab:
- Hostname/Address = localhost
- Post = 5433
- Maintenance database = postgres
- Username = postgres

## Make a new Database
in your .env file:
```
# PostgreSQL Database
DATABASE_URL=postgresql://postgres:password@localhost:5433/db_name
```
where postgresql is the protocol, postgres is the username, password is password, localhost is the host, db_name is the database name

Setup a new database:
```bash
cargo install sqlx-cli --no-default-features --features native-tls,postgres
systemctl status postgresql
systemctl start postgresql
sqlx database create
sqlx migrate add -r users
```
the last command will make two `.sql` files under the `migrations` folder:
`yyyymmdd123456_users.up.sql` file for applying changes
`yyyymmdd123456_users.down.sql` file for undoing migration if needed

To execute the migration, i.e. make `users` talbe  according to the `yyyymmdd123456_users.up.sql` file:
```bash
sqlx migrate run
```
... Applied 20241207142716/migrate users (283.438821ms)



Create a new database:
`CREATE DATABASE mydatabase;`

Create a new user with a password:
`CREATE USER myuser WITH PASSWORD 'mypassword';`

Grant privileges to the user for the new database:
`GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;`

To exit the PostgreSQL shell, type:
` \q `

Make a local PostgreSQL database and user by executing the following SQL commands in your PostgreSQL shell or client:

```
$sudo nano /etc/postgresql/14/main/pg_ident.conf
# MAPNAME  SYSTEM-USERNAME    PG-USERNAME
user1 <computer-username> postgres
//user1 user2038 postgres
//Replace the <computer-username> with the System-Username, which can be found using the whoami command.


https://stackoverflow.com/questions/69676009/psql-error-connection-to-server-on-socket-var-run-postgresql-s-pgsql-5432

$ sudo nano /etc/postgresql/14/main/pg_hba.conf
# Database administrative login by Unix domain socket
# TYPE  DATABASE  USER   ADDRESS   METHOD
local   all   postgres    trust
# "local" is for Unix domain socket connections only
local   all   all    md5
# IPv4 local connections:
host    all   all   127.0.0.1/32    md5
# IPv6 local connections:
host    all   all   ::1/128    md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replicationall   

```

Copy the contents of the `create.sql` file and execute it in your PostgreSQL database.

Create a `.env` file in the project root and configure the `DATABASE_URL` and `SERVER_ADDRESS`:

```env
DATABASE_URL=postgres://axum_postgres:axum_postgres@127.0.0.1:5432/axum_postgres
SERVER_ADDRESS=127.0.0.1:7878
```

## Run the application
Run the application with
```bash
sudo service postgresql start
cargo run
sudo service postgresql stop
```

## Invoke API Requests
```bash
slumber request -p local root
slumber request -p local get_tasks | jq
slumber request -p local add_task1
slumber request -p local update_task1
slumber request -p local delete_task1
```
Retrieves a list of all tasks.


#### **Enable Remote DB Access (Optional)**:

If you need to access PostgreSQL remotely, you need to adjust the configuration files.
Edit the PostgreSQL configuration file using:
```
sudo nano /etc/postgresql/15/main/postgresql.conf
```
Find the line:
`#listen_addresses = 'localhost'`
Change it to:
`listen_addresses = '*'`
Save the file and exit. Then, edit the *pg_hba.conf* file to allow remote connections:

```bash
sudo nano /etc/postgresql/15/main/pg_hba.conf
```
Add the following line at the end:
```
host    all   all   0.0.0.0/0  md5
```
Save the file, exit, and restart PostgreSQL for the changes to take effect:

```bash
sudo systemctl restart postgresql
```

Uninstalling PostgreSQL:
```bash
sudo apt remove --purge postgresql postgresql-contrib -y
```
You can also remove unnecessary packages and clean up residual configuration files:
```bash
sudo apt autoremove -y && sudo apt autoclean
```