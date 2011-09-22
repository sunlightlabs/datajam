# Create a site template if one doesn't exist.
unless SiteTemplate.first
  template_text = <<-EOT.strip_heredoc
  <html>
    <head>
      <title>Your Datajam Site</title>
    </head>

    <body>
      <h1>Your Datajam Site Title</h1>
      <div id="datajamEvent">
        <p>Nothing here yet!</p>
      </div>
    </body>

  </html>
  EOT
  SiteTemplate.create!(name: 'Site', template: template_text)
end
