APP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/dc18a_config.yml")[Rails.env]

if File.exists?("#{APP_CONFIG['extra_config_file_root']}/dc18a_extra_config.yml")
  extra_config = YAML.load_file("#{APP_CONFIG['extra_config_file_root']}/dc18a_extra_config.yml")[Rails.env]
  APP_CONFIG.merge!(extra_config)
else
  # puts "#{APP_CONFIG['extra_config_file_root']}/dc18a_extra_config.yml doesn't exist yet. This is ok in a local dev environment but should not be the case in production".yellow
end

INSTRUMENTS = YAML.load_file("#{Rails.root.to_s}/config/instruments.yml")
INSTITUTIONS = YAML.load_file("#{Rails.root.to_s}/config/institutions.yml").sort
