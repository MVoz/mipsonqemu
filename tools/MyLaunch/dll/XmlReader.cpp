#include <XmlReader.h>
#include <QSettings>
#include <QDir>
#include <bmapi.h>
#include <QUrl>
//extern QDateTime gLastUpdateTime;
//extern QString gIeFavPath;
//extern QDateTime gNowUpdateTime;
//extern QSettings *gSettings;
static QString browserName[]={QString(""),QString("ie"),QString("firefox"),QString("opera")};
void XmlReader::getCatalog(QList<CatItem>* items)
{

	while (!atEnd())
	  {
		  readNext();
		  if (isStartElement())
		    {
			    if (name() == "bookmark" && attributes().value("version") == "1.0")
			      {
				     getBookmarkCatalog(items);
			      }
		  } else if (isStartDocument())
		    {
		  } else if (isEndDocument())
		    {
		    }
	  }

}
void XmlReader::getBookmarkCatalog(QList<CatItem>* items)
{
	CatItem item;
	while (!atEnd())
	  {
		  readNext();
		  if (isStartElement())
		    {
			    if (name() == "category")
			      {
				     
			    } else if (name() == "item")
			      {
				      		while (!atEnd())
						  {
							  readNext();
							  if (isStartElement())
							    {

								    if (name() == "name")
									    importCatItemName(&item);
								    else if (name() == "link")
									    importCatItemFullPath(&item);
								    else if (name() == "comeFrom")
									    importCatItemComefrom(&item);
							  } else if (isEndElement())
							    {
								    if (name() == "item")
								      {
									      items->push_back(item);									
									      break;
								      }
							    }
						  }
			      }
		  } else if (isCharacters() && !isWhitespace())
		    {
            
		  } else if (isEndElement())
		    {

		    }
	  }
}
void XmlReader::readBrowserType(int browserType)
{
	int readFlag=0;
	 while (!atEnd())
	  {
		  readNext();
		  if (isStartElement())
		    {
			    if (name() == "browserType"&&attributes().value("name") == browserName[browserType])
			      {
			      			qDebug("%s %d %s",__FUNCTION__,__LINE__,qPrintable(browserName[browserType]));
			      			readFlag=1;
		 				readBookmarkElement();
			    	} 
		  } else if (isCharacters() && !isWhitespace())
		    {
                
		  } else if (isEndElement())
		    {
				//if(readFlag&&(name() == "browserType"))
					//break;
		    }
	  }
}
void XmlReader::readStream(uint flag,QSettings* setting,int browserType)
{
	this->flag = flag;
	this->maxGroupId = 0;
	while (!atEnd())
	  {
		  readNext();
		  if (isStartElement())
		    {
			    if (name() == "bookmark" && attributes().value("version") == "1.0")
			      {
				       //setting->setValue("updateTime", attributes().value("updateTime").toString().toUInt());
				       updateTime=attributes().value("updateTime").toString();
				       readBrowserType(browserType);
			      }
		  } else if (isStartDocument())
		    {
			  //  logToFile("%s %s %s", __FUNCTION__, qPrintable(documentVersion().toString()), qPrintable(documentEncoding().toString()));
		  } else if (isEndDocument())
		    {
		    }
	  }
	if (hasError())
	  {
		 // logToFile("Error: Failed to parse file %s", qPrintable(errorString()));
	  }

}
void XmlReader::importItem(struct bookmark_catagory *bc,int item)
{
	while (!atEnd())
	  {
		  readNext();
		  if (isCharacters() && !isWhitespace())   {
			switch(item){
				case BOOKMARK_CATAGORY_NAME:
				    bc->name = text().toString();
			    	    bc->name_hash= qhashEx(bc->name,bc->name.length());
				break;
				case BOOKMARK_CATAGORY_LINK:
				     bc->link = text().toString().trimmed();
				    handleUrlString(bc->link);
				    if(bc->link.length())
				    	bc->link_hash=qhashEx(bc->link ,bc->link.length());
				    else
					bc->link_hash=0;	
				break;
				case BOOKMARK_CATAGORY_DESCIPTION:
					bc->desciption = text().toString().trimmed();
				break;
				case BOOKMARK_CATAGORY_ICON:
					bc->icon= text().toString().trimmed();
				break;
				case BOOKMARK_CATAGORY_FEEDURL:
					bc->feedurl= text().toString().trimmed();
				break;
				case BOOKMARK_CATAGORY_LAST_CHARSET:
					bc->last_charset= text().toString().trimmed();
				break;
				case BOOKMARK_CATAGORY_PERSONAL_TOOLBAR_FOLDER:
					bc->personal_toolbar_folder= text().toString().trimmed();
				break;
				case BOOKMARK_CATAGORY_ID:
					bc->id= text().toString();
				break;
				case BOOKMARK_CATAGORY_ADDDATE:
					 bc->addDate = QDateTime::fromString(text().toString().trimmed(), TIME_FORMAT);
				break;
				case BOOKMARK_CATAGORY_MODIFYDATE:
					   bc->modifyDate = QDateTime::fromString(text().toString().trimmed(), TIME_FORMAT);
					    //update the serverlastUpdateTime
					    if (bc->modifyDate > serverLastUpdateTime)
						    serverLastUpdateTime = bc->modifyDate;
				break;
				case BOOKMARK_CATAGORY_LAST_VISIT:
					bc->last_visit= text().toString().trimmed();
				break;
				case BOOKMARK_CATAGORY_FLAGX:
				break;
				case BOOKMARK_CATAGORY_GROUPID:
				break;
				case BOOKMARK_CATAGORY_PARENTID:
				break;
				case BOOKMARK_CATAGORY_BMID:
					bc->bmid= text().toString().toUInt();
				break;
				case BOOKMARK_CATAGORY_LEVEL:
				break;
				case BOOKMARK_CATAGORY_HR:
					bc->hr= text().toString().toUInt();
				break;
				case BOOKMARK_CATAGORY_NAME_HASH:
				break;
				case BOOKMARK_CATAGORY_LINK_HASH:
				break;
			}
		   }
		  else if (isEndElement())		    
			    break;		    
	  }
}
#if 0
void XmlReader::importName(struct bookmark_catagory *bc)
{
	while (!atEnd())
	  {
		  readNext();
		  if (isCharacters() && !isWhitespace())
		    {
			    //    logToFile("%s %s",__FUNCTION__,qPrintable(text().toString()));       
			   // bc->name = text().toString().trimmed();
			   bc->name = text().toString();
			    bc->name_hash= qhashEx(bc->name,bc->name.length());
		  } else if (isEndElement())
		    {
			    break;
		    }
	  }
}

