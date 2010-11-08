PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE defines (fullPath VARCHAR(1024) NOT NULL, shortName VARCHAR(1024) NOT NULL, args VARCHAR(1024));
INSERT INTO "defines" (fullpath,shortName,args) VALUES('%comspec%','cmd','/K %s');
INSERT INTO "defines" (fullpath,shortName,args) VALUES('http://www.google.com/','google','search?q=%s');
INSERT INTO "defines" (fullpath,shortName,args) VALUES('http://www.baidu.com','baidu','s?wd=%s&ie=utf-8');
INSERT INTO "defines" (fullpath,shortName,args) VALUES('http://192.168.115.2','home','');
COMMIT;
