function blockContent() {
    document.documentElement.innerHTML = '<div style="display:flex;align-items:center;justify-content:center;height:100vh;font-size:2rem;color:#d32f2f;background:#fff;flex-direction:column;"><span>检测到您使用了广告拦截插件</span><br><span>请关闭广告拦截后访问本站</span></div>';
}

window.addEventListener('load', function () {
    // 等待 fuckAdBlock 加载
    function waitFAB() {
        if (typeof fuckAdBlock !== 'undefined') {
            fuckAdBlock.onDetected(blockContent);
            fuckAdBlock.onNotDetected(function () {
            });
            fuckAdBlock.check();
        } else {
            setTimeout(waitFAB, 50);
        }
    }

    waitFAB();
});
