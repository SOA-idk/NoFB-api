# NoFB Web API
## Purpose
Web API allow user to review/edit the database content of NoFB database.

## Installation
```bash=
bundle install
```
If you have not installed the gcc, please run this command before install.
```bash=
sudo apt-get install build-essential
```

## Command
If you want to run the app:
```bash=
rackup
```

如果有error，請跑這行:
```bash=
rbenv rehash
```

Check the code spec:
```bash=
rake spec
```

Check the quality of code:
```bash=
rake quality:all
```

Run the db
```bash=
rake db:migrate
```

Drop the db
```bash=
rake db:drop
```

## Design of table in Database
1. groups

| group_id | group_name | updated_at | created_at |
| -------- | ---------- | ---------- | ---------- |
| String   | String     | String   | String   |

2. posts

| post_id | group_id | user_name | message | updated_time |
| ------- | -------- | ------- | ------- | ------------ |
| String  | String   | String  | String  | String       |

3. users

| user_id | user_email | user_name |
| ------- | ---------- | ------------ |
| String  | String     | String       |

4. subscribes

| user_id | group_id | word   |
| ------- | -------- | ------ |
| String  | String   | String |

## Routes
### Root check
`GET /`
Status:
- 200: API server running (happy)

### Get DB content

`GET /users?access_key={access_key}`
`GET /posts?access_key={access_key}`
`GET /groups?access_key={access_key}`
`GET /subscribes?access_key={access_key}`

Status

- 200: content returned (happy)
- 403: problems about the access_key (sad)
- 500: problem of DB (bad)

### Create a new subscribe

`POST /subscribes?access_key={access_key}`
`Body: user_id(Text), fb_url(Text), subscribed_word(Text)`

- 201: new subscribe stored (happy)
- 400: the given subscribe has existed (sad)
- 403: problems about the access_key (sad)
- 500: problems of DB (bad)

### Update (or create) a subscribe

`PATCH /api/v1/subscribes/{user_id}/{group_id}?access_key={access_key}`
`Body: subscribed_word(Text)`

- 200: subscribe updated (happy)
- 403: problems about the access_key (sad)
- 500: problems of DB (bad)

### Delete a subscribe

`DELETE /api/v1/subscribes/{user_id}/{group_id}?access_key={access_key}`

- 200: subscribe deleted (happy)
- 403: problems about the access_key (sad)
- 404: the given subscribe not found (sad)
- 500: problems of DB (bad)