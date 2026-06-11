<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>items</key>
    <array>
        <dict>
            <key>cell</key>
            <string>PSGroupSpecifier</string>
            <key>label</key>
            <string>API 设置</string>
        </dict>
        <dict>
            <key>cell</key>
            <string>PSEditTextCell</string>
            <key>defaults</key>
            <string>com.crctdd.surgectl</string>
            <key>key</key>
            <string>port</string>
            <key>label</key>
            <string>端口</string>
            <key>default</key>
            <string>1836</string>
            <key>keyboard</key>
            <string>numbersAndPunctuation</string>
        </dict>
        <dict>
            <key>cell</key>
            <string>PSEditTextCell</string>
            <key>defaults</key>
            <string>com.crctdd.surgectl</string>
            <key>key</key>
            <string>key</string>
            <key>label</key>
            <string>密码</string>
            <key>default</key>
            <string>crctdd</string>
            <key>isSecureTextEntry</key>
            <true/>
        </dict>

        <dict>
            <key>cell</key>
            <string>PSGroupSpecifier</string>
            <key>label</key>
            <string>使用说明</string>
            <key>footerText</key>
            <string>Surge - 主页底部(更多设置) - 远程控制 - HTTP API &amp; Web 面板
打开HTTP API
端口：4～5位数(可默认)
密码：随便填(最好都是小写字母)

或者
编辑模式手动输入
[General]
http-api = 密码@127.0.0.1:端口

设置好了后，在上面填入。

↓↓↓

使用方法：
使用终端输入命令(仅输入英文)
surgectl direct   切换直连模式
surgectl rule   切换规则模式
surgectl proxy   切换全局代理
surgectl status   查看当前模式</string>
        </dict>
    </array>
    <key>title</key>
    <string>Surge 配置</string>
</dict>
</plist>
