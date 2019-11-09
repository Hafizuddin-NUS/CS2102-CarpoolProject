# main

Download zip file
Extract it.
Ensure nodeJS is installed and able to run node command

Create database with database name as Carpooling, and username as username and password as password
Login to PSQL.
Navigate to \CS2102-CarpoolProject-master\App\sql and import schema.sql

Open \CS2102-CarpoolProject-master\App\.env file and verify username and password is correct.
DATABASE_URL=postgres://username:password@localhost:5432/Carpooling

Open new command prompt
cd \CS2102-CarpoolProject-master\App
npm install

node bin\www

Open web browser, go to http://localhost:3000/auth/login
Username: hafiz
Password: password2



