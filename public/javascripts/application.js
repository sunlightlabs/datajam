window.onload = function() {
  if ($('textarea.datajamTemplate').length) {
    var editor = ace.edit("ace-editor");
    var HtmlMode = require("ace/mode/html").Mode;
    var editorSession = editor.getSession();
    editorSession.setMode(new HtmlMode());
    editorSession.setValue($('textarea.datajamTemplate').val());
    editorSession.setTabSize(2);
    editorSession.setUseSoftTabs(true);
    editorSession.on('change', function() {
      $('textarea.datajamTemplate').val(editorSession.getValue());
    });
    editor.setShowPrintMargin(false);
    editor.setShowGutter(false);
  }
};
