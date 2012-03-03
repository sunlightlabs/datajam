# Create a site template if one doesn't exist.
DEFAULT_SITE_TEMPLATE = <<-EOT.strip_heredoc
<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"> <!--<![endif]-->
<head>
  <meta charset="utf-8">
  <title>Welcome to Datajam</title>
  <meta name="description" content="Interactive, data-driven reporting in real time.">

  <link rel="shortcut icon" href="http://assets.sunlightfoundation.com/site/4.0/favicon.ico">
  <link rel="apple-touch-icon" href="http://assets.sunlightfoundation.com/site/4.0/apple-touch-icon.png">
  <link rel="stylesheet" href="http://twitter.github.com/bootstrap/assets/css/bootstrap.css">

  {{{head_assets}}}

  <style>
    body{padding-top:40px;}
    header.navbar{width:940px;margin:0 auto 20px;}
    #main{min-height:400px;}
    .footer{padding:2em 0;border-top:1px solid #f4f4f4;}
  </style>

  <script src="http://cdnjs.cloudflare.com/ajax/libs/modernizr/2.5.3/modernizr.min.js"></script>

</head>
<body>
  <header class="navbar">
    <div class="navbar-inner">
      <div class="container">
        <a href="/" class="brand">Datajam</a>
        <ul class="nav">
          <li class="live-now hidden">
            <a href="/">Live now!</a>
          </li>
          <li>
            <a href="/about">About</a>
          </li>
          <li>
            <a href="/archives">Event Archives</a>
          </li>
        </ul>
      </div>
    </div>
  </header>

  <div id="main" class="container">
    <div class="row">
      <div class="span8">
        <h2>Welcome to Datajam.</h2>
        <p>
          Congratulations! Your Datajam instance is up and running. You're now ready to start creating and producing events.
          To edit this template, go to the site template in the <a href="/admin">Admin area</a>. By default, the
          login email address is changeme@example.com, and the password is changeme. You'll probably want to do just that.
        </p>
        <p>
          You can read more about getting started with datajam at <a href="http://datajam.sunlightfoundation.com">datajam.sunlightfoundation.com</a>.
        </p>
      </div>
    </div>
    <div class="row">
      <div class="span12">
        {{{ content }}}
      </div>
    </div>
  </div>

  <footer class="footer">
    <div class="container">
      <p class="pull-right"><a href="#">Top &uarr;</a></p>
      <p>
        Datajam is a project of the <a href="http://sunlightfoundation.com">Sunlight Foundation</a>.
      </p>
    </div>
  </footer>

  {{{body_assets}}}
</body>
</html>
EOT

unless SiteTemplate.first
  SiteTemplate.create!(name: 'Site', template: DEFAULT_SITE_TEMPLATE)
end
