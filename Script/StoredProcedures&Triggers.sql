-- 实现多表查询
DELIMITER //   -- 声明存储过程的结束符
  CREATE PROCEDURE SELECTN(in start varchar(10),in end varchar(10), in date0 date) -- 存储过程的名称
  
  BEGIN   -- 开始
    -- sql语句+流程控制
    create table starttable as select 站名 as startStation from stop where 城市 = start;
    create table endtable as select 站名 as endStation from stop where 城市 = end;
    create table start_end as  select 车次 as trainNo,startStation,endStation,发车时间,到达时间,时间 as 历时 ,车型 from trains,starttable,endtable 
      where starttable.startStation = trains.出发站 and endtable.endStation = trains.到达站;
    create table table1 as select 车次, 出发站, 到达站, 历时,车型, 商务座特等座余票, 商务座特等座票价, 一等座余票, 一等座票价, 
      二等座票价, 二等座余票 from start_end
      left join remainall on start_end.trainNo= remainall.车次 and start_end.startStation = remainall.出发站 and 
        start_end.endStation = remainall.到达站 and remainall.日期 = date0;
   
    create table table2 as select  passstop.车次 as 车次,出发站, 到达站,passstop.出发时间 as 起始时间,历时,车型,商务座特等座余票, 商务座特等座票价, 一等座余票, 一等座票价, 
      二等座票价, 二等座余票 from table1 left join passstop on table1.车次 = passstop.车次 and table1.出发站 = passstop.站名;
     
    select passstop.车次 as 车次 ,出发站, 到达站, 起始时间, passstop.到达时间 as 到达时间,历时,车型,商务座特等座余票, 商务座特等座票价, 一等座余票, 一等座票价, 
      二等座票价, 二等座余票 from table2 left join passstop on table2.车次 = passstop.车次 and table2.到达站 = passstop.站名;
    
-- 删除表
      SET @delTabl = 'drop table starttable;';
      -- 执行动态生成的sql语句
      PREPARE temp FROM @delTabl;
      EXECUTE temp;
     SET @delTabl = 'drop table endtable;';
      -- 执行动态生成的sql语句
      PREPARE temp FROM @delTabl;
      EXECUTE temp;
 SET @delTabl = 'drop table start_end;';
      -- 执行动态生成的sql语句
      PREPARE temp FROM @delTabl;
      EXECUTE temp;
SET @delTabl = 'drop table table1;';
      -- 执行动态生成的sql语句
      PREPARE temp FROM @delTabl;
      EXECUTE temp;
SET @delTabl = 'drop table table2;';
      -- 执行动态生成的sql语句
      PREPARE temp FROM @delTabl;
      EXECUTE temp;
  END //

DELIMITER ;
-- 执行存储过程
CALL SELECTN('北京','上海','2021-12-17');

-- 实现单表查询(登录)
DELIMITER //   -- 声明存储过程的结束符
  CREATE PROCEDURE LOGIN(in username varchar(10), in passwd varchar(20)) 
  BEGIN
    select * from users where 用户名=username and 登录密码 = passwd;
  END //

DELIMITER ;
CALL LOGIN('wanen','123');





-- 删除存储过程的定义
drop procedure selectn;

-- 添加用户
DELIMITER //
  CREATE PROCEDURE ADDUSER(in 用户名 varchar(10), in 登陆密码 varchar(20), in 姓名 varchar(20), in 手机号 bigint(20), in 邮箱 varchar(20), in 证件号 varchar(20), in 旅客类型 varchar(20))
  BEGIN
    insert into users values ( 用户名, 登陆密码, 姓名, 手机号, 邮箱, 证件号, 旅客类型);
  END //
DELIMITER ;
-- 执行存储过程
CALL ADDUSER('wanwan','gaowanen', '高婉恩', 13590619113, '792404705@qq.com', 112233, '成人');

-- 实现数据插入(添加订单)
DELIMITER //
  CREATE PROCEDURE INSERTDATA(in 车次0 varchar(10), in 日期 date, in 出发地 varchar(10), in 目的地 varchar(10), in 车厢号 int, in 座位号 int) 
 BEGIN 
 DECLARE 
      starttime ,endtime time default '00:00:00';
  
      select 出发时间 into starttime from passstop where 车次 = 车次0 and 站名 = 出发地;
      select 到达时间 into endtime from passstop where 车次 = 车次0 and 站名 = 目的地;
      insert into orders values ('高高',车次0,日期,starttime,endtime,出发地,目的地,车厢号,座位号);
  END //
