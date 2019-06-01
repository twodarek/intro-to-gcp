require 'json'
require 'mysql2'
require 'rufus-scheduler'
require 'securerandom'
require 'sinatra'
require 'uri'

require "google/cloud/storage"

puts "Starting Sinatra server"

settings = Sinatra::Application.settings

# if settings.development?
#   require 'dotenv'
#   Dotenv.load
# end

# set :public_folder, Proc.new { File.join(root, "client") }
set :protection, :except => :frame_options
enable :logging, :dump_errors, :raise_errors

local_video_base = "videos"

get '/' do
  return "ok"
end

get '/upload/' do
  redirect '/upload/index.html'
end

get '/watch/' do
  redirect '/watch/index.html'
end

get '/api' do
  "Hello World"
end

get '/api/video/all' do
  result = get_all_video_objs()
  if result.nil?
    return 404
  else
    return result.to_json
  end
end

get '/api/video/:video_uuid' do
  result = get_video_obj(params[:video_uuid])
  if result.nil?
    return 404
  else
    return result.to_json
  end
end

post '/api/video/upload' do
  # access form data with params
  title = params["title"]
  description = params["description"]
  video_file = params["video_file"]["tempfile"]
  video_uuid = SecureRandom.uuid
  video_path = "#{local_video_base}/#{video_uuid}.mp4"
  File.open(video_path, 'wb') do |f|
    f.write(video_file.read)
  end
  public_url = upload_file_to_gcs(video_path, video_uuid)
  store_video(title, description, video_path, public_url, video_uuid)
  200
end

def upload_file_to_gcs(video_path, video_uuid)
  storage = get_gcs_client

  bucket = storage.bucket "twodarek-intro-to-gcp"

  gcs_video_file_loc = video_path
  file = bucket.create_file video_path, gcs_video_file_loc
  file.acl.public!
  public_url = file.public_url
  return public_url
end

def store_video(title, description, video_path, public_url, video_uuid)
  sql_client = get_sql_client
  stmt = sql_client.prepare("INSERT INTO video (title, description, video_path, public_url, video_uuid) VALUES (?, ?, ?, ?, ?)")
  stmt.execute(title, description, video_path, public_url, video_uuid)
end

def get_video_obj(video_uuid)
  puts "getting #{video_uuid}"
  sql_client = get_sql_client
  stmt = sql_client.prepare("SELECT * FROM video WHERE video_uuid = ?")
  results = stmt.execute(video_uuid)
  resultant = {}
  results.each do |row|
    resultant['title'] = row['title']
    resultant['description'] = row['description']
    resultant['public_url'] = row['public_url']
    resultant['video_uuid'] = row['video_uuid']
  end
  return resultant
end

def get_all_video_objs()
  puts "getting all videos"
  sql_client = get_sql_client
  stmt = sql_client.prepare("SELECT * FROM video")
  results = stmt.execute()
  resultant = []
  results.each do |row|
    puts row
    obj = {}
    obj['title'] = row['title']
    obj['description'] = row['description']
    obj['public_url'] = row['public_url']
    obj['video_uuid'] = row['video_uuid']
    resultant.push(obj)
  end
  return resultant
end

def get_gcs_client()
  if @storage.nil?
    @storage = Google::Cloud::Storage.new(
      project_id: "twodarek-talks",
      credentials: "/wodarek/secret/service_user.json"
    )
  end
  return @storage
end

def get_sql_client()
  host = ENV["SQL_HOST"]
  user = ENV["SQL_USER"]
  pass = ENV["SQL_PASS"]
  db = ENV["SQL_DB"]
  client = Mysql2::Client.new(:host => host, :username => user, :password => pass, :database => db)
end
