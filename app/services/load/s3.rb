# Documentation:
# https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Client.html
class Load::S3

  @@keyfile = ENV['keyfile'] # 'file.ext'
  @@client  = unless Rails.env.test?
                Aws::S3::Client.new(
                  access_key_id: ENV['SPACES_KEY'],
                  secret_access_key: ENV['SPACES_SECRET'],
                  endpoint: 'https://nyc3.digitaloceanspaces.com',
                  force_path_style: false, # Configures to use subdomain/virtual calling format.
                  region: ENV['s3_region'] # 'us-east-1's
                )
              end

  def initialize(bucket_name)
    @bucket_name = bucket_name
  end

  def upload(contents = "")
      @@client.put_object({
        bucket: @bucket_name,
        key: @@keyfile,
        body: contents,
        acl: "private",
        # metadata: { 'x-amz-meta-my-key': "your-value" }
      })
  end

  def download(bucket_name, local_target = '/tmp/local-file.ext')
    @@client.get_object(
      bucket: bucket_name,
      key: @@keyfile,
      response_target: local_target
    )
  end
end