DELIMITER ;
-- 执行存储过程
CALL INSERTDATA('C1003','2021-11-27','吉林','敦化',6,9);

-- 实现数据删除(删除订单）
DELIMITER //
  CREATE PROCEDURE DELETEDATA(in 车次0 varchar(10), in 日期0 date, in 出发地0 varchar(10))
  BEGIN
      delete from orders where 用户名='高高' and 车次=车次0 and 日期=日期0 and 出发地 = 出发地0;
  END//
DELIMITER ;
-- 执行存储过程
CALL DELETEDATA('C1003','2021-11-27','吉林');

-- 删除用户
DELIMITER //
  CREATE PROCEDURE DELETEUSER(in 用户名0 varchar(10))
  BEGIN
    delete from users where 用户名=用户名0;
  END//
DELIMITER ;
CALL DELETEUSER('余宛');

-- 实现数据修改
DELIMITER //
  CREATE PROCEDURE MODIFYDATA(in 车次0 varchar(10), in 日期0 date, in 出发地0 varchar(10), in 车厢号0 int, in 座位号0 int)
  BEGIN
      update orders set 车厢号 = 车厢号0, 座位号 = 座位号0 where 用户名='高高' and 车次=车次0 and 日期=日期0 and 出发地 = 出发地0;
  END//
DELIMITER ;
-- 执行存储过程
CALL INSERTDATA('C1003','2021-11-27','吉林','敦化',6,9);
CALL MODIFYDATA('C1003','2021-11-27','吉林',10,10);

-- 修改用户信息
DELIMITER //
  CREATE PROCEDURE ALTERUSER(in 用户名0 varchar(10), in 登陆密码0 varchar(20), in 姓名0 varchar(20), in 手机号0 bigint(20), in 邮箱0 varchar(20), in 证件号0 varchar(20), in 旅客类型0 varchar(20))
  BEGIN
	update users set 登录密码=登陆密码0,姓名=姓名0,手机号=手机号0,邮箱=邮箱0,证件号=证件号0,旅客类型=旅客类型0 where 用户名=用户名0;
  END //
DELIMITER ;

CALL ALTERUSER('wanwan','gaowanen', '高婉恩', 13590619113, '792404705@qq.com', 112233, '成人');


/*
创建触发器
*/

-- 增加订单时添加新用户
DELIMITER //
create trigger user_insert_orders
before insert on orders
for each row 
begin
declare a char(20);
select count(*) into a from users where 用户名=new.用户名;
if a = 0
then insert into users(用户名,登录密码,姓名,手机号,邮箱,证件号) values
(new.用户名,'111',new.用户名,13825551919,'111@qq.com',654321);
end if;
end//
DELIMITER ;

-- 激活触发器
insert into orders(用户名,车次,日期,出发地,目的地) values ("ww","C1004","2021-12-01","广州南","北京西");


-- 删除users中用户时，同时删除orders表中的用户订单
DELIMITER //
create trigger user_delete_orders
after delete on users
for each row
begin
delete from orders where old.用户名=用户名;
end //
DELIMITER ;

-- 激活触发器
delete from users where 用户名='ww';


-- 数据更新(当用户更新用户名时，新用户名已经有，则在新用户名后添加编号)
DELIMITER //
create trigger users
before update on users
for each row
begin
declare a int;
select count(*) into a from users where 用户名=new.用户名;
if a!=0 and old.用户名 != new.用户名 then set new.用户名=concat(new.用户名,a);
end if;
end//
DELIMITER ;

DELIMITER //
create procedure deleteUsers()
begin
delete from users where 用户名 REGEXP '(^[0-9]+.[0-9]+$)|(^[0-9]$)';
end//
DELIMITER ;

DELIMITER //   -- 声明存储过程的结束符
  CREATE PROCEDURE searchTruename(in truename varchar(20)) 
  BEGIN
    select * from users0 where 姓名=truename;
  END//
DELIMITER ;
CALL searchTruename('高婉恩');


DELIMITER //
  CREATE PROCEDURE ADDUSER(in 用户名 varchar(10), in 登陆密码 varchar(20), in 姓名 varchar(20), in 手机号 bigint(20), in 邮箱 varchar(20), in 证件号 varchar(20), in 旅客类型 varchar(20))
  BEGIN
    insert into users0 values ( 用户名, 登陆密码, 姓名, 手机号, 邮箱, 证件号, 旅客类型);
  END //
DELIMITER ;
-- 执行存储过程
CALL ADDUSER('wanwan','gaowanen', '高婉恩', 13590619113, '792404705@qq.com', 112233, '成人');


