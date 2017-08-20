#coding=utf-8
import os
import time
import urllib
import requests
import hashlib

from module.UserAgent import getUserAgent as UserAgent

def GetCachePath():
    pwd=os.getcwd()
    CacheDir=str(pwd) + "/../Cache/"
    if not os.path.exists(CacheDir):
        os.makedirs(CacheDir);
    return CacheDir

def GetCahceFile(md5):
    CacheDir = GetCachePath();
    file = str(CacheDir + str(md5) + ".cache")
    return file;

def ChechCacheExpress(md5,express):
    file = GetCahceFile(md5);
    if not os.path.exists(file):
        return None;
    #print file
    if (os.path.isfile(file)):
        #创建时间
        # os.path.getctime(file)
        #修改时间
        mtime = os.path.getmtime(file)
        ticks = time.time()
        # mtime = time.ctime(mtime)
        # print mtime
        #过期
        if int(mtime) + int(express) > int(ticks):
            return file

    os.remove(file);
    return None

def ReadCacheFile(file):
    data=None
    if not os.path.exists(file):
        return data;
    file_object = open(file, 'rb')
    try:
        data = file_object.read()
    finally:
        file_object.close()
    return data

def WriteCacheFile(file,content):
    with open(file, "wb") as code:
        code.write(content)
        code.close()
        return;
    if os.path.exists(file):
        os.remove(file);

def UpdateURLContent(url,file):
    print("UpdateURLContent(\"" + url + "\")")
    headers={"User-Agent":UserAgent()}
    response=requests.get(url=url,headers=headers)
    if response.status_code != 200:
        print("UpdateURLContent(\"" + url + "\")Failed." + response.status_code)
        return response.status_code
    WriteCacheFile(file,response.content);
    return response.status_code

def GetCapacity(capacity):
    capacity = float(capacity)
    mode = ""
    if capacity >= 1024*1024:
        capacity = capacity/(1024*1024)
        mode = "mb"
    elif capacity >= 1024:
        capacity = capacity/(1024)
        mode = "kb"
    else:
        mode = "b"
    return {"cap":capacity,"mode":mode}

def UpdateRate(total,block,time):
    rate = 0
    if time == 0:
        rate = block
    else:
        rate = float(block)/time
    rateObj = GetCapacity(rate)
    blockObj = GetCapacity(block)

    if(total == 0):
        print (str("%.0f" + blockObj["mode"] + " %.02f" + rateObj["mode"] + "ps")%(blockObj["cap"],rateObj["cap"]))
    else:
        print (str("%.0f%%"+ " %.02f" + rateObj["mode"] + "ps")%(100*blockObj["cap"]/total,rateObj["cap"]))

def DownloadURL(url,file):
    print("DownloadURL(\"" + url + "\")")
    headers={"User-Agent":UserAgent()}
    response = requests.get(url=url, stream=True, headers=headers)
    if response.status_code != 200:
        print("DownloadURL(\"" + url + "\")Failed." + response.status_code)
        return response.status_code
    contentLength = response.headers['Content-Length']
    if contentLength == None:
        contentLength = 0;
    contentLength = int(contentLength);

    start_time = int(time.time())
    download_size = 0;
    with open(file, 'wb') as local_file:
        for chunk in response.iter_content(chunk_size=1024*1024):
            if chunk:
                local_file.write(chunk)
                local_file.flush()
                download_size += len(chunk)
            use_time = int(time.time()) - start_time
            UpdateRate(contentLength,download_size,use_time)
        local_file.close()
    return response.status_code

def GetCacheUrl(url):
    md5string = hashlib.md5(str(url).encode('utf-8')).hexdigest()
    CacheFile = ChechCacheExpress(md5string,5)
    if CacheFile == None :
        CacheFile = GetCahceFile(md5string)
        ret = UpdateURLContent(url,CacheFile)
        if ret != 200:
            return None
    data = ReadCacheFile(CacheFile)
    if data == None:
        return None
    return {"url":url,"cache":CacheFile,"data":data}
