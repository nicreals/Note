# iOS性能优化
[iOS 保持界面流畅的技巧](http://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/)

## UITableView 性能优化

### 基本建议

* cell的prototype设计尽量抽象提高复用度；
* 减少页面层级关系；
* 图片资源尽量使用PNG格式；
* 减少页面层级关系；

### Self-Sized Cell
`Self-Sized Cell`的tableView的思路是在计算将要展示的cell高度时，会预先根据`estimated height`预先设置cell的高度和调整滚动条，然后cell通过自身设置的约束来调整自身`contentSize`。
此思路的tableView能直接为cell的高度赋值，只需要设置cell的预估高度和启用动态布局：
```
tableView.estimatedRowHeight = 44.f;
tableView.rowHeight = UITableViewAutomaticDimension;
```
