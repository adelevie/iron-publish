# iron-publish

Build Jekyll sites remotely--without a server and without Github's build system.

## What?

Use simple git post-commit webhooks to build and deploy Jekyll sites to Amazon S3.

## Why?

The git workflow is great for publishing, and is shown to be very useful when combined with GitHub's build system:

```sh
rake post title="Hello, world"
git add .
git commit -m "added Hello world post"
git push -u origin master
```

However, there are a few reasons to not have your Jekyll site built with GitHub's build system:

1. Troubleshooting: Was there some error with your build? Currently, there's no way to check for this on GitHub. With IronWorker, just check hud.iron.io and read the logs.

2. Capacity: As your site gets large and publishing frequency increases, so does the chance that there is an error with the build. As explained in point 1, troubleshooting is easier with IronWorker.

3. You own the build process: Need to build 100,000 pages? I'd be concerned about waking up GitHub's ops people in the middle of the night. On the other hand, IronWorker is built for stuff like this. Workers can run for up to 60 minutes. If building the blog takes more than 60 minutes, this code at least provides an entry point to creating a more scalable build process. Moreovoer, if you ever move away from Jekyll, because you own the build process, you can hack the worker to do whatever you want it to.

## Usage

### If you have an existing Jekyll blog

1. Clone/fork this repo anywhere. If you do decide to clone it/git submodule it within your Jekyll blog's directory, be sure to add `exclude: [workers]` to the `_config.yml` file. `cd` into the repo.

2. Add your api keys from [AWS](http://aws.amazon.com/) and [Iron.io](http://iron.io) and fill in the blanks in `configuration.rb`: 

```ruby 
class Configuration
  def self.keys
    {
      "aws_s3" => {
        "id"     => "myId",
        "secret" => "mySecret",
        "bucket" => "myBucket"
      },
      "ironio" => {
        "project_id" => "myProjectId",
        "token"      => "myToken"
      }
    }
  end
end
```

Be sure to already have an AWS S3 bucket created and configured for static site hosting.

3. `$ cd workers` then `$ ruby upload.rb`. Inside the terminal, you'll see a url. Copy this.

4. Configure your [GitHub post-commit hook](https://help.github.com/articles/post-receive-hooks). The url you just copied is the one you'll be pasting for this step.

5. Next time you push to the GitHub repo for your Jekyll blog, go to https://hud.iron.io/dashboard and find the running worker task. The build process should take about two minutes. Refresh at will. When the task is done (and there are no errors), check your blog.

6. To get the URL for your newly published blog, go to your AWS console, click on the correct bucket, then click properties and expand the static website hosting accordion.

### From Scratch

1. Create a GitHub repo for your new blog.

2. Create a Jekyll blog. I like to use [Jekyll-Bootstrap](http://jekyllbootstrap.com/), but any Jekyll site will do.

3. Be sure your repo's origin url points to the GitHub url. (eg, `git remote set-url origin ...`)

4. `rake post title='hello world'`

5. Edit the new post.

6. To view it locally, run `jekyll --server` and visit localhost:4000.

7. `git add .`

8. `git commit -m "added new post"`

Now you have an existing Jekyll blog, so scroll up to that section of this README and follow those directions.
 

