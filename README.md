# TestMMKVSize
![screenshot-20220421-175943](https://user-images.githubusercontent.com/338228/164431051-8848f480-97ed-4334-82a1-106ef3163e79.png)

从测试来看，频繁修改 key 的 value，MMKV 数据文件不会大幅增长。

官方文档中也有对文件增长的说明 https://github.com/Tencent/MMKV/wiki/design#%E7%A9%BA%E9%97%B4%E5%A2%9E%E9%95%BF
大概意思是：每次修改都是 append，当空间不够需要增加空间时会先整理重排之前的内容，整理之后空间够就继续写，如果不够才增长空间，空间是翻倍的增长。

然后 time 方法可以整理收缩空间。可以考虑应用切到后台时 time 下。
