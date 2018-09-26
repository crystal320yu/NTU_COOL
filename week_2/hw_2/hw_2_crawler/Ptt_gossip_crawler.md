

```python
import requests
from pyquery import PyQuery as pq
```


```python
#PTT會問是否滿18歲，將cookie設定為over18
res=requests.get("https://www.ptt.cc/bbs/Gossiping/index.html",cookies={"over18":"1"})
```


```python
#爬取前三頁，使用for迴圈
for eachPage in range(3):
    mainDoc = pq(res.text)
    for eachPost in mainDoc("#main-container .r-ent").items():
        print(eachPost('.title').text(),eachPost('.author').text())
    mainDoc.make_links_absolute(base_url = res.url)
    res=requests.get(mainDoc\
        (".btn-group-paging > a:nth-child(2)").attr("href"),\
                    cookies={"over18":"1"})
```

    [新聞] 瑞典「脫口秀」節目嘲弄陸客 IKEA成為中 tony86069
    [新聞] 議員南歐考察13天　42字心得文震撼PTT whj0530
    Re: [新聞] 生寶寶錯了嗎？解僱懷孕女業務　科技公司 xx8615xx
    Re: [問卦] 在大學旁邊吃早餐是不是很讚 Nigger5566
    [公告] 八卦板板規(2017.11.11) Kay731
    Fw: [協尋]行車紀錄9/7早上西屯路弘孝路口車禍 anher
    [協尋] 9/19 輔大前死亡車禍行車紀錄 peter750804
    [協尋] 9/14(五)23:03 國道三 47.9k車禍行車紀錄 RedInk
    [公告] 九月份置底閒聊文 RandyMarsh
    [問卦] 有沒有什麼時候會期待下雨的八卦 Yohooooooo
    [新聞] 1鍋6口香腸悲鳴 網驚：豬的靈魂在裡面 kbt2720
    [ＦＢ] 黃國昌 823 南部水災治水機制質詢 pilistar0222
    [新聞] 珠海台協會長：台商非常恐慌 我們不是背 Salcea
    [新聞] 「五星寺」亂台2年投降 資金來源曝光！ qqq87112
    [爆卦] 有沒有摩斯漢堡早餐優惠要等80分鐘的八卦 kjfd
    [新聞] 行政院新印的機關人員名錄上 張天欽還是 UNT
    Re: [新聞] 生寶寶錯了嗎？解僱懷孕女業務　科技公司 e741000
    [問卦] 雨傘王品質是不是很爛 vi000246
    [問卦] 電話常常一接起來就斷了 a32165498791
    [問卦] 呂純陽的警語可以送給政治人物嗎？ vmlinuz
    [新聞] 川普聯大演講：世界各國應抵制社會主義 pulagu
    [問卦] 在大學旁邊吃早餐是不是很讚 Merkle
    [問卦] 網路衛教文章怎麼都是兒童的 sec5566
    [問卦] 有沒有安妮的八卦阿 mballen
    [新聞] 高雄民調拉很近　鄭文燦批韓國瑜「純空降 youhow0418
    [問卦] 比基尼妹子整天在我窗外曬太陽怎辦？ MrBing
    Re: [新聞] 中捷徵才試題不公開挨批黑箱 董座：版權 kuo1102
    [新聞] 消失一百天 范冰冰去哪了？ serialhon
    Re: [新聞] 提升我防禦能力！ 美同意對台軍售F-16等 gn1384181
    [ＦＢ] 姚文智:提出「北區副都心」的規劃願景 jeff0025
    [新聞] 挺同團體發聲明 用「兩好三壞」 miler22020
    [新聞] 林青霞驚爆離婚 A咖女星爆料拿了80億贍養 ppibrother
    Re: [新聞] 陳致中被爆現身林森北私人招待所 2酒店紅 s910211
    [問卦] 台灣跟新加坡合併是不是不錯？？ ggus
    [問卦] 為什麼南部人要去台北招待所？ otoboku
    [問卦] 是不是應該要放颱風假了? pierreqq
    [新聞] 對2000性侵罪犯不手軟　哈薩克要閹下去 g987669
    Re: [ＦＢ] 周芷萱: 韓國瑜說教母語浪費學校時間 deann
    (本文已被刪除) [CPer] -
    [問卦] 高雄真的有沒落嗎 e741000
    [新聞] 北市府增列吳音寧條款 不備詢就開罰 jianoon
    [問卦]  是不是每台手機只要有裝APP就中毒了 Vincent6964
    [新聞] HTC宏達電祭VR平台100%分潤　利開發者 science9686
    Re: [新聞] 陳致中被爆現身林森北私人招待所 2酒店紅 popy8789
    Re: [ＦＢ] 田昀凡 很多柯粉原本就是藍色覺醒成 nk330833
    Re: [新聞] 生寶寶錯了嗎？解僱懷孕女業務　科技公司 siriusc
    [問卦] 為什麼我們的母語不是非洲話?? ljsnonocat2
    [問卦] 大家都怎麼稱讚台女? DoraGmon
    [問卦] 客家人為何比較容易有遺傳疾病 balahaha
    
