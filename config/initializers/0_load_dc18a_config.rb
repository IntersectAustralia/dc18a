APP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/dc18a_config.yml")[Rails.env]
INSTRUMENTS = YAML.load_file("#{Rails.root.to_s}/config/instruments.yml")
INSTITUTIONS = YAML.load_file("#{Rails.root.to_s}/config/institutions.yml").sort
