json.array!(@posts) do |post|
  json.extract! post, :title, :user_id, :approved
  json.url post_url(post, format: :json)
end