void XmlReader::importLink(struct bookmark_catagory *bc)
{
	while (!atEnd())
	  {
		  readNext();
		  if (isCharacters() && !isWhitespace())
		    {
			    //   logToFile("%s %s",__FUNCTION__,qPrintable(text().toString()));       
			    bc->link = text().toString().trimmed();
			    handleUrlString(bc->link);
			    if(bc->link.length())
			    	bc->link_hash=qhashEx(bc->link ,bc->link.length());
			    else
				bc->link_hash=0;	
		  } else if (isEndElement())
		    {
			    break;
		    }
	  }
}
void XmlReader::importID(struct bookmark_catagory *bc)
{
	while (!atEnd())
		  {
			  readNext();
			  if (isCharacters() && !isWhitespace())
				{
					//	 logToFile("%s %s",__FUNCTION__,qPrintable(text().toString())); 	  
					bc->id= text().toString();
			  } else if (isEndElement())
				{
					break;
				}
		  }

}
void XmlReader::importbmid(struct bookmark_catagory *bc)
{
	while (!atEnd())
		  {
			  readNext();
			  if (isCharacters() && !isWhitespace())
				{
					//	 logToFile("%s %s",__FUNCTION__,qPrintable(text().toString())); 	  
					bc->bmid= text().toString().toUInt();
			  } else if (isEndElement())
				{
					break;
				}
		  }

}

void XmlReader::importFeedurl(struct bookmark_catagory *bc)
{
	while (!atEnd())
		  {
			  readNext();
			  if (isCharacters() && !isWhitespace())
				{
					//	 logToFile("%s %s",__FUNCTION__,qPrintable(text().toString())); 	  
					bc->feedurl= text().toString().trimmed();
			  } else if (isEndElement())
				{
					break;
				}
		  }

}
void XmlReader::importIcon(struct bookmark_catagory *bc)
{
	while (!atEnd())
		  {
			  readNext();
			  if (isCharacters() && !isWhitespace())
				{
					//	 logToFile("%s %s",__FUNCTION__,qPrintable(text().toString())); 	  
					bc->icon= text().toString().trimmed();
			  } else if (isEndElement())
				{
					break;
				}
		  }

}
void XmlReader::importLastVisit(struct bookmark_catagory *bc)
{
	while (!atEnd())
		  {
			  readNext();
			  if (isCharacters() && !isWhitespace())
				{
					bc->last_visit= text().toString().trimmed();
			  } else if (isEndElement())
				{
					break;
				}
		  }

}
void XmlReader::importLastCharset(struct bookmark_catagory *bc)
{
	while (!atEnd())
		  {
			  readNext();
			  if (isCharacters() && !isWhitespace())
				{
					//	 logToFile("%s %s",__FUNCTION__,qPrintable(text().toString())); 	  
					bc->last_charset= text().toString().trimmed();
			  } else if (isEndElement())
				{
					break;
				}
		  }

}

void XmlReader::importHr(struct bookmark_catagory *bc)
{
		while (!atEnd())
			  {
				  readNext();
				  if (isCharacters() && !isWhitespace())
					{
						//	 logToFile("%s %s",__FUNCTION__,qPrintable(text().toString())); 	  
						bc->hr= text().toString().toUInt();
				  } else if (isEndElement())
					{
						break;
					}
			  }
	
}

void XmlReader::importPersonalToolbarFolder(struct bookmark_catagory *bc)
{
	while (!atEnd())
		  {
			  readNext();
			  if (isCharacters() && !isWhitespace())
				{
					//	 logToFile("%s %s",__FUNCTION__,qPrintable(text().toString())); 	  
					bc->personal_toolbar_folder= text().toString().trimmed();
			  } else if (isEndElement())
				{
					break;
				}
		  }

}

void XmlReader::importDescription(struct bookmark_catagory *bc)
{
	while (!atEnd())
	  {
		  readNext();
		  if (isCharacters() && !isWhitespace())
		    {
			    //   logToFile("%s %s",__FUNCTION__,qPrintable(text().toString()));       
			    bc->desciption = text().toString().trimmed();
		  } else if (isEndElement())
		    {
			    break;
		    }
	  }
}
void XmlReader::importAdddate(struct bookmark_catagory *bc)
{
	while (!atEnd())
	  {
		  readNext();
		  if (isCharacters() && !isWhitespace())
		    {
//                                     logToFile("%s %s",__FUNCTION__,qPrintable(text().toString())); 
			    bc->addDate = QDateTime::fromString(text().toString().trimmed(), TIME_FORMAT);
		  } else if (isEndElement())
		    {
			    break;
		    }
	  }
}
void XmlReader::importModifydate(struct bookmark_catagory *bc)
{
//      LOG_RUN_LINE;
	while (!atEnd())
	  {
		  readNext();
		  if (isCharacters() && !isWhitespace())
		    {
//                                     logToFile("%s %s",__FUNCTION__,qPrintable(text().toString())); 
			    bc->modifyDate = QDateTime::fromString(text().toString().trimmed(), TIME_FORMAT);
			    //update the serverlastUpdateTime
			    if (bc->modifyDate > serverLastUpdateTime)
				    serverLastUpdateTime = bc->modifyDate;
		  } else if (isEndElement())
		    {
			    break;
		    }
	  }
}

#endif

