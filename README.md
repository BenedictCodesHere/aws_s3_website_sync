## AWS S3 Website Sync

This is a tool to sync a folder from your local developer enviroment to your S3 Bucket and then invalidate the CloudFront cache.

I modified the source code of the original repo developed by [omenking](https://github.com/omenking) and [bayko](https://github.com/bayko), so that the use of an `AWS Session Token` via AWS STS is supported.

## How to use

### Create Gemfile and install

Create a `Gemfile` that installs the gem:

```rb
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rake'
gem 'aws_s3_website_sync', tag: '1.0.1'
gem 'dotenv', groups: [:development, :test]
```

The proceed to install the required gems:

```sh
bundle install
```

### Create Rakefile and run sync

Create a `Rakefile` with the following:

```rb
require 'aws_s3_website_sync'
require 'dotenv'

task :sync do
  puts "sync =="
  AwsS3WebsiteSync::Runner.run(
    aws_access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
    aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    # aws session token support for STS credentials
    aws_session_token: ENV["AWS_SESSION_TOKEN"],
    aws_default_region:    ENV["AWS_DEFAULT_REGION"],
    s3_bucket:             ENV["S3_BUCKET"],
    distribution_id:       ENV["CLOUDFRONT_DISTRIBUTION_ID"],
    build_dir:             ENV["BUILD_DIR"],
    output_changset_path:  ENV["OUTPUT_CHANGESET_PATH"],
    auto_approve:          ENV["AUTO_APPROVE"],
    silent: "ignore,no_change",
    ignore_files: [
      'stylesheets/index',
      'android-chrome-192x192.png',
      'android-chrome-256x256.png',
      'apple-touch-icon-precomposed.png',
      'apple-touch-icon.png',
      'site.webmanifest',
      'error.html',
      'favicon-16x16.png',
      'favicon-32x32.png',
      'favicon.ico',
      'robots.txt',
      'safari-pinned-tab.svg'
    ]
  )
end
```

Then to proceed to sync you just type:

```sh
bundle exec rake sync
```

## Credits
https://rubygems.org/gems/aws_s3_website_sync
https://github.com/teacherseat/aws-s3-website-sync

The creators of this Rubygem are:

Andrew Brown
https://github.com/omenking 
https://github.com/exampro-dev

Andrew Bayko
https://github.com/bayko

My thanks go to them for creating this Rubygem, I have simply extended upon it.
