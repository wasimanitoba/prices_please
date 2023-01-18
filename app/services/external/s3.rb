# Documentation:
# https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Client.html
class External::S3
  def self.client()
    Aws::S3::Client.new(
              access_key_id: ENV['SPACES_KEY'],
              secret_access_key: ENV['SPACES_SECRET'],
              endpoint: 'https://nyc3.digitaloceanspaces.com',
              force_path_style: false, # Configures to use subdomain/virtual calling format.
              region: 'us-east-1')
  end

  def upload()
      self.class.client.put_object({
        bucket: "example-bucket-name",
        key: "file.ext",
        body: "The contents of the file.",
        acl: "private",
        metadata: { 'x-amz-meta-my-key': "your-value" }
      })
  end

  def download()
    self.class.client.get_object(
      bucket: 'example-bucket-name',
      key: 'file.ext',
      response_target: '/tmp/local-file.ext'
    )
  end
end