void XmlReader::CreateCatagory(int level, QList < bookmark_catagory > *list, uint groupId, uint parentId)
{
	struct bookmark_catagory bc;
	bc.level = level;
	bc.flag = BOOKMARK_CATAGORY_FLAG;
	bc.groupId = groupId;
	bc.parentId = parentId;	
	bc.hr=0;
	struct {
		enum BOOKMARK_CATAGORY_ITEM im;
		QString name;
	} importlist[]={
		{  BOOKMARK_CATAGORY_NAME , QString("name") },
		{  BOOKMARK_CATAGORY_DESCIPTION , QString("DD") },
		{  BOOKMARK_CATAGORY_LINK , QString("link") },
		{  BOOKMARK_CATAGORY_BMID , QString("bmid") },
		{  BOOKMARK_CATAGORY_ADDDATE , QString("ADD_DATE") },
		{  BOOKMARK_CATAGORY_MODIFYDATE , QString("LAST_MODIFIED") },
		{  BOOKMARK_CATAGORY_ID , QString("ID") },
		{  BOOKMARK_CATAGORY_ICON , QString("ICON") },
		{  BOOKMARK_CATAGORY_FEEDURL , QString("FEEDURL") },
		{  BOOKMARK_CATAGORY_LAST_CHARSET , QString("LAST_CHARSET") },
		{  BOOKMARK_CATAGORY_PERSONAL_TOOLBAR_FOLDER , QString("PERSONAL_TOOLBAR_FOLDER") },
		{  BOOKMARK_CATAGORY_HR , QString("HR") },
		{  BOOKMARK_CATAGORY_MAX , QString("")}
	};
	while (!atEnd())
	  {
		  readNext();
		  if (isStartElement())
		    {
		    	int i = 0;
			while( !importlist[i].name.isEmpty() )
			{
				if( name() == importlist[i].name )
					{
						importItem(&bc,importlist[i].im);
						break;
					}
				i++;
			}
			
#if 0
			    if (name() == "name")
				    importName(&bc);
			    else if (name() == "link")
				    importLink(&bc);
			    else if(name()=="bmid")
				   importbmid(&bc);
			    else if (name() == "DD")
				    importDescription(&bc);
			    else if (name() == "ADD_DATE")
				    importAdddate(&bc);
			    else if (name() == "LAST_MODIFIED")
				    importModifydate(&bc);
			    else if (name() == "ID")
				    importID(&bc);
			    else if (name() == "FEEDURL")
				    importFeedurl(&bc);
			   else if (name() == "ICON")
				    importIcon(&bc);
			    else if (name() == "LAST_CHARSET")
				    importLastCharset(&bc);		
			    else if(name()=="PERSONAL_TOOLBAR_FOLDER")
				   importPersonalToolbarFolder(&bc);
			    else if(name()=="HR")
				   importHr(&bc);
			    else
#endif
			    if (name() == "item")
				    CreateItem(level + 1, &(bc.list), attributes().value("parentId").toString().toUInt());
			    else if (name() == "category")
			      {
				    //  if (maxGroupId < (attributes().value("groupId").toString().toUInt()))
				//	      maxGroupId = (attributes().value("groupId").toString().toUInt());
				      uint      level_groupId = (attributes().value("groupId").toString().toUInt());
				      uint       level_parentId = (attributes().value("parentId").toString().toUInt());
				      CreateCatagory(level + 1, &(bc.list), level_groupId, level_parentId);
			      }
		  } else if (isEndElement())
		    {
			    if (name() == "category")
			      {
			      	      bc.link.clear();
				      bc.link_hash=0;
			      	    //  list->push_back(bc);
				      addItemToSortlist(bc,list);
				      break;
			      }
		    }
	  }
}
void XmlReader::CreateItem(int level, QList < bookmark_catagory > *list, uint parentId)
{
	struct bookmark_catagory bc;
	bc.level = level;
	bc.flag = BOOKMARK_ITEM_FLAG;
	bc.groupId = 0;
	bc.parentId = parentId;
	bc.hr=0;

	struct {
		enum BOOKMARK_CATAGORY_ITEM im;
		QString name;
	} importlist[]={
		{  BOOKMARK_CATAGORY_NAME , QString("name") },
		{  BOOKMARK_CATAGORY_DESCIPTION , QString("DD") },
		{  BOOKMARK_CATAGORY_LINK , QString("link") },
		{  BOOKMARK_CATAGORY_BMID , QString("bmid") },
		{  BOOKMARK_CATAGORY_ADDDATE , QString("ADD_DATE") },
		{  BOOKMARK_CATAGORY_MODIFYDATE , QString("LAST_MODIFIED") },
		{  BOOKMARK_CATAGORY_ID , QString("ID") },
		{  BOOKMARK_CATAGORY_ICON , QString("ICON") },
		{  BOOKMARK_CATAGORY_FEEDURL , QString("FEEDURL") },
		{  BOOKMARK_CATAGORY_LAST_CHARSET , QString("LAST_CHARSET") },
		{  BOOKMARK_CATAGORY_PERSONAL_TOOLBAR_FOLDER , QString("PERSONAL_TOOLBAR_FOLDER") },
		{  BOOKMARK_CATAGORY_HR , QString("HR") },
		{  BOOKMARK_CATAGORY_MAX , QString("")}
	};
	
	while (!atEnd())
	  {
		  readNext();
		  if (isStartElement())
		    {
			int i = 0;
			while( !importlist[i].name.isEmpty() )
			{
				if( name() == importlist[i].name )
					{
						importItem(&bc,importlist[i].im);
						break;
					}
				i++;
			}
#if 0				
			    if (name() == "name")
				    importName(&bc);
			    else if (name() == "link")
				    importLink(&bc);
			    else if(name()=="bmid")
				   importbmid(&bc);
			    else if (name() == "DD")
				    importDescription(&bc);
			    else if (name() == "ADD_DATE")
				    importAdddate(&bc);
			    else if (name() == "LAST_MODIFIED")
				    importModifydate(&bc);
			    else if (name() == "ID")
				    importID(&bc);
			    else if (name() == "FEEDURL")
				    importFeedurl(&bc);
			   else if (name() == "ICON")
				    importIcon(&bc);
			    else if (name() == "LAST_CHARSET")
				    importLastCharset(&bc);	
			    else if (name() == "LAST_VISIT")
				    importLastVisit(&bc);
			    else if(name()=="HR")
				   importHr(&bc);
#endif
				
		  } else if (isEndElement())
		    {
			    if (name() == "item")
			      {
				     // list->push_back(bc);
				      addItemToSortlist(bc,list);  
				      break;
			      }
		    }
	  }
}

