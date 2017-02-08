\# MEMO



\#\# Articles



\* \[Architectures & Build Active Architecture Only区别及相关设置\]\(http://foggry.com/blog/2014/05/09/xcodeshe-zhi-xiang-zhi-architectureshe-valid-architectures/\)

\* \[iOS线程安全\]\(http://mp.weixin.qq.com/s/Pz1XdrAYDLrLeq97niT15g\)

\* \[strongSelf&weakSelf&循环引用\]\(http://ios.jobbole.com/88708/\)

\* \[ipa文件搜身\]\(http://www.jianshu.com/p/a72d03e92c80\)

\* \[OCLint静态分析Xcode工程\]\(http://oclint-docs.readthedocs.io/en/stable/guide/xcode.html\)

\* \[AFNetworking解读\]\(http://itangqi.me/2016/05/09/the-notes-of-learning-afnetworking-three/\)

\* \[iOS 开发中的证书和钥匙\]\(http://lincode.github.io/Certificate\)

\* \[Swift中的指针\]\(https://onevcat.com/2015/01/swift-pointer/\)

\* \[layoutSubviews&layoutIfNeeded&drawRect区别\]\(http://www.jianshu.com/p/eb2c4bb4e3f1\)

\* \[iOS 浮点数的精确计算和四舍五入问题\]\(http://www.jianshu.com/p/946c4c4aff33\)

\* \[Swift中的GCD用法\]\(http://swift.gg/2016/11/30/grand-central-dispatch/\)

\* \[iOS高效绘制圆角\]\(http://www.jianshu.com/p/f970872fdc22\)

\* \[Instruments工具性能调试\]\(http://www.samirchen.com/use-instruments/\)

\* \[iOS性能优化\]\(http://www.samirchen.com/ios-performance-optimization/\)

\* \[iOS 保持界面流畅的技巧\]\(http://blog.ibireme.com/2015/11/12/smooth\_user\_interfaces\_for\_ios/\)

\* \[优化UITableViewCell高度计算的那些事\]\(http://blog.sunnyxx.com/2015/05/17/cell-height-calculation/\)

\* \[深入理解RunLoop\]\(http://blog.ibireme.com/2015/05/18/runloop/\)



\#\# Tips



\#\#\# \`Create groups\` & \`Create folder references\` 区别



\`Create groups\`将创建一个黄色的文件组，通过该方式添加的文件将会被编译；而通过\`Create folder references\`只是添加了文件的引用，蓝色文件夹标识，，文件不会被编译，使用时需要\`import\`绝对文件路径。



\#\#\# 绘制阴影时避免\`Offscreen-Rendered\`



绘制阴影效果时，为layer指定shadowPath可以避免\`Offscreen-Rendered\`:



\`\`\`

view.layer.shadowPath = \[UIBezierPath  bezierPathWithRect:view.bounds\].CGPath;

\`\`\`



