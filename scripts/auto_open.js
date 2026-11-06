var spawn = require('child_process').exec;
//D:\WorkPlace\MarkdownPad\MarkdownPad2.exe 是MakdownPad编辑器在我本地的路径！
// Hexo 3 用户复制这段
hexo.on('new', function (data) {
    spawn('start  "C:\\Program Files\\Typora\\Typora.exe" ' + data.path);
});