void XmlReader::readBookmarkElement()
{
//      LOG_RUN_LINE;
	while (!atEnd())
	  {
		  readNext();
		  if (isStartElement())
		    {
			    //      logToFile("%s %s",__FUNCTION__,qPrintable(name().toString()));
			    if (name() == "category")
			      {
				   //   if (maxGroupId < (attributes().value("groupId").toString().toUInt()))
					uint      groupId = (attributes().value("groupId").toString().toUInt());
				        uint      parentId = (attributes().value("parentId").toString().toUInt());
				      CreateCatagory(0, &bm_list,groupId, parentId);
			    } else if (name() == "item")
			      {
				      CreateItem(0, &bm_list, attributes().value("parentId").toString().toUInt());
			      }
		  } else if (isCharacters() && !isWhitespace())
		    {
			    //       logToFile("%s %s",__FUNCTION__,qPrintable(text().toString()));                       
		  } else if (isEndElement())
		    {
					if((name() == "browserType"))
					break;
		    }
	  }
}
void XmlReader::bmListToXml(int flag, QList < bookmark_catagory > *list, QTextStream * os,int browserType,int start,QString updateTime)
{
	if (flag&BM_WRITE_HEADER)
	  {
		//  writeToFile(os, "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
		  *os<<"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
		 *os<<"<bookmark version=\"1.0\" updateTime=\""<<updateTime<<"\">\n";
	  }
	if(start) 
			writeToFile(os, "<browserType name=\"%s\">\n",qPrintable(browserName[browserType]));	
	qDebug("firefox_bc's size is %d",list->size());
	foreach(bookmark_catagory bm, *list)
	{
		//*os<<"flag="<<bm.flag<<" name="<<bm.name<<"\n";
		if (bm.flag == BOOKMARK_CATAGORY_FLAG)
		  {
			  writeToFile(os, "<category groupId=\"%u\" parentId=\"%u\">\n", bm.groupId, bm.parentId);
			  *os<< "<name><![CDATA["<<bm.name<<"]]></name>\n";
			   if(!bm.link.isNull()&&!bm.link.isEmpty())
			 	 writeToFile(os, "<link><![CDATA[%s]]></link>\n", qPrintable(bm.link));
			  if(bm.addDate.isValid())
			  	writeToFile(os, "<ADD_DATE><![CDATA[%s]]></ADD_DATE>\n", qPrintable(bm.addDate.toString(TIME_FORMAT)));
			  if(bm.modifyDate.isValid())
			  	writeToFile(os, "<LAST_MODIFIED><![CDATA[%s]]></LAST_MODIFIED>\n", qPrintable(bm.modifyDate.toString(TIME_FORMAT)));
			  if(!bm.id.isNull()&&!bm.id.isEmpty())
			  	writeToFile(os, "<ID><![CDATA[%s]]></ID>\n", qPrintable(bm.id));
			  writeToFile(os, "<bmid><![CDATA[%u]]></bmid>\n", bm.bmid);
			  if(!bm.desciption.isNull()&&!bm.desciption.isEmpty())
			  	*os<<"<DD><![CDATA["<<bm.desciption<<"]]></DD>\n";
			 if(!bm.personal_toolbar_folder.isNull()&&!bm.personal_toolbar_folder.isEmpty())
			  	writeToFile(os, "<PERSONAL_TOOLBAR_FOLDER><![CDATA[%s]]></PERSONAL_TOOLBAR_FOLDER>\n", qPrintable(bm.personal_toolbar_folder));
			  if(!bm.last_visit.isNull()&&!bm.last_visit.isEmpty())
			  	writeToFile(os, "<LAST_VISITE><![CDATA[%s]]></LAST_VISITE>\n", qPrintable(bm.last_visit));
			  if(bm.hr==1)
			  	writeToFile(os, "<HR><![CDATA[%d]]></HR>\n", bm.hr);
			  bmListToXml(0, &(bm.list), os,browserType,0,updateTime);
			  writeToFile(os, "</category>\n");

		} else
		  {
			  writeToFile(os, "<item parentId=\"%u\">\n", bm.parentId);
			  *os<< "<name><![CDATA["<<bm.name<<"]]></name>\n";
			  writeToFile(os, "<link><![CDATA[%s]]></link>\n", qPrintable(bm.link));			  
			  if(bm.addDate.isValid())
			  writeToFile(os, "<ADD_DATE><![CDATA[%s]]></ADD_DATE>\n", qPrintable(bm.addDate.toString(TIME_FORMAT)));
			   if(bm.modifyDate.isValid())
			  writeToFile(os, "<LAST_MODIFIED><![CDATA[%s]]></LAST_MODIFIED>\n", qPrintable(bm.modifyDate.toString(TIME_FORMAT)));		
			  writeToFile(os, "<bmid><![CDATA[%u]]></bmid>\n", bm.bmid);
			   if(!bm.id.isNull()&&!bm.id.isEmpty())
			  	writeToFile(os, "<ID><![CDATA[%s]]></ID>\n", qPrintable(bm.id));
			   if(!bm.icon.isNull()&&!bm.icon.isEmpty())
			  	*os<< "<ICON><![CDATA["<<bm.icon<<"]]></ICON>\n";
			   if(!bm.desciption.isNull()&&!bm.desciption.isEmpty())
			  	*os<<"<DD><![CDATA["<<bm.desciption<<"]]></DD>\n";
			   if(!bm.last_visit.isNull()&&!bm.last_visit.isEmpty())
			  	writeToFile(os, "<LAST_VISITE><![CDATA[%s]]></LAST_VISITE>\n", qPrintable(bm.last_visit));
			   if(!bm.feedurl.isNull()&&!bm.feedurl.isEmpty())
			  	writeToFile(os, "<FEEDURL><![CDATA[%s]]></FEEDURL>\n", qPrintable(bm.feedurl));
			    if(!bm.last_charset.isNull()&&!bm.last_charset.isEmpty())
			  	writeToFile(os, "<LAST_CHARSET><![CDATA[%s]]></LAST_CHARSET>\n", qPrintable(bm.last_charset));
			  if(bm.hr==1)
			  	writeToFile(os, "<HR><![CDATA[%d]]></HR>\n", bm.hr);
			  writeToFile(os, "<comeFrom><![CDATA[%u]]></comeFrom>\n", COME_FROM_IE+(browserType-BROWSER_TYPE_IE));
			  writeToFile(os, "</item>\n");
		  }

	}
	if(start)
			writeToFile(os,"</browserType>\n");
	if (flag&BM_WRITE_END)
		{
			
			writeToFile(os, "</bookmark>\n");
		}


}
void XmlReader::dumpBookmarkList(int level, QList < bookmark_catagory > list)
{
	foreach(bookmark_catagory bm, list)
	{
		QString str;
		for (int i = 0; i < level; i++)
			str.append("		");
		//logToFile("%s bm:flag=%d groupid=%d parentId=%d level=%d name=%s link=%s desciption=%s adddate=%s modifydate=%s", qPrintable(str), bm.flag, bm.groupId, bm.parentId, bm.level, qPrintable(bm.name), qPrintable(bm.link), qPrintable(bm.desciption), qPrintable(bm.addDate.toString(TIME_FORMAT)), qPrintable(bm.modifyDate.toString(TIME_FORMAT)));
		if (bm.list.count())
			dumpBookmarkList(level + 1, bm.list);

	}
}
void XmlReader::writeToFile(QTextStream * os, const char *cformat, ...)
{
/*
	va_list ap;
	va_start(ap, cformat);
	char msg[1024] = { 0 };
	vsnprintf(msg, sizeof(msg), cformat, ap);
	va_end(ap);
	//QString msgstring(msg);
	*os << QString::fromLocal8Bit(msg);
	*/
	va_list ap;
	va_start(ap, cformat);
	QString msg;
	msg.vsprintf( cformat, ap);
	va_end(ap);
	//qDebug("msg=%s",qPrintable(msg));
	*os << msg;
}
void XmlReader::buildLocalBmSetting(int level, QString path, QList < bookmark_catagory > list, QTextStream * os)
{
	foreach(bookmark_catagory bm, list)
	{
		if (bm.flag == BOOKMARK_CATAGORY_FLAG)
		  {
			  buildLocalBmSetting(level + 1, path + "/" + bm.name, bm.list, os);
			  writeToFile(os, "\n%s" LOCAL_BM_SETTING_INTERVAL "%s", qPrintable(path + "/" + bm.name), qPrintable(bm.link));
		} else
		  {
			  writeToFile(os, "\n%s" LOCAL_BM_SETTING_INTERVAL "%s", qPrintable(path + "/" + bm.name), qPrintable(bm.link));
		  }

	}
}
void XmlReader::importCatItemName(CatItem *item)
{
	while (!atEnd())
	  {
		  readNext();
		  if (isCharacters() && !isWhitespace())
		    {
			    item->shortName = text().toString().trimmed();
			    item->lowName = item->shortName.toLower();	
			    item->getPinyinReg(item->shortName );
		  } else if (isEndElement())
		    {
			    break;
		    }
	  }
}
void XmlReader::importCatItemComefrom(CatItem *item)
{
	while (!atEnd())
		  {
			  readNext();
			  if (isCharacters() && !isWhitespace())
				{
					item->comeFrom= text().toString().toUInt();
				//	qDebug("item->comeFrom=%d",item->comeFrom);
			  } else if (isEndElement())
				{
					break;
				}
		  }

}
void XmlReader::importCatItemFullPath(CatItem *item)
{
	while (!atEnd())
	  {
		  readNext();
		  if (isCharacters() && !isWhitespace())
		    {
			    item->fullPath = text().toString().trimmed();
			    item->hash_id=qHash(item->fullPath);			   
			    item->usage = 0;
			    item->groupId=0;
			    item->parentId=0;
			    item->alias1="";
			    item->alias2="";
			    item->shortCut="";
		  } else if (isEndElement())
		    {
			    break;
		    }
	  }
}

