# Create a site template if one doesn't exist.
if Template.first(conditions: { template_type: "site" }).nil?
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

  Template.create!(name: "Site", template_type: "site", template: template_text )
end
