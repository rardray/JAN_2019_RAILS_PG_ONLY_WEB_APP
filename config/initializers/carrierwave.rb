if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :aws
    config.aws_bucket = ENV.fetch('S3_BUCKET')
    config.aws_acl = 'public-read'

    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

    config.aws_credentials = {
      access_key_id: ENV.fetch('S3_ACCESS_KEY'),
      secret_access_key: ENV.fetch('S3_SECRET_KEY'),
      region: ENV.fetch('S3_REGION')
    }
  end
end