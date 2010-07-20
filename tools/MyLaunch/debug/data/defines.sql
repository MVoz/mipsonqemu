PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE defines (id INTEGER PRIMARY KEY AUTOINCREMENT, fullPath VARCHAR(1024) NOT NULL, shortName VARCHAR(1024) NOT NULL, lowName VARCHAR(1024) NOT NULL, icon VARCHAR(1024), usage INTEGER NOT NULL,hashId INTEGER NOT NULL,groupId INTEGER NOT NULL, parentId INTEGER NOT NULL, isHasPinyin INTEGER NOT NULL, comeFrom INTEGER NOT NULL, hanziNums INTEGER NOT NULL, pinyinDepth INTEGER NOT NULL, pinyinReg VARCHAR(1024), alias1 VARCHAR(1024), alias2 VARCHAR(1024),shortCut VARCHAR(1024),delId INTEGER NOT NULL,args VARCHAR(1024));
INSERT INTO "defines" (fullpath,shortName,lowName,comeFrom,args) VALUES('C:\Windows\System32\cmd.exe','cmd','cmd',1,'/K %s');
INSERT INTO "defines" (fullpath,shortName,lowName,comeFrom,args) VALUES('http://www.google.com/','google','google',1,'search?q=%s');
INSERT INTO "defines" (fullpath,shortName,lowName,comeFrom,args) VALUES('http://www.baidu.com','baidu','baidu',1,'s?wd=%s&ie=utf-8');
COMMIT;
