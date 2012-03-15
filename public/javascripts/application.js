window.onload = function() {
  function createEditorContainer(element) {
    var container = $("<div/>");
    container.attr("id", "editor-" + element.attr("id"));
    container.addClass("ace-editor");
    element.after(container)
    return container;
  }

  $("textarea.datajamTemplate").each(function() {
    var $el = $(this),
        container = createEditorContainer($el),
        editor = ace.edit(container.attr("id")),
        HtmlMode = require("ace/mode/html").Mode,
        editorSession = editor.getSession();

    $el.css({ display: "none" });

    editorSession.setMode(new HtmlMode());
    editorSession.setValue($el.val());
    editorSession.setTabSize(2);
    editorSession.setUseSoftTabs(true);
    editorSession.on('change', function() {
      $el.val(editorSession.getValue());
    });
    editor.setShowPrintMargin(false);
  });
};
