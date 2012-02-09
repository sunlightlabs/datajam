window.onload = function() {
  $("textarea.datajamTemplate").each(function() {
    var $el = $(this),
        editor = ace.edit($el.data("editor") || "ace-editor"),
        HtmlMode = require("ace/mode/html").Mode,
        editorSession = editor.getSession();

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
