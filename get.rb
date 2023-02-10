require 'open-uri'
require 'json'

data = []

Dir.glob("#{ARGV[0]}/**/*.json") do |json_file|
  File.open(json_file) do |file|
    data += JSON.load(file)
  end
end

urls = data.each_with_object({}) do |d, memo|
  files = d.fetch('files', [])
  files.each_with_index do |f, i|
    memo["#{d.fetch('client_msg_id')}_#{i}"] = f.fetch('url_private_download', nil)
  end
end

pp urls

urls.each do |k, v|
  URI.parse(v).open do |res|
    IO.copy_stream(res, "#{k}.jpg")
  end
end
