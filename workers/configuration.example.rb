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