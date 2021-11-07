# NoFB
The best word to describe us is **Good**.

## Installation
```bash=
sudo apt-get install build-essential
bundle install
```
When pushing to repo, remember to git add -u (in order to avoid Gemfile.lock).

## Resources
- class Posts
- class Post 

## Element
- class Posts
  * @size = int
  * @posts = [Post, Post, ...]
  * @post_list = [id, id, id, ...]
- class Post 
  * @updated_time
  * @message
  * @id

## Entities
There are objects that are import  to the Facebook group.
* Posts

## Result of simpleCov
![](https://i.imgur.com/r7acmhR.png)

## Result of rake
QAQ finally
![](https://i.imgur.com/VYJDtX6.png)

## Result of rake(10/30)
![](https://i.imgur.com/i72Boxc.png)

**result of mvc**
![](https://i.imgur.com/KT3KPeY.png)

## Open the folder of wsl
```explorer.exe .```

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
1. Groups

| group_id | group_name | updated_at | created_at |
| -------- | ---------- | ---------- | ---------- |
| String   | String     | String     | String     |

2. Posts

| post_id | updated_time | message | user_id | group_id |
| ------- | ------------ | ------- | ------- | -------- |
| String  | String       | String  | String  | String   |

3. Users

| user_id | user_email | access_token |
| ------- | ---------- | ------------ |
| String  | String     | String       |


## Result of rake (11/7)
- quality:all
![](https://i.imgur.com/Mu1vTvB.png)
- spec
![](https://i.imgur.com/AL3WXZp.png)