# Create a site template if one doesn't exist.
if Template.first(conditions: { name: "Site" }).nil?
  template_text = <<-EOT
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

  Template.create!(name: "Site", template: template_text )
end
