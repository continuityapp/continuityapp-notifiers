module ConfigStore
  def self.boot
    @options = YAML::load(File.open(File.expand_path('../../config/config.yml', __FILE__)))[ENVIRONMENT]
  end
  
  def self.options
    @options
  end
end