void XmlReader::readCategoryElement()
{

}
void XmlReader::readItemElement()
{
}


void XmlReader::addItemToSortlist(const struct bookmark_catagory &bc,QList < bookmark_catagory > *list)
{
       // QDEBUG("add name=%s name_hash=%u",qPrintable(bc.name),bc.name_hash);
	int i=0;
	if(!list->size()) //empty
		{
			list->push_back(bc);
			return;
		}
	
	for(i=0;i<list->size();i++)
	{
		if(list->at(i).name_hash<bc.name_hash)
			continue;		
		list->insert(i,bc);		
		return;
	}
	if(i==list->size())
		{
			list->push_back(bc);
		}
}
//flag 0--file 1--dir

void XmlReader::readDirectory(QString directory, QList < bookmark_catagory > *list, int level/*, uint flag*/)
{
	//if (level == 0)
	//	this->flag = flag;
	QString createTime, lastAccessTime, lastWriteTime;
	QDir qd(directory);
	QString dir = qd.absolutePath();
	QStringList dirs = qd.entryList(QDir::AllDirs | QDir::NoDotAndDotDot);


	for (int i = 0; i < dirs.count(); ++i)
	  {
		  QString cur = dirs[i];
		  if (cur.contains(".lnk"))
			  continue;
		   struct bookmark_catagory dir_bc;
		   dir_bc.name = dirs[i];
		  // dir_bc.name.trimmed();
		   dir_bc.name_hash=qhashEx(dir_bc.name,dir_bc.name.length());
		   dir_bc.link.clear();
		   dir_bc.link_hash=0;
		   dir_bc.flag = BOOKMARK_CATAGORY_FLAG;
		   dir_bc.level = level;
		  readDirectory(dir + "/" + dirs[i], &(dir_bc.list), level + 1/*,  flag*/);
		  addItemToSortlist(dir_bc,list);
	  }
	QStringList files = qd.entryList(QStringList("*.url"), QDir::Files, QDir::Unsorted);
	for (int i = 0; i < files.count(); ++i)
	  {
		  struct bookmark_catagory bc;
		  const QString FilePath(dir + "/" + files[i]);
		  QSettings favSettings (FilePath, QSettings::IniFormat);
		    {
			    struct bookmark_catagory dir_bc;
			    int dotIndex = files[i].lastIndexOf('.');
			    files[i].truncate(dotIndex);
			    dir_bc.link = favSettings.value("InternetShortcut/URL").toString();
			    if( !dir_bc.link.isEmpty())
			    {
			    	    QUrl url(dir_bc.link);
				    if (!url.isValid() || ((url.scheme().toLower() != QLatin1String("http"))&&(url.scheme().toLower() != QLatin1String("https")))) {
					//	qDebug()<<"unvalid http format!";
						break;
				    }
				    handleUrlString(dir_bc.link );
				    dir_bc.name = files[i];
				    dir_bc.name.trimmed();
				    dir_bc.name_hash=qhashEx(dir_bc.name,dir_bc.name.length());
					  
					   
				    dir_bc.link_hash=qhashEx(dir_bc.link,dir_bc.link.length());
				    dir_bc.flag = BOOKMARK_ITEM_FLAG;
				    dir_bc.level = level;			
				   // list->push_back(dir_bc);
				    addItemToSortlist(dir_bc,list);
			    	}
		    }
		  //items->push_back(CatItem(dir + "/" + files[i], files[i].mid(0,files[i].size()-4)));
	  }
}
/**************************firefox***************************************/
int XmlReader::outChildItem(int id,QSqlDatabase *db,QTextStream& os,QList < bookmark_catagory > *list,QString & excludeid)
{

		QString queryStr=QString("select * from moz_bookmarks bookmarks left join moz_places places on bookmarks.fk=places.id where bookmarks.parent=%1 and bookmarks.id not in (%2);").arg(id).arg(excludeid);
		qDebug("%s",qPrintable(queryStr));
		QSqlQuery   query(queryStr, *db);
		if(query.exec()){
					// os<<"##################################################\n";
					
					 QSqlRecord rec = query.record();
					  int idIndex = rec.indexOf("id"); // index of the field "name"
					  int typeIndex=rec.indexOf("type");
					  int urlIndex=rec.indexOf("url");
					  int titleIndex=rec.indexOf("title");
					  int parentIndex=rec.indexOf("parent");
					  while(query.next()) { 
						   if(query.value(urlIndex).toString().startsWith("place:")/*&&query.value(titleIndex).toString().isEmpty()*/)
											continue;
						    /*
							   for(int j=0;j<rec.count();j++){
								   (os)<<"|"<<query.value(j).toString();									
							   }
							  */
							 if(query.value(typeIndex).toInt()!=2){
								 if(!query.value(titleIndex).toString().isNull())
								 {
									  //os<<"<item itemId=\""<<query.value(idIndex).toString()<<"\" parentId=\""<<query.value(parentIndex).toString()<<"\">"<<"\n";
									  os<<"<item  parentId=\""<<query.value(parentIndex).toString()<<"\">"<<"\n";
									  os<<"<name><![CDATA["<<query.value(titleIndex).toString()<<"]]></name>"<<"\n";
									  os<<"<link><![CDATA["<<query.value(urlIndex).toString()<<"]]></link>"<<"\n";
									  os<<"</item>"<<"\n";
									   struct bookmark_catagory ff_bc;
		  							   ff_bc.name =query.value(titleIndex).toString();									   
									   ff_bc.name_hash=qhashEx(ff_bc.name,ff_bc.name.length());									   
									   ff_bc.link =query.value(urlIndex).toString();
									   handleUrlString(ff_bc.link);
									    QUrl url(ff_bc.link);
									    if (!url.isValid() || ((url.scheme().toLower() != QLatin1String("http"))&&(url.scheme().toLower() != QLatin1String("https")))) {
											//qDebug()<<"unvalid http format!";
											goto out;
									    }
									   ff_bc.link_hash=qhashEx(ff_bc.link,ff_bc.link.length());				
									   ff_bc.parentId=query.value(parentIndex).toString().toUInt();
		  							   ff_bc.flag = BOOKMARK_ITEM_FLAG;
									 //  list->push_back(ff_bc);
									    addItemToSortlist(ff_bc,list);
								 }
							 }
							//(os)<<"\n";
							if(query.value(typeIndex).toInt()==2)
							{
									//abbreviate the root direcory
									if(query.value(idIndex).toString().toUInt()!=FIREFORX3_ROOT_ID)
									{
										 if(!query.value(titleIndex).toString().isEmpty())
										   {
											   struct bookmark_catagory ff_bc;
				  							   ff_bc.name =query.value(titleIndex).toString();	
											   ff_bc.name_hash=qhashEx(ff_bc.name,ff_bc.name.length());		
											   ff_bc.groupId=query.value(idIndex).toString().toUInt();
											   ff_bc.parentId=query.value(parentIndex).toString().toUInt();
				  							   ff_bc.flag = BOOKMARK_CATAGORY_FLAG;
											   os<<"<category groupId=\""<<query.value(idIndex).toString()<<"\" parentId=\""<<query.value(parentIndex).toString()<<"\">"<<"\n";
											   os<<"<name><![CDATA["<<query.value(titleIndex).toString()<<"]]></name>"<<"\n";
											   os<<"<link><![CDATA["<<query.value(urlIndex).toString()<<"]]></link>"<<"\n";
											   ff_bc.link_hash=0;
											   outChildItem(query.value(idIndex).toInt(),db,os,&(ff_bc.list),excludeid);
											   os<<"</category>"<<"\n";
											   addItemToSortlist(ff_bc,list);
										 }
									}else{
										 outChildItem(query.value(idIndex).toInt(),db,os,list,excludeid);
									}

								 
							}
						out:
							do{}while(0);
					  }
				
		}
		return 0;
}

