PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE defines (fullPath VARCHAR(1024) NOT NULL, shortName VARCHAR(1024) NOT NULL,  comeFrom INTEGER NOT NULL,args VARCHAR(1024));
INSERT INTO "defines" (fullpath,shortName,comeFrom,args) VALUES('C:\Windows\System32\cmd.exe','cmd',1,'/K %s');
INSERT INTO "defines" (fullpath,shortName,comeFrom,args) VALUES('http://www.google.com/','google',1,'search?q=%s');
INSERT INTO "defines" (fullpath,shortName,comeFrom,args) VALUES('http://www.baidu.com','baidu',1,'s?wd=%s&ie=utf-8');
COMMIT;
