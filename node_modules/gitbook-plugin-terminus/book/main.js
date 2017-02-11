require(["gitbook"], function(gitbook) {
    gitbook.events.bind("page.change", function() {
        // do something
        $(".book-summary").prepend('<div class="terminus-logo"><img src="http://terminus.io/public/images/logo.png" alt="logo">端点科技 · DOCS</div>');
    });

    gitbook.events.bind("exercise.submit", function() {
        // do something
    });
});