QString XmlReader::productExcludeIdStr(QSqlDatabase *db)
{	
		QString ff_excludeId;
		qDebug("productExcludeIdStr begin.......");
	        QStringList excludeStr;
        	excludeStr << "tags" << "unfiled"; 
		for (int i = 0; i < excludeStr.size(); ++i)
		{
			
			QString queryStr=QString("select folder_id from moz_bookmarks_roots where root_name='%1';").arg(excludeStr.at(i));
			qDebug("%s",qPrintable(queryStr));
			QSqlQuery   query(queryStr, *db);
			if(query.exec()){					
					while(query.next()) { 
						if(!ff_excludeId.isEmpty()) 
						ff_excludeId.append(",");
							ff_excludeId.append(query.value(0).toString());
					}
			}
			else{
				qDebug("productExcludeIdStr sql error!query \n");
				return -1;
			}
		}
		qDebug("ff_excludeId:%s",qPrintable(ff_excludeId));
		 QString exclude_moz_anno_attributes_id;
		 QStringList exclude_moz_anno_attributes_id_str;
		 exclude_moz_anno_attributes_id_str<<"Places/SmartBookmark"<<"placesInternal/READ_ONLY"<<"livemark/feedURI"<<"livemark/siteURI"
		 <<"livemark/expiration"<<"places/excludeFromBackup"<<"PlacesOrganizer/OrganizerFolder"<<"PlacesOrganizer/OrganizerQuery"<<"URIProperties/characterSet";
		for (int i = 0; i < exclude_moz_anno_attributes_id_str.size(); ++i)
		{
			
			QString queryStr=QString("select id from moz_anno_attributes where name='%1';").arg(exclude_moz_anno_attributes_id_str.at(i));
			qDebug("%s",qPrintable(queryStr));
			QSqlQuery   query(queryStr, *db);
			if(query.exec()){					
					while(query.next()) { 
						if(!exclude_moz_anno_attributes_id.isEmpty()) 
							exclude_moz_anno_attributes_id.append(",");
						exclude_moz_anno_attributes_id.append(query.value(0).toString());
					}
			}
		}
		qDebug("exclude_moz_anno_attributes_id=%s",qPrintable(exclude_moz_anno_attributes_id));
		
		QString queryStr=QString("select distinct item_id from moz_items_annos where anno_attribute_id in (%1);").arg(exclude_moz_anno_attributes_id);
		qDebug("%s",qPrintable(queryStr));
			QSqlQuery   query(queryStr, *db);
			if(query.exec()){				
					while(query.next()) { 
							if(!ff_excludeId.isEmpty()) 
									ff_excludeId.append(",");
						ff_excludeId.append(query.value(0).toString());
					}
			}
		qDebug("ff_excludeId=%s",qPrintable(ff_excludeId));
		return ff_excludeId;
}

int XmlReader::readFirefoxBookmark3(QSettings* settings,QSqlDatabase* db,QList < bookmark_catagory > *list)
{
	 QSettings ff_reg("HKEY_LOCAL_MACHINE\\Software\\Mozilla\\Mozilla Firefox",QSettings::NativeFormat);
	 qDebug("firefox's version is %s",qPrintable(ff_reg.value("CurrentVersion","").toString()));
//	 ff_excludeId.clear();
	 QString excludeid =  productExcludeIdStr(db);
	 QString dest_filepath;
	  getUserLocalFullpath(settings,QString(BM_XML_FROM_FIREFOX),dest_filepath);
	  QFile file(dest_filepath);
	  file.open(QIODevice::WriteOnly | QIODevice::Text /*| QIODevice::Append*/);
	 QTextStream os(&file);
	 os.setCodec("UTF-8");
	 os<<"<?xml version=\"1.0\" encoding=\"utf-8\"?>"<<"\n";
	 os<<"<bookmark version=\"1.0\" updateTime=\"2009-11-22 21:36:20\">"<<"\n";
	 os<<"<browserType name=\"firefox\">"<<"\n";
	 outChildItem(0,db,os,list,excludeid);
	 os<<"</browserType>"<<"\n";
	 os<<"</bookmark>"<<"\n";
	 file.close();
	 return 1;
}
void XmlReader::setFirefoxDb(QSqlDatabase* db)
{
	ff_db=db;
}

