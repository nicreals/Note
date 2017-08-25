# Atom

> [Atom快捷键](https://github.com/futantan/atom)

## 快捷键

Descriptions |    ShortCut
:----------- | :-------------:
显示控制面板      | cmd-shift-p
隐藏/显示文件树 | cmd-\
列出所有Project |  cmd-ctrl-p
显示Markdown预览 | ctrl-shift-m
打开当前目录中的文件 | cmd-p

## 自动保存

`setting` -> 'packages' -> `autosave` -> enable

## 实用插件

- [file-icons](https://atom.io/packages/file-icons) 图标美化
- [atom-beautify](https://atom.io/packages/atom-beautify) 格式化代码
- [markdown-preview-enhanced](https://atom.io/packages/markdown-preview-enhanced) markdown工具集
- [project-manager](https://atom.io/packages/project-manager) 项目组织管理
- [split-off](https://atom.io/packages/split-diff) diff代码
- [merge-conflicts](https://atom.io/packages/merge-conflicts) 合并冲突可视化工具

## 更改快捷键

- 在`Preference`->`Keybindings` 中找到想更改的快捷键的`Selector`,`Command`,`Keystroke`；
- 在菜单栏中`Atom`->`Keymap...`打开`keymap.cson`；

示例：
```
'.platform-darwin':
    'ctrl-cmd-l': 'project-manager:list-projects'
```

## 更改样式

- 使用`cmd-alt-i`快捷键打开开发者工具，调试找出想要修改元素对应的css节点
- 在菜单栏中`Atom`->`Stylesheet...`打开`styless.less`修改样式；

示例：
```
.theme-one-dark-ui,
.theme-one-light-ui {
  .tab-bar {
    font-family: 'Menlo';
    font-size: 11px; // smaller font size
    margin-top: -4px;
  }
  .tab {
    min-width: 12em; // larger minimum width
    max-width: 18em; // smaller max width
  }
}
.markdown-preview-enhanced {
    font-size: 11px;
    font-family: 'Monaco';
}
```
