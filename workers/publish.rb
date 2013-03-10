require 'cgi'
require 'configuration'

config = Configuration.keys

cgi_parsed = CGI::parse(payload)
parsed = JSON.parse(cgi_parsed['payload'][0])

repo_name = parsed["repository"]["name"]
owner_name = parsed["repository"]["owner"]["name"]

clone_url = "git://github.com/#{owner_name}/#{repo_name}.git"

p "cloning repo"
`git clone #{clone_url}`
p "done cloning repo"

p "changing repo"
Dir.chdir(repo_name)
p "done changing repo"

p "writing _jekyll_s3.yml file"
open('_jekyll_s3.yml', 'w') { |f|
  f << "s3_id: #{config['aws_s3']['id']}\n"
  f << "s3_secret: #{config['aws_s3']['secret']}\n"
  f << "s3_bucket: #{config['aws_s3']['bucket']}\n"
}
p "done writing _jekyll-s3.yml file:"
p `cat _jekyll_s3.yml`

p "generating jekyll pages"

p `/task/__gems__/gems/jekyll-0.12.1/bin/jekyll --no-auto`

p "uploading to s3"
p `/task/__gems__/gems/jekyll-s3-0.0.5/bin/jekyll-s3`