int XmlReader::readFirefoxBookmark2(QFile& file)
{
	init_ff_bm();
	QString tmp_firefox2_xml_filepath;
	getUserLocalFullpath(settings,QString("/firefox2.xml"),tmp_firefox2_xml_filepath);
//	qDebug("tmp_firefox2_xml_filepath=%s",qPrintable(tmp_firefox2_xml_filepath));
       QFile ff_file(tmp_firefox2_xml_filepath);
	if (!ff_file.open(QIODevice::WriteOnly | QIODevice::Text))
		return 0;
	QTextStream ff_in(&ff_file);
	ff_in.setCodec("UTF-8");
	ff_in<<"<?xml version=\"1.0\" encoding=\"utf-8\"?>"<<"\n";
	ff_in<<"<bookmark version=\"1.0\" updateTime=\"2009-11-22 21:36:20\">"<<"\n";
	ff_in<<"<browserType name=\"firefox\" version=\"2\">"<<"\n";
	QRegExp regex_dir("<DT><H3 [\\s\\S]*>([\\s\\S]*)</H3>", Qt::CaseInsensitive);
	QRegExp regex_url("<a href=\"([^\"]*)\"", Qt::CaseInsensitive);
	QRegExp regex_urlname("\">([^<]*)</A>", Qt::CaseInsensitive);
	QRegExp regex_shortcut("SHORTCUTURL=\"([^\"]*)\"");
	QRegExp regex_postdata("POST_DATA", Qt::CaseInsensitive);
	QRegExp regex_hr("<HR>", Qt::CaseInsensitive);
	QRegExp regex_dirstart("<DL><p>",Qt::CaseInsensitive);
	QRegExp regex_dirend("</DL><p>",Qt::CaseInsensitive);
	QRegExp regex_h1("<H1 [\\s\\S]*>([\\s\\S]*)</H1>",Qt::CaseInsensitive);
	QRegExp regex_dd("<DD>([\\s\\S]*)",Qt::CaseInsensitive);
	int now_type=0;//catagory or item
	int now_finish=0;
	int has_hr=0;
	while (!file.atEnd()) {
		QString line = QString::fromUtf8(file.readLine());
		if(regex_hr.indexIn(line)!=-1){
				has_hr=1;
			}
		if (regex_dir.indexIn(line) != -1) {
			item_end(ff_in,now_type,now_finish);
			//qDebug("dir=%s",qPrintable(regex_dir.cap(1)));
			//qDebug("line=%s",qPrintable(line));
			ff_in<<"<category>"<<"\n";
			ff_in<<"<name><![CDATA["<<regex_dir.cap(1)<<"]]></name>"<<"\n";
			if(has_hr){
				ff_in<<"<HR><![CDATA["<<1<<"]]></HR>"<<"\n";
				has_hr=0;
			}
			handler_line(line,BOOKMARK_CATAGORY_FLAG);
			outToFile(ff_in);
			now_type=BOOKMARK_CATAGORY_FLAG;
		}
		if (regex_dd.indexIn(line) != -1) {
			ff_in<<"<DD><![CDATA["<<regex_dd.cap(1)<<"]]></DD>"<<"\n";
			item_end(ff_in,now_type,now_finish);

		}
		if (regex_dirend.indexIn(line) != -1&&!file.atEnd()) {
			//abbreviate the last "</DL><p>"
			//qDebug("dir=%s",qPrintable(regex_dirend.cap(1)));
			item_end(ff_in,now_type,now_finish);
			ff_in<<"</category>"<<"\n";
		}
		if(regex_dirstart.indexIn(line)!=-1){
		//	qDebug("dir start.....\n");
		}
		if (regex_url.indexIn(line) != -1) {
				item_end(ff_in,now_type,now_finish);
				QString url = regex_url.cap(1);	
				if (regex_urlname.indexIn(line) != -1) {
					QString name = regex_urlname.cap(1);				

				//qDebug("url=%s name=%s",qPrintable(url),qPrintable(name));
				ff_in<<"<item>"<<"\n";
				ff_in<<"<name><![CDATA["<<name<<"]]></name>"<<"\n";
				ff_in<<"<link><![CDATA["<<url<<"]]></link>"<<"\n";
				if(has_hr){
					ff_in<<"<HR><![CDATA["<<1<<"]]></HR>"<<"\n";
					has_hr=0;
				}
				handler_line(line,BOOKMARK_ITEM_FLAG);
				outToFile(ff_in);
				now_type=BOOKMARK_ITEM_FLAG;	
				now_finish=0;
				/*
				if (regex_shortcut.indexIn(line) != -1) {
					QString shortcut = regex_shortcut.cap(1);
						qDebug("url=%s name=%s",qPrintable(url),qPrintable(name));
				} else {

				}
				*/
	
			}			
		}
	
	}
	item_end(ff_in,now_type,now_finish);
	ff_in<<"</browserType>"<<"\n";
	ff_in<<"</bookmark>"<<"\n";
	ff_file.close();
	QDateTime  updateTime;
	QFile lastFile;
	 lastFile.setFileName(tmp_firefox2_xml_filepath);
	 lastFile.open(QIODevice::ReadOnly);
	 setDevice(&lastFile);
	 readStream(XML_FROM_FIREFOXFAV,settings,BROWSER_TYPE_FIREFOX);
	 lastFile.close();
	 return 1;
}
void XmlReader::init_ff_bm()
{
	ff_bm<<Firefox_BM(QString("ICON"),QString(""),QRegExp("ICON=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_ITEM_FLAG,DATA_TYPE_STRING)
		 <<Firefox_BM(QString("ID"),QString(""),QRegExp("ID=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_ITEM_FLAG|BOOKMARK_CATAGORY_FLAG,DATA_TYPE_STRING)
		 <<Firefox_BM(QString("ADD_DATE"),QString(""),QRegExp("ADD_DATE=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_ITEM_FLAG|BOOKMARK_CATAGORY_FLAG,DATA_TYPE_DATETIME)
		 <<Firefox_BM(QString("LAST_MODIFIED"),QString(""),QRegExp("LAST_MODIFIED=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_ITEM_FLAG|BOOKMARK_CATAGORY_FLAG,DATA_TYPE_DATETIME)
		 <<Firefox_BM(QString("LAST_CHARSET"),QString(""),QRegExp("LAST_CHARSET=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_ITEM_FLAG,DATA_TYPE_STRING)
		 <<Firefox_BM(QString("PERSONAL_TOOLBAR_FOLDER"),QString(""),QRegExp("PERSONAL_TOOLBAR_FOLDER=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_CATAGORY_FLAG,DATA_TYPE_STRING)
		 <<Firefox_BM(QString("FEEDURL"),QString(""),QRegExp("FEEDURL=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_ITEM_FLAG,DATA_TYPE_STRING)	
		 <<Firefox_BM(QString("LAST_VISIT"),QString(""),QRegExp("LAST_VISIT=\"([^\"]*)\"",Qt::CaseInsensitive),BOOKMARK_ITEM_FLAG,DATA_TYPE_STRING)
		 ;
}
void XmlReader::handler_line(QString line,int type)
{
	int i=0;
	for(i=0;i<ff_bm.size();i++){
		//clear the lasest result
		ff_bm[i].str="";
		if(!(ff_bm[i].type&type))
			continue;		
		if(ff_bm[i].reg.indexIn(line)!=-1)
			{
				
				ff_bm[i].str=ff_bm[i].reg.cap(1);
				//qDebug("str=%s",qPrintable(ff_bm[i].str));
			}
	}
}
void XmlReader::outToFile(QTextStream& os)
{
	foreach(Firefox_BM  bm,ff_bm){
			if(!bm.str.isEmpty()){
			      if(bm.dataType==DATA_TYPE_DATETIME)
				  os<<"<"<<bm.name<<"><![CDATA["<<QDateTime::fromTime_t(bm.str.toUInt()).toString(TIME_FORMAT)<<"]]></"<<bm.name<<">"<<"\n";	
			      else
				  os<<"<"<<bm.name<<"><![CDATA["<<bm.str<<"]]></"<<bm.name<<">"<<"\n";
			}
		}
}
void XmlReader::item_end(QTextStream& os,int type,int& finish)
{
	if(type==BOOKMARK_ITEM_FLAG&&!finish)
	{
		os<<"</item>"<<"\n";
		finish=1;
	}
}
void XmlReader::productFirefox2BM(int level,QList < bookmark_catagory > *list, QTextStream* os)
{
	if(!level)
		writeToFile(os,"%s","<!DOCTYPE NETSCAPE-Bookmark-file-1>\n"
	"<!-- This is an automatically generated file.\n"
	"	 It will be read and overwritten.\n"
	"	 DO NOT EDIT! -->\n"
	"<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">\n"
	"<TITLE>Bookmarks</TITLE>\n"
	"<H1 LAST_MODIFIED=\"1260708025\">Bookmarks</H1>\n"
	"												\n"
	"<DL><p>\n");

	foreach(bookmark_catagory bm, *list)
	{
		if (bm.flag == BOOKMARK_CATAGORY_FLAG)
		  {
		  	 if(bm.hr){
			 	    writeToFile(os,"%s", "<HR>\n");
		  	 	}
			  writeToFile(os,"%s", "<DT><H3");
			  if(bm.addDate.isValid())
			  	writeToFile(os, " ADD_DATE=\"%u\"",bm.addDate.toTime_t());
			   if(bm.modifyDate.isValid())
			  	writeToFile(os, " LAST_MODIFIED=\"%u\"",bm.modifyDate.toTime_t());
			   if(!bm.last_visit.isNull()&&!bm.last_visit.isEmpty())
			  	writeToFile(os, " LAST_VISITE=\"%s\"", qPrintable(bm.last_visit));
			   if(!bm.personal_toolbar_folder.isNull()&&!bm.personal_toolbar_folder.isEmpty())
			  	writeToFile(os, " PERSONAL_TOOLBAR_FOLDER=\"%s\"", qPrintable(bm.personal_toolbar_folder));
			   if(!bm.id.isNull()&&!bm.id.isEmpty())
			  	writeToFile(os, " ID=\"%s\"",qPrintable(bm.id));	
			   //   writeToFile(os, ">%s</H3>\n", qPrintable(bm.name));
			   *os<<">"<<bm.name<<"</H3>\n";
			  if(!bm.desciption.isNull()&&!bm.desciption.isEmpty())
			  	*os<<"<DD>"<<bm.desciption;
			  writeToFile(os,"%s", " <DL><p>\n");			 
			  productFirefox2BM(level+1,&(bm.list), os);
			  writeToFile(os,"%s", "	</DL><p>\n");

		} else
		  {
		    	 if(bm.hr){
			 	    writeToFile(os,"%s", "<HR>\n");
		  	 	}
			writeToFile(os, "	 <DT><A HREF=\"%s\"",qPrintable(bm.link));
			 if(!bm.icon.isNull()&&!bm.icon.isEmpty())
			  		*os<<" ICON=\""<<bm.icon<<"\"";
			 if(bm.addDate.isValid())
					  writeToFile(os, " ADD_DATE=\"%u\"",bm.addDate.toTime_t());
			 if(bm.modifyDate.isValid())
					  writeToFile(os, " LAST_MODIFIED=\"%u\"",bm.modifyDate.toTime_t());

			// if(!bm.personal_toolbar_folder.isNull()&&!bm.personal_toolbar_folder.isEmpty())
			//		  writeToFile(os, "   PERSONAL_TOOLBAR_FOLDER=\"%s\"", qPrintable(bm.personal_toolbar_folder));
			 if(!bm.last_visit.isNull()&&!bm.last_visit.isEmpty())
					  writeToFile(os, " LAST_VISITE=\"%s\"", qPrintable(bm.last_visit));	

			   if(!bm.feedurl.isNull()&&!bm.feedurl.isEmpty())
			  	writeToFile(os, " FEEDURL=\"%s\"", qPrintable(bm.feedurl));
			    if(!bm.last_charset.isNull()&&!bm.last_charset.isEmpty())
			  	writeToFile(os, " LAST_CHARSET=\"%s\"", qPrintable(bm.last_charset));
			 if(!bm.id.isNull()&&!bm.id.isEmpty())
					  writeToFile(os, " ID=\"%s\"",qPrintable(bm.id));
			    // writeToFile(os, ">%s</A>\n",qPrintable(bm.name));
			    *os<<">"<<bm.name<<"</A>\n";
			    if(!bm.desciption.isNull()&&!bm.desciption.isEmpty())
					  *os<<"<DD>"<<bm.desciption;
		
		  }

	}
	if(!level)
		writeToFile(os,"%s","<DL><p>\n");
}



