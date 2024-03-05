module AwsS3WebsiteSync
  class Runner
    # aws session token support for STS credentials
    def self.run(
      aws_access_key_id:,
      aws_secret_access_key:,
      aws_session_token:,
      aws_default_region:,
      s3_bucket:,
      auto_approve:,
      distribution_id:,
      build_dir:,
      output_changset_path:,
      ignore_files:,
      silent:
    )
      $logger.info "Runner.run"
      # aws session token support for STS credentials
      AwsS3WebsiteSync::Plan.run(
        output_changeset_path: output_changset_path,
        build_dir: build_dir,
        aws_access_key_id: aws_access_key_id,
        aws_secret_access_key: aws_secret_access_key,
        aws_session_token: aws_session_token,
        s3_bucket: s3_bucket,
        aws_default_region: aws_default_region,
        ignore_files: ignore_files
      )
      AwsS3WebsiteSync::Preview.run(
        changeset_path: output_changset_path,
        silent: silent
      )

      json = File.read output_changset_path
      data = JSON.parse json
      items = data.select{|t| %w{create update delete}.include?(t["action"]) }

      if items.count.zero?
        puts "no changes to apply, quitting....."
      else
        puts "Execute the plan? Type: yes or no"
        if auto_approve == "true"
          # aws session token support for STS credentials
          AwsS3WebsiteSync::Apply.run(
            changeset_path: output_changset_path,
            build_dir: build_dir,
            aws_access_key_id: aws_access_key_id,
            aws_secret_access_key: aws_secret_access_key,
            aws_session_token: aws_session_token,
            s3_bucket: s3_bucket,
            aws_default_region: aws_default_region,
            distribution_id: distribution_id,
            caller_reference:  File.basename(output_changset_path,'.json')
          )
        else
          print "> "
          case (STDIN.gets.chomp)
          when 'yes'
            # aws session token support for STS credentials
            AwsS3WebsiteSync::Apply.run(
              changeset_path: output_changset_path,
              build_dir: build_dir,
              aws_access_key_id: aws_access_key_id,
              aws_secret_access_key: aws_secret_access_key,
              aws_session_token: aws_session_token,
              s3_bucket: s3_bucket,
              aws_default_region: aws_default_region,
              distribution_id: distribution_id,
              caller_reference:  File.basename(output_changset_path,'.json')
            )
          when 'no'
            puts "quitting...."
          end
        end
      end
    end
  end
end
