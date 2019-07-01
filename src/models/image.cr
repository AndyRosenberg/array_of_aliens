class Image < Granite::Base
  adapter pg
  table_name images

  primary id : Int64
  user_id : Int64
  profile : Bool
  object_key : String
  timestamps

  def generate_key
    Random::Secure.hex(15)
  end

  def upload(filepath : String)
    client = Awscr::S3::Client.new(
      ENV["AWS_REGION"],
      ENV["S3_ACCESS_KEY_ID"],
      ENV["S3_ACCESS_KEY_SECRET"]
    )

    body = File.read(File.expand_path(filepath))
    extension = (/\.([A-Za-z0-9]+)$/.match(filepath) || "")[0]
    ext = extension.to_s[1..-1]

    client.put_object(
      ENV["AWS_BUCKET"],
      generate_key + extension,
      body,
      {"Content-Type" => "image/#{ext}"}
    )
  end
end
