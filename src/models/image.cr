require "base64"

class Image < Granite::Base
  adapter pg
  table_name images

  primary id : Int64
  field user_id : Int64
  field profile : Bool
  field object_key : String
  field object_url : String
  timestamps

  belongs_to :user

  def self.upload(filepath : String, body : String, profile : Bool = false)
    return Image.new if body.blank?

    body = Base64.decode_string(body)

    extension = (/\.([A-Za-z0-9]+)$/.match(filepath) || " ")[0].downcase
    ext = mimed(extension.to_s[1..-1])
    key = (generate_key + extension).strip

    object = client.put_object(
               ENV["AWS_BUCKET"],
               key,
               body,
               {"Content-Type" => "image/#{ext}", "Content-Encoding" => "base64"}
             )

    create(object_key: key, object_url: get_url(key), profile: profile)
  end

  private def self.generate_key
    UUID.random.to_s
  end
  
  private def self.get_url(key : String)
    "https://#{ENV["AWS_BUCKET"]}.s3-#{ENV["AWS_REGION"]}.amazonaws.com/#{key}"
  end

  private def self.client
    Awscr::S3::Client.new(
      ENV["AWS_REGION"],
      ENV["S3_ACCESS_KEY_ID"],
      ENV["S3_ACCESS_KEY_SECRET"]
    )
  end

  private def self.mimed(ext : String)
    return ext unless ext == "jpg"
    "jpeg"
  end
end
