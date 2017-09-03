#coding=utf-8
from bs4 import BeautifulSoup
import URLContent
import types
import os

def ParseURL(url):
    result = URLContent.GetCacheUrl(url)
    if (result == None):
        return;
    content = result["data"]
    # soup = BeautifulSoup(content,"html5lib")
    soup = BeautifulSoup(content,"lxml")

    tr = soup.find_all('tr');
    items = []
    for iff in tr:
        td = iff.find_all('td');
        if len(td) < 4:
            continue;
        item = {"name":td[0].string,
                "version":td[1].string,
                "website":td[2].string,
                "url":url + td[3].a["href"],
                "filename":td[3].a.string
                }
        items.append(item);
    return items;

def FindPacket(name):
    url = "http://ffmpeg.zeranoe.com/builds/"
    result = ParseURL(url)
    if type(result) == types.ListType:
        for item in result:
            if(item['name'] == name):
                return item;
    return;

def FindPacketDownload(name,Dir):
    packet = FindPacket("OpenH264")
    if type(packet) == types.DictType:
        print "download start:" + packet["filename"]
        URLContent.DownloadURL(packet["url"],Dir + packet["filename"])
        print "download end"
        return 1
    return 0

if __name__ == '__main__':
    pwd = os.getcwd();
    # Dir = pwd + "/extra/"
    Dir = pwd + "/../extra/"
    FindPacketDownload("OpenH264",Dir)
    # url = "http://ffmpeg.zeranoe.com/builds/source/external_libraries/openh264-1.7.0.tar.xz"
    # URLContent.DownloadURL(url,Dir + "test.tar.xz");
