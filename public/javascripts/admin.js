(function($){
  $(function(){
    var taggables = $(":input.taggable");
    taggables.autoSuggest("/admin/tags.json", {
      minChars: 2
    });

    $(document).on("click", ".inline-form label", function(event) {
      $("label", this.form).hide();
      $("input, button", this.form).show();
      return false;
    });

    $(document).on("submit", ".inline-form form", function() {
      var label = $("label", this),
          input = $("input:visible", this);

      label.show();
      label.html(input.val());

      $.flash("Tag updated.");

      $("input, button", this).hide();
      return true;
    });

    $(document).on("ajax:success", ".inline-form form", function(data) {
      $("label", this).text(data);
    });

    $(document).on("click", ".inline-form .cancel", function() {
      $("label", this.form).show();
      $("input, button", this.form).hide();
      return false;
    });

    $("#search-box").on("submit", function(event) {
      var queryElement = $(this).find("#query");
      var query = queryElement.val();
      var field = $(this).find("#field").val();
      var container = ".ajax-table";

      $.pjax({
        container: container,
        url: "?q=" + query + "&field=" + field,
        fragment: container
      });

      queryElement.val("");
      return false;
    });

    // toggle 'new' form if list is empty
    if(!location.search.match(/q=/)) {
      $('.tab-pane.active .empty').each(function(){
        var href = $(this).parents('.tab-pane').attr('id');
        $('a[href=#' + href + ']').parents('li').next('li').find('a').tab('show');
      });
    }

    // Infinite Scrolling for tables
    var InfiniteScrolling = function() {
      this.pageNumber = 1;
      this.loading = false;
      this.finished = false;

      this.table = $('#table-main.ajax-table');

      this.nextPage = function() {
        var basePath = "//" + location.host + location.pathname;

        var searchPage = location.search.match(/page=([0-9])/);
        var currentPage = searchPage ? searchPage[1] : false;

        var queryString = location.search.replace(/(page=)([0-9])/, function(string, query, page) {
          return query + (parseInt(currentPage, 10) + 1);
        });

        if(!currentPage) {
          currentPage = this.pageNumber;
          var pageString = (location.search.length ? "&" : "?") + "page=" + (currentPage + 1);

          queryString = location.search + pageString;
          this.pageNumber = currentPage + 1;
        }

        return basePath + queryString;
      };

      this.currentViewportAt = function() {
        return $(window).scrollTop() + $(window).height();
      };

      this.tableEndsAt = function() {
        return this.table.position().top + this.table.height();
      };

    };

    InfiniteScrolling.prototype = {

      reset: function() {
        this.pageNumber = 1;
        this.finished = false;
      },

      checkAndLoadMore: function() {
        if(this.table.size() < 1) return;
        if(this.currentViewportAt() - this.tableEndsAt() >= 50) {
          var self = this;

          if(!this.finished && !this.loading) {
            this.loading = true;
            $.ajax({
              url: this.nextPage(),
              success: function(data, xhr) {
                var newContent = $(data).find('tbody tr');
                var table = $('#table-main.ajax-table table tbody');

                self.loading = false;

                if(newContent.size()) {
                  table.append(newContent);
                } else {
                  self.finished = true;
                }
              }
            });
          }
        }
      }

    };

    var scroller = new InfiniteScrolling();
    scroller.checkAndLoadMore();

    $(window).scroll(function() {
      scroller.checkAndLoadMore();
    }); //End Infinite Scrolling

    // PJAX requests
    $('a[data-pjax]').pjax({
      fragment: '.ajax-table',
      success: function() {
        scroller.reset();
        scroller.checkAndLoadMore();
      }
    });

    $.flash = function(text, type) {
      if (typeof type == "undefined") {
        type = "success";
      }

      var alert = $(".alert");

      if (alert.length === 0) {
        alert = $("<div class='alert alert-" + type + "' />");
        $("#content").prepend(alert);
      }

      alert.html(text);
    };

  });

  $(window).load(function(){

    function createEditorContainer(element) {
      var container = $("<div/>");
      container.attr("id", "editor-" + element.attr("id"));
      container.addClass("ace-editor");
      element.after(container);
      return container;
    }

    $("textarea.datajamTemplate").each(function() {
      var $el = $(this),
          container = createEditorContainer($el);

      // init hidden editors off-screen so they work
      if(container.is(':hidden')){
        container.wrap('<div id="' + container.attr('id') + '_wrap" class="ace-editor-replaceme"></div>');
        $('body').append(container.css({
          'position': 'absolute',
          'left': '-9999px'
        }).remove());
      }

      var editor = ace.edit(container.attr("id")),
          HtmlMode = require("ace/mode/html").Mode,
          editorSession = editor.getSession();

      $el.hide();
      editorSession.setMode(new HtmlMode());
      editorSession.setValue($el.val());
      editorSession.setTabSize(2);
      editorSession.setUseSoftTabs(true);
      editorSession.on('change', function() {
        $el.val(editorSession.getValue());
      });
      editor.setShowPrintMargin(false);
    });
    // reset off-screen editors
    $('.ace-editor-replaceme').each(function(){
      var $el = $('#' + $(this).attr('id').replace('_wrap', ''));
      $(this).append($el.css({
        'position': 'static',
        'left': 0
      }).remove());
      $el.unwrap();
    });
  });
})(jQuery);
