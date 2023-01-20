# Documentation:
# https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/S3/Client.html
class Load::S3
  @@keyfile = ENV['keyfile'] # 'file.ext'
  @@client  = self.define_client

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
