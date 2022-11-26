
-- 1) first 10 users on the platform
select username,created_at from users order by created_at limit 10;

-- 2) total number of registrations

select count(*) as "Total Registrations" from users;

-- 3) Total number of Posts
select count(*) from photos;

-- 4) day of the week most users registered on
 SELECT dayname(created_at) as "Day of the week",count(*) as 'day of the week' from users group by 1 order by 2 DESC;

-- 5) users who have never posted a photo
select username from users where id not in(select Distinct user_id from photos);
-- or 
SELECT u.username,p.id FROM users u LEFT JOIN photos p ON p.user_id = u.id;

--  6) most liked  photo
select image_url from photos where id = (select photo_id from likes group by photo_id order by count(*) DESC limit 1);

-- 7) users having top5 most liked photos
select u.username,count(*) as "likes" from likes l inner join photos p on p.id=l.photo_id
inner join users u on u.id=p.user_id group by p.id order by 2 DESC limit 5;

-- 8) average posts by users
select count(photos.id)/count(distinct users.id) as "avg" from users left join photos on users.id=photos.user_id ;
-- or 
SELECT ROUND((SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users),2) AS 'Average Posts by Users';

-- 9) number of photos posted by most active users
select users.username,count(*) as"number of photos posted" from users 
inner join photos on users.id=photos.user_id group by users.id order by 2 DESC limit 5;


-- 10) total number of users with posts
select count(distinct users.id) as "total" from users inner join photos on users.id=photos.user_id;

-- 11) username ending with numbers
select username from users where username regexp '[$0-9]';

-- username not ending with numbers
select username from users where username not regexp '[$0-9]';

-- 12) username starting with A/a
select username from users where username like "A%" ;

-- 13) username starting with vowels 
select username from users where username regexp "^[a,e,i,o,u]";

-- 14) most popular tag names by usage
select tags.tag_name,count(pt.tag_id) from photo_tags pt inner join tags on tags.id=pt.tag_id
 group by pt.tag_id order by 2 DESC limit 10;

-- 15) most popular tag names by likes
select t.tag_name,count(*) from tags t inner join photo_tags pt on t.id=pt.tag_id 
inner join likes l on l.photo_id=pt.photo_id group by pt.tag_id order by 2 DESC;

-- 16) users who have liked every single photo on the site
select user_id,username,count(*) from likes inner join users on users.id=likes.user_id
 group by user_id having count(*)=(select count(*) from photos);
 
-- 17) total number of users without comments
select count(username) as "count" from users left join comments on comments.user_id=users.id where comments.id is null;

-- 18) maximum comments on a photo
select max(t) from (select count(*) as t from comments group by photo_id order by count(*)  DESC) as dt ;

 
-- 19) Top 10 most commented photos
select image_url,count(*) as "total comments" from comments 
inner join photos on comments.photo_id=photos.id group by photo_id order by 2 DESC limit 10;


-- 20) percentage of users who liked every photo
select 100*count(c)/(select count(*) from users) as "percentage" from
(select id as c from users inner join likes on users.id=likes.user_id
 group by user_id having count(*)=(select count(*) from photos)) as dt;
 

 