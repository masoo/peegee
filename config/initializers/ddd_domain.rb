Rails.configuration do |config|
  config.paths.add 'app/domains/passwords', eager_load: true
end
