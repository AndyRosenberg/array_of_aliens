class Image < Granite::Base
  adapter pg
  table_name images

  primary id : Int64
  field user_id : Int64
  field profile : Bool
  field object_key : String
  field object_url : String
  timestamps

  def upload(filepath : String)
    get_client

    body = File.read(File.expand_path(filepath))
    extension = (/\.([A-Za-z0-9]+)$/.match(filepath) || " ")[0].downcase
    ext = mimed(extension.to_s[1..-1])
    key = (generate_key + extension).strip

    object = @client.put_object(
               ENV["AWS_BUCKET"],
               key,
               body,
               {"Content-Type" => "image/#{ext}"}
             )

    update(object_key: key, object_url: get_url(key))
  end

  private def generate_key
    UUID.random.to_s
  end
  
  private def get_url(key : String)
    "https://#{ENV["AWS_BUCKET"]}.s3-#{ENV["AWS_REGION"]}.amazonaws.com/#{key}"
  end

  private def get_client
    @client = Awscr::S3::Client.new(
      ENV["AWS_REGION"],
      ENV["S3_ACCESS_KEY_ID"],
      ENV["S3_ACCESS_KEY_SECRET"]
    )
  end

  private def mimed(ext : String)
    return ext unless ext == "jpg"
    "jpeg"
  end
end
