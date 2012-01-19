require 'spec_helper'

describe DataCard do

  it "can be created when passed in a CSV string" do
    csv = <<-EOF.strip_heredoc
      "Candidate","Percentage"
      "Mitt Romney","28%",
      "Ron Paul","22%"
    EOF

    params = { title: 'Straw Poll', csv: csv, source: "Gallup" }
    card = DataCard.create(params)

    card.table_head.should eql(['Candidate','Percentage'])
    card.table_body.length.should eql(2)

  end

end

