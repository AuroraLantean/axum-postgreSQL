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
chrono: for DB timestamps
lettre: sending emails
tokio: async runtime from timer to networking
tower: networking clients and servers
time: compliment chronos
tracing-subscriber: for collecting structured event logs
uuid: for unique identifier
validator: validation for data models
