directory "/tmp/example"
file "/tmp/example/file" do
  content node["example_cookbook"]["contents"]
end
